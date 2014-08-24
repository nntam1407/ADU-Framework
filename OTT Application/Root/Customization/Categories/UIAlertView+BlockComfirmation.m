/*============================================================================
 PROJECT: SportLocker
 FILE:    UIAlertView+BlockComfirmation.m
 AUTHOR:  Ho Huu Tai
 DATE:    6/20/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "UIAlertView+BlockComfirmation.h"
#import <objc/runtime.h>
/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation UIAlertView (BlockComfirmation)
//Runtime association key.
static NSString *handlerRunTimeAccosiationKey = @"alertViewBlocksDelegate";

- (void)showWithCompleteHandler:(UIAlertViewCallBackHandler)handler {
    objc_setAssociatedObject(self, (__bridge  const void *)(handlerRunTimeAccosiationKey), handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.delegate = self;
    [self show];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIAlertViewCallBackHandler completionHandler = objc_getAssociatedObject(self, (__bridge  const void *)(handlerRunTimeAccosiationKey));
    
    if (completionHandler != nil) {
        
        completionHandler(alertView, buttonIndex);
    }
}
@end
