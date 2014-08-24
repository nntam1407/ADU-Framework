//
//  SLCoverItem.m
//  SportLocker
//
//  Created by Vinh Huynh on 6/26/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLCoverItem.h"

@implementation SLCoverItem

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    BOOL isOptionalProperty = [super propertyIsOptional:propertyName];
    isOptionalProperty |= ([propertyName isEqualToString:@"content"] ||
                           [propertyName isEqualToString:@"subtitle"] ||
                           [propertyName isEqualToString:@"date"]
                           );
    
    return isOptionalProperty;
}

@end
