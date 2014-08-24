//
//  iCloudSystem.h
//  CoreDate&iCloud
//
//  Created by Bao Nhan on 11/19/12.
//  Copyright (c) 2012 SportLocker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface iCloudSystem : NSObject

+ (bool)checkiCLoudAvaiable;
+ (NSDictionary *)setUp;

@end
