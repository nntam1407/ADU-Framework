/*============================================================================
 PROJECT: SportLocker
 FILE:    DataCenter.m
 AUTHOR:  Nguyen Minh Khoai
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseNetwork.h"

/*============================================================================
 MACRO
 =============================================================================*/


@class Deal;
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

/*----------------------------------------------------------------------------
 Interface:   DataCenter
 -----------------------------------------------------------------------------*/
@class GooglePrediction;
@interface DataCenter : NSObject

#pragma mark - Cache APIs

- (void)checkCacheRevisions:(NSArray *)cacheVersions completeHandler:(void(^)(id data, id error))completeHandler;

- (void)getCacheForRevision:(CacheRevision *)revision
                 withParams:(NSMutableDictionary *)params
                     method:(NSString *)method
            completeHandler:(void(^)(id data, id error))completeHandler;

#pragma mark - Home screen APIs

- (void)getScoreItemsUsingBlock:(void (^)(id data, id error))block;
- (void)getHomeCarouselItemsUsingBlock:(void (^)(id data, id error))block;
- (void)getHomeTrendingItemsUsingBlock:(void (^)(id data, id error))block;
- (void)getHomeFavoriteItemsUsingBlock:(void (^)(id data, id error))block;
- (void)getHomeLeagueItemsUsingBlock:(void (^)(id data, id error))block;
- (void)getHomeNewsItemsUsingBlock:(void (^)(id data, id error))block;
- (void)getHomeBornTodayItemsUsingBlock:(void (^)(id data, id error))block;
- (void)getHomeOnThisdDayItemsUsingBlock:(void (^)(id data, id error))block;

#pragma mark - Google Service APIs

- (void)getCurrentLocationUsingBlock:(void (^)(id data, id error))block;
- (void)getHintListFromGoogle:(NSString *)keyword usingBlock:(void (^)(id data, id error))block;
- (void)getPlaceDetailFromGoogle:(GooglePrediction *)prediction usingBlock:(void (^)(id data, id error))block;
- (void)getRoutesBetweenA:(CLLocation *)locationA
                     andB:(CLLocation *)locationB
                   inMode:(NSString *)mode
               usingBlock:(void (^)(id data, id error))block;


@end

