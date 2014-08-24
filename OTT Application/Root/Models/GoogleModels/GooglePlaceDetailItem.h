//
//  GooglePlaceDetailItem.h
//  Halalgems
//
//  Created by taihh on 10/10/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GooglePlaceDetailItem : NSObject
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *longtitude;
@property(nonatomic, strong) NSString *latitude;
@property(nonatomic, strong) NSString *iconUrl;
@end
