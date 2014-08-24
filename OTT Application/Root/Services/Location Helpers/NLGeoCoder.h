/*============================================================================
 PROJECT: SportLocker
 FILE:    NLGeoCoder.m
 AUTHOR:  Nguyen Minh Khoai
 =============================================================================*/

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class NLGeoCoder;

@protocol NLGeoCoderDelegate <NSObject>
- (void)reverseGeocoder:(NLGeoCoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark;

- (void)reverseGeocoder:(NLGeoCoder *)geocoder didFailWithError:(NSError *)error;
@end

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_5_0
@interface NLGeoCoder : NSObject<MKReverseGeocoderDelegate> {
    MKReverseGeocoder   *_geocoder;
#else

@interface NLGeoCoder : NSObject {
    CLGeocoder *_geocoder;
#endif
    id <NLGeoCoderDelegate> __weak _delegate;
}

@property(nonatomic, weak) id <NLGeoCoderDelegate> delegate;

- (void)reverseGeocodeLocation:(CLLocation *)location;

- (void)cancelGeocode;

@end
