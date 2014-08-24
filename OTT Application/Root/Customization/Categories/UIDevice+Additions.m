//
//  UIDevice+Additions.m
//  MobionPhoto
//
//  Created by Han Korea on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIDevice+Additions.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface UIDevice(Private)
- (NSString *)macaddress;
@end

@implementation UIDevice (UDID)

#pragma mark === Private Method ===
- (NSString *) macaddress {
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

#pragma mark === Public method ===

- (NSString *)udid {
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *uniqueIdentifier = [macaddress md5Encryption];
    return uniqueIdentifier;
}


- (NSString *)type
{
    size_t size;
    
    // Set 'oldp' parameter to NULL to get the size of the data
    // returned so we can allocate appropriate amount of space
    sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
    
    // Allocate the space to store name
    char *name = malloc(size);
    
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    
    // Place name into a string
    NSString *deviceType = @(name);
    
    // Done with this
    free(name);
    
    return deviceType;
}


- (BOOL)isIPod {
    NSString *m = [self model];
    return ([m rangeOfString:@"iPod"].length > 0);
}


- (BOOL)isIPad {
    SEL sel = @selector(userInterfaceIdiom);
    if ([self respondsToSelector:sel]) {
        return (self.userInterfaceIdiom == UIUserInterfaceIdiomPad);
    }
    return FALSE;
}

- (CGFloat)currentSysVersion {
    NSString *version = [self systemVersion];
    return [version floatValue];
}

- (BOOL)hasSupportVersion:(CGFloat)v {
    CGFloat version = [self currentSysVersion];
    return (version >= v);
}

- (BOOL)hasSupportLessThanVersion:(CGFloat)v {
    CGFloat version = [self currentSysVersion];
    return (version < v);
}

- (NSString *)cpuFrequency {
    size_t length;
    int mib[6];    
    int result;
    
    mib[0] = CTL_HW;
    mib[1] = HW_CPU_FREQ;
    length = sizeof(result);
    if (sysctl(mib, 2, &result, &length, NULL, 0) < 0) {
        NSLog(@"Error getting cpu frequency");
    }
    return [NSString stringWithFormat:@"%d hz", result];
}

- (UIDeviceResolution)resolution {
    UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIDeviceResolution_iPhoneRetina4;
            else if (pixelHeight == 1136.0f)
                resolution = UIDeviceResolution_iPhoneRetina5;
            
        } else if (scale == 1.0f && pixelHeight == 480.0f)
            resolution = UIDeviceResolution_iPhoneStandard;
        
    } else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIDeviceResolution_iPadRetina;
            
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIDeviceResolution_iPadStandard;
        }
    }
    
    return resolution;
}

- (NSString *)resolutionToString {
    UIDeviceResolution resolution = [self resolution];
    NSString *pixelRatio = @"";
    
    switch (resolution) {
        case UIDeviceResolution_Unknown:
            pixelRatio = @"Unknow";
            break;
            
        case UIDeviceResolution_iPhoneStandard:
            pixelRatio = @"iPhoneStandard";
            break;
            
        case UIDeviceResolution_iPhoneRetina4:
            pixelRatio = @"iPhoneRetina4";
            break;
            
        case UIDeviceResolution_iPhoneRetina5:
            pixelRatio = @"iPhoneRetina5";
            break;
            
        case UIDeviceResolution_iPadStandard:
            pixelRatio = @"iPadStandard";
            break;
            
        case UIDeviceResolution_iPadRetina:
            pixelRatio = @"iPadRetina";
            break;
    }
    return pixelRatio;
}

@end
