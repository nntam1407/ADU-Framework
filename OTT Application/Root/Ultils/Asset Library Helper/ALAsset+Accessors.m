/*============================================================================
 PROJECT: SportLocker
 FILE:    ALAsset+Images.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    11/15/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "ALAsset+Accessors.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation ALAsset (Accessors)

- (UIImage *)thumbnailImage {
    return [UIImage imageWithCGImage:self.aspectRatioThumbnail];
}

- (UIImage *)originalImage {
    return [UIImage imageWithCGImage:[self.defaultRepresentation fullResolutionImage]
                               scale:1.0
                         orientation:(UIImageOrientation)self.defaultRepresentation.orientation];
}

- (NSData *)bytes {
    ALAssetRepresentation *rep = [self defaultRepresentation];
    Byte *buffer = (Byte *)malloc((unsigned long)rep.size);
    NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(unsigned long)rep.size error:nil];
    return [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
}

- (NSString *)name {
    return [[self defaultRepresentation] filename];
}

- (NSURL *)url {
    return [[self defaultRepresentation] url];
}

- (BOOL)isPhoto {
    return ([[self valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]);
}

- (BOOL)isVideo {
    return ([[self valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]);
}

@end
