/*============================================================================
 PROJECT: SportLocker
 FILE:    BaseNetwork.m
 AUTHOR:  Nguyen Quang Khai
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/

#import "BaseNetwork.h"

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
/*----------------------------------------------------------------------------
 Interface:   BaseNetwork
 -----------------------------------------------------------------------------*/
@interface BaseNetwork()

@end

@implementation BaseNetwork
@synthesize networkEngine;
@synthesize enableDebugLog;

/*----------------------------------------------------------------------------
 Method:      init
 init function
 -----------------------------------------------------------------------------*/
- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (id)initWithBaseURL:(NSString *)baseUrlString {
    self = [super init];
    if (self) {
        self.networkEngine = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        self.networkEngine.securityPolicy = securityPolicy;
    }
    
    return self;
    
}
/*----------------------------------------------------------------------------
 Method: service
 called to return a new service.
 -----------------------------------------------------------------------------*/
+ (BaseNetwork *)service {
    return [[BaseNetwork alloc] initWithBaseURL:kBaseService];
}

/*----------------------------------------------------------------------------
 Method: configureRequestHeaderWithUser
 Set some default keys with their values to request header
 -----------------------------------------------------------------------------*/
- (void)configureRequestHeaderWithUser:(id)user {
    //    [networkEngine setDefaultHeader:kHTTP_HEADER_API_TOKEN value:kAPIKey];
    //    [networkEngine setDefaultHeader:kHTTP_HEADER_USER_TOKEN value:user.accessToken];
    //    [networkEngine setDefaultHeader:kHTTP_HEADER_USER_INFO value:user.userId];
    //    [networkEngine setDefaultHeader:kHTTP_HEADER_USER_LANG value:user.accessToken];
    //    [networkEngine setDefaultHeader:kHTTP_HEADER_APP_ID value:[[AppHelper sharedAppHelper] appId]];
    //    [networkEngine setDefaultHeader:kHTTP_HEADER_APP_VERSION value:[[AppHelper sharedAppHelper] appVersion]];
    //    [networkEngine setDefaultHeader:kHTTP_HEADER_APP_PIXEL_RATIO value:[[UIDevice currentDevice] resolutionToString]];
    //    [networkEngine setDefaultHeader:kHTTP_HEADER_APP_DEVICE_ACCESS value:@"Device Access"];
    //    [networkEngine setDefaultHeader:kHTTP_HEADER_TIME_ZONE value:[NSTimeZone localTimeZone].name];
    //    [networkEngine setDefaultHeader:@"Accept-Encoding" value:@"gzip"];
}

/*----------------------------------------------------------------------------
 Method: requestWithURL: params: successBlock: errorBlock: httpMethod:
 called to get data with path and params.
 -----------------------------------------------------------------------------*/
- (void)requestWithURL:(NSString *)inputUrlString
                params:(NSMutableDictionary*)params
          successBlock:(void (^)(NSDictionary *))successBlock
            errorBlock:(void (^)(NSString *))errorBlock
            httpMethod:(NSString *)method {
    
    if(!appDelegate.hasNetwork) {
        [Utils showAlertWithMessage:kNoConnectionErrorMessage];
        errorBlock(kNoConnectionErrorMessage);
        return;
    }
    
    if ([method isEqualToString:@"GET"]) {
        [self.networkEngine GET:inputUrlString
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
                            /* get URL string */
                            NSString *urlString = operation.request.URL.absoluteString;
                            DLog(@"Response for:%@\n\n%@==================",  urlString, operation.responseString);
                            successBlock(jsonResponse);
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSString *errorMessage = operation.responseString;
                            if (!errorMessage) {
                                errorMessage = kServiceNotAvailableMessage;
                            }
                            /* get URL string */
                            NSString *urlString = operation.request.URL.absoluteString;
                            DLog(@"Response for:%@\n\n%@==================",  urlString, operation.responseString);
                            errorBlock(errorMessage);
                        }];
    }
    else if ([method isEqualToString:@"PUT"]) {
        [self.networkEngine PUT:inputUrlString
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
                            NSDictionary *response = [operation.responseString objectFromJSONString];
                            successBlock(response);
                            
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            /* get URL string */
                            NSString *urlString = operation.request.URL.absoluteString;
                            DLog(@"Response for:%@\n\n%@==================",  urlString, operation.responseString);
                            NSString *errorMessage = operation.responseString;
                            if (!errorMessage) {
                                errorMessage = kServiceNotAvailableMessage;
                            }
                            errorBlock(errorMessage);
                        }];
    }
    else if([method isEqualToString:@"POST"]) {
        [self.networkEngine POST:inputUrlString
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
                             NSDictionary *response = [operation.responseString objectFromJSONString];
                             successBlock(response);
                         }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             /* get URL string */
                             NSString *urlString = operation.request.URL.absoluteString;
                             DLog(@"Response for:%@\n\n%@==================",  urlString, operation.responseString);
                             NSString *errorMessage = operation.responseString;
                             if (!errorMessage) {
                                 errorMessage = kServiceNotAvailableMessage;
                             }
                             errorBlock(errorMessage);
                         }];
    }
    else if([method isEqualToString:@"DELETE"]) {
        [self.networkEngine DELETE:inputUrlString
                        parameters:params
                           success:^(AFHTTPRequestOperation *operation, id jsonResponse) {
                               NSDictionary *response = [operation.responseString objectFromJSONString];
                               successBlock(response);
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               /* get URL string */
                               NSString *urlString = operation.request.URL.absoluteString;
                               DLog(@"Response for:%@\n\n%@==================",  urlString, operation.responseString);
                               NSString *errorMessage = operation.responseString;
                               if (!errorMessage) {
                                   errorMessage = kServiceNotAvailableMessage;
                               }
                               errorBlock(errorMessage);
                           }];
    }
}

/*----------------------------------------------------------------------------
 Method: requestWithHttpBody: headerFields: successBlock: errorBlock: httpMethod:
 called a request in SOAP type
 -----------------------------------------------------------------------------*/
- (void)requestWithHttpBody:(NSString *)httpBody
               headerFields:(NSMutableDictionary *)fields
               successBlock:(void (^)(id))successBlock
                 errorBlock:(void (^)(NSString *))errorBlock
                 httpMethod:(NSString *)method {
    
    if(!appDelegate.hasNetwork) {
        [Utils showAlertWithMessage:kNoConnectionErrorMessage];
        errorBlock(kNoConnectionErrorMessage);
        return;
    }
    
    /* create request */
    NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)httpBody.length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kBaseService]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:length forHTTPHeaderField:@"Content-Length"];
    
    /* additional fields */
    for (NSString *key in fields.allKeys) {
        [request addValue:[fields valueForKey:key] forHTTPHeaderField:key];
    }
    
    [request setHTTPMethod:method];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    /* add to queue */
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(enableDebugLog) {
            /* get URL string */
            NSString *urlString = operation.request.URL.absoluteString;
            
            /* check dict respone */
            DLog(@"Response for:%@\n==================\n%@==================", urlString, operation.responseString);
        }
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorMessage = operation.responseString;
        if (!errorMessage) {
            errorMessage = kServiceNotAvailableMessage;
        }
        errorBlock(errorMessage);
    }];
    
    [networkEngine.operationQueue addOperation:operation];
}

/*----------------------------------------------------------------------------
 Method: formRequestWithURLPath: params: filePath: successBlock: errorBlock: httpMethod:
 called a form request in SOAP type
 -----------------------------------------------------------------------------*/
- (void)formRequestWithURLPath:(NSString *)urlString
                        params:(NSMutableDictionary *)params
                      filePath:(NSString *)filePath
                          name:(NSString *)name
                  successBlock:(void (^)(NSDictionary *))successBlock
                    errorBlock:(void (^)(NSString *))errorBlock {
    
    if(!appDelegate.hasNetwork) {
        [Utils showAlertWithMessage:kNoConnectionErrorMessage];
        errorBlock(kNoConnectionErrorMessage);
        return;
    }
    
    NSData *data = nil;
    if(filePath.length > 0) {
        data = [NSData dataWithContentsOfFile:filePath];
    }
    
    AFHTTPRequestOperation *operation = [self.networkEngine POST:urlString
                                                      parameters:params
                                       constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                           if(filePath && data.length > 0) {
                                               [formData appendPartWithFileData:data name:name fileName:[filePath lastPathComponent] mimeType:@"image/jpeg"];
                                               NSMutableDictionary *header = [NSMutableDictionary dictionary];
                                               [header setValue:@"application/octet-stream" forKey:@"Content-Type"];
                                               [formData appendPartWithHeaders:header body:data];
                                           }
                                       } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                       }];
    
    // if you want progress updates as it's uploading, uncomment the following:
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(enableDebugLog) {
            /* get URL string */
            NSString *urlString = operation.request.URL.absoluteString;
            
            /* check dict respone */
            DLog(@"Response for:%@\n==================\n%@==================", urlString, operation.responseString);
        }
        DLog(@"Response for:%@\n==================\n%@==================", urlString, operation.responseString);
        successBlock([operation.responseString objectFromJSONString]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorMessage = error.localizedDescription;
        errorBlock(errorMessage);
        DLog(@"ERROR: %@", errorMessage);
    }];
}

/*----------------------------------------------------------------------------
 Method: formRequestWithURLPath: params: filePath: successBlock: errorBlock: httpMethod:
 called a form request in SOAP type
 -----------------------------------------------------------------------------*/
- (void)formRequestWithURLPath:(NSString *)urlString
                        params:(NSMutableDictionary *)params
                         image:(UIImage *)image
                  successBlock:(void (^)(NSDictionary *))successBlock
                    errorBlock:(void (^)(NSString *))errorBlock
                 progressBlock:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock {
    
    if(!appDelegate.hasNetwork) {
        [Utils showAlertWithMessage:kNoConnectionErrorMessage];
        errorBlock(kNoConnectionErrorMessage);
        return;
    }
    
    NSData *data = UIImagePNGRepresentation(image);
    
    AFHTTPRequestOperation *operation = [self.networkEngine POST:urlString
                                                      parameters:params
                                       constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                           if(image && data.length > 0) {
                                               [formData appendPartWithFileData:data name:@"file"
                                                                       fileName:[params objectForKey:@"name"]
                                                                       mimeType:@"image/jpeg"];
                                           }
                                       } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
                                       }];
    
    // if you want progress updates as it's uploading, uncomment the following:
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        progressBlock(totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(enableDebugLog) {
            /* get URL string */
            NSString *urlString = operation.request.URL.absoluteString;
            
            /* check dict respone */
            DLog(@"Response for:%@\n==================\n%@==================", urlString, operation.responseString);
        }
        DLog(@"Response for:%@\n==================\n%@==================", urlString, operation.responseString);
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorMessage = error.localizedDescription;
        errorBlock(errorMessage);
        DLog(@"ERROR: %@", errorMessage);
    }];
    
    //continue upload when app go to background
    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        // Handle iOS shutting you down (possibly make a note of where you
        // stopped so you can resume later)
    }];
}

/*----------------------------------------------------------------------------
 Method: formRequestWithURLPath: params: successBlock: errorBlock: httpMethod:
 called a form request in SOAP type
 -----------------------------------------------------------------------------*/
- (void)formRequestWithURLPath:(NSString *)urlString
                        params:(NSMutableDictionary *)params
                  successBlock:(void (^)(NSDictionary *))successBlock
                    errorBlock:(void (^)(NSString *))errorBlock {
    
    //    networkEngine.parameterEncoding = AFFormURLParameterEncoding;
    [self formRequestWithURLPath:urlString
                          params:params
                        filePath:nil
                            name:nil
                    successBlock:successBlock
                      errorBlock:errorBlock];
}

- (void)jsonBodyInRequestWithURLPath:(NSString *)urlString
                              params:(NSMutableDictionary *)params
                        successBlock:(void (^)(NSDictionary *))successBlock
                          errorBlock:(void (^)(NSString *))errorBlock {
    
    
    self.networkEngine.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.networkEngine.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [self.networkEngine POST:urlString parameters:params
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         successBlock(responseObject);
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         errorBlock([error localizedFailureReason]);
                     }];
}

@end
