/*============================================================================
 PROJECT: FamilySupport
 FILE:    MKUITaskRefresh.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    5/17/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
#define kTimerBlockKey  @"kTimerBlockKey"
#define kTimerKey       @"kTimerKey"
#define kTimerInterval  0.2f

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
@interface MKTaskManager ()
@property(strong, nonatomic) NSOperationQueue *refreshQueue;
@property(strong, nonatomic) NSMutableDictionary *timers;
@property(strong, nonatomic) NSMutableArray *sequenceTasks;
@end

@implementation MKTaskManager

- (id)init {
    self = [super init];
    if (self) {
        self.activeTime = kTimerInterval;
    }
    return self;
}

- (NSOperationQueue *)refreshQueue {
    if (!_refreshQueue) {
        _refreshQueue = [[NSOperationQueue alloc] init];
        _refreshQueue.maxConcurrentOperationCount = 1;
    }
    return _refreshQueue;
}

- (NSMutableDictionary *)timers {
    if (!_timers) {
        _timers = [NSMutableDictionary dictionary];
    }
    return _timers;
}

- (NSMutableArray *)sequenceTasks {
    if (!_sequenceTasks) {
        _sequenceTasks = [NSMutableArray array];
    }
    return _sequenceTasks;
}

- (void)startTask:(NSString *)taskName executeBlock:(TaskBlock)executeBlock {

    /* create main task */
    MKTask *refreshTask = [MKTask operationWithBlock:executeBlock];
    refreshTask.name = taskName;

    /* add task in queue */
    [self.refreshQueue addOperation:refreshTask];

    /* start queue if it's stopping */
    if (self.refreshQueue.isSuspended) {
        [self.refreshQueue setSuspended:NO];
    }
}

- (void)stopTasksInQueue {
    [self.refreshQueue setSuspended:YES];
    [self.refreshQueue cancelAllOperations];
}

/* sequencer tasks */
- (BOOL)isRuningSequenceTask {
    NSEnumerator *enumerator = [self.sequenceTasks reverseObjectEnumerator];

    for (MKSequenceTask *task in enumerator) {
        if ([task isRuning]) return YES;
    }

    return NO;
}

- (void)removeSequenceTask:(MKSequenceTask *)task {
    if (task) {
        [self.sequenceTasks removeObject:task];
    }
}

- (void)startNextSequenceTask {
    if (self.sequenceTasks.count > 0) {
        MKSequenceTask *task = [self.sequenceTasks lastObject];
        if (task) {
            [task start];
        }
    }
}

- (void)startSequenceTaskInBlock:(SequenceTaskBlock)handler {

    MKSequenceTask *task = [MKSequenceTask taskWithBlock:handler];
    task.manager = self;
    [self.sequenceTasks addObject:task];

    if (![self isRuningSequenceTask]) {
        [self startNextSequenceTask];
    }
}

#pragma mark - Timer

- (void)startTimer:(NSString *)timerKey handler:(void (^)())handler repeat:(BOOL)repeat {

    /* stop timer first */
    [self stopTimerForKey:timerKey];

    /* start new timer */
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.activeTime
                                             target:self
                                           selector:@selector(handleTimer:)
                                           userInfo:@{kTimerBlockKey : handler, kTimerKey : timerKey}
                                            repeats:repeat];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [self.timers setObject:timer forKey:timerKey];
}

- (void)stopTimerForKey:(NSString *)timerKey {
    NSTimer *timer = self.timers[timerKey];
    if (timer) {
        [timer invalidate];
        [self.timers removeObjectForKey:timerKey];
        timer = nil;
    }
}

- (void)handleTimer:(NSTimer *)timer {
    void (^TimerBlock)(void) = timer.userInfo[kTimerBlockKey];
    TimerBlock();

    NSString *timerKey = timer.userInfo[kTimerKey];
    [self stopTimerForKey:timerKey];
}

@end
