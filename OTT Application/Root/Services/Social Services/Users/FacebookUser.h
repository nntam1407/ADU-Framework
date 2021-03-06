/*============================================================================
 PROJECT: SportLocker
 FILE:    FacebookUser.h
 AUTHOR:  Vien Tran
 DATE:    8/8/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "AbstractSocialUser.h"
#import <FacebookSDK/FacebookSDK.h>

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   FacebookUser
 =============================================================================*/

@class FBGraphObject, FBGraphUser;
@interface FacebookUser : AbstractSocialUser

+ (FacebookUser *)facebookUserFromDictionary:(NSDictionary<FBGraphUser> *)userDic;

@end
