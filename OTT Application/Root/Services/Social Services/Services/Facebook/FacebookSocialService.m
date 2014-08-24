/*============================================================================
 PROJECT: SportLocker
 FILE:    FacebookSocialService.m
 AUTHOR:  Vien Tran
 DATE:    8/8/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "FacebookSocialService.h"
#import "FacebookUser.h"
#import <FacebookSDK/FacebookSDK.h>
/*============================================================================
 PRIVATE MACRO
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
@interface FacebookSocialService(){
    SocialAuthenticateBlock authenticateBlock;
}

@end

@implementation FacebookSocialService

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

/*----------------------------------------------------------------------------
 Method:      FBErrorCodeDescription
 Description: create FB errors
 ----------------------------------------------------------------------------*/
+ (NSString *)FBErrorCodeDescription:(FBErrorCode) code {
    switch(code) {
        case FBErrorInvalid :{
            return @"FBErrorInvalid";
        }
        case FBErrorOperationCancelled:{
            return @"FBErrorOperationCancelled";
        }
        case FBErrorLoginFailedOrCancelled:{
            return @"FBErrorLoginFailedOrCancelled";
        }
        case FBErrorRequestConnectionApi:{
            return @"FBErrorRequestConnectionApi";
        }case FBErrorProtocolMismatch:{
            return @"FBErrorProtocolMismatch";
        }
        case FBErrorHTTPError:{
            return @"FBErrorHTTPError";
        }
        case FBErrorNonTextMimeTypeReturned:{
            return @"FBErrorNonTextMimeTypeReturned";
        }
            //        case FBErrorNativeDialog:{
            //            return @"FBErrorNativeDialog";
            //        }
        default:
            return @"[Unknown]";
    }
}

- (void)handleBecomeActive {
    [FBSession.activeSession handleDidBecomeActive];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)permisstionAvailableWith:(NSString*)permission{
    if ([self isValidSession]) {
        return [FBSession.activeSession.permissions
                indexOfObject:permission] != NSNotFound;
    }else{
        return NO;
    }
}

#pragma mark - Overriden Methods
- (void)authenticateWithReturnBlock:(void (^)(AbstractSocialService *, NSError *))block {
    authenticateBlock = block;
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error){
        switch (state) {
            case FBSessionStateOpen: {
                /* get user information */
                [FBSession setActiveSession:session];
                self.sessionState = SocialSessionStateOpen;
            }
                break;
            case FBSessionStateClosed: {
                self.sessionState = SocialSessionStateClosed;
                [FBSession.activeSession closeAndClearTokenInformation];
            }
                break;
            case FBSessionStateClosedLoginFailed: {
                [FBSession.activeSession closeAndClearTokenInformation];
                self.sessionState = SocialSessionStateClosedLoginFailed;
            }
                break;
            default:
                break;
        }
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %@",
                                                                         [FacebookSocialService FBErrorCodeDescription:error.code]]
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        if (authenticateBlock != nil) {
            authenticateBlock(self, error);
            authenticateBlock = nil;
        }
    }];
}

/*----------------------------------------------------------------------------
 Method:      populateUserDetails
 Description: get user detail
 ----------------------------------------------------------------------------*/
- (void)populateUserDetailsWithReturnBlock:(void (^)(AbstractSocialService *, NSError *))block {
    if (FBSession.activeSession.isOpen && [self permisstionAvailableWith:@"email"]) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 self.userInfo = [FacebookUser facebookUserFromDictionary:user];
             }
             if(block != nil) {
                 block(self, error);
             }
         }];
    }else{
        [self authenticateWithReturnBlock:^(AbstractSocialService *service, NSError *error) {
            [self populateUserDetailsWithReturnBlock:block];
        }];
    }
}


- (void)getListUserFriendWithReturnBlock:(void (^)(AbstractSocialService *service, NSArray *friendList, NSError *error))block{
    if (FBSession.activeSession.isOpen) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"picture,id,name,link,gender,last_name,first_name",@"fields",nil];

        FBRequest *request = [FBRequest requestWithGraphPath:@"/me/friends" parameters:params HTTPMethod:@"GET"];
        request.session = FBSession.activeSession;
        [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
            if (!error) {
                NSArray* friends = [result objectForKey:@"data"];
                NSMutableArray *facebookFriendsList = [NSMutableArray new];
                for (NSDictionary<FBGraphUser>* friend in friends) {
                    FacebookUser *fbFriend = [FacebookUser facebookUserFromDictionary:friend];
                    [facebookFriendsList addObject:fbFriend];
                }
                
                if (block != nil) {
                    block(self, facebookFriendsList, error);
                }
            }else{
                if (block != nil) {
                    block(self, nil, error);
                }
            }
        }];
        
//        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
//        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
//                                                      NSDictionary* result,
//                                                      NSError *error) {
//            if (!error) {
//                NSArray* friends = [result objectForKey:@"data"];
//                NSMutableArray *facebookFriendsList = [NSMutableArray new];
//                for (NSDictionary<FBGraphUser>* friend in friends) {
//                    FacebookUser *fbFriend = [FacebookUser facebookUserFromDictionary:friend];
//                    [facebookFriendsList addObject:fbFriend];
//                }
//                
//                if (block != nil) {
//                    block(self, facebookFriendsList, error);
//                }
//            }else{
//                if (block != nil) {
//                    block(self, nil, error);
//                }
//            }
//        }];
    }else{
        [self authenticateWithReturnBlock:^(AbstractSocialService *service, NSError *error) {
            [self getListUserFriendWithReturnBlock:block];
        }];
    }
}

- (void)sendInvitationToFriends:(NSArray*)friendsList completeBlock:(SocialInvitationRequestBlock)block{
    NSArray *limitFriendsList = nil;
//    NSArray *queueFriendsList = nil;
    if (friendsList.count > 50) {
        limitFriendsList = [friendsList subarrayWithRange:NSMakeRange(0, 50)];
//        queueFriendsList = [friendsList subarrayWithRange:NSMakeRange(50, friendsList.count - 50)];
    }else{
        limitFriendsList = friendsList;
    }
    
    NSMutableArray *listFBID = [NSMutableArray new];
    for (FacebookUser *user in limitFriendsList) {
        [listFBID addObject:user.userId];
    }
    
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys: [listFBID componentsJoinedByString:@","], @"to", nil];
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:@"Join my DealHits social network!"
                                                    title:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          block(self, error);
                                                          // Error launching the dialog or sending the request.
                                                          NSLog(@"Error sending request.");
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User clicked the "x" icon
                                                              NSLog(@"User canceled request.");
                                                          } else {
                                                              // Handle the send request callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              if (![urlParams valueForKey:@"request"]) {
                                                                  // User clicked the Cancel button
                                                                  NSLog(@"User canceled request.");
                                                              } else {
                                                                  // User clicked the Send button
                                                                  block(self, nil);
                                                                  NSString *requestID = [urlParams valueForKey:@"request"];
                                                                  NSLog(@"Request ID: %@", requestID);
                                                              }
                                                          }
                                                      }
                                                  }];
}


/**
 * Helper method for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (BOOL)isValidSession {
    return FBSession.activeSession.isOpen;
}

- (void)logout:(void (^)(BOOL))block
{
    [[FBSession activeSession] closeAndClearTokenInformation];
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://login.facebook.com"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
    
    for (NSHTTPCookie *cookie in [cookies cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [cookies deleteCookie:cookie];
        }
    }
    block(YES);
}

- (NSString *)accessToken{
    return [[FBSession activeSession] accessTokenData].accessToken;
}
@end
