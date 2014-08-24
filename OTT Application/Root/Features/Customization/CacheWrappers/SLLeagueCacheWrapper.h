//
//  SLLeagueCacheWrapper.h
//  SportLocker
//
//  Created by Vinh Huynh on 8/8/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLCacheWrapper.h"

typedef NS_ENUM(short, LeagueCacheAPIType) {
    LeagueCacheAPITypeCarousel,
    LeagueCacheAPITypeTeams,
    LeagueCacheAPITypeScores,
};

@interface SLLeagueCacheWrapper : SLCacheWrapper

+ (instancetype)cacheWrapperWithLeague:(NSString *)leguage;
- (void)getLeagueTeamsCacheCompleteHandler:(void(^)(id response, id error))completeHandler;
- (void)getLeagueScoresCacheCompleteHandler:(void(^)(id response, id error))completeHandler;


@end
