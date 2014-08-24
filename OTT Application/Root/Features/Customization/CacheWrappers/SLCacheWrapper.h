/*============================================================================
 PROJECT: SportLocker
 FILE:    SLCacheWrapper.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/28/14
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

/*============================================================================
 Interface:   SLCacheWrapper
 =============================================================================*/


@interface SLCacheWrapper : NSObject
@property(nonatomic, strong) NSMutableArray *cacheVersions;
@property(nonatomic, assign) BOOL checkingCache;
@property(nonatomic, strong) MKTaskManager *taskManager;

+ (instancetype)cacheWrapper;

- (instancetype)initWithServicePaths:(NSArray *)servicePaths;

- (void)saveToPersistenceStore;

- (void)checkCacheStatusOfServices;

- (NSMutableArray *)itemsFromResponse:(NSDictionary *)response parseToClass:(Class)classKind;

- (void)getCacheForServicePath:(NSString *)servicePath
                    withParams:(NSDictionary *)params
                        method:(NSString *)method
               completeHandler:(void(^)(id data, id error))completeHandler;

- (void)getCacheForGETServicePath:(NSString *)servicePath
                       withParams:(NSDictionary *)params
                  completeHandler:(void(^)(id data, id error))completeHandler;

- (void)getCacheForPOSTServicePath:(NSString *)servicePath
                        withParams:(NSDictionary *)params
                   completeHandler:(void(^)(id data, id error))completeHandler;

- (void)getCarouselCacheCompleteHandler:(void(^)(id response, id error))completeHandler;

@end
