/*============================================================================
 PROJECT: SportLocker
 FILE:    PhotoLibraryAccessor.m
 AUTHOR:  Khoai Nguyen
 DATE:    6/26/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "AssetLibraryHelper.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation AssetLibraryHelper

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (ALAssetsLibrary *)assetsLibrary {
    if(!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

+ (id)sharedPhotoLibraryAccessor {
	static dispatch_once_t predicate;
	static AssetLibraryHelper *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}
#if (!__has_feature(objc_arc))

- (id)retain {
    
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    
    return self;
}
#endif

#pragma mark - Group access

- (void)getAssetGroupsFromLibrary:(void (^)(NSMutableArray *groups, NSError *error))resultBlock {
    NSMutableArray *groups = [NSMutableArray array];
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if(*stop || group == nil) {
            resultBlock(groups, nil);
            return ;
        }
        
        if([group valueForProperty:ALAssetsGroupPropertyType]) {
            [groups addObject:group];
        }
    } failureBlock:^(NSError *error) {
        resultBlock(nil, error);
    }];
}

- (void)getAssetsFromGroup:(ALAssetsGroup *)group
               resultBlock:(void(^)(NSMutableArray *photos, NSError *error))resultBlock {
    NSMutableArray *photos = [NSMutableArray array];
    [group setAssetsFilter:[ALAssetsFilter allAssets]];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(*stop || result == nil) {
            resultBlock(photos, nil);
            return ;
        }
        
        [photos addObject:result];
    }];
}

- (void)getAssestByURL:(NSString *)url resultBlock:(void (^)(ALAsset *asset, NSError *error))block {
    
    if([url hasPrefix:@"assets-library"]) {
        [self.assetsLibrary assetForURL:[NSURL URLWithString:url]
                            resultBlock:^(ALAsset *asset) {
                                block(asset, nil);
                            } failureBlock:^(NSError *error) {
                                block(nil, error);
                            }];
    } else {
        if(block != NULL) {
            block(nil, MKOtherError(NSLocalizedString(@"Not Assets URL", nil)));
        }
    }
}

- (void)enumeratePhotosFromCameraRollUsingBlock:(void(^)(ALAsset *result, NSError *error))resultBlock {
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                          
                                          if(*stop) {
                                              resultBlock(nil, nil);
                                              return ;
                                          }
                                          
                                          /* get photos here */
                                          [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                          [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                              if(*stop) {
                                                  resultBlock(nil, nil);
                                                  return ;
                                              }
                                              
                                              resultBlock(result, nil);
                                          }];
                                      } failureBlock:^(NSError *error) {
                                          resultBlock(nil, error);
                                      }];
}

@end
