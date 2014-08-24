/*============================================================================
 PROJECT: SportLocker
 FILE:    UIActionSheet+UsingBlock.m
 AUTHOR:  Ho Huu Tai
 DATE:    6/20/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "UIActionSheet+UsingBlock.h"
#import <objc/runtime.h>
/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
//Runtime association key.
static NSString *handlerRunTimeAccosiationKey = @"actionSheetBlocksDelegate";
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation UIActionSheet (UsingBlock)

- (void)showInView:(UIView *)view withCompletionHanlder:(UIActionSheetCallBack)callback{
    objc_setAssociatedObject(self, (__bridge  const void*)(handlerRunTimeAccosiationKey), callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.delegate = self;
    [self showInView:view];
}
- (void)showFromTabBar:(UITabBar *)tabbar withCompletionHanlder:(UIActionSheetCallBack)callback{
    objc_setAssociatedObject(self, (__bridge  const void*)(handlerRunTimeAccosiationKey), callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.delegate = self;
    [self showFromTabBar:tabbar];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated withCompletionHanlder:(UIActionSheetCallBack)callback{
    objc_setAssociatedObject(self, (__bridge  const void*)(handlerRunTimeAccosiationKey), callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.delegate = self;
    [self showFromRect:rect inView:view animated:animated];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    UIActionSheetCallBack completionHandler = objc_getAssociatedObject(self, (__bridge  const void *)(handlerRunTimeAccosiationKey));
    
    if (completionHandler != nil) {
        completionHandler(actionSheet, buttonIndex);
    }
}

@end
