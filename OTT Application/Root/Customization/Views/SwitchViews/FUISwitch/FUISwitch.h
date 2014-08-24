//
//  FUISwitch.h
//  FlatUI
//
//  Created by Jack Flintermann on 5/3/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FUISwitch : UIControl

@property(nonatomic,getter=isOn) BOOL on;
@property(nonatomic, strong) UIColor *onBackgroundColor;
@property(nonatomic, strong) UIColor *offBackgroundColor;
@property(nonatomic, strong) UIColor *onColor;
@property(nonatomic, strong) UIColor *offColor;
@property(nonatomic, strong) UIColor *highlightedColor;
@property(nonatomic, readwrite) CGFloat percentOn;
@property(strong, readwrite, nonatomic) UILabel *offLabel;
@property(strong, readwrite, nonatomic) UILabel *onLabel;
- (void)setOn:(BOOL)on animated:(BOOL)animated; // does not send action


@end
