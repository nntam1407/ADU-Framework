/*============================================================================
 PROJECT: SportLocker
 FILE:    LinkedInSocialService.m
 AUTHOR:  vientc
 DATE:    9/20/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "LinkedInSocialService.h"
#import "OAuthLoginView.h"
#import "LinkedInUser.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
#define LinkedInAccessTokenKey @"LinkedInAccessTokenKey"
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
@interface LinkedInSocialService(){
    OAuthLoginView *oAuthLoginView;
    SocialAuthenticateBlock authenticateBlock;
    SocialFriendListRequestBlock friendsRequestBlock;
    SocialInvitationRequestBlock invitationRequestBlock;
    ShareLinkedInRequestBlock shareRequestBlock;
    OAToken *accessToken;
}

@end

@implementation LinkedInSocialService

- (id)init{
    self = [super init];
    if (self) {
        oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
        accessToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:LinkedInAccessTokenKey prefix:nil];
    }
    
    return self;
}

- (void)authenticateWithReturnBlock:(void (^)(AbstractSocialService *service, NSError *error))block {
    authenticateBlock = block;
    [oAuthLoginView openActiveSecsionWithCompleteHandler:^(OAuthLoginView *loginView, NSString *errorMessage) {
        accessToken = oAuthLoginView.accessToken;
        if (authenticateBlock != nil) {
            authenticateBlock(self, nil);
            authenticateBlock = nil;
        }
    } didCancel:^{
        authenticateBlock = nil;
    }];
    /* will be overriden in subclasses */
}

- (BOOL)isValidSession {
    return [accessToken isValid];
}

- (BOOL)userInfoAvailable{
    return self.userInfo ? YES : NO;
}

- (void)populateUserDetailsWithReturnBlock:(void (^)(AbstractSocialService *, NSError *))block{

}

- (void)getListUserFriendWithReturnBlock:(void (^)(AbstractSocialService *service, NSArray *friendList, NSError *error))block{
    friendsRequestBlock = block;
    
    if ([self isValidSession]) {
        NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/connections"];
        OAMutableURLRequest *request =
        [[OAMutableURLRequest alloc] initWithURL:url
                                        consumer:oAuthLoginView.consumer
                                           token:accessToken
                                        callback:nil
                               signatureProvider:nil];
        
        [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
        
        OADataFetcher *fetcher = [[OADataFetcher alloc] init];
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(friendsApiCallResult:didFinish:)
                      didFailSelector:@selector(friendsApiCallResult:didFail:)];
    }else{
        [self authenticateWithReturnBlock:^(AbstractSocialService *service, NSError *error) {
            if (!error) {
                [self getListUserFriendWithReturnBlock:block];
            }else{
                [Utils showAlertWithMessage:[error description]];
            }
        }];
    }
}

- (void)friendsApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    NSDictionary *responseDict = [responseBody objectFromJSONString];
    
    if ( responseDict )
    {
        NSArray *users = [responseDict valueForKey:@"values"];
        
        NSMutableArray *linkedInFriendsList = [NSMutableArray new];
        for (NSDictionary *dict in users) {
            LinkedInUser *linkedInUser = [LinkedInUser linkedInUserFromDictionary:dict];
            [linkedInFriendsList addObject:linkedInUser];
        }
        
        if(friendsRequestBlock != nil) {
            friendsRequestBlock(self, linkedInFriendsList, nil);
            friendsRequestBlock = nil;
        }
    }
}

- (void)friendsApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error {
    NSError *errorResponse = [NSError errorWithDomain:[error description] code:0 userInfo:nil];
    if(friendsRequestBlock != nil) {
        friendsRequestBlock(self, nil, errorResponse);
        friendsRequestBlock = nil;
    }
}

- (void)sendInvitationToFriends:(NSArray*)friendsList completeBlock:(SocialInvitationRequestBlock)block{
    invitationRequestBlock = block;
    if ([self isValidSession]) {
        NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/mailbox"];
        OAMutableURLRequest *request =
        [[OAMutableURLRequest alloc] initWithURL:url
                                        consumer:oAuthLoginView.consumer
                                           token:accessToken
                                        callback:nil
                               signatureProvider:nil];
        
        NSString *currentUserFirstName = @"";//appDelegate.dataCenter.activeUser.firstName;
        NSString *subject = NSLocalizedString(@"Join my DealHits social network!", @"NSString");
        NSString *body = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"Hi,\nI'm inviting you to join and connect with me at www.DealHits.net.\nI'm sharing latest incredible restaurants and retail stores' deals and promotions while on the move with my families and friends to enrich our shopping experience.\nLet's start connecting with me now by downloading DealHits from Apple App Store or Google Play Store onto your mobile device and be part of my growing social network.\nSincerely,", @"NSString"), currentUserFirstName];
        
        NSMutableDictionary *update = [NSMutableDictionary new];
        [update setObject:subject forKey:@"subject"];
        [update setObject:body forKey:@"body"];
        NSMutableDictionary *recipients = [NSMutableDictionary new];
        NSMutableArray *listRecipients = [NSMutableArray new];
        
        for (LinkedInUser *user in friendsList) {
            NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"/people/%@", user.userId], @"_path", nil],@"person", nil];
            [listRecipients addObject:userDict];
        }
        
        [recipients setObject:listRecipients forKey:@"values"];
        [update setObject:recipients forKey:@"recipients"];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *updateString = [update JSONString];
        
        [request setHTTPBodyWithString:updateString];
        [request setHTTPMethod:@"POST"];
        
        OADataFetcher *fetcher = [[OADataFetcher alloc] init];
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(sendMessagesApiCallResult:didFinish:)
                      didFailSelector:@selector(sendMessagesApiCallResult:didFail:)];
    }else{
        [self authenticateWithReturnBlock:^(AbstractSocialService *service, NSError *error) {
            if (!error) {
                [self sendInvitationToFriends:friendsList completeBlock:block];
            }else{
                [Utils showAlertWithMessage:[error description]];
            }
        }];
    }
}

- (void)sendMessagesApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    if(invitationRequestBlock != nil) {
        invitationRequestBlock(self, nil);
        invitationRequestBlock = nil;
    }
}

- (void)sendMessagesApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSError *errorResponse = [NSError errorWithDomain:[error description] code:0 userInfo:nil];
    if(invitationRequestBlock != nil) {
        invitationRequestBlock(self, errorResponse);
        invitationRequestBlock = nil;
    }
}


- (void)shareWithMessage:(NSString*)message imageURL:(NSString*)image completeBlock:(ShareLinkedInRequestBlock)block{
    shareRequestBlock = block;
    if ([self isValidSession]) {
        NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/shares"];
        OAMutableURLRequest *request =
        [[OAMutableURLRequest alloc] initWithURL:url
                                        consumer:oAuthLoginView.consumer
                                           token:accessToken
                                        callback:nil
                               signatureProvider:nil];
        
        NSMutableDictionary *update = [NSMutableDictionary new];
        [update setObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"anyone",@"code",nil] forKey:@"visibility"];
        
        [update setObject:message forKey:@"comment"];

        if (image) {
            [update setObject:[[NSDictionary alloc]
                               initWithObjectsAndKeys:
//                               @"Title",@"title",
//                               @"Desciption",@"description",
                               @"http://dealhits.net/",@"submitted-url",
                               image,@"submitted-image-url",
                               nil] forKey:@"content"];
        }
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *updateString = [update JSONString];
        
        [request setHTTPBodyWithString:updateString];
        [request setHTTPMethod:@"POST"];
        
        OADataFetcher *fetcher = [[OADataFetcher alloc] init];
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(shareApiCallResult:didFinish:)
                      didFailSelector:@selector(shareApiCallResult:didFail:)];
    }else{
        [self authenticateWithReturnBlock:^(AbstractSocialService *service, NSError *error) {
            if (!error) {
                [self shareWithMessage:message imageURL:image completeBlock:block];
            }else{
                [Utils showAlertWithMessage:[error description]];
            }
        }];
    }
}

- (void)shareApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
//    NSString *responseBody = [[NSString alloc] initWithData:data
//                                                   encoding:NSUTF8StringEncoding];
//    NSDictionary *responseDict = [responseBody objectFromJSONString];
//    NSLog(@"%@", responseBody);
//    NSLog(@"%@", responseDict);
    if(shareRequestBlock != nil) {
        shareRequestBlock(self, nil);
        shareRequestBlock = nil;
    }
}

- (void)shareApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSError *errorResponse = [NSError errorWithDomain:[error description] code:0 userInfo:nil];
    if(shareRequestBlock != nil) {
        shareRequestBlock(self, errorResponse);
        shareRequestBlock = nil;
    }
}

- (void)logout:(void (^)(BOOL))block
{
    /* will be overriden in subclasses */
}


@end
