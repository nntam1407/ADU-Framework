/*============================================================================
 PROJECT: SportLocker
 FILE:    NLGeoCoder.h
 AUTHOR:  Nguyen Minh Khoai
 =============================================================================*/

#import "NLGeoCoder.h"

@implementation NLGeoCoder

@synthesize delegate = _delegate;


- (void)cancelGeocode {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_5_0
    [_geocoder cancel];
    _geocoder.delegate = nil;
#else
    [_geocoder cancelGeocode];
#endif
}

- (void)reverseGeocodeLocation:(CLLocation *)location {
    [self cancelGeocode];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *systemVersionMajor = [[NSString alloc] initWithFormat:@"%c", [systemVersion characterAtIndex:0]];
    if ([systemVersionMajor intValue] < 5) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_5_0
        [_geocoder cancel];
        _geocoder.delegate = nil;   
        
        _geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate];
        _geocoder.delegate = self;
        [_geocoder start];
#endif
    }
    else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_5_0
        if (!_geocoder) {
            _geocoder = [[CLGeocoder alloc] init];
        }

        [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {

            BOOL locationEnable = [CLLocationManager locationServicesEnabled] &&
                    [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;

            if (error) {
                CallTargetWith2Obj(_delegate, @selector(reverseGeocoder:didFailWithError:), self, error);
            } else {
                if (placemarks && placemarks.count > 0 && locationEnable) {
                    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:placemarks[0]];
                    CallTargetWith2Obj(_delegate, @selector(reverseGeocoder:didFindPlacemark:), self, placemark);
                } else {
                    CallTargetWith2Obj(_delegate, @selector(reverseGeocoder:didFailWithError:), self, NULL);
                }
            }
        }];
#endif
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_5_0
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    CallTargetWith2Obj(_delegate, @selector(reverseGeocoder:didFindPlacemark:), self, placemark);
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    CallTargetWith2Obj(_delegate, @selector(reverseGeocoder:didFailWithError:), self, error);
}
#endif

- (void)dealloc {
    [self cancelGeocode];
}
@end
