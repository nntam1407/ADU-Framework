/*============================================================================
 PROJECT: SportLocker
 FILE:    LocationService.h
 AUTHOR:  Nguyen Minh Khoai
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "MKCachedLocation.h"

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
#define kLatestLocationKey              @"kLatestLocationKey"

/*----------------------------------------------------------------------------
 Interface:   LocationService
 -----------------------------------------------------------------------------*/
@interface LocationService ()
@property(nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation LocationService

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    return _locationManager;
}

/*----------------------------------------------------------------------------
 Method:      init
 init local variable
 -----------------------------------------------------------------------------*/
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)callBlockWith:(CLLocation *)location error:(NSError *)error {
    if (_updateLocationCallback) {
        _updateLocationCallback(location, error);
    }
}

/*----------------------------------------------------------------------------
 Method:      getUpdateLocationWithSuccessBlock:errorBlock:
 get current location of user
 -----------------------------------------------------------------------------*/
- (void)getUpdateLocationWithCallback:(void (^)(CLLocation *location, NSError *error))callback {
    
    @synchronized(self) {
        /* keep blocks to use later */
        self.updateLocationCallback = callback;
        
        /* check internet first, if has no connection, don't try to get new location */
        if (!appDelegate.hasNetwork) {
            
            /* get cache latest */
            NSMutableArray *locations = [FileHelper restoreArrayForKey:kLatestLocationKey];
            [self callBlockWith:[locations lastObject] error:MKError(kNoConnectionErrorCode, kNoConnectionErrorMessage)];
            
            return;
        }
        
        /* If location service is enable, try to get device's current location.
         Otherwise, force show alert to indicate location service is disable and settings option*/
        if (![CLLocationManager locationServicesEnabled]
            || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            
            NSString *domain = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            
            NSString *errorMsg = NSLocalizedString(@"Location service is disabled. Go Setting and enable it to use our service", nil);
            userInfo[@"ErrorMessage"] = errorMsg;
            
            NSError *error = [NSError errorWithDomain:domain code:501 userInfo:userInfo];
            [self callBlockWith:nil error:error];
        }
        
        self.locationManager.delegate = self;
        if(_shouldStartMonitoringSignificantLocationChanges) {
            [self.locationManager startMonitoringSignificantLocationChanges];
        }
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - implement CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    /* save cache latest */
    CLLocation *newLocation = [locations lastObject];
    [FileHelper backupArray:@[[MKCachedLocation cachedLocationForLocation:newLocation]]
                     forKey:kLatestLocationKey];
    
    /* call block */
    [self callBlockWith:newLocation error:nil];
    
    /* stop update location */
    if (!_tracking) {
        [self stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    /* save cache latest */
    [FileHelper backupArray:@[[MKCachedLocation cachedLocationForLocation:newLocation]]
                     forKey:kLatestLocationKey];
    
    /* call block */
    [self callBlockWith:newLocation error:nil];
    
    /* stop update location */
    if (!_tracking) {
        [self stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    /* get cache latest */
    NSMutableArray *locations = [FileHelper restoreArrayForKey:kLatestLocationKey];
    
    if([locations lastObject]) {
        [self callBlockWith:[[locations lastObject] cachedLocation] error:error];
    } else {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:kCLLocationCoordinate2DInvalid.latitude
                                                          longitude:kCLLocationCoordinate2DInvalid.longitude];
        [self callBlockWith:location error:error];
    }
    
    /* stop update location */
    if (!_tracking) {
        [self stopUpdatingLocation];
    }
}

- (void)stopUpdatingLocation {
    [_locationManager stopMonitoringSignificantLocationChanges];
    [_locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}
@end
