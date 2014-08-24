//
//  DirectionInfo.h
//  Findereat
//
//  Created by Nguyen Minh Khoai on 10/18/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//

#import <Foundation/Foundation.h>

/* direction mode */
typedef NS_ENUM(NSInteger, DirectionModeType) {
    kDirectionModeTypeWalking = 0,
    kDirectionModeTypeDriving,
    kDirectionModeTypeTransit
};

#define kDirectionModes @[@"walking", @"driving", @"transit"]

@interface DirectionInfo : NSObject {
    NSMutableArray *routes;
    NSString *addressA;
    NSString *addressB;
    NSString *distance;
    NSString *duration;
}

@property(nonatomic, retain) NSMutableArray *routes;
@property(nonatomic, retain) NSString *addressA;
@property(nonatomic, retain) NSString *addressB;
@property(nonatomic, retain) NSString *distance;
@property(nonatomic, retain) NSString *duration;

- (void)setupWithDictionary:(NSDictionary *)dict;

@end
