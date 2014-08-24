/*============================================================================
 PROJECT: SportLocker
 FILE:    TwitterSocialService.m
 AUTHOR:  vientc
 DATE:    5/2/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "TwitterSocialService.h"
#import "TwitterUser.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
@interface TwitterSocialService(){
    BOOL isValid;
}

@end

@implementation TwitterSocialService

- (id)init{
    self = [super init];
    return self;
}

- (void)showAlertViewToSettingTwitter{
    UIViewController *tweetComposer;
    UIViewController *rootView = [appDelegate window].rootViewController;
    
    if([SLComposeViewController class] != nil)
    {
        tweetComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [(SLComposeViewController *)tweetComposer setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             [rootView dismissViewControllerAnimated:NO completion:^{
                 
             }];
         }];
    }
    else
    {
        tweetComposer = [[TWTweetComposeViewController alloc] init];
        
        [(TWTweetComposeViewController *)tweetComposer setCompletionHandler:^(TWTweetComposeViewControllerResult result)
         {
             if(SupportiOS7) {
                 [rootView dismissViewControllerAnimated:YES completion:^{
                     
                 }];
             } else {
                 [rootView dismissModalViewControllerAnimated:YES];
             }
         }];
    }
    
    for (UIView *view in [[tweetComposer view] subviews])
        [view removeFromSuperview];
    
    if(SupportiOS7) {
        [rootView presentViewController:tweetComposer animated:YES completion:^{
            
        }];
    } else {
        [rootView presentModalViewController:tweetComposer animated:YES];
    }
}

- (BOOL)twitterAvailabel{
    BOOL available = NO;
    if ([SLComposeViewController class]) {
        available = [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    }
    else {
        available = [TWTweetComposeViewController canSendTweet];
    }
    return available;
}

#pragma mark - Overriden Methods
- (void)getListUserFriendWithReturnBlock:(void (^)(AbstractSocialService *service, NSArray *friendList, NSError *error))block{
    if ([self twitterAvailabel]) {
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request access from the user to access their Twitter account
        [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *rqError){
            // Did user allow us access?
            if (granted == YES)
            {
                // Populate array with all available Twitter accounts
                NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                
                // Sanity check
                if ([arrayOfAccounts count] > 0) {
                    // Keep it simple, use the first account available
                    ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                    
                    // Build a twitter request
                    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/followers/list.json"] parameters:nil requestMethod:TWRequestMethodGET];
                    
                    // Post the request
                    [postRequest setAccount:acct];
                    
                    // Block handler to manage the response
                    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
                        if (!error){
                            NSError *jsonError = nil;
                            NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];
                            NSArray *users = [userDic valueForKey:@"users"];
                            
                            NSMutableArray *twitterFriendsList = [NSMutableArray new];
                            for (NSDictionary *dict in users) {
                                TwitterUser *twitterUser = [TwitterUser twitterUserFromDictionary:dict];
                                [twitterFriendsList addObject:twitterUser];
                            }
                            
                            if(block != NULL) {
                                block(self, twitterFriendsList, error);
                            }
                        }else{
                            if(block != NULL) {
                                block(self, nil, error);
                            }
                        }
                        
                    }];
                }
            }else{
                if(block != NULL) {
                    block(self, nil, rqError);
                }
            }
        }];
    }else{
        [self showAlertViewToSettingTwitter];
    }
}

/*----------------------------------------------------------------------------
 Method:      populateUserDetails
 Description: get user detail
 ----------------------------------------------------------------------------*/
- (void)authenticateWithReturnBlock:(void (^)(AbstractSocialService *service, NSError *error))block {
    [self populateUserDetailsWithReturnBlock:block];
}


- (void)populateUserDetailsWithReturnBlock:(void (^)(AbstractSocialService *, NSError *))block {
    if ([self twitterAvailabel]) {
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request access from the user to access their Twitter account
        [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error){
            // Did user allow us access?
            if (granted == YES)
            {
                // Populate array with all available Twitter accounts
                NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                
                // Sanity check
                if ([arrayOfAccounts count] > 0) {
                    // Keep it simple, use the first account available
                    ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                    
                    // Build a twitter request
                    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"] parameters:nil requestMethod:TWRequestMethodGET];
                    
                    // Post the request
                    [postRequest setAccount:acct];
                    
                    // Block handler to manage the response
                    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
                        if (!error){
                            NSError *jsonError = nil;
                            NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];
                            /* call block to return status */
                            self.userInfo = [TwitterUser twitterUserFromDictionary:userDic];
                        }
                        if(block != NULL) {
                            block(self, error);
                        }
                    }];
                }
            }else{
                if(block != NULL) {
                    block(self, error);
                }
            }
        }];
    }else{
        [self showAlertViewToSettingTwitter];
        NSError *error = [NSError errorWithDomain:@"" code:errorCodeTwitterAccountNotAvailable userInfo:nil];
        if(block != NULL) {
            block(self, error);
        }
    }
}

- (void)sendInvitationToFriends:(NSArray*)friendsList completeBlock:(SocialInvitationRequestBlock)block{
    __block NSInteger successMessageCount = 0;
    
    for (TwitterUser *user in friendsList) {
        if ([self twitterAvailabel]) {
            ACAccountStore *account = [[ACAccountStore alloc] init];
            ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            // Request access from the user to access their Twitter account
            [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error){
                // Did user allow us access?
                if (granted == YES)
                {
                    // Populate array with all available Twitter accounts
                    NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                    
                    // Sanity check
                    if ([arrayOfAccounts count] > 0) {
                        // Keep it simple, use the first account available
                        ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                        
                        // Build a twitter request
                        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/direct_messages/new.json"];
                        NSDictionary *p = [NSDictionary dictionaryWithObjectsAndKeys:
                                           user.username,                    @"screen_name",
                                           NSLocalizedString(@"I’m inviting you to join and connect with me at www.DealHits.net.", @"NSString"), @"text",
                                           nil
                                           ];
                        
                        TWRequest *postRequest = [[TWRequest alloc]
                                                  initWithURL:   url
                                                  parameters:    p
                                                  requestMethod: TWRequestMethodPOST
                                                  ];
                        
                        // Post the request
                        [postRequest setAccount:acct];
                        
                        // Block handler to manage the response
                        [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                            successMessageCount++;
                            if (successMessageCount == [friendsList count]) {
                                block(self, nil);
                            }
                            if (error){
                                NSLog(@"Error");
                            }
                        }];
                    }
                }else{
                    if(block != NULL) {
                        block(self, error);
                    }
                }
            }];
        }else{
            [self showAlertViewToSettingTwitter];
            NSError *error = [NSError errorWithDomain:@"" code:errorCodeTwitterAccountNotAvailable userInfo:nil];
            if(block != NULL) {
                block(self, error);
            }
        }
    }
}

- (BOOL)isValidSession {
    return YES;
}

@end
