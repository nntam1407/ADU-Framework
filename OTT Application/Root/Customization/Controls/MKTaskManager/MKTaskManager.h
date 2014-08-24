/*============================================================================
 PROJECT: FamilySupport
 FILE:    MKUITaskRefresh.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    5/17/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <Foundation/Foundation.h>
#import "MKSequenceTask.h"
#import "MKTask.h"


/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   MKUITaskRefresh
 =============================================================================*/

@class MKSequenceTask;

@interface MKTaskManager : NSObject
@property(assign, nonatomic) NSInteger maximumNumberOfTasks;
@property(assign, nonatomic) NSTimeInterval activeTime;

- (void)startTask:(NSString *)taskName executeBlock:(TaskBlock)executeBlock;

- (void)stopTasksInQueue;

/* sequencer tasks */
- (void)startSequenceTaskInBlock:(SequenceTaskBlock)handler;

- (void)removeSequenceTask:(MKSequenceTask *)task;

- (void)startNextSequenceTask;

/* timers */
- (void)startTimer:(NSString *)timerKey handler:(void (^)())handler repeat:(BOOL)repeat;

- (void)stopTimerForKey:(NSString *)timerKey;

@end
