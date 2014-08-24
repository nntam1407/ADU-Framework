/*============================================================================
 PROJECT: SportLocker
 FILE:    NSObject+CastingObject.m
 AUTHOR:  Khoai Nguyen
 DATE:    7/27/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "NSObject+CastingObject.h"
#import <objc/runtime.h>
#import "DateHelper.h"
/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation NSObject (CastingObject)
- (NSNumber *)castToNumberValue {
    id value = [NSNumber numberWithInteger:0];
    if(self != [NSNull null]) {
        if([self isKindOfClass:[NSNumber class]]) {
            value = self;
        } else if ([self isKindOfClass:[NSString class]]) {
            value = [NSNumber numberWithInteger:[(NSString *)self integerValue]];
        }
        
    }
    return value;
}

- (NSString *)castToStringValue {
    NSString *result = @"";
    if(self != [NSNull null]) {
        if([self isKindOfClass:[NSString class]]) {
            result = (NSString *)self;
        }
    }
    return result;
}

- (NSDate *)castToDateValue {
    NSDate *date = nil;
    if(self != [NSNull null]) {
        if([self isKindOfClass:[NSDate class]]) {
            date = (NSDate *)self;
        } else if ([self isKindOfClass:[NSString class]]) {
            date = [DateHelper dateFromString:(NSString *)self withFormat:kDateFormat];
        }
    }
    return date;
}

@end
