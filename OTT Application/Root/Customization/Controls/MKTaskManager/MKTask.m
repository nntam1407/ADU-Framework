/*============================================================================
 PROJECT: FamilySupport
 FILE:    MKRefreshTask.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    5/17/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation MKTask

+ (MKTask *)operationWithBlock:(TaskBlock)handler {
    @autoreleasepool {
        MKTask *task = [[MKTask alloc] init];
        task.executeBlock = handler;
        return task;
    }
}

- (void)main {
    @try {
        self.executeBlock();
    }
    @catch (NSException *exception) {

    }
}

@end
