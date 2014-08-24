//
//  iCloudSystem.m
//  CoreDate&iCloud
//
//  Created by Bao Nhan on 11/19/12.
//  Copyright (c) 2012 SportLocker. All rights reserved.
//

#import "iCloudSystem.h"

//iCloud Parameters
#define UBIQUITY_CONTAINER_IDENTIFIER @"T8H6X5NR9D.com.nexlesoft.icloudlib"
#define UBIQUITY_CONTENT_NAME_KEY @"com.nexlesoft.icloudlib"

@implementation iCloudSystem

+ (bool)checkiCLoudAvaiable {
    [[NSBundle mainBundle] bundleIdentifier];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *contentURL = [fileManager URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_IDENTIFIER];
    if(contentURL) {
        return YES;
    } else {
        return NO;
    }

}

+ (NSDictionary *)setUp {
    [[NSBundle mainBundle] bundleIdentifier];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *contentURL = [fileManager URLForUbiquityContainerIdentifier:UBIQUITY_CONTAINER_IDENTIFIER];
    
    NSDictionary  *options = @{NSPersistentStoreUbiquitousContentNameKey: UBIQUITY_CONTENT_NAME_KEY,
                              NSPersistentStoreUbiquitousContentURLKey: contentURL};
    return options;
}

@end
