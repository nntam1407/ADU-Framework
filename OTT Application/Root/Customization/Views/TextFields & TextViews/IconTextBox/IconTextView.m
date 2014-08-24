/*============================================================================
 PROJECT: SportLocker
 FILE:    IconTextView.m
 AUTHOR:  Nguyen Minh Khoai
 DATE:    1/30/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "IconTextView.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation IconTextView
@synthesize textView;
@synthesize placeHolder;
@synthesize moreOrLeftDistance;
@synthesize originalHeight;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Overriden Methods

- (void)setContentLeftMargin:(CGFloat)margin {
    [super setContentLeftMargin:margin];
    
    /* relayout for content view */
    [self setNeedsLayout];
}

- (void)createBaseUI {
    [super createBaseUI];
    
    /* create text field and relayout it */
    textView = [[PlaceholderTextView alloc] init];
    textView.placeholder = @" ";
    textView.autoresizesSubviews = YES;
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textView.contentInset = UIEdgeInsetsMake(-8, -8, -8, -8); /* clear padding and margin */
    textView.font = FontArialWithSize(13);
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = self;
    [self addSubview:textView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /* get bounds of view */
    CGRect bounds = self.bounds;
    
    /* Layout for text view */
    if(!iconView.image) {
        iconView.frame = CGRectZero;
    }
    
    BOOL hiddenWarning = warningButton.hidden;
    CGRect rect = iconView.frame;
    CGFloat x = (contentLeftMargin > 0 ? contentLeftMargin : rect.origin.x + rect.size.width + kIconLeftMargin);
    CGFloat y = contentTopMargin > 0 ? self.contentTopMargin : 0;
    CGFloat width = bounds.size.width - (x + kIconLeftMargin) - (!hiddenWarning ? warningButton.frame.size.width : 0);
    CGFloat height = contentTopMargin > 0 ? bounds.size.height - 2*contentTopMargin : bounds.size.height;
    textView.frame = CGRectMake(x, y, width, height);
    
    /* keep original height here */
    if(originalHeight == 0) {
        originalHeight = textView.frame.size.height;
    }
}

- (void)setPlaceHolder:(NSString *)text {
    placeHolder = text;
    textView.placeholder = text;
    [self setNeedsLayout];
}

- (NSString *)placeHolder {
    return placeHolder;
}

- (NSString *)text {
    return self.textView.text;
}

- (void)setText:(NSString *)text {
    [self.textView setText:text];
    [self textViewDidChange:textView];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if(delegate && [delegate respondsToSelector:@selector(textBoxShouldBeginEditing:)]) {
        return [delegate textBoxShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if(delegate && [delegate respondsToSelector:@selector(textBoxShouldEndEditing:)]) {
        return [delegate textBoxShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if(delegate && [delegate respondsToSelector:@selector(textBoxDidBeginEditing:)]) {
        [delegate textBoxDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if(delegate && [delegate respondsToSelector:@selector(textBoxDidEndEditing:)]) {
        [delegate textBoxDidEndEditing:self];
    }
}

- (BOOL)textView:(UITextView *)tv shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if(delegate && [delegate respondsToSelector:@selector(textBox:shouldChangeTextInRange:replacementText:)]) {
        return [delegate textBox:self shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)tv {
    /* calculate  more or left distance when text did changed */
    CGSize size = textView.contentSize;
    moreOrLeftDistance = [self calculateMoreOrLeftDistanceFromSize:size];
    
    if(delegate && [delegate respondsToSelector:@selector(textBoxDidChange:)]) {
        [delegate textBoxDidChange:self];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if(delegate && [delegate respondsToSelector:@selector(textBoxDidChangeSelection:)]) {
        [delegate textBoxDidChangeSelection:self];
    }
}

- (void)hideKeyboard {
    [self.textView resignFirstResponder];
}

- (CGFloat)calculateMoreOrLeftDistanceFromSize:(CGSize)size {

    CGFloat distance = size.height - textView.frame.size.height;
    if(size.height < originalHeight) {
        if(distance > 0 || textView.frame.size.height < originalHeight) {
            distance = size.height - originalHeight;
        } else {
            distance = 0;
        }
    }
    return distance;
}

@end
