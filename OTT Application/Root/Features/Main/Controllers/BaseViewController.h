/*============================================================================
 PROJECT: SupportLocker
 FILE:    BaseViewController.h
 AUTHOR:  Nguyen Minh Khoai
 DATE:    1/30/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>
#import "UIBarButtonItem+Customizes.h"
#import "ProgressView.h"
#import "JSBadgeView.h"
#import "CustomNavigationBar.h"
#import "DAKeyboardControl.h"

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/
typedef void(^BaseEmptyBlock)();

/*============================================================================
 Interface:   BaseViewController
 =============================================================================*/


@interface BaseViewController : UIViewController <ProgressViewDelegate>

@property(nonatomic, strong) UILabel *titleLabel;

@property(nonatomic, strong) NSString *leftNavigationButtonImageName;
@property(nonatomic, strong) NSString *rightNavigationButtonImagName;
@property(nonatomic, strong) NSString *leftNavigationButtonTitle;
@property(nonatomic, strong) NSString *rightNavigationButtonTitle;

@property(nonatomic, assign) BOOL hiddenBackButton;
@property(nonatomic, assign) BOOL hiddenRightButton;
@property(nonatomic, assign) BOOL hiddenBadgeView;
@property(assign, nonatomic) BOOL enabledKeyBoardFrameChangedEvent;
@property(assign, nonatomic) BOOL processingServerRequest;
@property(assign, nonatomic) BOOL isFirstTimeLoadData;
@property(nonatomic, getter = isVisible) BOOL visible;
@property(nonatomic, assign) CGFloat navigationBarButtonPadding;

/* Ads banner */
@property(nonatomic, assign) BOOL shouldShowAds;
@property(nonatomic, strong) UIView *bannerView;

/******************************************************************************
 For iPad customization
 ******************************************************************************/
@property(weak, nonatomic) IBOutlet CustomNavigationBar *customNavigationBar;

/******************************************************************************
 Block Handlers
 ******************************************************************************/
@property(copy, nonatomic) BaseEmptyBlock backActionHandler;

- (CGSize)originalViewSize;

#pragma mark - Customize Methods

- (void)enableOptionalSettings;

- (void)customizeNavigationBar;

- (void)customizeNavigationBarForiPhone;

- (void)customizeNavigationBarForiPad;

- (void)customizeTitleLabel;

#pragma mark - Data Handling

- (void)loadDataInFirstTime;

#pragma mark - Badge Update

- (void)updateBadgeNumber;


#pragma mark - Keyboard Handling

- (void)hideKeyBoard;

#pragma mark - Layout Subviews

- (void)doLayout:(UIInterfaceOrientation)orientation;

- (void)layoutSubViewsWithKeyboardFrame:(CGRect)keyboardFrame;

- (void)relayoutSubviews;

#pragma mark - Loading Progress

- (void)showLoadingViewWithMessage:(NSString *)message;

- (void)showLoadingView;

- (void)hideLoadingView;


#pragma mark - Button Events

- (void)didTouchedOnLeftButton:(id)sender;

- (void)didTouchedOnRightButton:(id)sender;


#pragma mark - Validate Data

- (BOOL)validateField:(UIView *)field;

- (BOOL)doValidation;

#pragma mark - Notifications

- (void)registerNotifications;

- (void)unregisterNotifications;


#pragma mark - For zoom

- (void)showZoomView;

@end
