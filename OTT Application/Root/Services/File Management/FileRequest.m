/*============================================================================
 PROJECT: SportLocker
 FILE:    RequestFile.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    11/14/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "FileRequest.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation FileRequest

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.localPath = [aDecoder decodeObjectForKey:@"localPath"];
        self.response = [aDecoder decodeObjectForKey:@"response"];
        self.parentId = [aDecoder decodeObjectForKey:@"parentId"];
        self.thumbnailURL = [aDecoder decodeObjectForKey:@"thumbnailURL"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.localPath forKey:@"localPath"];
    [aCoder encodeObject:self.response forKey:@"response"];
    [aCoder encodeObject:self.parentId forKey:@"parentId"];
    [aCoder encodeObject:self.thumbnailURL forKey:@"thumbnailURL"];
}

+ (FileRequest *)fileWithURL:(NSString *)url name:(NSString *)name identifier:(NSString *)identifier {
    FileRequest *file = [[FileRequest alloc] init];
    file.url = url;
    file.name = name;
    file.identifier = identifier;
    return file;
}

+ (FileRequest *)fileWithURL:(NSString *)url name:(NSString *)name {
    return [FileRequest fileWithURL:url name:name identifier:nil];
}

+ (FileRequest *)fileWithURL:(NSString *)url identifier:(NSString *)identifier {
    return [FileRequest fileWithURL:url name:nil identifier:identifier];
}

@end
