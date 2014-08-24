/*============================================================================
 PROJECT: SportLocker
 FILE:    TrackingService.m
 AUTHOR:  Ngoc Tam Nguyen
 DATE:    10/7/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "TrackingService.h"
#import "LocationService.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface TrackingService()

@property (nonatomic, strong)   LocationService *service;
@property (nonatomic, strong)   CLLocation *currentLocation;

@end

@implementation TrackingService

+ (id)sharedTrackingService {
	static dispatch_once_t predicate;
	static TrackingService *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}
#if (!__has_feature(objc_arc))

- (id)retain {
    
    return self;
}

- (NSUInteger)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    
    return self;
}

#endif

- (void)startSession {
    [Flurry setCrashReportingEnabled:YES];
    //    [Flurry setDebugLogEnabled:YES];
    //    [Flurry setLogLevel:FlurryLogLevelCriticalOnly];
    //    [Flurry setBackgroundSessionEnabled:YES];
    [Flurry startSession:kFlurryAPIKey];
}

- (void)registerPushNotification:(NSString *)deviceToken {
//    [Flurry setPushToken:deviceToken];
}

- (void)logPageView:(PageViewType)type {
    [Flurry logEvent:[kPageViews objectAtIndex:type] timed:YES];
    [self logPageView];
}

- (void)endTimeAtPageView:(PageViewType)type {
    [Flurry endTimedEvent:[kPageViews objectAtIndex:type] withParameters:nil];
}

- (void)logPageView {
    [Flurry logPageView];
}

- (void)trackingLocation {
    @autoreleasepool {
        if (!_service) {
            
            LocationService *service = [[LocationService alloc] init];
            self.service = service;
        }
        
        _service.tracking = YES;
        
        [_service getUpdateLocationWithCallback:^(CLLocation *location, NSError *error) {
            if(!self.currentLocation
               || (self.currentLocation.coordinate.latitude != location.coordinate.latitude
                   || self.currentLocation.coordinate.longitude != location.coordinate.longitude)) {
                   self.currentLocation = location;
                   [Flurry setLatitude:location.coordinate.latitude
                             longitude:location.coordinate.longitude
                    horizontalAccuracy:location.horizontalAccuracy
                      verticalAccuracy:location.verticalAccuracy];
               }
        }];
    }
}

@end
