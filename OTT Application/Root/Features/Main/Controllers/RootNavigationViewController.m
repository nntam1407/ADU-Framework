/*============================================================================
 PROJECT: SportLocker
 FILE:    RootNavigationViewController.m
 AUTHOR:  Nguyen Minh Khoai
 DATE:    1/30/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <QuartzCore/QuartzCore.h>
#import "RootNavigationViewController.h"
#import "UIAlertView+BlockComfirmation.h"
#import <AudioToolbox/AudioToolbox.h>
//#import "TrackingService.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
#define kNotFirstTimeKey   @"NotFirstTimeKey"

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface RootNavigationViewController () {
    
}

@property (readwrite)   CFURLRef        soundFileURLRef;
@property (readonly)    SystemSoundID   soundFileObject;

@end

@implementation RootNavigationViewController

+ (RootNavigationViewController *)createRootNavigationController {
    @autoreleasepool {
        /* create front, left and right view controller */
        UIViewController *frontViewController = [[IBHelper sharedUIHelper] loadViewController:@"HomeViewController" inStory:@"MainStoryboard"];
        
        UIViewController *leftViewController = [[IBHelper sharedUIHelper] loadViewController:@"LeftMenuViewController" inStory:@"MainStoryboard"];
        
        
        /* create navigation controller to contain left, right and front view */
        BaseNavigationController *frontNavigationController = [[BaseNavigationController alloc] initWithRootViewController:frontViewController];
        
        /* create root reveal view controller */
        PKRevealController *rootRevealController = [PKRevealController revealControllerWithFrontViewController:frontNavigationController
                                                                                            leftViewController:leftViewController];
        RootNavigationViewController *rootNavigationController = [[RootNavigationViewController alloc] initWithRootViewController:rootRevealController];
        return rootNavigationController;
    }
}

#pragma mark - accessors
- (PKRevealController *)revealController {
    NSArray *viewControllers = self.viewControllers;
    return [viewControllers objectAtIndex:0];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)showIntroViewController:(BOOL)animated {
    
}

- (void)getAllExtraData {
    //    if(appDelegate.dataCenter.activeUser.accessToken.length > 0) {
    //
    //    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deviceToken = @"";
}

- (void)viewDidUnload {
    NotifUnregAll(self);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    NotifUnregAll(self);
    
}

#pragma mark - Application event

- (void)applicationDidFinishedLauchingWithOptions:(NSDictionary *)launchOptions {
    //    [self performSelector:@selector(showPasswordProtector) withObject:nil afterDelay:0.3];
    
    NSDictionary *remoteNotif = [launchOptions objectForKey:
                                 UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if(remoteNotif != nil) {
        self.hasReceivedRemoteNotification = YES;
    }
}

- (void)applicationDidBecomeActive {
    /* update opening status */
    //    if(appDelegate.dataCenter.activeUser.accessToken.length > 0) {
    //
    //    }
}

- (void)applicationWillResignActive {
    //    [appDelegate.dataHelper saveContext];
    
    /* update away status */
    //    if(appDelegate.dataCenter.activeUser.accessToken.length > 0) {
    //    }
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return YES;
}

- (void)applicationWillTerminate {
    //    [appDelegate.dataHelper saveContext];
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *dToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dToken = [dToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.deviceToken = dToken;
    
    //    [[TrackingService sharedTrackingService] registerPushNotification:self.deviceToken];
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    self.hasReceivedRemoteNotification = YES;
    
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

- (void)applicationDidEnterBackground {
    
}

- (void)applicationWillEnterForeground {
}

#pragma mark - Reveal actions

- (void)revealLeftMenu {
    if (self.revealController.focusedController == self.revealController.leftViewController) {
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
        [self.revealController showViewController:self.revealController.leftViewController];
    }
}

- (void)revealRightMenu {
    if (self.revealController.focusedController == self.revealController.rightViewController) {
        [self.revealController showViewController:self.revealController.frontViewController];
    } else {
        [self.revealController showViewController:self.revealController.rightViewController];
    }
}

- (void)pushChildViewController:(UIViewController *)vc animated:(BOOL)animated {
    /* push view controller from front view controller */
    UINavigationController *navigationController = (UINavigationController *)self.revealController.frontViewController;
    
    /* push view controller from left */
    BOOL animating = (self.revealController.focusedController == self.revealController.leftViewController || self.revealController.focusedController != self.revealController.rightViewController);
    
    if(![vc isKindOfClass:[navigationController.topViewController class]]) {
        [navigationController pushViewController:vc animated:(animating ? animated : NO)];
    }
    
    /* check if focus view controller is left or right view controller, dismiss it */
    if(self.revealController.focusedController == self.revealController.leftViewController
       || self.revealController.focusedController == self.revealController.rightViewController) {
        [self.revealController showViewController:self.revealController.frontViewController
                                         animated:NO
                                       completion:NULL];
    }
}

- (void)popToChildViewController:(UIViewController *)vc animated:(BOOL)animated {
    /* push view controller from front view controller */
    UINavigationController *navigationController = (UINavigationController *)self.revealController.frontViewController;
    
    /* push view controller from left */
    BOOL animating = (self.revealController.focusedController == self.revealController.leftViewController || self.revealController.focusedController != self.revealController.rightViewController);
    
    if(![vc isKindOfClass:[navigationController.topViewController class]]) {
        [navigationController popToViewController:vc animated:(animating ? animated : NO)];
    }
    
    /* check if focus view controller is left or right view controller, dismiss it */
    if(self.revealController.focusedController == self.revealController.leftViewController
       || self.revealController.focusedController == self.revealController.rightViewController) {
        [self.revealController showViewController:self.revealController.frontViewController
                                         animated:NO
                                       completion:NULL];
    }
}

- (void)showAuthenticationViewWithPopToRoot:(BOOL)status {
    [(UINavigationController *)self.revealController.frontViewController popToRootViewControllerAnimated:NO];
    [self showIntroViewController:YES];
}

- (void)handleAuthenticationSucceeded:(NSNotification *)noti {
    /* try to get all extra data */
    [self getAllExtraData];
    
    /* try to reload data at current screen */
    UINavigationController *frontNavigationController = (UINavigationController *)self.revealController.frontViewController;
    if([frontNavigationController isKindOfClass:[UINavigationController class]]) {
        /* get top view controller from navigation controller */
        //        UIViewController *topViewController = frontNavigationController.topViewController;
        //        if([topViewController respondsToSelector:@selector(handleUpdateData:)]) {
        //            [topViewController performSelector:@selector(handleUpdateData:) withObject:noti];
        //        }
    }
}

- (void)handleAuthenticationFailed:(NSNotification *)noti {
    [self showIntroViewController:YES];
}

#pragma mark - Methods

- (void)startUp {
    @autoreleasepool {
        /* check whether first time to use app */
        BOOL isNotFirstTime = UserBool4Key(kNotFirstTimeKey);
        
        /* If not first time, show sign in view controller */
        if(isNotFirstTime) {
            
        }
        else {
            /* not first time now */;
            SetBool4Key(YES, kNotFirstTimeKey);
        }
        
        //        if([appDelegate.dataCenter.activeUser.userId length] == 0
        //           || [appDelegate.dataCenter.activeUser.accessToken length] == 0) {
        //            [self showIntroViewController:NO];
        //        } else {
        //            /* Init and connect jabber service */
        //        }
        
        /* register authentication event */
        NotifReg(self, @selector(handleAuthenticationSucceeded:), kAuthenticationSucceededEventNotification);
        NotifReg(self, @selector(handleAuthenticationFailed:), kAuthenticationFailedEventNotification);
        
        /* try to get extra data */
        [self getAllExtraData];
    }
    
    //load sound file
    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource:@"new-mail"
                                                withExtension:@"caf"];
    
    // Store the URL as a CFURLRef instance
    self.soundFileURLRef = (__bridge CFURLRef) tapSound;
    
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (
                                      
                                      _soundFileURLRef,
                                      &_soundFileObject
                                      );
    
    [self showIntroViewController:YES];
}

@end
