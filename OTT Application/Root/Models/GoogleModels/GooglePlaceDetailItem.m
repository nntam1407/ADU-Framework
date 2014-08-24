//
//  GooglePlaceDetailItem.m
//  Halalgems
//
//  Created by taihh on 10/10/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//
#import "GooglePlaceDetailItem.h"

@implementation GooglePlaceDetailItem

- (id)copyWithZone:(NSZone *)zone {
    GooglePlaceDetailItem *copyItem = [[GooglePlaceDetailItem allocWithZone:zone] init];
    copyItem.name = _name;
    copyItem.latitude = _latitude;
    copyItem.longtitude = _longtitude;
    copyItem.iconUrl = _iconUrl;
    return copyItem;
}

@end
