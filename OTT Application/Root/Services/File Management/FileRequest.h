/*============================================================================
 PROJECT: SportLocker
 FILE:    RequestFile.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    11/14/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <Foundation/Foundation.h>

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   RequestFile
 =============================================================================*/


@interface FileRequest : NSObject<NSCoding>
@property (strong, nonatomic) NSString *thumbnailURL;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *localPath;
@property (strong, nonatomic) id response;
@property (strong, nonatomic) NSString *parentId;

+ (FileRequest *)fileWithURL:(NSString *)url name:(NSString *)name identifier:(NSString *)identifier;
+ (FileRequest *)fileWithURL:(NSString *)url name:(NSString *)name;
+ (FileRequest *)fileWithURL:(NSString *)url identifier:(NSString *)identifier;

@end
