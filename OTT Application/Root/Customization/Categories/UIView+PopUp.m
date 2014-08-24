/*============================================================================
 PROJECT: SportLocker
 FILE:    UIView+PopUp.m
 AUTHOR:  Huu Tai Ho
 DATE:    8/28/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "UIView+PopUp.h"
#import <objc/runtime.h>
/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
@interface UIView(PrivatePopUp){
}

@property (nonatomic, strong)   UIButton  *overlayView;
@property (nonatomic, assign)   BOOL       visible;

- (void)hidePopUp:(id)sender;
@end

@implementation UIView (PopUp)

//Runtime association key.
static NSString *visible = @"visible";
static NSString *overlayView = @"overlayView";

- (void)showModalWithOpacityOverlay:(CGFloat)opacity {
    /* don't show if visible */
    if(self.visible) {
        return;
    }
    
    self.visible = YES;
    
    /* overlay view */
    if (!self.overlayView) {
        self.overlayView = [[UIButton alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [self.overlayView addTarget:self action:@selector(hidePopUp:) forControlEvents:UIControlEventTouchUpInside];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.layer.opacity = 0;
    }
    
    
    /* show if hidden view */
    if(!self.superview) {
        /* get top window */
        UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
        [topWindow addSubview:self.overlayView];
        self.center = topWindow.center;
        [topWindow addSubview:self];
        //overlayView.alpha = 0;
        
        // set first hiden if has animation
        self.layer.opacity = 0;
        self.overlayView.layer.opacity = 0;
        
        [UIView animateWithDuration:0.4f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.layer.opacity = 1;
                             self.overlayView.layer.opacity = opacity;
                         }
                         completion:^(BOOL finished) {
                         }];
        
        //[_viewMainFlag popFromInitialScale:1.0f];
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.94, 0.94);
        [UIView animateWithDuration:0.2 delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

- (void)hide {
    /* don't hide if hidden */
    if(!self.visible) {
        return;
    }
    self.visible = NO;
    
    /* hide it */
    if (self.superview) {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.layer.opacity = 0;
                             
                             // hide overlay view
                             if (self.overlayView) {
                                 self.overlayView.layer.opacity = 0;
                             }
                         }
                         completion:^(BOOL finished) {
                             // hide overlay view
                             if (self.overlayView) {
                                 [self.overlayView removeFromSuperview];
                             }
                             
                             [self removeFromSuperview];
                         }];
    }
}

- (UIView *)overlayView{
    return objc_getAssociatedObject(self, (__bridge const void*)(overlayView));
}

- (void)setOverlayView:(UIView *)view{
    objc_setAssociatedObject(self, (__bridge const void*)overlayView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)visible{
    NSNumber *visibleBOOL = objc_getAssociatedObject(self, (__bridge const void*)(visible));
    return visibleBOOL.boolValue;
}

- (void)setVisible:(BOOL)isVisible{
    NSNumber *visibleBOOL = [NSNumber numberWithBool:isVisible];
    objc_setAssociatedObject(self, (__bridge const void*)visible, (id)visibleBOOL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark Private

- (void)hidePopUp:(id)sender{
    [self hide];
}
@end
