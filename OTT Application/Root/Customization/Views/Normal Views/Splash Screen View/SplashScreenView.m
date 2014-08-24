//
//  SplashScreenView.m
//  Findereat
//
//  Created by Nguyen Minh Khoai on 10/17/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//

#import "SplashScreenView.h"

@interface SplashScreenView()
@end

@implementation SplashScreenView
@synthesize delegate;
@synthesize bgImageView;

+ (SplashScreenView *)sharedSplashScreen {
    static SplashScreenView *sharedSplashScreen = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!sharedSplashScreen) {
//            sharedSplashScreen = [[SplashScreenView alloc] initWithFrame:kScreenFrame];
            sharedSplashScreen = [[IBHelper sharedUIHelper] loadViewNib:@"SplashScreenView"];
        }
    });
    return sharedSplashScreen;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImageView.image = [[IBHelper sharedUIHelper] loadImage:@"Default"];
        [self addSubview:bgImageView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    bgImageView.image = [[IBHelper sharedUIHelper] loadImage:@"Default"];
    [self addSubview:bgImageView];
}

- (void)startAnimation {
    //sleep(4);
    [self handleTimer];
}

- (void)handleTimer {
    if(delegate && [delegate respondsToSelector:@selector(didFinishedAnimation:)]) {
        [delegate performSelector:@selector(didFinishedAnimation:) withObject:self];
    }
}

@end
