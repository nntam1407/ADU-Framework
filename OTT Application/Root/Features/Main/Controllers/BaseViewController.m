/*============================================================================
 PROJECT: SupportLocker
 FILE:    BaseViewController.m
 AUTHOR:  Nguyen Minh Khoai
 DATE:    1/30/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "BaseViewController.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/

#define kNavigationBarTitleColor        UIColorFromRGB(0x333333)
#define kNavigationBarTitleFont         FontBoldArialWithSize(IS_IPAD ? 40 : 14)
#define kNavigationBarLeftButtonImage   @"icon_back"
#define kNavigationBarEmptyButtonImage  @"btn_nav"
#define kBaseBackgroundImage            @"bg_app"

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface BaseViewController () <UIGestureRecognizerDelegate>
@property(strong, nonatomic) JSBadgeView *badgeView;
@property(nonatomic, strong) ProgressView *progressView;
@property(nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation BaseViewController

#pragma mark - Accessors

- (UIView *)bannerView {
//    if(appDelegate.dataCenter.onlineUser.subcriptionStatus == SubcriptionStatatusTrial) {
//        _bannerView = appDelegate.bannerView;
//        return _bannerView;
//    } else {
//        return nil;
//    }
    return nil;
}

- (CGSize)originalViewSize {
    CGFloat screenHeight = kScreenFrame.size.height;
    CGFloat navigationHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat tabbarHeight = CGRectGetHeight(self.tabBarController.tabBar.frame);
    CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    
    CGFloat height = (screenHeight - (navigationHeight + tabbarHeight + statusBarHeight));
    return CGSizeMake(kScreenFrame.size.width, height);
}

#pragma mark - Customize Subviews

/*----------------------------------------------------------------------------
 Method:      setUpNavigationBar
 Description: customize iPhone/iPod Navigation Bar
 -----------------------------------------------------------------------------*/
- (void)customizeNavigationBarForiPhone {
    
    self.navigationBarButtonPadding = 5;
    self.hiddenRightButton = NO;
    
    if (!self.leftNavigationButtonImageName) {
        self.leftNavigationButtonImageName = kNavigationBarLeftButtonImage;
    }
    
    /* Create back button on navigation bar */
    if (!_hiddenBackButton) {
        NSArray *attributes = @[@{kBarButtonItemImage : NotNullString(self.leftNavigationButtonImageName),
                                  kBarButtonItemTitle : NotNullString(self.leftNavigationButtonTitle),
                                  kBarButtonItemSelector : @"didTouchedOnLeftButton:"}];
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem leftBarButtonItemsWithTarget:self attributes:attributes];
        
        
    }
    
    if (!self.hiddenRightButton) {
        NSArray *attributes = @[@{kBarButtonItemImage : NotNullString(self.rightNavigationButtonImagName),
                                  kBarButtonItemTitle : NotNullString(self.rightNavigationButtonTitle),
                                  kBarButtonItemSelector : @"handleTouchedOnRightButton:"}];
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem rightBarButtonItemsWithTarget:self attributes:attributes];
    }
}

/*----------------------------------------------------------------------------
 Method:      customizeNavigationBarForiPad
 Description: customize navigation bar for iPad
 -----------------------------------------------------------------------------*/
- (void)customizeNavigationBarForiPad {
    if (self.customNavigationBar) {
        self.navigationBarButtonPadding = 20;
        
        /* Margin for left, right button */
        self.customNavigationBar.leftButtonMargin = self.navigationBarButtonPadding;
        self.customNavigationBar.rightButtonMargin = self.navigationBarButtonPadding;
        
        if (!self.leftNavigationButtonImageName) {
            self.leftNavigationButtonImageName = kNavigationBarLeftButtonImage;
        }
        
        /* Create back button on navigation bar */
        if (!_hiddenBackButton) {
            [self.customNavigationBar createLeftButtonWithImageName:self.leftNavigationButtonImageName backgroundImageName:nil title:nil];
            
            [self.customNavigationBar.leftBarButton addTarget:self action:@selector(didTouchedOnLeftButton:) forControlEvents:UIControlEventTouchUpInside];
            
            if (self.hiddenBadgeView) {
            }
        }
        
        if (!self.hiddenRightButton) {
            [self.customNavigationBar createRightButtonWithImageName:self.rightNavigationButtonImagName
                                                 backgroundImageName:kNavigationBarEmptyButtonImage
                                                               title:self.rightNavigationButtonTitle];
            
            [self.customNavigationBar.rightBarButton addTarget:self action:@selector(handleTouchedOnRightButton:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

/*----------------------------------------------------------------------------
 Method:      customizeNavigationBar
 Description: customize navigation bar
 -----------------------------------------------------------------------------*/
- (void)customizeNavigationBar {
    if (IS_IPAD) {
        [self customizeNavigationBarForiPad];
    } else {
        [self customizeNavigationBarForiPhone];
    }
}

/*----------------------------------------------------------------------------
 Method:      customizeTitleLabel
 Description: customize title view of navigation item
 -----------------------------------------------------------------------------*/
- (void)customizeTitleLabel {
    
    @autoreleasepool {
        /* create title label */
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kNavigationBarTitleFont;
        _titleLabel.textColor = kNavigationBarTitleColor;
        _titleLabel.textAlignment = MKTextAlignmentCenter;
        _titleLabel.autoresizingMask = UIViewAutoresizingNone;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.frame = CGRectMake(0, 0, 150, 40);
        
        if (IS_IPAD) {
            self.customNavigationBar.barTitleLabel = _titleLabel;
        } else {
            self.navigationItem.titleView = _titleLabel;
        }
    }
}

/*----------------------------------------------------------------------------
 Method:      customizeBackgroundView
 Description: customize background image view
 -----------------------------------------------------------------------------*/
- (void)customizeBackgroundView {
    @autoreleasepool {
        CGRect rect = self.view.bounds;
        rect.size.height -= (44);
        rect.origin.y = 44;
        
        if (!_backgroundImageView) {
            _backgroundImageView = [[UIImageView alloc] initWithFrame:rect];
            _backgroundImageView.contentMode = UIViewContentModeBottomLeft;
            _backgroundImageView.image = [[IBHelper sharedUIHelper] loadImage:kBaseBackgroundImage];
            _backgroundImageView.frame = rect;
            [self.view insertSubview:_backgroundImageView atIndex:0];
        }
    }
}

- (void)enableOptionalSettings {
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    /* enable optional settings */
    [self enableOptionalSettings];
    
    /* call super method */
    [super viewDidLoad];
    
    /* setting navigation controller */
    [self customizeNavigationBar];
    [self customizeTitleLabel];
    
    /* setting background app */
    //    [self customizeBackgroundView];
    //    self.view.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    /* register notifications */
    [self registerNotifications];
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    [self unregisterNotifications];
    [super viewDidUnload];
}

- (void)dealloc {
    [self unregisterNotifications];
    NSLog(@"DEALLOC VIEW CONTROLLER: %@", NSStringFromClass([self class]));
}

- (void)viewDidDisappear:(BOOL)animated {
    _visible = NO;
    [super viewDidDisappear:animated];
    
    /* register keyboard event */
    if (self.enabledKeyBoardFrameChangedEvent) {
        [self.view removeKeyboardControl];
    }
    
    NSLog(@"DISAPPEAR VIEW CONTROLLER: %@", NSStringFromClass([self class]));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /* register keyboard event */
    if (self.enabledKeyBoardFrameChangedEvent) {
        __weak BaseViewController *weakSelf = self;
        [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
            [weakSelf layoutSubViewsWithKeyboardFrame:keyboardFrameInView];
        }];
    }
    
    if (!self.isFirstTimeLoadData) {
        [self performSelector:@selector(loadDataInFirstTime) withObject:nil afterDelay:0.2f];
        self.isFirstTimeLoadData = YES;
    }
    
    [self updateBadgeNumber];
    
    NSLog(@"APPEAR VIEW CONTROLLER: %@", NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLayoutSubviews {
    [self doLayout:self.interfaceOrientation];
    
    if (SupportiOS7) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
            self.edgesForExtendedLayout = UIRectEdgeNone;
        
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * -1;
        
        self.view.bounds = viewBounds;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self doLayout:toInterfaceOrientation];
}


#pragma mark - Data Handling

/*----------------------------------------------------------------------------
 Method:      loadDataInFirstTime
 Description: only load data or do something one time when the view is visible
 -----------------------------------------------------------------------------*/
- (void)loadDataInFirstTime {
    
}

#pragma mark - Badge Update

/*----------------------------------------------------------------------------
 Method:      updateBadgeNumber
 -----------------------------------------------------------------------------*/
- (void)updateBadgeNumber {
    
}

#pragma mark - Keyboard Handling

/*----------------------------------------------------------------------------
 Method:      hideKeyBoard
 Description: hide keyboard by call resignFirstResponse
 -----------------------------------------------------------------------------*/
- (void)hideKeyBoard {
    
}

#pragma mark - Layout Subviews

- (void)layoutSubViewsWithKeyboardFrame:(CGRect)keyboardFrame {
    
}

- (void)doLayout:(UIInterfaceOrientation)orientation {
    
}

- (void)relayoutSubviews {
    
}

#pragma mark - Loading Progress

/*----------------------------------------------------------------------------
 Method:      showLoadingViewWithMessage
 Description: show loading view with specific message
 -----------------------------------------------------------------------------*/
- (void)showLoadingViewWithMessage:(NSString *)message {
    if (!_progressView) {
        self.progressView = [ProgressView progressView];
    }
    
    [_progressView setTitle:message];
    [_progressView bringSubviewToFront:self.view];
    [_progressView showOnView:self.view animation:YES freeze:YES top:IS_IPAD ? self.customNavigationBar.frame.size.height : 0];
}

/*----------------------------------------------------------------------------
 Method:      showLoadingView
 Description: show progress view with empty message
 -----------------------------------------------------------------------------*/
- (void)showLoadingView {
    [self showLoadingViewWithMessage:@""];
    self.processingServerRequest = YES;
}

/*----------------------------------------------------------------------------
 Method:      hideLoadingView
 Description: hide progress view
 -----------------------------------------------------------------------------*/
- (void)hideLoadingView {
    [_progressView hide:NO];
    self.processingServerRequest = NO;
}

#pragma mark - Button Events

/*----------------------------------------------------------------------------
 Method:      didTouchOnLeftButton
 Description: handle left button on navigation touched
 -----------------------------------------------------------------------------*/
- (void)didTouchedOnLeftButton:(id)sender {
    [self unregisterNotifications];
    [self.view removeKeyboardControl];
    
    if (self.backActionHandler) {
        self.backActionHandler();
        self.backActionHandler = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*----------------------------------------------------------------------------
 Method:      didTouchOnRightButton
 Description: handle right button on navigation touched
 -----------------------------------------------------------------------------*/
- (void)didTouchedOnRightButton:(id)sender {
    if ([self.rightNavigationButtonImagName isEqualToString:@"icon_zoom"]) {
        [self showZoomView];
    }
}

- (void)handleTouchedOnRightButton:(id)sender {
    /* before touch on Right button, trick for disable touch */
    if (self.processingServerRequest) {
        /* ingnore touching */
    } else {
        [self didTouchedOnRightButton:sender];
    }
    
}

#pragma mark - Validate Data

/*----------------------------------------------------------------------------
 Method:      validateField
 Description: validate data in view
 -----------------------------------------------------------------------------*/
- (BOOL)validateField:(UIView *)field {
    return YES;
}

/*----------------------------------------------------------------------------
 Method:      doValidation
 Description: validate all mandatory fields before do something via API
 -----------------------------------------------------------------------------*/
- (BOOL)doValidation {
    return YES;
}


#pragma mark - Notifications

/*----------------------------------------------------------------------------
 Method:      registerNotifications
 Description: register all notifications
 -----------------------------------------------------------------------------*/
- (void)registerNotifications {
    
}

/*----------------------------------------------------------------------------
 Method:      unregisterNotifications
 Description: unregister all notifications
 -----------------------------------------------------------------------------*/
- (void)unregisterNotifications {
    NotifUnregAll(self);
}

#pragma mark - For zoom

/*----------------------------------------------------------------------------
 Method:      showZoomView
 Description: show zoome view
 -----------------------------------------------------------------------------*/
- (void)showZoomView {
    [self hideKeyBoard];
//    [[FamilySupportZoomView sharedFamilySupportZoomView] showZoomView];
}

@end
