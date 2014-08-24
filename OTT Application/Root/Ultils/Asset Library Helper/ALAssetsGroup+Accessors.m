/*============================================================================
 PROJECT: SportLocker
 FILE:    ALAssetsGroup+Accessors.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    12/21/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "ALAssetsGroup+Accessors.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation ALAssetsGroup (Accessors)
- (UIImage *)thumnailImage {
    return [UIImage imageWithCGImage:self.posterImage];
}

- (NSString *)name {
    return [self valueForProperty:ALAssetsGroupPropertyName];
}

- (NSURL *)url {
    return [self valueForProperty:ALAssetsGroupPropertyURL];
}

@end
