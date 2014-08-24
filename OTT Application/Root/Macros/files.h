/*=============================================================================
 PROJECT: SportLocker
 FILE:    file.h
 AUTHOR:  Mai Trung Tin
 =============================================================================*/
#ifndef _FILE_H_H_
#define _FILE_H_H_
#import "array.h"

/*=============================================================================
 MACRO DEFINITION
 =============================================================================*/
#define FileManager             [NSFileManager defaultManager]

#define DocPath                 ArrObj4Idx(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES),0)
#define FilePathInDoc(f)        [DocPath stringByAppendingPathComponent:f]

#define FileExist(f0)           [FileManager fileExistsAtPath:f0]
#define FileRemove(f0)          [FileManager removeItemAtPath:f0 error:nil]
#define FileRename(f0,f1)       [FileManager moveItemAtPath:f0 toPath:f1 error:nil]
#define FileCopy(f0,f1)         [FileManager copyItemAtPath:f0 toPath:f1 error:nil]


static BOOL isExistDirectory(NSString *dir) {
    BOOL isDir = NO; 
    return ([FileManager fileExistsAtPath:dir isDirectory:&isDir] && isDir);
}

static BOOL createDirectory(NSString *dir) {
    BOOL status = YES;
    if(!isExistDirectory(dir)) {
        NSError *error = nil;
        [FileManager createDirectoryAtPath:dir
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
        
        if(error) {
            status = NO;
        }
    }
    return status;
}

static NSString *getDirectory(NSString *name) {
    NSString *path = FilePathInDoc(name);
    if(!createDirectory(path)) {
        path = nil;
    }
    return path;
}

#endif  /* _FILE_H_H_ */