//
//  CacheVersion.m
//  SportLocker
//
//  Created by Khoai Nguyen Minh on 7/28/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "CacheRevision.h"


@implementation CacheRevision

@dynamic revisionNumber;
@dynamic servicePath;
@dynamic content;
@dynamic updatedToDate;

+ (CacheRevision *)cacheForDictionary:(NSDictionary *)dict {
    
    if(!dict) return nil;
    
    BOOL isNewCache = NO;
    NSString *servicePath = dict[@"servicePath"];
    NSString *revisionNumber = dict[@"revisionNumber"];
    
    /* get cache request from DB */
    CacheRevision *cache = [CacheRevision cacheForServicePath:servicePath];
    if([cache.revisionNumber isEqualToString:revisionNumber]) {
        isNewCache = YES;
    }
    
    /* update new cache */
    cache.revisionNumber = revisionNumber;
    cache.updatedToDate = isNewCache;
    
    return cache;
}

+ (instancetype)cacheForServicePath:(NSString *)servicePath {
    NSArray *caches = [CacheRevision MR_findByAttribute:@"servicePath" withValue:servicePath];
    CacheRevision *cache = [caches lastObject];
    if(!cache) {
        cache = [CacheRevision MR_createEntity];
        cache.servicePath = servicePath;
        cache.updatedToDate = NO;
    }
    return cache;
}

- (NSDictionary *)dictionaryValue {
    if(self.revisionNumber.length > 0) {
        return @{@"servicePath": NotNullString(self.servicePath), @"revisionNumber": NotNullString(self.revisionNumber)};
    }
    return @{@"servicePath": NotNullString(self.servicePath)};
}

@end
