//
//  SLLeagueCacheWrapper.m
//  SportLocker
//
//  Created by Vinh Huynh on 8/8/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLLeagueCacheWrapper.h"

@implementation SLLeagueCacheWrapper

+ (instancetype)cacheWrapperWithLeague:(NSString *)leguage {
    @autoreleasepool {
        NSArray *servicePaths = @[[NSString stringWithFormat:@"public/v1/%@/league/carousel", leguage],
                                  [NSString stringWithFormat:@"public/v1/%@/league/teams", leguage],
                                  [NSString stringWithFormat:@"public/v1/%@/league/scores", leguage],
                                  [NSString stringWithFormat:@"public/v1/%@/league/standings", leguage],
                                  [NSString stringWithFormat:@"public/v1/%@/league/draft", leguage],
                                  [NSString stringWithFormat:@"public/v1/%@/league/odds", leguage],
                                  [NSString stringWithFormat:@"public/v1/%@/league/injuries", leguage],
                                  [NSString stringWithFormat:@"public/v1/%@/league/venues", leguage],];
        
        SLLeagueCacheWrapper *wrapper = [[SLLeagueCacheWrapper alloc] initWithServicePaths:servicePaths];
        return wrapper;
    }
}

- (void)getItemsCacheOfAPIType:(LeagueCacheAPIType)type
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

- (void)getLeagueTeamsCacheCompleteHandler:(void (^)(id, id))completeHandler {
    [self getItemsCacheOfAPIType:LeagueCacheAPITypeTeams
                  forObjectClass:[SLTeamItem class]
                 completeHandler:^(id response, id error) {
        completeHandler(response, error);
    }];
}

- (void)getCarouselCacheCompleteHandler:(void(^)(id response, id error))completeHandler {
    [self getItemsCacheOfAPIType:LeagueCacheAPITypeCarousel
                  forObjectClass:[SLCoverItem class]
                 completeHandler:completeHandler];
}
- (void)getLeagueScoresCacheCompleteHandler:(void(^)(id response, id error))completeHandler {
    [self getItemsCacheOfAPIType:LeagueCacheAPITypeScores
                       forObjectClass:[SLNFLLeagueScoreItem class]
                      completeHandler:completeHandler];
}
@end
