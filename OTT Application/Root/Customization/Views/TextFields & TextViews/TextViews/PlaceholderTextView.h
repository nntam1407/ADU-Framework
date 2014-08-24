//
//  PlaceholderTextView.h
//  Findereat
//
//  Created by Nguyen Minh Khoai on 12/28/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

- (void)textChanged:(NSNotification *)notification;

@end
