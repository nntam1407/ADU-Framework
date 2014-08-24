//
//  RouteInfo.m
//  Findereat
//
//  Created by Nguyen Minh Khoai on 10/18/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//
#import "RouteInfo.h"

@implementation RouteInfo
@synthesize instructions, distance, duration;

- (void)dealloc {
    self.distance = nil;
    self.instructions = nil;
    self.duration = nil;
}
@end
