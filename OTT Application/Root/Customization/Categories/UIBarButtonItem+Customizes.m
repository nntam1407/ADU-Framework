/*============================================================================
 PROJECT: SportLocker
 FILE:    UIBarButtonItem+Customizes.m
 AUTHOR:  Nguyen Minh Khoai
 DATE:    1/31/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "UIBarButtonItem+Customizes.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
#define kButtonPadding  5

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation UIBarButtonItem (Customizes)

+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                    selector:(SEL)sel
                                       title:(NSString *)title
                                    iconName:(NSString *)iconName
                              backgroundName:(NSString *)backgroundName
                                     padding:(CGFloat)padding {
    
    @autoreleasepool {
        
        /* create icon and background images */
        UIImage *image = [[IBHelper sharedUIHelper] loadImage:iconName];
        UIImage *backgroundImage = [[IBHelper sharedUIHelper] middleStretchImage:backgroundName];
        
        /* create container view */
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor clearColor];
        
        /* create custom button */
        UIButton *button = [[UIButton alloc] init];
        //        button.showsTouchWhenHighlighted = YES;
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = FontArialWithSize(14);
        [containerView addSubview:button];
        
        /* update frame basing on title */
        CGRect rect;
        if (title.length > 0) {
            [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
            CGSize size = [Utils constrainSizeForLabel:button.titleLabel autoFitSize:AutoFitSizeHeight];
            rect = CGRectMake(0, 0, size.width + (IS_IPAD ? 20 : 10), 30);
        } else {
            [button setImage:image forState:UIControlStateNormal];
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
        }
        button.frame = rect;
        
        /* register button event */
        if (target) {
            [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        }
        
        /* update frame for container view */
        rect.size.width += fabs(padding);
        containerView.frame = rect;
        
        /* update frame for button */
        if (padding < 0) {
            rect = button.frame;
            rect.origin.x -= padding;
            button.frame = rect;
        }
        
        return [[UIBarButtonItem alloc] initWithCustomView:containerView];
    }
}

+ (UIBarButtonItem *)barButtonItemWithTarget:(id)target
                                    selector:(SEL)sel
                                       title:(NSString *)title
                                   imageName:(NSString *)name {
    @autoreleasepool {
        
        BOOL isColor = NO;
        UIImage *image = [[IBHelper sharedUIHelper] loadCommonImage:name];
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = FontBoldWithSize(14);
        //        button.showsTouchWhenHighlighted = YES;
        
        if (isColor) {
            CGSize size = [Utils constrainSizeForLabel:button.titleLabel autoFitSize:AutoFitSizeHeight];
            CGRect rect = CGRectMake(0, 0, size.width + 2 * kButtonPadding, size.height + 2 * kButtonPadding);
            button.frame = rect;
            
            LayerConer(button.layer);
            LayerBorderWithSizeColor(button.layer, 0.2, [UIColor lightGrayColor]);
        } else {
            if (title) {
                CGSize size = [Utils constrainSizeForLabel:button.titleLabel autoFitSize:AutoFitSizeHeight];
                CGRect rect = CGRectMake(0, 0, size.width, size.height);
                button.frame = rect;
            } else {
                CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
                button.frame = rect;
            }
        }
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        if (target) {
            [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        }
        return [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

+ (NSArray *)barButtonItemsWithTarget:(id)target attributes:(NSArray *)attributes xOffset:(NSInteger)xOffset {
    
    @autoreleasepool {
        
        NSMutableArray *items = [NSMutableArray array];
        /* create list of customize buttons */
        for (NSDictionary *dict in attributes) {
            
            UIImage *image = [[IBHelper sharedUIHelper] loadImage:dict[kBarButtonItemImage]];
            UIImage *highLightedImage = [[IBHelper sharedUIHelper] loadImage:dict[kBarButtonItemHighlightedImage]];
            
            /* create customize bar button */
            UIButton *button = nil;
            
            if (image) {
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                if (highLightedImage) {
                    [button setImage:image forState:UIControlStateNormal];
                    [button setImage:highLightedImage forState:UIControlStateSelected];
                } else {
                    [button setBackgroundImage:image forState:UIControlStateNormal];
                }
            } else {
                image = dict[kBarButtonItemImageColor];
                if (!image) {
                    button = [[UIButton alloc] initWithFrame:CGRectZero];
                    button.layer.cornerRadius = kCornerRadius;
                    button.clipsToBounds = YES;
                }
            }
            
            CGFloat height = 44;//(UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ? 44 : 34);
            button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            
            [button setTitle:dict[kBarButtonItemTitle] forState:UIControlStateNormal];
            [button.titleLabel setFont:dict[kBarButtonItemFont]];
            [button setTitleColor:dict[kBarButtonItemTextColor] forState:UIControlStateNormal];
            [button addTarget:target action:NSSelectorFromString(dict[kBarButtonItemSelector]) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:Num2Int(dict[kBarButtonItemTag])];
            
            if (!image && button.titleLabel.text.length > 0) {
                height = 34;
                CGSize size = [Utils sizeForText:button.titleLabel.text label:button.titleLabel];
                button.frame = CGRectMake(0, 0, size.width + 10, height);
            }
            
            /* add it to array */
            UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            [items addObject:barButtonItem];
        }
        
        /* create flexible space bar button */
        UIBarButtonItem *flexibleBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                               target:nil
                                                                                               action:nil];
        flexibleBarButtonItem.width = SupportiOS7 ? -xOffset : 0;
        [items insertObject:flexibleBarButtonItem atIndex:0];
        
        return items;
    }
}

+ (NSArray *)leftBarButtonItemsWithTarget:(id)target attributes:(NSArray *)attributes {
    return [UIBarButtonItem barButtonItemsWithTarget:target attributes:attributes xOffset:11];
}

+ (NSArray *)rightBarButtonItemsWithTarget:(id)target attributes:(NSArray *)attributes {
    return [UIBarButtonItem barButtonItemsWithTarget:target attributes:attributes xOffset:11];
}

@end
