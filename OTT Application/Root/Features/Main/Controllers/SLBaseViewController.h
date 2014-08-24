/*============================================================================
 PROJECT: SportLocker
 FILE:    SLBaseViewController.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/28/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "BaseViewController.h"
#import "SLHomeCacheWrapper.h"
#import "SLLeagueCacheWrapper.h"

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   SLBaseViewController
 =============================================================================*/


@interface SLBaseViewController : BaseViewController

/* cache versions */
@property (nonatomic, strong, getter=cacher)   SLCacheWrapper *cacheWrapper;

- (SLCacheWrapper *)initializeCacher;
- (void)reloadData;
@end
