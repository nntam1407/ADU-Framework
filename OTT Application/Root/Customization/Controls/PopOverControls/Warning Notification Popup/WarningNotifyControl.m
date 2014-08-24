/*============================================================================
 PROJECT: SportLocker
 FILE:    WarningNotifyControl.m
 AUTHOR:  Nguyen Minh Khoai
 DATE:    2/25/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "WarningNotifyControl.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation WarningNotifyControl
@synthesize toolTipView;

+ (id)sharedWarningNotifyControl {
	static dispatch_once_t predicate;
	static WarningNotifyControl *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}
#if (!__has_feature(objc_arc))

- (id)retain {
    
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    
    return self;
}
#endif

- (void)showNotifyWithTitle:(NSString *)title message:(NSString *)message onView:(UIView *)view {
    if(!toolTipView) {
        self.toolTipView = [[CMPopTipView alloc] initWithTitle:title message:message];
        toolTipView.delegate = self;
        toolTipView.animation = CMPopTipAnimationSlide;
        toolTipView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        toolTipView.borderColor = [UIColor clearColor];
        toolTipView.textColor = [UIColor whiteColor];
        toolTipView.textFont = FontArialWithSize(14);
        toolTipView.dismissTapAnywhere = YES;
    } else {
        toolTipView.title = title;
        toolTipView.message = message;
    }
    
    UIView *containerView = [UIApplication sharedApplication].keyWindow;
    [toolTipView presentPointingAtView:view inView:containerView animated:YES];
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
        
}

@end
