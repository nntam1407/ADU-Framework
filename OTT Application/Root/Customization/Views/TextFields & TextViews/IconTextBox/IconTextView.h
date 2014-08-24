/*============================================================================
 PROJECT: SportLocker
 FILE:    IconTextView.h
 AUTHOR:  Nguyen Minh Khoai
 DATE:    1/30/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "IconTextBoxView.h"
#import "PlaceholderTextView.h"

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   IconTextView
 =============================================================================*/
@interface IconTextView : IconTextBoxView<UITextViewDelegate> {
    PlaceholderTextView  *textView;
    NSString    *placeHolder;
    CGFloat     moreOrLeftDistance;
    CGFloat     originalHeight;
}

@property (nonatomic, strong)   PlaceholderTextView  *textView;
@property (nonatomic, strong)   NSString             *placeHolder;
@property (nonatomic, assign)   CGFloat     moreOrLeftDistance;
@property (nonatomic, assign)   CGFloat     originalHeight;

- (CGFloat)calculateMoreOrLeftDistanceFromSize:(CGSize)size;

@end
