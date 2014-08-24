/*============================================================================
 PROJECT: SportLocker
 FILE:    MainViewController.m
 AUTHOR:  Ho Huu Tai
 DATE:    7/8/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "PKRevealController.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
#define kRootViewControllerName               @"name"
#define kRootViewControllerStoryName          @"story"
#define kRootViewControllertitle              @"title"
#define kRootViewControllerSelectedImage      @"selectedImage"
#define kRootViewControllerUnSelectedImage    @"unSelectedImage"
#define kRootViewControllerTag                @"tag"

typedef NS_ENUM(NSInteger, TabbarItemViewControllerTag) {
    kTabbarItemViewControllerTagMessage = 0,
    kTabbarItemViewControllerTagContact,
    kTabbarItemViewControllerTagPlsAssist,
    kTabbarItemViewControllerTagOutAbout,
    kTabbarItemViewControllerTagSettings
};
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface MainViewController ()

@end

@implementation MainViewController

+ (MainViewController *)shared {
    static MainViewController *_Share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIViewController *frontViewController = [[IBHelper sharedUIHelper] loadViewController:@"SLHomeViewController" inStory:@"MainStoryboard"];
        
        UIViewController *leftViewController = [[IBHelper sharedUIHelper] loadViewController:@"SLLeftViewController" inStory:@"MainStoryboard"];
        UINavigationController *homeNav     = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        UINavigationController *leftNav = [[UINavigationController alloc] initWithRootViewController:leftViewController];
//        [leftNav setNavigationBarHidden:YES animated:YES];
        _Share = [MainViewController revealControllerWithFrontViewController:homeNav leftViewController:leftNav rightViewController:nil];
    });
    
    return _Share;
}
#pragma mark - Settings for each kind: UITabbarController, UINavigationController, PKRevealViewController
/* For UITabbarViewController */

//- (BaseNavigationController *)tabbarItemViewControllerForAttributes:(NSDictionary *)attributes {
//    @autoreleasepool {
//        /* create root view controller with specific name */
//        BaseViewController *rootViewController = [[IBHelper sharedUIHelper] loadViewController:attributes[kRootViewControllerName]
//                                                                                       inStory:attributes[kRootViewControllerStoryName]];
//        rootViewController.enablePinToZoomAtPoint = YES;
//        /* adjust UI for Tabbar Item */
//        UITabBarItem *tabBarItem = nil;
//        UIImage *unSelectedImage = [[IBHelper sharedUIHelper] loadImage:attributes[kRootViewControllerUnSelectedImage]];
//        UIImage *selectedImage = [[IBHelper sharedUIHelper] loadImage:attributes[kRootViewControllerSelectedImage]];
//        
//        if(SupportiOS7) {
//            tabBarItem = [[UITabBarItem alloc] initWithTitle:attributes[kRootViewControllertitle]
//                                                       image:unSelectedImage
//                                               selectedImage:selectedImage];
//        } else {
//            tabBarItem = [[UITabBarItem alloc] initWithTitle:attributes[kRootViewControllertitle]
//                                                       image:nil
//                                                         tag:Num2Int(attributes[kRootViewControllerTag])];
//            [tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unSelectedImage];
//        }
//        rootViewController.tabBarItem = tabBarItem;
//        
//        /* create navigation bar controller */
//        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:rootViewController];
//        return nav;
//    }
//}

- (void)adjustUIForRevealController {
    /* background image for tabbar view */
//    [self.tabBar setBackgroundImage:[[IBHelper sharedUIHelper] loadImage:@""]];
//
//    /* adjust icon & text for tabbar items */
//    /* For Message Tab */
//    NSDictionary *attributes = nil;
//    attributes = @{kRootViewControllerName:@"MessageViewController",
//                   kRootViewControllerStoryName:@"MessageStory",
//                   kRootViewControllertitle:NSLocalizedString(@"Message", @"TabbarItemTitle"),
//                   kRootViewControllerTag:Num4Int(kTabbarItemViewControllerTagMessage),
//                   kRootViewControllerSelectedImage:@"messages_hover",
//                   kRootViewControllerUnSelectedImage:@"messages"};
//    BaseNavigationController *messageNav = [self tabbarItemViewControllerForAttributes:attributes];
//    
//    /* For Contact Tab */
//    attributes = @{kRootViewControllerName:@"ContactViewController",
//                   kRootViewControllerStoryName:@"ContactStory",
//                   kRootViewControllertitle:NSLocalizedString(@"Contact", @"TabbarItemTitle"),
//                   kRootViewControllerTag:Num4Int(kTabbarItemViewControllerTagMessage),
//                   kRootViewControllerSelectedImage:@"contact_hover",
//                   kRootViewControllerUnSelectedImage:@"contact"};
//    BaseNavigationController *contactNav = [self tabbarItemViewControllerForAttributes:attributes];
//    
//    /* For Pls Assist Tab */
//    attributes = @{kRootViewControllerName:@"PlsAssistViewController",
//                   kRootViewControllerStoryName:@"PlsAssistStory",
//                   kRootViewControllertitle:NSLocalizedString(@"Pls Assist", @"TabbarItemTitle"),
//                   kRootViewControllerTag:Num4Int(kTabbarItemViewControllerTagMessage),
//                   kRootViewControllerSelectedImage:@"PLSassist_hover",
//                   kRootViewControllerUnSelectedImage:@"PLSassist"};
//    BaseNavigationController *plsAssistNav = [self tabbarItemViewControllerForAttributes:attributes];
//    
//    /* For Out & About Tab */
//    attributes = @{kRootViewControllerName:@"OutAboutViewController",
//                   kRootViewControllerStoryName:@"OutAboutStory",
//                   kRootViewControllertitle:NSLocalizedString(@"Out & About", @"TabbarItemTitle"),
//                   kRootViewControllerTag:Num4Int(kTabbarItemViewControllerTagMessage),
//                   kRootViewControllerSelectedImage:@"out_about_hover",
//                   kRootViewControllerUnSelectedImage:@"out_about"};
//    BaseNavigationController *outAboutNav = [self tabbarItemViewControllerForAttributes:attributes];
//    
//    /* For Settings Tab */
//    attributes = @{kRootViewControllerName:@"SettingsViewController",
//                   kRootViewControllerStoryName:@"SettingsStory",
//                   kRootViewControllertitle:NSLocalizedString(@"Settings", @"TabbarItemTitle"),
//                   kRootViewControllerTag:Num4Int(kTabbarItemViewControllerTagMessage),
//                   kRootViewControllerSelectedImage:@"settings_hover",
//                   kRootViewControllerUnSelectedImage:@"settings"};
//    BaseNavigationController *settingsNav = [self tabbarItemViewControllerForAttributes:attributes];
//    
//    /* update all controllers for tabbarController */
//    self.viewControllers = @[messageNav, contactNav, plsAssistNav, outAboutNav, settingsNav];
}

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View Lifecyle

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    
    
    /* create navigation controller to contain left, right and front view */
//    BaseNavigationController *frontNavigationController = [[BaseNavigationController alloc] initWithRootViewController:frontViewController];
    
    /* create root reveal view controller */
    /* adjust UI for UITabbarController */
//    if([self isKindOfClass:[UITabBarController class]]) {
//        [self adjustUIForTabbarController];
//    }
    
    /* register authentication notification */
    NotifReg(self, @selector(handleAuthenticatedNotification:), KAuthenticatedNotification);
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark - Main methods

- (void)startUp:(BOOL)animate {
    
}

- (void)handleAuthenticatedNotification:(NSNotification *)notification {
    [self startUp:YES];
}

#pragma mark - Application event

- (void)applicationDidFinishedLauching {
    
}

- (void)applicationDidBecomeActive {
    
}

- (void)applicationWillResignActive {
    
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return YES;
}

- (void)applicationWillTerminate {
    
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

- (void)applicationDidEnterBackground {
    
}

- (void)applicationWillEnterForeground {
    
}

@end
