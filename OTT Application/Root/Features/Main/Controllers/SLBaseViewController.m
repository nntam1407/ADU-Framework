/*============================================================================
 PROJECT: SportLocker
 FILE:    SLBaseViewController.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/28/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "SLBaseViewController.h"
#import "SLNavigationBarView.h"
/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface SLBaseViewController ()

@end

@implementation SLBaseViewController
@synthesize cacheWrapper = _cacheWrapper;

- (SLCacheWrapper *)initializeCacher {
    return [SLCacheWrapper cacheWrapper];
}

- (SLCacheWrapper *)cacher {
    if(!_cacheWrapper) {
        _cacheWrapper = [self initializeCacher];
    }
    return _cacheWrapper;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)reloadData {
    /* check cache status */
    [self.cacheWrapper checkCacheStatusOfServices];
}

@end
