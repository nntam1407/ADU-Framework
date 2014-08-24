//
//  SLNavigationBarView.h
//  SportLocker
//
//  Created by Vinh Huynh on 6/27/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SearchCompleteHandler)(NSArray *result);
typedef void(^SearchAutoCompleteHandler)(NSString *searchKeyWord);
typedef void(^SearchHandler)(NSString *searchKeyWord);
typedef NSString *(^SearchCompareConditionHandler)(id obj);

@interface SLNavigationBarView : UIView <UISearchBarDelegate> {
    __weak IBOutlet UISearchBar *searchBar;
    UIButton *hideKeyboardButotn;
}

@property (nonatomic, assign) NSMutableArray *searchDataSource;
@property (nonatomic, copy) SearchCompleteHandler completeHandler;
@property (nonatomic, copy) SearchAutoCompleteHandler autoCompleteHandler;
@property (nonatomic, copy) SearchHandler searchHandler;
@property (nonatomic, copy) SearchCompareConditionHandler compareConditionHandler;

/* register for Screen Search On Exiting Records */
- (void)registerSearchOnExistingRecords:(NSMutableArray *)records
                       conditionHandler:(NSString *(^)(id compareObj))conditionHandler;

@end
