//
//  IBHelper.h
//  Halalgems
//
//  Created by Nguyen Minh Khoai on 12/20/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DynNumber(x)  (IS_IPAD ? 2 * x : x)
#define RectMake(x, y, w, h) CGRectMake(x, y, w, DynNumber(h))

@interface IBHelper : NSObject

+ (IBHelper *)sharedUIHelper;

+ (UINib *)nibWithNibName:(NSString *)name;

- (id)loadViewNib:(NSString *)nibName;

- (id)loadViewControllerNib:(NSString *)nibView;

- (id)loadStoryBoard:(NSString *)storyName;

- (id)loadViewController:(NSString *)name inStory:(NSString *)story;

/* check iPad device */
- (UIImage *)loadImage:(NSString *)name;

- (UIImage *)middleStretchImage:(NSString *)name;

- (UIImage *)horizontalStretchImage:(NSString *)name;

- (UIImage *)verticalStretchImage:(NSString *)name;

- (UIImage *)tiledImageName:(NSString *)imageName edgeInset:(UIEdgeInsets)inset;

- (UIImage *)stretchImagedName:(NSString *)imageName topPadding:(CGFloat)padding;

/* no check iPad device */
- (NSString *)imageCommonName:(NSString *)name;

- (UIImage *)loadCommonImage:(NSString *)name;

- (UIImage *)middleStretchCommonImage:(NSString *)name;

@end
