//
//  JSONHelper.m
//  Halalgems
//
//  Created by Nguyen Minh Khoai on 12/20/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//

#import "JSONHelper.h"

@implementation JSONHelper

+ (BOOL)isValidJSONFromDictionary:(NSDictionary *)data error:(NSError **)error {
    BOOL isValid = NO;
    
    NSDictionary *dictionary = nil;
    if ([data isKindOfClass:[NSData class]]) {
        dictionary = [NSJSONSerialization JSONObjectWithData:(NSData *)data
                                                     options:NSJSONReadingMutableContainers
                                                       error:error];
    } else if([data isKindOfClass:[NSDictionary class]]) {
        dictionary = data;
    }
    
    if([dictionary isKindOfClass:[NSDictionary class]]) {
        NSNumber *status = [[dictionary objectForKey:@"success"] castToNumberValue];
        NSNumber *errorCode = [[dictionary objectForKey:@"error"] castToNumberValue];
        NSString *message = [[dictionary objectForKey:@"message"] castToStringValue];
        
        isValid = Num2Bool(status);
        if(!isValid) {
            if (error != NULL) {
                *error = MKError(Num2Int(errorCode), message);
            }
        }
    }
    return isValid;
}

@end
