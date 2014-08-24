/*============================================================================
 PROJECT: SportLocker
 FILE:    TWLoadingView.m
 AUTHOR:  Nguyen Minh Khoai
 DATE:    2/22/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "TWLoadingView.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
#define kTWLoadingViewWidth 80
#define kTWLoadingViewHeight 80

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
@implementation TWLoadingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /* configure some properties */
        [self setTextColor:[UIColor whiteColor]];
        [self setActivityColor:[UIColor whiteColor]];
        [self setTitle:@""];
    }
    return self;
}

+ (TWLoadingView *)sharedLoadingView {
    static TWLoadingView *sharedLoading = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!sharedLoading) {
            CGFloat x = (kScreenFrame.size.width - kTWLoadingViewWidth)/2;
            CGFloat y = (kScreenFrame.size.height - kTWLoadingViewHeight)/2;
            CGRect rect = CGRectMake(x, y, kTWLoadingViewWidth, kTWLoadingViewHeight);
            sharedLoading = [[TWLoadingView alloc] initWithFrame:rect];
            
            sharedLoading.activityView.center = CGPointMake(rect.size.width/2, rect.size.height/2);
        }
    });
    return sharedLoading;
}

+ (void)showWithDelegate:(id)delegate {
    TWLoadingView *view = [TWLoadingView sharedLoadingView];
    view.delegate = delegate;
    
    /* show view now */
    [view show];
}

+ (void)show {
    TWLoadingView *view = [TWLoadingView sharedLoadingView];
    /* show view now */
    [view show];
}

+ (void)hide {
    TWLoadingView *view = [TWLoadingView sharedLoadingView];
    /* hide view now */
    [view hide];
}

@end
