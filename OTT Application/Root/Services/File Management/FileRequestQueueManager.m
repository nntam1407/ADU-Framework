/*============================================================================
 PROJECT: SportLocker
 FILE:    FileRequestQueueManager.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    11/18/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "FileRequestQueueManager.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
#define kDownloadQueueMaximumCount  10

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation FileRequestQueueManager

- (id)init {
    self = [super init];
    if (self) {
        /* Downloader */
        self.downloadQueue.maxConcurrentOperationCount = kDownloadQueueMaximumCount;
    }
    return self;
}

+ (id)sharedManager {
	static dispatch_once_t predicate;
	static FileRequestQueueManager *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}
#if (!__has_feature(objc_arc))

- (id)retain {
    
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    
    return self;
}
#endif

#pragma mark - Accessor

- (FileDownloadQueue *)downloadQueue {
    if(!_downloadQueue) {
        _downloadQueue = [[FileDownloadQueue alloc] init];
        _downloadQueue.delegate = self;
    }
    return _downloadQueue;
}

- (FileUploadQueue *)uploadQueue {
    if(!_uploadQueue) {
        _uploadQueue = [[PhotosUploadQueue alloc] init];
        _uploadQueue.delegate = self;
    }
    return _uploadQueue;
}

- (NSMutableDictionary *)callbackDict {
    if(!_callbackDict) {
        _callbackDict = [[NSMutableDictionary alloc] init];
    }
    return _callbackDict;
}

#pragma mark - Callback Management

- (NSMutableArray *)callbacksForKey:(NSString *)key {
    NSMutableArray *callbacks = [self.callbackDict valueForKey:key];
    return callbacks;
}

- (void)setCallback:(id)value forKey:(NSString *)key {
    if(key && value) {
        /* get array of callbacks for key */
        NSMutableArray *callbacks = [self callbacksForKey:key];
        if(callbacks == nil) {
            callbacks = [NSMutableArray array];
        }
        
        if(![callbacks containsObject:value]) {
            [callbacks addObject:value];
            
            /* update callback dict */
            [self.callbackDict setValue:callbacks forKey:key];
        }
    }
}

- (void)callbackForRequest:(FileRequest *)request percent:(CGFloat)percent error:(NSError *)error {
    /* get array of callbacks for key */
    NSMutableArray *callbacks = [self callbacksForKey:request.identifier];
    
    /* callback now */
    for (FileRequestBlock block in callbacks) {
        block(request, percent, error);
    }
}

- (void)removeAllCallbacksForKey:(NSString *)key {
    [self.callbackDict removeObjectForKey:key];
}

- (BOOL)isUploadingFileRequest:(FileRequest *)request {
    return [self.uploadQueue hasFileRequest:request];
}

- (BOOL)isDownloadingFileRequest:(FileRequest *)request {
    return [self.downloadQueue hasFileRequest:request];
}

#pragma mark - Downloader

- (void)downloadFile:(FileRequest *)fileRequest usingBlock:(void(^)(FileRequest *fileRequest, CGFloat percentage, NSError *error))block {
    
}

- (void)uploadFile:(FileRequest *)fileRequest usingBlock:(void(^)(FileRequest *fileRequest, CGFloat percentage, NSError *error))block {
    /* keep callback */
    [self setCallback:block forKey:fileRequest.identifier];
    
    /* otherwise, download new file */
    if(![self.uploadQueue hasFileRequest:fileRequest]) {
        
        /* add file in download queue */
        [self.uploadQueue addFileRequest:fileRequest];
    }
}

#pragma mark - FileRequestQueueDelegate

- (void)requestQueue:(FileRequestQueue *)queue request:(FileRequest *)request didUpdatedProgress:(CGFloat)percent {
    /* update status of file */
    [self callbackForRequest:request percent:percent error:nil];
}

- (void)requestQueue:(FileRequestQueue *)queue didFailedRequest:(FileRequest *)request error:(NSError *)error {
    [self callbackForRequest:request percent:kFileRequestProgressTypeUnknown error:error];
    [self removeAllCallbacksForKey:request.identifier];
}

- (void)requestQueue:(FileRequestQueue *)queue didCompletedRequest:(FileRequest *)request {
    /* update status of file */
    [self callbackForRequest:request percent:kFileRequestProgressTypeFinished error:nil];
    [self removeAllCallbacksForKey:request.identifier];
}

- (void)didCompletedRequestQueue:(FileRequestQueue *)queue {
    
}

- (void)requestQueue:(FileRequestQueue *)queue didStartedRequest:(FileRequest *)request {

}

@end
