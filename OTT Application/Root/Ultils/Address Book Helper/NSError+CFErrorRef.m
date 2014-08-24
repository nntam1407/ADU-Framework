/*============================================================================
 PROJECT: SportLocker
 FILE:    NSError+CFErrorRef.m
 AUTHOR:  Khoai Nguyen
 DATE:    8/6/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "NSError+CFErrorRef.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation NSError (CFErrorRef)
- (CFErrorRef) cferror{
    CFStringRef domain = (__bridge CFStringRef) self.domain;
    CFDictionaryRef userInfo = (__bridge CFDictionaryRef)self.userInfo;
    CFErrorRef returnRef = CFErrorCreate(kCFAllocatorDefault, domain, self.code, userInfo);
    id temp =  (__bridge_transfer id)returnRef;
    DLog(@"%@", temp);
    return returnRef;
}
@end
