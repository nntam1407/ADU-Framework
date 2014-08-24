/*============================================================================
 PROJECT: SportLocker
 FILE:    UIImageView+Loading.m
 AUTHOR:  Ngoc Tam Nguyen
 DATE:    10/10/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "UIImageView+Loading.h"
#import <objc/runtime.h>

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface UIView(PrivateLoading)

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

//Runtime association key.
static NSString *indicatorView = @"indicatorView";

@implementation UIImageView (Loading)

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.indicatorView.frame;
    rect.origin.x = (self.bounds.size.width - rect.size.width)/2;
    rect.origin.y = (self.bounds.size.height - rect.size.height)/2;
    self.indicatorView.frame = rect;
}

- (UIView *)indicatorView {
    return objc_getAssociatedObject(self, (__bridge const void*)(indicatorView));
}

- (void)setIndicatorView:(UIActivityIndicatorView *)indicator {
    objc_setAssociatedObject(self, (__bridge const void*)indicatorView, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)startLoading {
    if(self.indicatorView == nil) {
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.indicatorView setHidesWhenStopped:YES];
    }
    
    // Add to this image view and center it
    if(!self.indicatorView.superview) {
        [self addSubview:self.indicatorView];
    } else {
        [self.indicatorView bringSubviewToFront:self];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Start animation
        [self.indicatorView startAnimating];
        [self setNeedsLayout];
    });
}

- (void)stopLoading {
    if(self.indicatorView == nil) {
        return;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
        });
    }
}

@end
