/*============================================================================
 PROJECT: SportLocker
 FILE:    FileRequestQueue.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    11/14/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <Foundation/Foundation.h>
#import "BaseNetwork.h"
#import "FileRequest.h"
#import "OrderedDictionary.h"

/*============================================================================
 MACRO
 =============================================================================*/
#define percent(x,y)                    roundf(x / y * 100) / 100;
#define kCurrentFileRequestKey          @"kCurrentFileRequestKey"
#define kCacheFolder                    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]
#define kNoConnectionErrorMessage       NSLocalizedString(@"No connection. Please check your network", @"Error Message")

/*============================================================================
 PROTOCOL
 =============================================================================*/

@class FileRequestQueue;
@protocol FileRequestQueueDelegate <NSObject>
@optional
- (void)requestQueue:(FileRequestQueue *)queue request:(FileRequest *)request didUpdatedProgress:(CGFloat)percent;
- (void)requestQueue:(FileRequestQueue *)queue didFailedRequest:(FileRequest *)request error:(NSError *)error;
- (void)requestQueue:(FileRequestQueue *)queue didCompletedRequest:(FileRequest *)request;
- (void)didCompletedRequestQueue:(FileRequestQueue *)queue;
- (void)requestQueue:(FileRequestQueue *)queue didStartedRequest:(FileRequest *)request;
@end

/*============================================================================
 Interface:   FileRequestQueue
 =============================================================================*/

@interface FileRequestQueue : NSObject {
    OrderedDictionary *taskQueue;
}

@property (weak, nonatomic)                                 id<FileRequestQueueDelegate> delegate;
@property (strong, nonatomic, getter = requestQueue)        AFHTTPRequestOperationManager *client;
@property (assign, nonatomic)                               NSInteger maxConcurrentOperationCount;
@property (strong, nonatomic)                               OrderedDictionary *waitingTaskQueue;
@property (strong, nonatomic)                               OrderedDictionary *runningTaskQueue;
@property (readonly, nonatomic)                             OrderedDictionary *requestTaskQueue;

- (void)configureRequestHeader;

/* Handle request state */
- (BOOL)isFinished;
- (BOOL)isStopped;
- (BOOL)isInterrupted;

/* Handle operations */
- (void)addFileRequest:(FileRequest *)fileRequest;
- (AFHTTPRequestOperation *)operationForFileRequest:(FileRequest *)fileRequest;

- (void)cancelAllOperations;
- (void)pauseAllOperations;
- (void)resumeAllOperations;
- (void)startNextOperation;
- (void)startQueue;
- (void)createOperationForFileRequest:(FileRequest *)fileRequest;

/* Handle file request */
- (void)removeFileRequest:(FileRequest *)fileRequest;
- (BOOL)hasFileRequest:(FileRequest *)fileRequest;

@end
