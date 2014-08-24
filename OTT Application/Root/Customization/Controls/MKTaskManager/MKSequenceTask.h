/*============================================================================
 PROJECT: FamilySupport
 FILE:    MKSequenceTask.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    5/27/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <Foundation/Foundation.h>

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/
typedef NS_ENUM(short, SequenceTaskStatus) {
    kSequenceTaskStatusNew = 0,
    kSequenceTaskStatusProgressing,
    kSequenceTaskStatusStopped
};

typedef void(^SequenceTaskBlock)(id task);

/*============================================================================
 Interface:   MKSequenceTask
 =============================================================================*/

@class MKTaskManager, MKTask;

@interface MKSequenceTask : NSObject
@property(nonatomic) SequenceTaskStatus status;
@property(strong, nonatomic) SequenceTaskBlock executeBlock;
@property(nonatomic, assign) MKTaskManager *manager;

+ (MKSequenceTask *)taskWithBlock:(id)handler;

- (void)start;

- (void)stop;

- (BOOL)isRuning;

- (BOOL)isStopped;

@end
