/*============================================================================
 PROJECT: SportLocker
 FILE:    AppHelper.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    8/15/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "AppHelper.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation AppHelper

+ (id)sharedAppHelper {
	static dispatch_once_t predicate;
	static AppHelper *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}
#if (!__has_feature(objc_arc))

- (id)retain {
    
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    
    return self;
}
#endif

- (NSString *)appVersion {
    NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    return versionString;
}

- (NSString *)appId {
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    return bundleIdentifier;
}

+ (NSString *)currentLanguage {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentLanguage = [[defaults objectForKey:@"AppleLanguages"] objectAtIndex:0];
    return currentLanguage;
}

+ (NSString *)appName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
}

@end
