/*============================================================================
 PROJECT: SportLocker
 FILE:    PhotoLibraryAccessor.h
 AUTHOR:  Khoai Nguyen
 DATE:    6/26/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAsset+Accessors.h"
#import "ALAssetsGroup+Accessors.h"

/*============================================================================
 MACRO
 =============================================================================*/
#define kAssetURLFormat @"assets-library"

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   PhotoLibraryAccessor
 =============================================================================*/


@interface AssetLibraryHelper : NSObject
@property (nonatomic, strong, getter = assetsLibrary) ALAssetsLibrary   *library;

+ (id)sharedPhotoLibraryAccessor;
- (void)getAssetGroupsFromLibrary:(void (^)(NSMutableArray *groups, NSError *error))resultBlock;
- (void)getAssetsFromGroup:(ALAssetsGroup *)group resultBlock:(void(^)(NSMutableArray *photos, NSError *error))resultBlock;
- (void)getAssestByURL:(NSString *)url resultBlock:(void (^)(ALAsset *asset, NSError *error))block;
- (void)enumeratePhotosFromCameraRollUsingBlock:(void(^)(ALAsset *result, NSError *error))resultBlock;
@end
