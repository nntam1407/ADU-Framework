/*============================================================================
 PROJECT: FamilySupport
 FILE:    MKCachedLocation.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    6/19/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "MKCachedLocation.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation MKCachedLocation

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeDouble:self.latitude forKey:@"lat"];
    [coder encodeDouble:self.longitude forKey:@"lng"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self.latitude = [coder decodeDoubleForKey:@"lat"];
    self.longitude = [coder decodeDoubleForKey:@"lng"];
    return self;
}

+ (MKCachedLocation *)cachedLocationForLocation:(CLLocation *)location {
    MKCachedLocation *cache = [[MKCachedLocation alloc] init];
    cache.latitude = location.coordinate.latitude;
    cache.longitude = location.coordinate.longitude;
    return cache;
}

- (CLLocation *)cachedLocation {
    @autoreleasepool {
        return [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    }
}
@end
