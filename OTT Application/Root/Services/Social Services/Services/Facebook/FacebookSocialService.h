/*============================================================================
 PROJECT: SportLocker
 FILE:    FacebookSocialService.h
 AUTHOR:  Vien Tran
 DATE:    8/8/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "AbstractSocialService.h"
#import <FacebookSDK/FacebookSDK.h>

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   FacebookSocialService
 =============================================================================*/
@class FacebookAlbum;
@interface FacebookSocialService : AbstractSocialService {
    
}

- (void)handleBecomeActive;
- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)permisstionAvailableWith:(NSString*)permission;

@end
