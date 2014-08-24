//
//  IBHelper.m
//  Halalgems
//
//  Created by Nguyen Minh Khoai on 12/20/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//

#import "IBHelper.h"

#define kIBHelper   [IBHelper sharedUIHelper]

@implementation IBHelper

+ (IBHelper *)sharedUIHelper {
    static IBHelper *sharedUIHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedUIHelper) {
            @autoreleasepool {
                sharedUIHelper = [[IBHelper alloc] init];
            }
        }
    });
    return sharedUIHelper;
}

- (NSString *)correctName:(NSString *)name iPad:(BOOL)iPad {
    if (iPad) {
        return [NSString stringWithFormat:@"%@%@", name, (IS_IPAD ? @"_iPad" : @"")];
    }
    return [NSString stringWithFormat:@"%@", name];
}

- (NSString *)imageName:(NSString *)name iPad:(BOOL)iPad {
    return [NSString stringWithFormat:@"%@.png", [self correctName:name iPad:iPad]];
}

- (UIImage *)loadImage:(NSString *)name {
    UIImage *image = [UIImage imageNamed:[self imageName:name iPad:YES]];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if (SupportiOS7) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
#endif
    return image;
}

+ (UIImage *)stretchImageName:(NSString *)imageName
          horizontalDirection:(BOOL)horizontalDirection
            verticalDirection:(BOOL)verticalDirection
                   topPadding:(CGFloat)topPadding {
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat leftCap = (horizontalDirection ? image.size.width / 2 : 0);
    CGFloat topCap = (verticalDirection ? image.size.height / 2 : 0) + topPadding;
    return [image stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

+ (UIImage *)tiledImageName:(NSString *)imageName edgeInset:(UIEdgeInsets)inset {
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image resizableImageWithCapInsets:inset];
    return image;
}

- (UIImage *)stretchImagedName:(NSString *)imageName topPadding:(CGFloat)topPadding {
    return [IBHelper stretchImageName:[self imageName:imageName iPad:YES]
                  horizontalDirection:YES
                    verticalDirection:YES
                           topPadding:topPadding];
}

- (UIImage *)middleStretchImage:(NSString *)name {
    return [IBHelper stretchImageName:[self imageName:name iPad:YES]
                  horizontalDirection:YES
                    verticalDirection:YES
                           topPadding:0];
}

- (UIImage *)tiledImageName:(NSString *)imageName edgeInset:(UIEdgeInsets)inset {
    return [IBHelper tiledImageName:[self imageName:imageName iPad:YES] edgeInset:inset];
}

/* common images */
- (NSString *)imageCommonName:(NSString *)name {
    return [NSString stringWithFormat:@"%@.png", [self correctName:name iPad:NO]];
}

- (UIImage *)loadCommonImage:(NSString *)name {
    return [UIImage imageNamed:[self imageName:name iPad:NO]];
}

- (UIImage *)middleStretchCommonImage:(NSString *)name {
    return [IBHelper stretchImageName:[self imageName:name iPad:NO]
                  horizontalDirection:YES
                    verticalDirection:YES
                           topPadding:0];
}

- (UIImage *)horizontalStretchImage:(NSString *)name {
    return [IBHelper stretchImageName:[self imageName:name iPad:YES]
                  horizontalDirection:YES
                    verticalDirection:NO
                           topPadding:0];
}

- (UIImage *)verticalStretchImage:(NSString *)name {
    return [IBHelper stretchImageName:[self imageName:name iPad:YES]
                  horizontalDirection:NO
                    verticalDirection:YES
                           topPadding:0];
}

/* xibs or story boards */
- (id)loadViewNib:(NSString *)nibName {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:[self correctName:nibName iPad:YES] owner:nil options:nil];
    if ([nibs count] > 0) {
        return nibs[0];
    }
    return nil;
}

- (id)loadViewControllerNib:(NSString *)nibName {
    @autoreleasepool {
        UIViewController *viewController = [[NSClassFromString(nibName) alloc] initWithNibName:[self correctName:nibName iPad:YES] bundle:nil];
        return viewController;
    }
}

- (id)loadStoryBoard:(NSString *)storyName {
    @autoreleasepool {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:[self correctName:storyName iPad:YES] bundle:nil];
        return storyBoard;
    }
}

- (id)loadViewController:(NSString *)name inStory:(NSString *)story {
    UIStoryboard *storyBoard = [self loadStoryBoard:story];
    return [storyBoard instantiateViewControllerWithIdentifier:name];
}

/* xibs or story boards */
+ (UINib *)nibWithNibName:(NSString *)name {
    return [UINib nibWithNibName:[kIBHelper correctName:name iPad:YES] bundle:nil];
}

#pragma mark - Customize Fonts

/* Customize fonts for all control */
- (void)configureFont:(UIFont *)font forLabel:(UILabel *)label {
    label.font = font;
}

@end
