//
//  AutoScrollView.h
//  AutoScrollView
//
//  Created by Clark Kent on 7/18/13.
//  Copyright (c) 2013 Clark Kent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoScrollView : UIScrollView

@property (nonatomic, assign) float activeViewBottomMargin;
@property (nonatomic, assign) float extendKeyboardHeight;

- (void)enableCloseKeyboardWhenTouchOutSideTextField:(BOOL)enable;
- (void)setFocusView:(UIView *)focusView;

@end
