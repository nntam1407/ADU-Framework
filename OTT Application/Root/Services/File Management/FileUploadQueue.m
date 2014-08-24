/*============================================================================
 PROJECT: SportLocker
 FILE:    FileUploadQueue.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    11/14/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "FileUploadQueue.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
@interface FileUploadQueue()
- (void)getDataOfFileRequest:(FileRequest *)fileRequest resultBlock:(void(^)(ALAsset *asset, NSError *error))block;
@end

@implementation FileUploadQueue

#pragma mark - Overriden Methods

- (void)getDataOfFileRequest:(FileRequest *)fileRequest resultBlock:(void(^)(ALAsset *asset, NSError *error))block {
    [[AssetLibraryHelper sharedPhotoLibraryAccessor] getAssestByURL:fileRequest.url
                                                        resultBlock:^(ALAsset *asset, NSError *error) {
                                                            block(asset, error);
                                                        }];
}

- (void)settingsForRemindUploadNotification {
    /* start local notification to remind uploading service */
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSDate *date = [NSDate date];
    
    // Break the date up into components
    NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:date];
    
    NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    
    // Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
    
    // Notification will fire in 1 seconds
    [dateComps setMinute:[timeComponents minute]];
    [dateComps setSecond:[timeComponents second] + 1];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.fireDate = itemDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    // Notification details
    localNotif.alertBody = LocStr(@"Going back into the app will resume the upload");
    
    // Set the action button
    localNotif.alertAction = @"Resume";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

- (void)configureOperation:(AFHTTPRequestOperation *)operation withFileRequest:(FileRequest *)fileRequest {
    
    /* Progress upload callback */
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        CGFloat percent = percent((CGFloat)totalBytesWritten, totalBytesExpectedToWrite);
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestQueue:request:didUpdatedProgress:)]) {
            [self.delegate requestQueue:self request:fileRequest didUpdatedProgress:percent];
        }
        DLog(@"Percent: %f", percent);
    }];
    
    /* Complete callback */
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        /* find correct file request */
        NSDictionary *response = [operation.responseString objectFromJSONString];
        FileRequest *request = [operation.userInfo valueForKey:kCurrentFileRequestKey];
        request.response = response;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestQueue:didCompletedRequest:)]) {
            [self.delegate requestQueue:self didCompletedRequest:request];
        }
        
        /* remove file request */
        [self removeFileRequest:request];
        
        /* start next operation */
        [self startNextOperation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        /* find correct file request */
        FileRequest *request = [operation.userInfo valueForKey:kCurrentFileRequestKey];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestQueue:didFailedRequest:error:)]) {
            [self.delegate requestQueue:self didFailedRequest:request error:error];
        }
        
        /* remove file request */
        [self removeFileRequest:request];
    }];
}

- (NSMutableURLRequest *)createUploadRequestForFileRequest:(FileRequest *)file asset:(ALAsset *)asset {
    /* create params */
    NSMutableDictionary *params = nil;
    NSMutableURLRequest *request = [self.requestQueue.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                             URLString:nil
                                                                                            parameters:params
                                                                             constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                 
                                                                             } error:nil];
    
    return request;
}

- (void)createOperationForFileRequest:(FileRequest *)fileRequest {
    
    if([self.requestQueue.operationQueue operationCount] < self.maxConcurrentOperationCount) {
        /* check network first */
        if(!appDelegate.hasNetwork) {
            NSError *error = MKOtherError(kNoConnectionErrorMessage);
            if (self.delegate && [self.delegate respondsToSelector:@selector(requestQueue:didFailedRequest:error:)]) {
                [self.delegate requestQueue:self didFailedRequest:fileRequest error:error];
            }
            return;
        }
        
        [self configureRequestHeader];
        
        /* get file data to upload */
        [self getDataOfFileRequest:fileRequest resultBlock:^(ALAsset *asset, NSError *error) {
            
            if(asset) {
                fileRequest.name = [asset name];
                
                /* create operation request */
                NSMutableURLRequest *request = [self createUploadRequestForFileRequest:fileRequest asset:asset];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                
                /* keep identifier informtion */
                operation.userInfo = @{kCurrentFileRequestKey:fileRequest};
                
                /* configure operation */
                [self configureOperation:operation withFileRequest:fileRequest];
                
                //continue upload when app go to background
                [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
                    // Handle iOS shutting you down (possibly make a note of where you
                    // stopped so you can resume later)
                    [self settingsForRemindUploadNotification];
                }];
                
                [self.requestQueue.operationQueue addOperation:operation];
            } else {
                /* check network first */
                if (self.delegate && [self.delegate respondsToSelector:@selector(requestQueue:didFailedRequest:error:)]) {
                    [self.delegate requestQueue:self didFailedRequest:fileRequest error:MKOtherError(NSLocalizedString(@"Empty data", nil))];
                }
            }
        }];
    }
}

@end
