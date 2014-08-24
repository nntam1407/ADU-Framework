//
//  SLNavigationBarView.m
//  SportLocker
//
//  Created by Vinh Huynh on 6/27/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLNavigationBarView.h"

@implementation SLNavigationBarView

- (id)initWithFrame:(CGRect)frame {
    self = [[IBHelper sharedUIHelper] loadViewNib:[[self class] description]];
    if (self) {
        
        // Initialization code
        UIImage *searchBgr = [UIImage imageNamed:@"bgr_search_bar"];
        UIImage *img =  [searchBgr resizableImageWithCapInsets:UIEdgeInsetsMake(14, 12, 14 , 12)];
        
        [searchBar setTintColor:[UIColor lightGrayColor]];
        searchBar.placeholder = @"";
        
        [searchBar setTranslucent:YES];
        [searchBar setBackgroundImage:[UIImage new]];
        [searchBar setDelegate:self];
        
        // Set background UISearchBar
        [[UISearchBar appearance] setSearchFieldBackgroundImage:img forState:UIControlStateNormal];
        
        // Set textcolor UISearchBar
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor lightTextColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
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

#pragma mark UISeachBar Delegate


- (BOOL)searchBar:(UISearchBar *)search shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString* keyWork = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    //Search Autocomplete
    if (_autoCompleteHandler) {
        _autoCompleteHandler(keyWork);
    }
    
    if(_compareConditionHandler) {
         /* Seach Commpare */
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.searchDataSource.count];
        [self.searchDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *attributeValue = _compareConditionHandler(obj);
            if([[keyWork lowercaseString] isEqualToString:[attributeValue lowercaseString]]) {
                [result addObject:obj];
            }
        }];
        
        if(_completeHandler) {
            _completeHandler(result);
        }
    }
   
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)search {
    if (_searchHandler) {
        _searchHandler(search.text);
    }
    [self endEditing:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self endEditing:YES];
    if (_completeHandler) {
        _completeHandler(nil);
    }
}

#pragma mark - Addintion Methods

- (void)registerSearchOnExistingRecords:(NSMutableArray *)records
                       conditionHandler:(NSString *(^)(id compareObj))conditionHandler {
    self.searchDataSource = records;
    self.compareConditionHandler = conditionHandler;
}

- (void)keyboardWillShow {
    NSLog(@"===>keyboardWillShow");
    hideKeyboardButotn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, self.bounds.size.width, self.window.frame.size.height - self.bounds.size.height - 40 - kKeyboardKeyboardIphone)];
    [self.window addSubview:hideKeyboardButotn];
    [hideKeyboardButotn addTarget:self action:@selector(hideButon) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)hideButon {
    [self endEditing:YES];
}

- (void)keyboardWillHide {
    NSLog(@"===>keyboardWillHide");
    [hideKeyboardButotn removeFromSuperview];
    
}

@end
