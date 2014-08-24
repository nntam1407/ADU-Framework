/*============================================================================
 PROJECT: SportLocker
 FILE:    SLHomeCacheWrapper.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/28/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "SLCacheWrapper.h"

/*============================================================================
 MACRO
 =============================================================================*/
typedef NS_ENUM(short, HomeCacheAPIType) {
    HomeCacheAPITypeCarousel,
    HomeCacheAPITypeLeagues,
    HomeCacheAPITypeTrending,
    HomeCacheAPITypeFavorites,
    HomeCacheAPITypeScores,
    HomeCacheAPITypeNews,
    HomeCacheAPITypeBornToday,
    HomeCacheAPITypeOnThisDay,
    HomeCacheAPITypeSubmission
};

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   SLHomeCacheWrapper
 =============================================================================*/


@interface SLHomeCacheWrapper : SLCacheWrapper

- (void)getLeaguesCacheCompleteHandler:(void(^)(id response, id error))completeHandler;
- (void)getTrendingCacheCompleteHandler:(void(^)(id response, id error))completeHandler;
- (void)getFavoritesCacheCompleteHandler:(void(^)(id response, id error))completeHandler;
- (void)getScoresCacheCompleteHandler:(void(^)(id response, id error))completeHandler;
- (void)getNewsCacheCompleteHandler:(void(^)(id response, id error))completeHandler;
- (void)getBornTodayCacheCompleteHandler:(void(^)(id response, id error))completeHandler;
- (void)getOnThisDayCacheCompleteHandler:(void(^)(id response, id error))completeHandler;
- (void)getSubmissionCacheCompleteHandler:(void(^)(id response, id error))completeHandler;

@end
