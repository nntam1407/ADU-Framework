/*============================================================================
 PROJECT: SportLocker
 FILE:    iconTextField.h
 AUTHOR:  Nguyen Minh Khoai
 DATE:    1/30/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "IconTextBoxView.h"


/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   iconTextField
 =============================================================================*/

@interface IconTextField : IconTextBoxView<UITextFieldDelegate> {
    UITextField *textField;
}

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString  *placeHolder;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@end
