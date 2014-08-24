
#import "IAPShare.h"

#if ! __has_feature(objc_arc)
//#error You need to either convert your project to ARC or add the -fobjc-arc compiler flag to IAPShare.m.
#endif

@implementation IAPShare
@synthesize iap= _iap;
static IAPShare * _sharedHelper;

+ (IAPShare *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[IAPShare alloc] init];
    _sharedHelper.iap = nil;
    return _sharedHelper;
}

@end
