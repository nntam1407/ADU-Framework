/*============================================================================
 PROJECT: SportLocker
 FILE:    FileHelper.h
 AUTHOR:  Nguyen Minh Khoai
 =============================================================================*/

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject {
}

+ (FileHelper *)sharedManager;

/* prevent auto backup to iCloud */
- (void)preventiCloudAutoBackup;

/* get default avatar path */
+ (NSString *)pathForFileName:(NSString *)fileName;
+ (NSString *)avatarPath;

/* save & load NSDictionary */
+ (void)backupDictionary:(NSDictionary *)dict forKey:(NSString *)key;
+ (NSDictionary *)restoreDictionaryForKey:(NSString *)key;

/* save & load NSMutableArray */
+ (void)backupArray:(NSArray *)array forKey:(NSString *)key;
+ (NSMutableArray *)restoreArrayForKey:(NSString *)key;

/* save & load Object */
+ (void)backupObject:(id)array forKey:(NSString *)key;
+ (id)restoreObjectForKey:(NSString *)key;

// remove object for key
+ (void)removeObjectForKey:(NSString *)key;

/*fileSiz*/
+ (CGFloat)getFileSize:(NSString*)filePath;
@end
