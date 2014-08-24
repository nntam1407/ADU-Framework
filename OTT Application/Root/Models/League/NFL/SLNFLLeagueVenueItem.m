//
//  SLLeagueVenueItem.m
//  SportLocker
//
//  Created by Vinh Huynh on 8/14/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLNFLLeagueVenueItem.h"

@implementation SLNFLLeagueVenueItem
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    BOOL isOptionalProperty = [super propertyIsOptional:propertyName];
    isOptionalProperty |= ([propertyName isEqualToString:@"numberOfExecutiveSuites"]
                           );
    
    return isOptionalProperty;
}
@end
