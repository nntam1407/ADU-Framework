/*============================================================================
 PROJECT: SportLocker
 FILE:    iconTextField.m
 AUTHOR:  Nguyen Minh Khoai
 DATE:    1/30/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "IconTextField.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/


/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/


@implementation IconTextField
@synthesize textField;
@synthesize placeHolder;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Overriden Methods

- (void)setPlaceHolder:(NSString *)holder {
    textField.placeholder = holder;
}

- (NSString *)placeHolder {
    return textField.placeholder;
}

- (void)setFont:(UIFont *)font {
    textField.font = font;
}

- (UIFont *)font {
    return textField.font;
}

- (void)setTextColor:(UIColor *)color {
    textField.textColor = color;
}

- (UIColor *)textColor {
    return textField.textColor;
}

- (NSString *)text {
    return self.textField.text;
}

- (void)setText:(NSString *)text {
    [self.textField setText:text];
}

- (void)setContentLeftMargin:(CGFloat)margin {
    [super setContentLeftMargin:margin];
    
    /* relayout for content view */
    [self setNeedsLayout];
}

- (void)createBaseUI {
    [super createBaseUI];
    
    /* create text field and relayout it */
    textField = [[UITextField alloc] init];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    textField.font = FontArialWithSize(12);
    textField.borderStyle = UITextBorderStyleNone;
    textField.delegate = self;
    [self addSubview:textField];
    
    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    //to make the done button aligned to the right
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Accessory UIBarButtonItem")
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(hideKeyboard)];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];
    self.textField.inputAccessoryView = toolbar;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /* get bounds of view */
    CGRect bounds = self.bounds;
    
    /* Layout for text field */
    CGRect rect = iconView.frame;
    BOOL hiddenWarning = warningButton.hidden;
    
    CGFloat x = rect.origin.x + rect.size.width + self.iconLeftMargin + self.contentLeftMargin;
    CGFloat y = self.contentTopMargin;
    CGFloat width = bounds.size.width - (x + self.iconLeftMargin) - (!hiddenWarning ? warningButton.frame.size.width : 0);
    CGFloat height = bounds.size.height - 2 * self.contentTopMargin;
    
    textField.frame = CGRectMake(x, y, width, height);
}

- (BOOL)becomeFirstResponder {
    [textField becomeFirstResponder];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [textField resignFirstResponder];
    return [super resignFirstResponder];
}

- (BOOL)isFirstResponder {
    return [textField isFirstResponder];
}
#pragma mark - UITextFieldDelegate

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(delegate && [delegate respondsToSelector:@selector(textBoxShouldBeginEditing:)]) {
        return [delegate textBoxShouldBeginEditing:self];
    }
    return YES;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(delegate && [delegate respondsToSelector:@selector(textBoxDidBeginEditing:)]) {
        [delegate textBoxDidBeginEditing:self];
    }
}
// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if(delegate && [delegate respondsToSelector:@selector(textBoxShouldEndEditing:)]) {
        return [delegate textBoxShouldEndEditing:self];
    }
    return YES;
}
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if(delegate && [delegate respondsToSelector:@selector(textBoxDidEndEditing:)]) {
        [delegate textBoxDidEndEditing:self];
    }
}
// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(delegate && [delegate respondsToSelector:@selector(textBox:shouldChangeTextInRange:replacementText:)]) {
        return [delegate textBox:self shouldChangeTextInRange:range replacementText:string];
    }
    return YES;
}
// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(delegate && [delegate respondsToSelector:@selector(textBoxShouldReturn:)]) {
        return [delegate textBoxShouldReturn:self];
    }
    return YES;
}

- (void)hideKeyboard {
    [self.textField resignFirstResponder];
}

@end
