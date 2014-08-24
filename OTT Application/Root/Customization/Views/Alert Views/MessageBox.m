//
//  MessageBox.m
//  Kanpai
//
//  Created by Khoai Nguyen Minh on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageBox.h"

@implementation MessageBox
@synthesize currentMsg = _currentMsg;
@synthesize delegate = _delegate;
@synthesize errorDialog = _errorDialog;
@synthesize tag = _tag;

static MessageBox *sharedBox = nil;

#pragma mark -
#pragma mark Singleton

- (id)init {
    self = [super init];
	if (self) {
        self.currentMsg = nil;
    }
	return self;
}

+ (MessageBox *)sharedMessageBox {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedBox == nil)
			sharedBox = [[MessageBox alloc] init];
    });
	return sharedBox;
}


#pragma mark UIAlertViewDelegate

- (void)alertViewCancel:(UIAlertView *)alertView {
    _isShowAlert = NO;
    self.currentMsg = nil;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(messageBoxCancel:)]) {
        [_delegate performSelector:@selector(messageBoxCancel:) withObject:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _isShowAlert = NO;
    self.currentMsg = nil;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(messageBox:clickedButtonAtIndex:)]) {
         [_delegate performSelector:@selector(messageBox:clickedButtonAtIndex:) withObject:self withObject:@(buttonIndex)];
    }
}

- (void)showBoxWithTitle:(NSString *)title message:(NSString *)message 
                delegate:(id)delegate 
       cancelButtonTitle:(NSString *)cancelButtonTitle 
       otherButtonTitles:(NSArray *)otherButtonTitles {
    
    // the input message mustn't be extract with current message
    if(_currentMsg == nil 
       || (![self.currentMsg  isEqualToString:message]) 
       || (_delegate && ![self.delegate isKindOfClass:[delegate class]] )) {
        // dismiss previous dialog
        if(self.errorDialog) {
            [self.errorDialog dismissWithClickedButtonIndex:0 animated:NO];
        }
     
        self.currentMsg = message;
        self.delegate = delegate;
       
        NSString *cancelTitle = nil;
        if(cancelButtonTitle) {
            cancelTitle = cancelButtonTitle;
        }
        
        // create new alert
        UIAlertView *dialog = 
        [[UIAlertView alloc] initWithTitle:title message:message
                                  delegate:self cancelButtonTitle:cancelTitle
                         otherButtonTitles:nil];
        
        // create other buttons
        for (NSString *title in otherButtonTitles) {
            [dialog addButtonWithTitle:title];
        }
        
        self.errorDialog = dialog;
        
        [_errorDialog show];
    }
}

- (void)resetStatus {    
    self.currentMsg = nil;
    
    if(self.errorDialog) {
        [self.errorDialog dismissWithClickedButtonIndex:0 animated:NO];
    }
}

@end
