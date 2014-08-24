//
//  ShareableItem.h
//  HappinessApp
//
//  Created by Nam Tran on 7/27/12.
//  Copyright (c) 2012 On Budget and Time Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareableItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *imageURL;

- (id)initWithTitle:(NSString *)title;

@end