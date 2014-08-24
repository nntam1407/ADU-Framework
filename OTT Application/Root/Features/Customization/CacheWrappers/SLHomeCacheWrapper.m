/*============================================================================
 PROJECT: SportLocker
 FILE:    SLHomeCacheWrapper.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/28/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "SLHomeCacheWrapper.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation SLHomeCacheWrapper

+ (instancetype)cacheWrapper {
    @autoreleasepool {
        
        NSArray *servicePaths = @[@"public/v1/home/carousel",
                                  @"public/v1/home/leagues",
                                  @"public/v1/home/trending",
                                  @"public/v1/home/favorites",
                                  @"public/v1/home/scores",
                                  @"public/v1/home/news",
                                  @"public/v1/home/bornToday",
                                  @"public/v1/home/onThisDay",
                                  @"public/v1/home/submissions"];
        
        SLHomeCacheWrapper *wrapper = [[SLHomeCacheWrapper alloc] initWithServicePaths:servicePaths];
        return wrapper;
    }
}

- (void)getItemsCacheOfAPIType:(HomeCacheAPIType)type
                forObjectClass:(Class)objectClass
               completeHandler:(void(^)(id response, id error))completeHandler {
    
    [self getCacheForGETServicePath:[self.cacheVersions[type] servicePath]
                         withParams:nil
                    completeHandler:^(id response, id error) {
                        
                        if(response) {
                            completeHandler([self itemsFromResponse:response parseToClass:objectClass], nil);
                        } else {
                            /* show error message */
                            [Utils showAlertWithMessage:error];
                        }
                    }];
}

- (void)getCarouselCacheCompleteHandler:(void(^)(id response, id error))completeHandler {
    [self getItemsCacheOfAPIType:HomeCacheAPITypeCarousel
                  forObjectClass:[SLCoverItem class]
                 completeHandler:completeHandler];
}

- (void)getLeaguesCacheCompleteHandler:(void(^)(id response, id error))completeHandler {
    [self getItemsCacheOfAPIType:HomeCacheAPITypeLeagues
                  forObjectClass:[SLLeagueItem class]
                 completeHandler:completeHandler];
}

- (void)getTrendingCacheCompleteHandler:(void(^)(id response, id error))completeHandler {
    [self getItemsCacheOfAPIType:HomeCacheAPITypeTrending
                  forObjectClass:[SLTrendingItem class]
                 completeHandler:completeHandler];
}

- (void)getFavoritesCacheCompleteHandler:(void(^)(id response, id error))completeHandler {
    [self getItemsCacheOfAPIType:HomeCacheAPITypeFavorites
                  forObjectClass:[SLFavoriteItem class]
                 completeHandler:completeHandler];
}

- (void)getScoresCacheCompleteHandler:(void(^)(id response, id error))completeHandler {
    [self getItemsCacheOfAPIType:HomeCacheAPITypeScores
                  forObjectClass:[SLScoreItem class]
                 completeHandler:completeHandler];
}

- (void)getNewsCacheCompleteHandler:(void(^)(id response, id error))completeHandler {
    [self getItemsCacheOfAPIType:HomeCacheAPITypeNews
                  forObjectClass:[SLNewsItem class]
                 completeHandler:completeHandler];
}

- (void)getBornTodayCacheCompleteHandler:(void(^)(id response, id error))completeHandler {
    [self getItemsCacheOfAPIType:HomeCacheAPITypeBornToday
                  forObjectClass:[SLBornTodayItem class]
                 completeHandler:completeHandler];
}

- (void)getOnThisDayCacheCompleteHandler:(void(^)(id response, id error))completeHandler {
    [self getItemsCacheOfAPIType:HomeCacheAPITypeOnThisDay
                  forObjectClass:[SLOnThisDayItem class]
                 completeHandler:completeHandler];
}

- (void)getSubmissionCacheCompleteHandler:(void(^)(id response, id error))completeHandler {
    [self getItemsCacheOfAPIType:HomeCacheAPITypeSubmission
                  forObjectClass:[SLSubmissionItem class]
                 completeHandler:completeHandler];
}

@end
