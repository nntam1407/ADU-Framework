//
//  RouteInfo.h
//  Findereat
//
//  Created by Nguyen Minh Khoai on 10/18/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteInfo : NSObject {
    NSString *instructions;
    NSString *distance;
    NSString *duration;
}

@property(nonatomic, retain) NSString *instructions;
@property(nonatomic, retain) NSString *distance;
@property(nonatomic, retain) NSString *duration;

@end
