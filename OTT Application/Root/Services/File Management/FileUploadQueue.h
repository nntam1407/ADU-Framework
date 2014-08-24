/*============================================================================
 PROJECT: SportLocker
 FILE:    FileUploadQueue.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    11/14/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "FileRequestQueue.h"

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   FileUploadQueue
 =============================================================================*/

@class ALAsset;
@interface FileUploadQueue : FileRequestQueue
- (NSMutableURLRequest *)createUploadRequestForFileRequest:(FileRequest *)file asset:(ALAsset *)asset;
@end
