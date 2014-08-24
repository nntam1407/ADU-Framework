/*============================================================================
 PROJECT: SportLocker
 FILE:    UIActionSheet+UsingBlock.h
 AUTHOR:  Ho Huu Tai
 DATE:    6/20/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>

/*============================================================================
 MACRO
 =============================================================================*/
typedef void(^UIActionSheetCallBack) (UIActionSheet *actionSheet, NSInteger selectedIndex);
/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   UIActionSheet_UsingBlock
 =============================================================================*/

@interface UIActionSheet (UsingBlock) <UIActionSheetDelegate>
- (void)showInView:(UIView *)view withCompletionHanlder:(UIActionSheetCallBack)callback;
- (void)showFromTabBar:(UITabBar *)tabbar withCompletionHanlder:(UIActionSheetCallBack)callback;
- (void)showFromRect:(CGRect)rect inView:(UIView*)view animated:(BOOL)animated withCompletionHanlder:(UIActionSheetCallBack)callback;
@end
