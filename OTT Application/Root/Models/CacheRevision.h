//
//  CacheVersion.h
//  SportLocker
//
//  Created by Khoai Nguyen Minh on 7/28/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CacheRevision : NSManagedObject

@property (nonatomic, retain) NSString * revisionNumber;
@property (nonatomic, retain) NSString * servicePath;
@property (nonatomic, retain) NSString *content;
@property (nonatomic)         BOOL updatedToDate;

+ (CacheRevision *)cacheForDictionary:(NSDictionary *)dict;
+ (instancetype)cacheForServicePath:(NSString *)servicePath;
- (NSDictionary *)dictionaryValue;

@end
