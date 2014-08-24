/*============================================================================
 PROJECT: SportLocker
 FILE:    NSInvocation+DynamicMethods.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    11/21/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "NSInvocation+DynamicMethods.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation NSInvocation (DynamicMethods)

+ (void)performSelector:(SEL)sel onTarget:(id)target params:(void(^)(NSInvocation *invocation))block {
    /* create signature first & create invocation */
    NSMethodSignature *sig = [[target class] instanceMethodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation retainArguments];
    [invocation setTarget:target];
    [invocation setSelector:sel];
    
    /* settings invocation here */
    block(invocation);
    
    /* call invocation */
    [invocation invoke];
}

@end
