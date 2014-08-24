/*============================================================================
 PROJECT: SportLocker
 FILE:    WarningNotifyControl.h
 AUTHOR:  Nguyen Minh Khoai
 DATE:    2/25/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "CMPopTipView.h"

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   WarningNotifyControl
 =============================================================================*/


@interface WarningNotifyControl : NSObject<CMPopTipViewDelegate> {
    CMPopTipView    *toolTipView;
}

@property (nonatomic, strong)   CMPopTipView    *toolTipView;

+ (id)sharedWarningNotifyControl;
- (void)showNotifyWithTitle:(NSString *)title message:(NSString *)message onView:(UIView *)view;
@end
