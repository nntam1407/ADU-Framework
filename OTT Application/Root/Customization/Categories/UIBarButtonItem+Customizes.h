/*============================================================================
 PROJECT: SportLocker
 FILE:    UIBarButtonItem+Customizes.h
 AUTHOR:  Nguyen Minh Khoai
 DATE:    1/31/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>

/*============================================================================
 MACRO
 =============================================================================*/
#define kBarButtonItemImage                 @"kBarButtonItemImage"
#define kBarButtonItemImageColor            @"kBarButtonItemImageColor"
#define kBarButtonItemHighlightedImage      @"kBarButtonItemHighlightedImage"
#define kBarButtonItemTitle                 @"kBarButtonItemTitle"
#define kBarButtonItemFont                  @"kBarButtonItemFont"
#define kBarButtonItemSelector              @"kBarButtonItemSelector"
#define kBarButtonItemTag                   @"kBarButtonItemTag"
#define kBarButtonItemTextColor             @"kBarButtonItemTextColor"

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   UIBarButtonItem_Customizes
 =============================================================================*/

@interface UIBarButtonItem (Customizes)
+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                    selector:(SEL)sel
                                       title:(NSString *)title
                                   imageName:(NSString *)name;

+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                    selector:(SEL)sel
                                       title:(NSString *)title
                                    iconName:(NSString *)iconName
                              backgroundName:(NSString *)backgroundName
                                     padding:(CGFloat)padding;

+ (NSArray *)barButtonItemsWithTarget:(id)target
                           attributes:(NSArray *)attributes
                              xOffset:(NSInteger)xOffset;

+ (NSArray *)leftBarButtonItemsWithTarget:(id)target
                               attributes:(NSArray *)attributes;

+ (NSArray *)rightBarButtonItemsWithTarget:(id)target
                                attributes:(NSArray *)attributes;

@end
