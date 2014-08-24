/*============================================================================
 PROJECT: SportLocker
 FILE:    FileDownloadQueue.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/25/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "FileDownloadQueue.h"
#import <JSONKit/JSONKit.h>

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface FileDownloadQueue ()
@end

@implementation FileDownloadQueue

#pragma mark - Overriden

- (void)setupOperation:(AFHTTPRequestOperation *)operation {
    __weak AFDownloadRequestOperation *aOperation = (AFDownloadRequestOperation *)operation;
    aOperation.deleteTempFileOnCancel = YES;
    
    [aOperation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        CGFloat percent = percent((CGFloat)totalBytesReadForFile, totalBytesExpectedToReadForFile);
      
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestQueue:request:didUpdatedProgress:)]) {
            FileRequest *request = [operation.userInfo valueForKey:kCurrentFileRequestKey];
            [self.delegate requestQueue:self request:request didUpdatedProgress:percent];
        }
    }];
    
    [aOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self onFileDownloadOperationComplete:aOperation response:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self onFileDownloadOperationComplete:aOperation response:error];
    }];
}

- (void)onFileDownloadOperationComplete:(AFDownloadRequestOperation *)operation response:(id)responseObject {
    if (![responseObject isKindOfClass:[NSError class]]) {
        /* find correct file request */
        NSDictionary *response = [operation.responseString objectFromJSONString];
        FileRequest *request = [operation.userInfo valueForKey:kCurrentFileRequestKey];
        request.response = response;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestQueue:didCompletedRequest:)]) {
            [self.delegate requestQueue:self didCompletedRequest:request];
        }
        
        /* start next operation */
        [self startNextOperation];
    }
    else {
        /* find correct file request */
        FileRequest *request = [operation.userInfo valueForKey:kCurrentFileRequestKey];

        if (self.delegate && [self.delegate respondsToSelector:@selector(requestQueue:didFailedRequest:error:)]) {
            [self.delegate requestQueue:self didFailedRequest:request error:responseObject];
        }
        
        /* remove file request */
        [self removeFileRequest:request];
    }
}

- (void)createOperationForFileRequest:(FileRequest *)fileRequest {
    [self configureRequestHeader];
    
    /* check network first */
    if(!appDelegate.hasNetwork) {
        NSError *error = MKOtherError(kNoConnectionErrorMessage);
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestQueue:didFailedRequest:error:)]) {
            [self.delegate requestQueue:self didFailedRequest:fileRequest error:error];
        }
        return;
    }
    
    /* create url request */
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:fileRequest.url]];
    NSString *cacheFolder = [FileHelper pathForFileName:kCacheFolder];
    NSString *filePath = (fileRequest.localPath.length > 0 ? fileRequest.localPath : [cacheFolder stringByAppendingPathComponent:fileRequest.identifier]);
    
    /* create operation */
    AFDownloadRequestOperation *downloadOperation = [[AFDownloadRequestOperation alloc] initWithRequest:urlRequest
                                                                                             targetPath:filePath
                                                                                           shouldResume:YES];
    downloadOperation.shouldOverwrite = YES;
    downloadOperation.userInfo = @{kCurrentFileRequestKey:fileRequest};
    
    [self setupOperation:downloadOperation];
    
    //continue upload when app go to background
    [downloadOperation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        // Handle iOS shutting you down (possibly make a note of where you
        // stopped so you can resume later)
    }];

    [self.requestQueue.operationQueue addOperation:downloadOperation];
}

@end
