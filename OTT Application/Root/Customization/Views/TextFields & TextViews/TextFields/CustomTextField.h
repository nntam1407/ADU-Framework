/*============================================================================
 PROJECT: SportLocker
 FILE:    CustomTextField.h
 AUTHOR:  Clark Kent
 DATE:    5/23/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>


/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/
@class CustomTextField;

@protocol CustomTextFieldDelegate <NSObject>

@optional
- (BOOL)customTextFieldShouldBeginEditing:(CustomTextField *)customTextField;
- (BOOL)customTextFieldShouldEndEditing:(CustomTextField *)customTextField;
- (void)customTextFieldDidBeginEditing:(CustomTextField *)customTextField;
- (void)customTextFieldDidEndEditing:(CustomTextField *)customTextField;
- (BOOL)customTextField:(CustomTextField *)textBox shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)customTextFieldDidChange:(CustomTextField *)textBox;
- (void)customTextFieldDidChangeSelection:(CustomTextField *)customTextField;
- (BOOL)customTextFieldShouldReturn:(CustomTextField *)customTextField;
- (void)customTextFieldDidTouchedOnWarning:(CustomTextField *)customTextField;
@end

/*============================================================================
 Interface:   CustomTextField
 =============================================================================*/

@interface CustomTextField : UIView <UITextFieldDelegate> {
    __weak id<CustomTextFieldDelegate> _delegate;
}


@property (nonatomic, weak)     id<CustomTextFieldDelegate> delegate;

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *placeHolderLabel;

@property (strong, nonatomic) UIFont *font; // font for both text and playholder
@property (assign, nonatomic) float paddingTop; // padding for both text and place holder
@property (assign, nonatomic) float paddingLeft;

@property (assign, nonatomic) float placeHolderPaddingTop;
@property (assign, nonatomic) float placeHolderPaddingLeft;
@property (strong, nonatomic) UIFont *placeHolderFont;
@property (strong, nonatomic) UIColor *placeHolderColor;
@property (strong, nonatomic) NSString *placeHolder;

@property (assign, nonatomic) float textPaddingTop;
@property (assign, nonatomic) float textPaddingLeft;
@property (strong, nonatomic) UIFont *textFont;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) NSTextAlignment textAlignment;

- (void)createBaseUI;
- (void)hidePlayHolderWithAnimation:(BOOL)animation;
- (void)showPlayHolderWithAnimation:(BOOL)animation;

@end
