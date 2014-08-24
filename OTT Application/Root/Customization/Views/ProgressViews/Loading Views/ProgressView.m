/*============================================================================
 PROJECT: SportLocker
 FILE:    ProgressView.m
 AUTHOR:  Nguyen Minh Khoai
 DATE:    2/22/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "ProgressView.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface ProgressView ()
@property(strong, nonatomic) UIImageView *imageView;
@property(assign, nonatomic) BOOL visible;
@end

@implementation ProgressView

+ (ProgressView *)progressView {
    
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, kLoadingViewWidth, kLoadingViewHeight);
        ProgressView *progressView = [[ProgressView alloc] initWithFrame:rect];
        [progressView setTextColor:[UIColor whiteColor]];
        [progressView setActivityColor:[UIColor whiteColor]];
        progressView.activityView.center = CGPointMake(progressView.frame.size.width / 2, progressView.frame.size.height / 2);
        progressView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [progressView setBackgroundImage:nil];
        
        return progressView;
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        @autoreleasepool {
            self.backgroundColor = [UIColor clearColor];
            _animationType = kProgressViewAnimationTypeFade;
            LayerConer(self.layer);
            
            /* create and add background view */
            _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            _imageView.backgroundColor = [UIColor blackColor];
            _imageView.alpha = 0.6f;
            _imageView.layer.opaque = NO;
            [self addSubview:_imageView];
            
            /* create and add activity view */
            CGFloat dy = (self.bounds.size.height - 20) / 2;
            _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            _activityView.hidesWhenStopped = YES;
            [_activityView setColor:UIColorFromRGB(0x000000)];
            [self addSubview:_activityView];
            
            /* create and add label title */
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dy, self.bounds.size.width, self.bounds.size.height - 2 * dy)];
            _titleLabel.font = FontArialWithSize(14);
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            [_titleLabel setBackgroundColor:[UIColor clearColor]];
            [self addSubview:_titleLabel];
            
            /* create and add cancel button */
            _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelButton setFrame:CGRectMake(self.bounds.size.width - 30, dy, 20, 20)];
            [_cancelButton addTarget:self action:@selector(didTouchedOnCancelButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_cancelButton];
            
            self.enabledOverlayView = YES;
        }
    }
    return self;
}

- (void)didTouchedOnCancelButton:(id)sender {
    CallTarget(_delegate, @
               selector(didCanceledActionView:), self);
    [self hide];
}

- (void)setActivityColor:(UIColor *)color {
    [_activityView setColor:color];
}

- (void)setTextColor:(UIColor *)color {
    [_titleLabel setTextColor:color];
}

- (void)setBackgroundImage:(UIImage *)image {
    if (image) {
        _imageView.image = image;
        _imageView.alpha = 1.0;
    }
    _imageView.backgroundColor = [UIColor clearColor];
}

- (void)setTitle:(NSString *)title {
    [_titleLabel setText:title];
}

- (void)show:(BOOL)animated {
    if (_visible) {
        return;
    }
    _visible = YES;
    
    if (!self.superview) {
        UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
        
        /* add overlay view first */
        if (self.enabledOverlayView) {
            @autoreleasepool {
                self.overlayView = [[UIView alloc] initWithFrame:kScreenFrame];
                _overlayView.backgroundColor = [UIColor clearColor];
                [topWindow addSubview:_overlayView];
            }
        }
        /* add main view now */
        [topWindow addSubview:self];
    }
    
    /* layout center */
    CGRect rect = self.frame;
    rect.origin.x = (kScreenFrame.size.width - rect.size.width) / 2;
    rect.origin.y = (kScreenFrame.size.height - rect.size.height) / 2;
    self.frame = rect;
    
    [_activityView startAnimating];
    
    if (animated) {
        if (_animationType == kProgressViewAnimationTypeFade) {
            /* Show with effect */
            self.layer.opacity = 0;
            
            [UIView animateWithDuration:0.4f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.layer.opacity = 1;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
            
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
            [UIView animateWithDuration:0.2 delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                             }
                             completion:^(BOOL finished) {
                             }];
        }
    } else {
        self.layer.opacity = 1;
    }
}

- (void)showOnView:(UIView *)view
         animation:(BOOL)animated
            freeze:(BOOL)freeze
               top:(CGFloat)topMargin {
    if (_visible) {
        return;
    }
    _visible = YES;
    
    if (!self.superview) {
        if (freeze) {
            @autoreleasepool {
                /* add overlay view first */
                self.overlayView = [[UIView alloc] initWithFrame:view.frame];
                _overlayView.backgroundColor = [UIColor clearColor];
                _overlayView.opaque = NO;
                
                CGRect rect = _overlayView.frame;
                rect.origin = CGPointMake(0, 0 + topMargin);
                _overlayView.frame = rect;
                
                [view addSubview:_overlayView];
            }
        }
        [view addSubview:self];
    }
    
    /* layout center */
    CGRect rect = self.frame;
    rect.origin.x = (view.frame.size.width - rect.size.width) / 2;
    rect.origin.y = (view.frame.size.height - rect.size.height) / 2;
    self.frame = rect;
    
    [_activityView startAnimating];
    
    if (animated) {
        if (_animationType == kProgressViewAnimationTypeFade) {
            /* Show with effect */
            self.layer.opacity = 0;
            
            [UIView animateWithDuration:0.4f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.layer.opacity = 1;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
            
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
            [UIView animateWithDuration:0.2 delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                             }
                             completion:^(BOOL finished) {
                             }];
        }
    } else {
        self.layer.opacity = 1;
    }
}

- (void)showOnView:(UIView *)view animation:(BOOL)animated {
    if (_visible) {
        return;
    }
    _visible = YES;
    
    /* layout center */
    CGRect rect = self.frame;
    rect.origin.x = (view.frame.size.width - rect.size.width) / 2;
    rect.origin.y = (view.frame.size.height - rect.size.height) / 2;
    self.frame = rect;
    
    [_activityView startAnimating];
    
    if (animated) {
        if (_animationType == kProgressViewAnimationTypeFade) {
            /* Show with effect */
            self.layer.opacity = 0;
            
            [UIView animateWithDuration:0.4f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 self.layer.opacity = 1;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
            
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
            [UIView animateWithDuration:0.2 delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                             }
                             completion:^(BOOL finished) {
                             }];
        }
    } else {
        self.layer.opacity = 1;
    }
}

- (void)show {
    [self show:YES];
}

- (void)clear {
    
    /* stop activity */
    [_activityView stopAnimating];
    
    /* remove overlay view */
    [_overlayView removeFromSuperview];
    self.overlayView = nil;
    
    /* remove view from its parent */
    [self removeFromSuperview];
}

- (void)hide:(BOOL)animated {
    if (!_visible) {
        return;
    }
    _visible = NO;
    
    if (self.superview) {
        if (animated) {
            if (_animationType == kProgressViewAnimationTypeFade) {
                /* zoom in animation */
                [UIView animateWithDuration:0.3f
                                 animations:^{
                                     self.layer.opacity = 0;
                                 }
                                 completion:^(BOOL finished) {
                                     [self clear];
                                 }];
            }
        } else {
            [self clear];
        }
    }
    
}

- (void)hide {
    [self hide:YES];
}

@end
