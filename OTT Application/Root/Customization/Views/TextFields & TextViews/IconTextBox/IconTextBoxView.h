/*============================================================================
 PROJECT: SportLocker
 FILE:    IconTextBoxView.h
 AUTHOR:  Nguyen Minh Khoai
 DATE:    1/30/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>


/*============================================================================
 MACRO
 =============================================================================*/
#define kIconLeftMargin 5
#define kIconRightMargin 5
#define kTextFieldTopMargin 3

typedef enum {
    WarningStatusHide,
    WarningStatusShowError,
    WarningStatusShowOK
} WarningStatus;

/*============================================================================
 PROTOCOL
 =============================================================================*/
@class IconTextBoxView;
@protocol IconTextBoxViewDelegate <NSObject>
@optional
- (BOOL)textBoxShouldBeginEditing:(IconTextBoxView *)textBox;
- (BOOL)textBoxShouldEndEditing:(IconTextBoxView *)textBox;
- (void)textBoxDidBeginEditing:(IconTextBoxView *)textBox;
- (void)textBoxDidEndEditing:(IconTextBoxView *)textBox;
- (BOOL)textBox:(IconTextBoxView *)textBox shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textBoxDidChange:(IconTextBoxView *)textBox;
- (void)textBoxDidChangeSelection:(IconTextBoxView *)textBox;
- (BOOL)textBoxShouldReturn:(IconTextBoxView *)textBox;
- (void)textBoxDidTouchedOnWarning:(IconTextBoxView *)textBox;
@end

/*============================================================================
 Interface:   IconTextBoxView
 =============================================================================*/

@interface IconTextBoxView : UIView {
@protected
    UIImageView *iconView;
    UIImageView *backgroundView;
    CGSize iconSize;
    CGFloat iconTopMargin;
    CGFloat iconLeftMargin;
    CGFloat contentLeftMargin;
    CGFloat contentTopMargin;
    UIButton *warningButton;
    NSString *warningMessage;
    __weak id<IconTextBoxViewDelegate> delegate;
}

@property (nonatomic, strong)   UIImage *iconImage;
@property (nonatomic, strong)   UIImageView *iconView;
@property (nonatomic)           CGSize iconSize;
@property (nonatomic, weak)     id<IconTextBoxViewDelegate> delegate;
@property (nonatomic, assign)   CGFloat iconTopMargin;
@property (nonatomic, assign)   CGFloat iconLeftMargin;
@property (nonatomic, strong)   NSString *text;
@property (nonatomic, assign)   CGFloat contentLeftMargin;
@property (nonatomic, assign)   CGFloat contentTopMargin;
@property (nonatomic, strong)   NSString *warningMessage;

- (void)createBaseUI;
- (void)setIconSize:(CGSize)size;
- (void)setIconImage:(UIImage *)iconImage;
- (void)setBackgroundImage:(UIImage *)image;
- (void)allowToAutoResizeView:(BOOL)status;
- (void)showWarningStatus:(WarningStatus)status;
- (void)hideKeyboard;

- (BOOL)needToShowOneOfErrorMessages:(NSArray *)errorMessages
                    ifInvalidAtLeast:(NSInteger)atLeast
                              atMost:(NSInteger)atMost
            usingMoreValidationBlock:(void(^)(BOOL *valid))block;

- (BOOL)needToShowOneOfErrorMessages:(NSArray *)errorMessages usingMoreValidationBlock:(void(^)(BOOL *valid))block;

@end
