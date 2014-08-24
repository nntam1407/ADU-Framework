//
//  SplashScreenView.h
//  Findereat
//
//  Created by Nguyen Minh Khoai on 10/17/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SplashScreenView;
@protocol SplashScreenViewDelegate <NSObject>
- (void)didFinishedAnimation:(SplashScreenView *)view;
@end

@interface SplashScreenView : UIView {
    id<SplashScreenViewDelegate> __weak delegate;
}

@property (strong, nonatomic) UIImageView *bgImageView;
@property (nonatomic, weak)   id<SplashScreenViewDelegate> delegate;

- (void)startAnimation;
+ (SplashScreenView *)sharedSplashScreen;

@end
