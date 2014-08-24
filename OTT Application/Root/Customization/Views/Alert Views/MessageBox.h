//
//  MessageBox.h
//  Kanpai
//
//  Created by Khoai Nguyen Minh on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MessageBox;
@protocol MessageBoxDelegate <NSObject>
@optional

- (void)messageBox:(MessageBox *)box clickedButtonAtIndex:(NSNumber *)buttonIndex;
- (void)messageBoxCancel:(MessageBox *)box;

@end

@interface MessageBox : NSObject<UIAlertViewDelegate>  {
    BOOL  _isShowAlert;
    NSString *_currentMsg;
    
    UIAlertView *_errorDialog;
    id<MessageBoxDelegate> __weak _delegate;
    NSInteger   _tag;
}

@property (nonatomic, copy) NSString *currentMsg;
@property (nonatomic, strong) UIAlertView *errorDialog;
@property (nonatomic, weak) id<MessageBoxDelegate> delegate;
@property (nonatomic, assign) NSInteger   tag;

+ (MessageBox *)sharedMessageBox;

- (void)resetStatus;
- (void)showBoxWithTitle:(NSString *)title message:(NSString *)message 
           delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

@end
