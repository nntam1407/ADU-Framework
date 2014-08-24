/*============================================================================
 PROJECT: SportLocker
 FILE:    SLCacheWrapper.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/28/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "SLCacheWrapper.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation SLCacheWrapper

- (MKTaskManager *)taskManager {
    if(!_taskManager) {
        _taskManager = [[MKTaskManager alloc] init];
    }
    return _taskManager;
}

+ (instancetype)cacheWrapper {
    /* will be overridden in subclasses */
    return nil;
}

- (instancetype)initWithServicePaths:(NSArray *)servicePaths {
    self = [super init];
    if(self) {
        
        self.cacheVersions = [NSMutableArray arrayWithCapacity:servicePaths.count];
        
        /* get existing caches. If there's no existing records, then create new */
        for (NSString *servicePath in servicePaths) {
            CacheRevision *cache = [CacheRevision cacheForServicePath:servicePath];
            [self.cacheVersions addObject:cache];
        }
    }
    return self;
}

- (void)saveToPersistenceStore {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        
    }];
}

- (void)checkCacheStatusOfServices {
    
    /* add check cache service into sequence */
    if(self.checkingCache) return; /* checking cache */
    
    /* check cache status */
    self.checkingCache = YES;
    [self.taskManager startSequenceTaskInBlock:^(id task) {
        [MMStopwatchARC start:@"checkCacheRevisions"];
        [appDelegate.dataCenter checkCacheRevisions:self.cacheVersions
                                    completeHandler:^(id response, id error) {
                                        [MMStopwatchARC stop:@"checkCacheRevisions"];
                                        if(!error) {
                                            
                                            /* parse versions and save */
                                            NSArray *items = response[@"items"];
                                            NSMutableArray *caches = [NSMutableArray arrayWithCapacity:items.count];
                                            for (NSDictionary *dict in items) {
                                                CacheRevision *cache = [CacheRevision cacheForDictionary:dict];
                                                if(cache) {
                                                    [caches addObject:cache];
                                                }
                                            }
                                            
                                            self.cacheVersions = caches;
                                            [self saveToPersistenceStore];
                                            self.checkingCache = NO;
                                        }
                                        
                                        /* stop current task */
                                        [task stop];
                                    }];
    }];
}

- (NSMutableArray *)itemsFromResponse:(NSDictionary *)response parseToClass:(Class)classKind {
    NSArray *info = response[@"items"];
    NSMutableArray *items = [NSMutableArray array];
    if([info isKindOfClass:[NSArray class]]) {
        for (NSDictionary *itemInfo in info) {
            @autoreleasepool {
                NSError *error = nil;
                id item = [[classKind alloc] initWithDictionary:itemInfo error:&error];
                if(!error && item) {
                    [items addObject:item];
                }
            }
        }
    }
    return items;
}

- (void)getCacheForServicePath:(NSString *)servicePath
                    withParams:(NSDictionary *)params
                        method:(NSString *)method
               completeHandler:(void(^)(id data, id error))completeHandler {
    
    /* start get cache service with params and service path */
    CacheRevision *revisionCache = nil;
    for (CacheRevision *cache in self.cacheVersions) {
        if([cache.servicePath isEqualToString:servicePath]) {
            revisionCache = cache;
            break;
        }
    }
    
    if (revisionCache.content.length == 0 || !revisionCache.updatedToDate) {
        [self.taskManager startSequenceTaskInBlock:^(id task) {
            [MMStopwatchARC start:revisionCache.servicePath];
            [appDelegate.dataCenter getCacheForRevision:revisionCache
                                             withParams:[NSMutableDictionary dictionaryWithDictionary:params]
                                                 method:method
                                        completeHandler:^(id data, id error) {
                                            [MMStopwatchARC stop:revisionCache.servicePath];
                                            if(!error) {
                                                /* save cache content */
                                                revisionCache.content = [data JSONString];
                                                revisionCache.updatedToDate = YES;
                                                [self saveToPersistenceStore];
                                                
                                                /* get data from Database */
                                                completeHandler(data, error);
                                            } else {
                                                /* get data from Database */
                                                completeHandler([NotNullString(revisionCache.content) objectFromJSONString], error);
                                            }
                                        }];
            /* bypass API processing to call next API */
            [task stop];
        }];
    } else {
        /* get data from Database */
        completeHandler([NotNullString(revisionCache.content) objectFromJSONString], nil);
    }
}

- (void)getCacheForGETServicePath:(NSString *)servicePath
                       withParams:(NSDictionary *)params
                  completeHandler:(void(^)(id data, id error))completeHandler {
    
    [self getCacheForServicePath:servicePath
                      withParams:params
                          method:@"GET"
                 completeHandler:completeHandler];
}

- (void)getCacheForPOSTServicePath:(NSString *)servicePath
                        withParams:(NSDictionary *)params
                   completeHandler:(void(^)(id data, id error))completeHandler {
    
    [self getCacheForServicePath:servicePath
                      withParams:params
                          method:@"POST"
                 completeHandler:completeHandler];
    
}

- (void)getCarouselCacheCompleteHandler:(void(^)(id response, id error))completeHandler {
    
}

@end
