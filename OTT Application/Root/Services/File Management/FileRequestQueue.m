/*============================================================================
 PROJECT: SportLocker
 FILE:    FileRequestQueue.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    11/14/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "FileRequestQueue.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
#define kBaseHTTP   @"http://dealhits.net" /* customize it depending on project */

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation FileRequestQueue

- (id)init {
    self = [super init];
    if (self) {
        self.maxConcurrentOperationCount = 1;
        
        /* register notifications for application */
        NotifReg(self, @selector(applicationDidBecomeActive:), UIApplicationDidBecomeActiveNotification);
        NotifReg(self, @selector(applicationWillEnterBackground:), UIApplicationWillEnterForegroundNotification);
        NotifReg(self, @selector(applicationWillBeTerminated:), UIApplicationWillTerminateNotification);
    }
    return self;
}

- (void)configureRequestHeader {
    
}

#pragma mark - Accesstor

- (OrderedDictionary *)runningQueue {
    if(!_runningTaskQueue) {
        _runningTaskQueue = [[OrderedDictionary alloc] init];
    }
    return _runningTaskQueue;
}

- (OrderedDictionary *)waitingQueue {
    if(!_waitingTaskQueue) {
        _waitingTaskQueue = [[OrderedDictionary alloc] init];
    }
    return _waitingTaskQueue;
}

- (OrderedDictionary *)requestTaskQueue {
    if(!taskQueue) {
        taskQueue = [[OrderedDictionary alloc] init];
    }
    [taskQueue removeAllObjects];
    [taskQueue addObjectsFromDictionary:_waitingTaskQueue];
    [taskQueue addObjectsFromDictionary:_runningTaskQueue];
    return taskQueue;
}

- (NSString *)waitingQueueKey {
    return [NSStringFromClass([self class]) stringByAppendingFormat:@"_WaitingQueue"];
}

- (NSString *)runningQueueKey {
    return [NSStringFromClass([self class]) stringByAppendingFormat:@"_RunningQueue"];
}

- (AFHTTPRequestOperationManager *)requestQueue {
    if(!_client) {
        _client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseHTTP]];
    }
    return _client;
}

- (void)setMaxConcurrentOperationCount:(NSInteger)maxConcurrentOperationCount {
    _maxConcurrentOperationCount = maxConcurrentOperationCount;
    [self.requestQueue.operationQueue setMaxConcurrentOperationCount:maxConcurrentOperationCount];
}

#pragma mark - Queue Manament Methods

- (BOOL)isFinished {
    return (self.waitingQueue.count == 0 && self.runningQueue.count == 0);
}

- (BOOL)isStopped {
    return (self.requestQueue.operationQueue.operationCount > 0 && self.requestQueue.operationQueue.isSuspended);
}

- (BOOL)isInterrupted {
    return NO;
}

- (AFHTTPRequestOperation *)operationForFileRequest:(FileRequest *)fileRequest {
    /* will be overriden on subclasses */
    return nil;
}

- (void)cancelAllOperations {
    [self.requestQueue.operationQueue cancelAllOperations];
}

- (void)pauseAllOperations {
    if(!self.requestQueue.operationQueue.isSuspended) {
        [self.requestQueue.operationQueue setSuspended:YES];
    }
}

- (void)resumeAllOperations {
    if(self.requestQueue.operationQueue.isSuspended) {
        [self.requestQueue.operationQueue setSuspended:NO];
    }
}

- (void)startNextOperation {
    if(self.waitingQueue.count > 0) {
        /* get file request from waiting queue */
        FileRequest *fileRequest = [self.waitingQueue objectAtIndex:0];
        
        /* add it to running queue */
        [self.runningQueue setObject:fileRequest forKey:fileRequest.identifier];
        
        /* remove it from waiting queue */
        [self.waitingQueue removeObjectForKey:fileRequest.identifier];
        
        /* started operation */
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestQueue:didStartedRequest:)]) {
            [self.delegate requestQueue:self didStartedRequest:fileRequest];
        }
        
        [self createOperationForFileRequest:fileRequest];
    } else {
        
        if([self isFinished]) {
            /* Finished queue */
            if (self.delegate && [self.delegate respondsToSelector:@selector(didCompletedRequestQueue:)]) {
                [self.delegate didCompletedRequestQueue:self];
            }
            
            /* save operations */
            [self saveAllQueues];
        }
    }
}

- (void)startQueue {
    /* load all operations */
    self.runningTaskQueue = [FileHelper restoreObjectForKey:self.runningQueueKey];
    self.waitingTaskQueue = [FileHelper restoreObjectForKey:self.waitingQueueKey];
    
    /* clear from NSUserDefault */
    [self clearAllQueues];
    
    /* start next operation */
    [self startNextOperation];
}

- (void)saveAllQueues {
    /* save operations */
    [FileHelper backupObject:self.waitingQueue forKey:self.waitingQueueKey];
    [FileHelper backupObject:self.runningQueue forKey:self.runningQueueKey];
}

- (void)clearAllQueues {
    [FileHelper removeObjectForKey:self.waitingQueueKey];
    [FileHelper removeObjectForKey:self.runningQueueKey];
}

#pragma mark - Request Methods

- (void)createOperationForFileRequest:(FileRequest *)fileRequest {
    [self configureRequestHeader];
    
    AFHTTPRequestOperation *operation = [self operationForFileRequest:fileRequest];
    if(operation) {
        [self.requestQueue.operationQueue addOperation:operation];
    }
}

- (void)addFileRequest:(FileRequest *)fileRequest {
    /* keep file request */
    [self.waitingQueue setObject:fileRequest forKey:fileRequest.identifier];
    
    /* create operation to do it */
    if([self.requestQueue.operationQueue operationCount] < self.maxConcurrentOperationCount) {
        [self startNextOperation];
    }
}

- (void)removeFileRequest:(FileRequest *)fileRequest {
    [self.runningQueue removeObjectForKey:fileRequest.identifier];
}

- (BOOL)hasFileRequest:(FileRequest *)fileRequest {
    return ([self.waitingQueue objectForKey:fileRequest.identifier] || [self.runningQueue objectForKey:fileRequest.identifier]);
}

#pragma mark - Application Notifications

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if([self isStopped]) {
            /* start again operations */
            [self startNextOperation];
        }
    });
}

- (void)applicationWillEnterBackground:(NSNotification *)notification {
    /* save operations */
    [self saveAllQueues];
}

- (void)applicationWillBeTerminated:(NSNotification *)notification {
    /* save operations */
    [self saveAllQueues];
}

@end
