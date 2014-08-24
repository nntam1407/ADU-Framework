/*============================================================================
 PROJECT: SportLocker
 FILE:    LocationService.h
 AUTHOR:  Nguyen Minh Khoai
 =============================================================================*/

#define kNoConnectionErrorCode  9999

/*============================================================================
 IMPORT
 =============================================================================*/

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

typedef void (^UpdateLocationCallback)(CLLocation *location, NSError *error);

/*----------------------------------------------------------------------------
 Interface:   LocationService
 -----------------------------------------------------------------------------*/

@interface LocationService : NSObject <CLLocationManagerDelegate>
@property(nonatomic, assign) BOOL tracking;
@property(nonatomic, assign) BOOL shouldStartMonitoringSignificantLocationChanges;
@property(nonatomic, strong) CLLocation *currentLocation;
@property(nonatomic, strong) UpdateLocationCallback updateLocationCallback;

- (void)getUpdateLocationWithCallback:(void (^)(CLLocation *location, NSError *error))callback;
- (void)stopUpdatingLocation;

@end
