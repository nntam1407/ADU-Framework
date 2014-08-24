/*============================================================================
 PROJECT: SportLocker
 FILE:    FileHelper.m
 AUTHOR:  Nguyen Minh Khoai
 =============================================================================*/

#import "FileHelper.h"
#include <sys/xattr.h>
#import "UIDevice+Additions.h"

#define kAvatarImage @"avatar.jpg"

@implementation FileHelper
- (id)init {
    if ( (self = [super init]) ) {
    }
    return self;
}


+ (FileHelper *)sharedManager {
    static FileHelper *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !shared || shared == NULL ) {
            // allocate the shared instance, because it hasn't been done yet
            shared = [[FileHelper alloc] init];
        }
    });
    return shared;
}

/*----------------------------------------------------------------------------
 Method:      addSkipBackupAttributeToItemAtURL
 Description: prevent auto backup to iCloud
 ----------------------------------------------------------------------------*/
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    if ([[UIDevice currentDevice] hasSupportVersion:5.1] && NSURLIsExcludedFromBackupKey) {
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        NSError *error = nil;
        
        BOOL success = [URL setResourceValue:@YES
                                      forKey:NSURLIsExcludedFromBackupKey
                                       error:&error];
        
        if(!success) {
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }
    else {
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        const char* filePath = [[URL path] fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
}

/*----------------------------------------------------------------------------
 Method:      preventiCloudAutoBackup
 Description: prevent auto backup to iCloud
 ----------------------------------------------------------------------------*/
- (void)preventiCloudAutoBackup {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSURL *pathURL = [NSURL fileURLWithPath:documentsDirectory];
    [self addSkipBackupAttributeToItemAtURL:pathURL];
}

/*----------------------------------------------------------------------------
 Method:      pathForFileName:
 Description: get file name path
 ----------------------------------------------------------------------------*/
+ (NSString *)pathForFileName:(NSString *)fileName {
    /* get cache folder */
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheFolderPath = dirs[0];
    
    /* create data */
    NSString *filePath = [cacheFolderPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

/*----------------------------------------------------------------------------
 Method:      avatarPath
 Description: get default avatar path
 ----------------------------------------------------------------------------*/
+ (NSString *)avatarPath {
    return [FileHelper pathForFileName:kAvatarImage];
}

/*----------------------------------------------------------------------------
 Method:      backupDictionary
 Description: backup a dictionary with a key
 ----------------------------------------------------------------------------*/
+ (void)backupDictionary:(NSDictionary *)dict forKey:(NSString *)key {
    if(dict) {
        NSMutableArray *arr = [NSMutableArray arrayWithObject:dict] ; // set value
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
        SetObj4Key(data, key);
    }
}

+ (void)removeObjectForKey:(NSString *)key {
    if(key != nil) {
        RemoveObj4Key(key);
    }
}

/*----------------------------------------------------------------------------
 Method:      restoreDictionaryForKey
 Description: restore a dictionary for a key
 ----------------------------------------------------------------------------*/
+ (NSDictionary *)restoreDictionaryForKey:(NSString *)key {
    NSData *data = UserDfl4Key(key);
    
    if(data) {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(ArrCount(arr) > 0) {
            return ArrObj4Idx(arr, 0);
        }
    }
    return nil;
}

/*----------------------------------------------------------------------------
 Method:      backupArray
 Description: backup an array with a key
 ----------------------------------------------------------------------------*/
+ (void)backupArray:(NSArray *)array forKey:(NSString *)key {
    if(array && ArrCount(array) > 0) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        SetObj4Key(data, key);
    }
}

/*----------------------------------------------------------------------------
 Method:      restoreArrayForKey
 Description: restore an array for a key
 ----------------------------------------------------------------------------*/
+ (NSMutableArray *)restoreArrayForKey:(NSString *)key {
    NSData *data = UserDfl4Key(key);
    
    if(data) {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(ArrCount(arr) > 0) {
            return [NSMutableArray arrayWithArray:arr];
        }
    }
    return nil;
}

+ (void)backupObject:(id)object forKey:(NSString *)key {
    if(object) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
        SetObj4Key(data, key);
    }
}

+ (id)restoreObjectForKey:(NSString *)key {
    NSData *data = UserDfl4Key(key);
    
    if(data) {
        id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return object;
    }
    return nil;
}

+ (CGFloat)getFileSize:(NSString *)filePath {
    return 0;
}

@end
