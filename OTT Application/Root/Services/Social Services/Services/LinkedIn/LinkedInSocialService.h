/*============================================================================
 PROJECT: SportLocker
 FILE:    LinkedInSocialService.h
 AUTHOR:  vientc
 DATE:    9/20/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "AbstractSocialService.h"

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/
@class LinkedInSocialService;
typedef void (^ShareLinkedInRequestBlock)(LinkedInSocialService *service, NSError *error);
/*============================================================================
 Interface:   LinkedInSocialService
 =============================================================================*/


@interface LinkedInSocialService : AbstractSocialService

- (void)shareWithMessage:(NSString*)message imageURL:(NSString*)image completeBlock:(ShareLinkedInRequestBlock)block;

@end
