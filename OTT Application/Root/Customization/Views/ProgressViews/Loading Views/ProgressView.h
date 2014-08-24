/*============================================================================
 PROJECT: SportLocker
 FILE:    ProgressView.h
 AUTHOR:  Nguyen Minh Khoai
 DATE:    2/22/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>


/*============================================================================
 MACRO
 =============================================================================*/

#define kLoadingViewWidth 80
#define kLoadingViewHeight 80

typedef enum {
    kProgressViewAnimationTypeFade = 0
} ProgressViewAnimationType;
/*============================================================================
 PROTOCOL
 =============================================================================*/
@class ProgressView;

@protocol ProgressViewDelegate <NSObject>
@optional
- (void)didCanceledActionView:(ProgressView *)view;
@end

/*============================================================================
 Interface:   ProgressView
 =============================================================================*/

@interface ProgressView : UIView

@property(nonatomic, weak) id <ProgressViewDelegate> delegate;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIView *overlayView;
@property(nonatomic, assign) ProgressViewAnimationType animationType;
@property(nonatomic, assign) BOOL enabledOverlayView;

+ (ProgressView *)progressView;

- (void)show:(BOOL)animated;

- (void)show;

- (void)showOnView:(UIView *)view animation:(BOOL)animated;

- (void)showOnView:(UIView *)view animation:(BOOL)animated freeze:(BOOL)freeze top:(CGFloat)topMargin;

- (void)hide:(BOOL)animated;

- (void)hide;

- (void)setTextColor:(UIColor *)color;

- (void)setActivityColor:(UIColor *)color;

- (void)setBackgroundImage:(UIImage *)image;

- (void)setTitle:(NSString *)title;

@end
