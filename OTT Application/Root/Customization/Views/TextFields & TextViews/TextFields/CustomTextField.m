/*============================================================================
 PROJECT: SportLocker
 FILE:    CustomTextField.m
 AUTHOR:  Clark Kent
 DATE:    5/23/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "CustomTextField.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface CustomTextField()
@end


@implementation CustomTextField
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBaseUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createBaseUI];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Layout text content
    CGRect textFrame = _textField.frame;
    textFrame.origin.y += _textPaddingTop;
    textFrame.size.height -= _textPaddingTop;
    
    if(_textField.textAlignment == MKTextAlignmentLeft) {
        textFrame.origin.x += _textPaddingLeft;
        textFrame.size.width -= _textPaddingLeft;
    }
    
    _textField.frame = textFrame;
    
    // Layout place holder
    CGRect placeHolderFrame = _placeHolderLabel.frame;
    placeHolderFrame.origin.y += _placeHolderPaddingTop;
    placeHolderFrame.size.height -= _placeHolderPaddingTop;
    
    if(_placeHolderLabel.textAlignment == MKTextAlignmentLeft) {
        placeHolderFrame.origin.x += _placeHolderPaddingLeft;
        placeHolderFrame.size.width -= _placeHolderPaddingLeft;
    }
    
    _placeHolderLabel.frame = placeHolderFrame;
}

#pragma mark - Implement methods

- (void)setTextPaddingLeft:(float)textPaddingLeft {
    _textPaddingLeft = textPaddingLeft;
    [self setNeedsLayout];
}

- (void)setTextPaddingTop:(float)textPaddingTop {
    _textPaddingTop = textPaddingTop;
    [self setNeedsLayout];
}

- (void)setPaddingLeft:(float)paddingLeft {
    _paddingLeft = paddingLeft;
    _placeHolderPaddingLeft = paddingLeft;
    _textPaddingLeft = paddingLeft;
    
    [self setNeedsLayout];
}

- (void)setPaddingTop:(float)paddingTop {
    _paddingTop = paddingTop;
    _placeHolderPaddingTop = paddingTop;
    _textPaddingTop = paddingTop;
    
    [self setNeedsLayout];
}

- (void)setPlaceHolderPaddingTop:(float)placeHolderPaddingTop {
    _placeHolderPaddingTop = placeHolderPaddingTop;
    [self setNeedsLayout];
}

- (void)setPlaceHolderPaddingLeft:(float)placeHolderPaddingLeft {
    _placeHolderPaddingLeft = placeHolderPaddingLeft;
    [self setNeedsLayout];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor = placeHolderColor;
    _placeHolderLabel.textColor = placeHolderColor;
}

- (void)setPlaceHolderFont:(UIFont *)placeHolderFont {
    _placeHolderFont = placeHolderFont;
    _placeHolderLabel.font = placeHolderFont;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _textField.textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    _textField.font = textFont;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    _textFont = font;
    _textField.font = font;
    
    _placeHolderFont = font;
    _placeHolderLabel.font = font;
}

- (void)setText:(NSString *)text {
    _textField.text = [text trim];
    
    if(text.length > 0) {
        [self hidePlayHolderWithAnimation:false];
    } else {
        [self showPlayHolderWithAnimation:NO];
    }
}

- (NSString *)text {
    return _textField.text;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    _placeHolderLabel.text = placeHolder;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textField.textAlignment = textAlignment;
    _placeHolderLabel.textAlignment = textAlignment;
}
#pragma mark - Implement methods

- (void)createBaseUI {
    // Initialization default value
    _textPaddingTop = 0;
    _textPaddingLeft = 0;
    _textColor = [UIColor blackColor];
    _font = [UIFont systemFontOfSize:13];
    
    _placeHolderPaddingTop = 0;
    _placeHolderPaddingLeft = 0;
    _placeHolderColor = [UIColor lightGrayColor];
    _placeHolderFont = [UIFont systemFontOfSize:13];
    
    // Create place holder
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _placeHolderLabel.font = _placeHolderFont;
    _placeHolderLabel.textColor = _placeHolderColor;
    _placeHolderLabel.backgroundColor = [UIColor clearColor];
    _placeHolderLabel.textAlignment = MKTextAlignmentCenter;
    
    [self addSubview:_placeHolderLabel];
    //[_placeHolderLabel release];
    
    // Create text field
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.font = _font;
    _textField.textColor = _textColor;
    _textField.placeholder = nil;
    _textField.textAlignment = MKTextAlignmentCenter;
    _textField.text = @"";
    
    _textField.delegate = self;
    [self addSubview:_textField];
    //[_textField release];
    
    // update layout
    [self setNeedsLayout];
}

- (void)hidePlayHolderWithAnimation:(BOOL)animation {
    if(animation) {
        [UIView animateWithDuration:0.3 animations:^{
            _placeHolderLabel.layer.opacity = 0;
        }];
    } else {
        _placeHolderLabel.layer.opacity = 0;
    }
}

- (void)showPlayHolderWithAnimation:(BOOL)animation {
    NSString *tmp = _textField.text;
    
    if(tmp.length != 0)
        return;
    
    if(animation) {
        [UIView animateWithDuration:0.3 animations:^{
            _placeHolderLabel.layer.opacity = 1;
        }];
    } else {
        _placeHolderLabel.layer.opacity = 1;
    }
}

#pragma mark - Implement UITextField delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(_delegate && [_delegate respondsToSelector:@selector(customTextFieldShouldReturn:)]) {
        return [_delegate customTextFieldShouldReturn:self];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self hidePlayHolderWithAnimation:NO];
    
    if(_delegate && [_delegate respondsToSelector:@selector(customTextFieldShouldBeginEditing:)]) {
        return [_delegate customTextFieldShouldBeginEditing:self];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if(_delegate && [_delegate respondsToSelector:@selector(customTextFieldShouldEndEditing:)]) {
        return [_delegate customTextFieldShouldEndEditing:self];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    /* update placeholder */
    //[self showPlayHolderWithAnimation:false];
    
    if(_delegate && [_delegate respondsToSelector:@selector(customTextFieldDidBeginEditing:)]) {
        return [_delegate customTextFieldDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    /* update placeholder */
    [self showPlayHolderWithAnimation:false];
    
    if(_delegate && [_delegate respondsToSelector:@selector(customTextFieldDidEndEditing:)]) {
        return [_delegate customTextFieldDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *finalText = textField.text;
    finalText = [finalText stringByReplacingCharactersInRange:range withString:string];
    
    if(finalText.length > 0) {
        [self hidePlayHolderWithAnimation:false];
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(customTextField:shouldChangeTextInRange:replacementText:)]) {
        return [_delegate customTextField:self shouldChangeTextInRange:range replacementText:string];
    }
    
    return YES;
}

@end
