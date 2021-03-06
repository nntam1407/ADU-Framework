/*============================================================================
 PROJECT: SportLocker
 FILE:    UIView+PopUp.h
 AUTHOR:  Huu Tai Ho
 DATE:    8/28/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   UIView_PopUp
 =============================================================================*/

@interface UIView (PopUp)

- (void)showModalWithOpacityOverlay:(CGFloat)opacity;
- (void)hide;

@end
