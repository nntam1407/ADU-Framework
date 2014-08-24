/*============================================================================
 PROJECT: SportLocker
 FILE:    FileRequestQueueManager.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    11/18/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "FileDownloadQueue.h"
#import "PhotosUploadQueue.h"

/*============================================================================
 MACRO
 =============================================================================*/
typedef NS_ENUM(NSInteger, FileRequestProgressType) {
    kFileRequestProgressTypeUnknown = -1,
    kFileRequestProgressTypeStarted,
    kFileRequestProgressTypeProgressing,
    kFileRequestProgressTypeFinished
};

/*============================================================================
 PROTOCOL
 =============================================================================*/
typedef void(^FileRequestBlock)(FileRequest *fileRequest, CGFloat percentage, NSError *error);
/*============================================================================
 Interface:   FileRequestQueueManager
 =============================================================================*/


@interface FileRequestQueueManager : NSObject<FileRequestQueueDelegate>
@property (nonatomic, strong) NSMutableDictionary *callbackDict;
@property (nonatomic, strong) FileDownloadQueue *downloadQueue;
@property (nonatomic, strong) PhotosUploadQueue *uploadQueue;

+ (id)sharedManager;

/* for Download management */
- (void)downloadFile:(FileRequest *)file usingBlock:(void(^)(FileRequest *fileRequest, CGFloat percentage, NSError *error))block;

/* for upload management */
- (void)uploadFile:(FileRequest *)file usingBlock:(void(^)(FileRequest *fileRequest, CGFloat percentage, NSError *error))block;

/* check progressing file request */
- (BOOL)isUploadingFileRequest:(FileRequest *)request;
- (BOOL)isDownloadingFileRequest:(FileRequest *)request;
@end
