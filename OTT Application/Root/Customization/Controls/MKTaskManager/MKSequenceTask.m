/*============================================================================
 PROJECT: FamilySupport
 FILE:    MKSequenceTask.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    5/27/14
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

@implementation MKSequenceTask

- (BOOL)isRuning {
    return (self.status == kSequenceTaskStatusProgressing);
}

- (BOOL)isStopped {
    return (self.status == kSequenceTaskStatusStopped);
}

- (void)start {
    self.status = kSequenceTaskStatusProgressing;
    self.executeBlock(self);
}

- (void)stop {
    self.status = kSequenceTaskStatusStopped;
    [self.manager removeSequenceTask:self];
    [self.manager startNextSequenceTask];
}

+ (MKSequenceTask *)taskWithBlock:(id)handler {
    @autoreleasepool {
        MKSequenceTask *task = [[MKSequenceTask alloc] init];
        task.executeBlock = handler;
        task.status = kSequenceTaskStatusNew;
        return task;
    }
}
@end
