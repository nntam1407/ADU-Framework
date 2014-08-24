/*============================================================================
 PROJECT: SportLocker
 FILE:    BaseNetwork.h
 AUTHOR:  Nguyen Minh Khoai
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/*============================================================================
 MACRO
 =============================================================================*/
#define kNoConnectionErrorMessage       NSLocalizedString(@"No connection. Please check your network", @"Error Message")

#define kServiceNotAvailableMessage     NSLocalizedString(@"The network service is currently unavailable. Please try again later.", @"Error Message")
#define kErrorMessageKey                @"message"
#define kNullValueMessage               NSLocalizedString(@"Return null value", @"Error Message")
#define kAuthenticationFailedMessage    NSLocalizedString(@"Authentication failed", @"Error Message")
#define kNullResponseMessage            NSLocalizedString(@"Null response", @"Error Message")

#define TEST_SERVICE
#ifdef  TEST_SERVICE
#define kAPIKey                         @"d5479d798f2dfbfe28ba44fb4664ce18d1d55e66"
#define kBaseService                    @"https://sportlocker1.appspot.com/_ah/api/"
#else
#define kAPIKey                         @"d5479d798f2dfbfe28ba44fb4664ce18d1d55e66"
#define kBaseService                    @"https://sportlocker1.appspot.com/_ah/api/"
#endif

/* Header field keys */
#define kHTTP_HEADER_USER_TOKEN         @"usertoken"
#define kHTTP_HEADER_USER_INFO          @"userinfo"
#define kHTTP_HEADER_USER_LANG          @"language"
#define kHTTP_HEADER_APP_TOKEN          @"token"
#define kHTTP_HEADER_APP_ID             @"appId"
#define kHTTP_HEADER_APP_VERSION        @"version"
#define kHTTP_HEADER_APP_PIXEL_RATIO    @"X-PixelRatio"
#define kHTTP_HEADER_APP_DEVICE_ACCESS  @"X-DeviceAccess"
#define kHTTP_HEADER_TIME_ZONE          @"timezone"
#define kHTTP_HEADER_API_TOKEN          @"Apikey"

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
/*----------------------------------------------------------------------------
 Interface:   BaseNetwork
 -----------------------------------------------------------------------------*/
@interface BaseNetwork : NSObject

/* properties */
@property (nonatomic, strong) AFHTTPRequestOperationManager *networkEngine;
@property (nonatomic, assign) BOOL enableDebugLog;

- (id)initWithBaseURL:(NSString *) baseUrlString;
+ (BaseNetwork *)service;

- (void)configureRequestHeaderWithUser:(id)user;

/* for normal request */
- (void)requestWithURL:(NSString *)urlString
                params:(NSMutableDictionary*)params
          successBlock:(void (^)(NSDictionary *))successBlock
            errorBlock:(void (^)(NSString *))errorBlock
            httpMethod:(NSString *)method;

/* for SOAP request */
- (void)requestWithHttpBody:(NSString *)httpBody
               headerFields:(NSMutableDictionary *)fields
               successBlock:(void (^)(id))successBlock
                 errorBlock:(void (^)(NSString *))errorBlock
                 httpMethod:(NSString *)method;

/* for form request */
- (void)formRequestWithURLPath:(NSString *)urlString
                        params:(NSMutableDictionary *)params
                  successBlock:(void (^)(NSDictionary *))successBlock
                    errorBlock:(void (^)(NSString *))errorBlock;

- (void)formRequestWithURLPath:(NSString *)urlString
                        params:(NSMutableDictionary *)params
                      filePath:(NSString *)filePath
                          name:(NSString *)name
                  successBlock:(void (^)(NSDictionary *))successBlock
                    errorBlock:(void (^)(NSString *))errorBlock;

- (void)formRequestWithURLPath:(NSString *)urlString
                        params:(NSMutableDictionary *)params
                         image:(UIImage *)image
                  successBlock:(void (^)(NSDictionary *))successBlock
                    errorBlock:(void (^)(NSString *))errorBlock
                 progressBlock:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;

/* JSON in body */
- (void)jsonBodyInRequestWithURLPath:(NSString *)urlString
                              params:(NSMutableDictionary *)params
                        successBlock:(void (^)(NSDictionary *))successBlock
                          errorBlock:(void (^)(NSString *))errorBlock;

@end
