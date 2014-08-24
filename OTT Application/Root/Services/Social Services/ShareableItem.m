//
//  ShareableItem.m
//  HappinessApp
//
//  Created by Nam Tran on 7/27/12.
//  Copyright (c) 2012 On Budget and Time Ltd. All rights reserved.
//

#import "ShareableItem.h"

@implementation ShareableItem
@synthesize title, image, url;

- (id)initWithTitle:(NSString *)shareTitle {
    self = [super init];
    if (self) {
        self.title = shareTitle;
    }
    return self;
}

@end
