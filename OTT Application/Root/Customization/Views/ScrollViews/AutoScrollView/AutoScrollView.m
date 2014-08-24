//
//  AutoScrollView.m
//  AutoScrollView
//
//  Created by Clark Kent on 7/18/13.
//  Copyright (c) 2013 Clark Kent. All rights reserved.
//

#import "AutoScrollView.h"

@interface AutoScrollView()

@property (nonatomic, strong) UIView *focusedControl;
@property (nonatomic, assign) CGPoint originOffset;
@property (nonatomic, assign) BOOL isKeyboardWillShow;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

- (void)initAutoScrollView;
- (BOOL)view:(UIView *)view isChildOfView:(UIView *)parent;

@end

@implementation AutoScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initAutoScrollView];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initAutoScrollView];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if(newSuperview == nil) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Private methods

- (void)initAutoScrollView {
    /* Register key board notification */
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
    /* Register notification when textField is focused */
    [nc addObserver:self selector:@selector(textFieldDidBeginEditNotif:) name:UITextFieldTextDidBeginEditingNotification object:nil];
//    [nc addObserver:self selector:@selector(textFieldDidBeginEditNotif:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
    _originOffset = CGPointMake(-1, -1);
    _isKeyboardWillShow = NO;
    
    /* Default is 5 */
    _activeViewBottomMargin = 0;
    _extendKeyboardHeight = 0;
    
    // Set default content size
    self.contentSize = self.frame.size;
}

#pragma mark - Keyboards notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    /* Get focus control on this scroll view */
    //_focusedControl = [self getFocusControl];
    
    if(_focusedControl == nil) {
        return;
    }
    
    _isKeyboardWillShow = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardFrameInWindow;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrameInWindow];
    keyboardFrameInWindow.size.height += _extendKeyboardHeight;
    keyboardFrameInWindow.origin.y -= _extendKeyboardHeight;
    
    // the keyboard frame is specified in window-level coordinates. this calculates the frame as if it were a subview of our view, making it a sibling of the scroll view
    CGRect keyboardFrameInView = [self.superview convertRect:keyboardFrameInWindow fromView:nil];
    
    CGRect scrollViewKeyboardIntersection = CGRectIntersection(self.frame, keyboardFrameInView);
    UIEdgeInsets newContentInsets = UIEdgeInsetsMake(0, 0, scrollViewKeyboardIntersection.size.height, 0);
    
    // this is an old animation method, but the only one that retains compaitiblity between parameters (duration, curve) and the values contained in the userInfo-Dictionary.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    
    self.contentInset = newContentInsets;
    self.scrollIndicatorInsets = newContentInsets;
    
    /*
     * Depending on visual layout, _focusedControl should either be the input field (UITextField,..) or another element
     * that should be visible, e.g. a purchase button below an amount text field
     * it makes sense to set _focusedControl in delegates like -textFieldShouldBeginEditing: if you have multiple input fields
     */
    if (_focusedControl) {
        
        if(_originOffset.x == -1 && _originOffset.y == -1) {
            _originOffset = self.contentOffset;
        }
        
        CGRect controlFrameInScrollView = [self convertRect:_focusedControl.bounds fromView:_focusedControl]; // if the control is a deep in the hierarchy below the scroll view, this will calculate the frame as if it were a direct subview
        controlFrameInScrollView = CGRectInset(controlFrameInScrollView, 0, -_activeViewBottomMargin); // replace 10 with any nice visual offset between control and keyboard or control and top of the scroll view.
        
        CGFloat controlVisualOffsetToTopOfScrollview = controlFrameInScrollView.origin.y - self.contentOffset.y;
        CGFloat controlVisualBottom = controlVisualOffsetToTopOfScrollview + controlFrameInScrollView.size.height;
        
        // this is the visible part of the scroll view that is not hidden by the keyboard
        CGFloat scrollViewVisibleHeight = self.frame.size.height - scrollViewKeyboardIntersection.size.height;
        
        if (controlVisualBottom > scrollViewVisibleHeight) { // check if the keyboard will hide the control in question
            // scroll up until the control is in place
            CGPoint newContentOffset = self.contentOffset;
            newContentOffset.y += (controlVisualBottom - scrollViewVisibleHeight);
            
            // make sure we don't set an impossible offset caused by the "nice visual offset"
            // if a control is at the bottom of the scroll view, it will end up just above the keyboard to eliminate scrolling inconsistencies
            newContentOffset.y = MIN(newContentOffset.y, self.contentSize.height - scrollViewVisibleHeight);
            
            [self setContentOffset:newContentOffset animated:NO]; // animated:NO because we have created our own animation context around this code
        } else if (controlFrameInScrollView.origin.y < self.contentOffset.y) {
            // if the control is not fully visible, make it so (useful if the user taps on a partially visible input field
            CGPoint newContentOffset = self.contentOffset;
            newContentOffset.y = controlFrameInScrollView.origin.y;
            
            [self setContentOffset:newContentOffset animated:NO]; // animated:NO because we have created our own animation context around this code
        }
    }
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _isKeyboardWillShow = NO;
    
    [self performSelector:@selector(animationHideKeyboard:) withObject:notification afterDelay:0.01f];
}

- (void)animationHideKeyboard:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    
    if(_isKeyboardWillShow == YES) {
        return;
    }
    
    [UIView animateWithDuration:[[userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.0f
                        options:[[userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                     animations:^{
                         // undo all that keyboardWillShow-magic
                         // the scroll view will adjust its contentOffset apropriately
                         self.contentInset = UIEdgeInsetsZero;
                         self.scrollIndicatorInsets = UIEdgeInsetsZero;
                         
                         [self setContentOffset:_originOffset animated:YES];
                     }
                     completion:^(BOOL finished) {
                         if(finished) {
                             _focusedControl = nil;
                             _originOffset = CGPointMake(-1, -1);
                             _isKeyboardWillShow = NO;
                         }
                     }];
}

- (void)textFieldDidBeginEditNotif:(NSNotification *)notification {
    UIView *focusView = notification.object;
    
    if([self view:focusView isChildOfView:self]) {
        _focusedControl = focusView;
    } else {
        _focusedControl = nil;
    }
}

#pragma mark - Gesture event

- (void)tapGestureEvent:(UITapGestureRecognizer *)sender {
    /* Resign first response */
    if(_focusedControl) {
        [(UITextField *)_focusedControl resignFirstResponder];
    }
}

#pragma mark - Methods

- (void)enableCloseKeyboardWhenTouchOutSideTextField:(BOOL)enable {
    if(_tapGesture == nil && enable == YES) {
        /* Add gesture recorginze */
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
        [_tapGesture setNumberOfTapsRequired:1];
        _tapGesture.cancelsTouchesInView = NO;
        [self addGestureRecognizer:_tapGesture];
    }
    
    if(enable == NO && _tapGesture != nil) {
        /* Remove tap gesture */
        [self removeGestureRecognizer:_tapGesture];
        _tapGesture = nil;
    }
}

- (void)setFocusView:(UIView *)focusView {
    _focusedControl = focusView;
}

- (BOOL)view:(UIView *)view isChildOfView:(UIView *)parent {
    if(view == nil || parent == nil) {
        return NO;
    }
    
    UIView *parentOfView = view.superview;
    
    if (parentOfView == parent) {
        return YES;
    } else {
        return [self view:parentOfView isChildOfView:parent];
    }
}

@end
