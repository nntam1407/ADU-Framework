/*============================================================================
 PROJECT: SportLocker
 FILE:    AbstractSocialService.h
 AUTHOR:  Vien Tran
 DATE:    8/8/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <Foundation/Foundation.h>

/*============================================================================
 MACRO
 =============================================================================*/
typedef enum {
    SocialSessionStateClosed = 0,
    SocialSessionStateOpen,
    SocialSessionStateClosedLoginFailed
} SocialSessionState;
/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   AbstractSocialService
 =============================================================================*/
@class AbstractSocialService;
typedef void (^SocialAuthenticateBlock)(AbstractSocialService *service, NSError *error);
typedef void (^SocialFriendListRequestBlock)(AbstractSocialService *service, NSArray *friendList, NSError *error);
typedef void (^SocialInvitationRequestBlock)(AbstractSocialService *service, NSError *error);

@class AbstractSocialUser;
@interface AbstractSocialService : NSObject {
    AbstractSocialUser  *userInfo;
    SocialSessionState  sessionState;
}

@property (nonatomic, strong)   AbstractSocialUser  *userInfo;
@property (nonatomic, assign)   SocialSessionState  sessionState;
@property (nonatomic, strong, readonly)   NSString    *accessToken;

- (void)authenticateWithReturnBlock:(SocialAuthenticateBlock)block;
- (void)populateUserDetailsWithReturnBlock:(void (^)(AbstractSocialService *, NSError *))block;
- (void)getListUserFriendWithReturnBlock:(SocialFriendListRequestBlock)block;
- (void)sendInvitationToFriends:(NSArray*)friendsList completeBlock:(SocialInvitationRequestBlock)block;
- (BOOL)isValidSession;
- (BOOL)userInfoAvailable;
- (void)logout:(void (^)(BOOL success)) block;

@end
