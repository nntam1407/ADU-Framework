/*============================================================================
 PROJECT: SportLocker
 FILE:    AbstractSocialService.m
 AUTHOR:  Vien Tran
 DATE:    8/8/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "AbstractSocialService.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation AbstractSocialService
@synthesize userInfo;
@synthesize sessionState;

- (void)authenticateWithReturnBlock:(void (^)(AbstractSocialService *service, NSError *error))block {
    /* will be overriden in subclasses */
}

- (BOOL)isValidSession {
    /* will be overriden in subclasses */
    return NO;
}

- (BOOL)userInfoAvailable{
    return self.userInfo ? YES : NO;
}

- (void)populateUserDetailsWithReturnBlock:(void (^)(AbstractSocialService *, NSError *))block{
    /* will be overriden in subclasses */
}

- (void)sendInvitationToFriends:(NSArray*)friendsList completeBlock:(SocialInvitationRequestBlock)block{
    /* will be overriden in subclasses */
}

- (void)getListUserFriendWithReturnBlock:(void (^)(AbstractSocialService *service, NSArray *friendList, NSError *error))block{
    /* will be overriden in subclasses */
}

- (void)logout:(void (^)(BOOL))block
{
    /* will be overriden in subclasses */
}
@end
