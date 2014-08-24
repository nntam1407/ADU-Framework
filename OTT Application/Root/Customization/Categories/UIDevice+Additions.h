//
//  UIDevice+Additions.h
//  MobionPhoto
//
//  Created by Han Korea on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    UIDeviceResolution_Unknown           = 0,
    UIDeviceResolution_iPhoneStandard    = 1,    // iPhone 1,3,3GS Standard Display  (320x480px)
    UIDeviceResolution_iPhoneRetina4    = 2,    // iPhone 4,4S Retina Display 3.5"  (640x960px)
    UIDeviceResolution_iPhoneRetina5     = 3,    // iPhone 5 Retina Display 4"       (640x1136px)
    UIDeviceResolution_iPadStandard      = 4,    // iPad 1,2,mini Standard Display   (1024x768px)
    UIDeviceResolution_iPadRetina        = 5     // iPad 3 Retina Display            (2048x1536px)
}; typedef NSUInteger UIDeviceResolution;

NSString *NSStringFromResolution(UIDeviceResolution resolution);

@interface  UIDevice (UDID)
- (NSString *)udid;
- (NSString *)type;
- (NSString *)cpuFrequency;
- (BOOL)isIPod;
- (BOOL)isIPad;
- (NSString *)macaddress;
- (BOOL)hasSupportVersion:(CGFloat)version;
- (BOOL)hasSupportLessThanVersion:(CGFloat)version;
- (UIDeviceResolution)resolution;
- (NSString *)resolutionToString;
@end
