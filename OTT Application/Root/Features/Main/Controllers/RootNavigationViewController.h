/*============================================================================
 PROJECT: SportLocker
 FILE:    RootNavigationViewController.h
 AUTHOR:  Nguyen Minh Khoai
 DATE:    1/30/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "PKRevealController.h"

/*============================================================================
 MACRO
 =============================================================================*/


/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   RootNavigationViewController
 =============================================================================*/


@interface RootNavigationViewController : BaseNavigationController<UINavigationControllerDelegate, UIAlertViewDelegate> {
}

@property (nonatomic, strong) NSString  *deviceToken;
@property (nonatomic, assign) BOOL hasReceivedRemoteNotification;

+ (RootNavigationViewController *)createRootNavigationController;

/* reveal actions */
- (void)revealLeftMenu;
- (void)revealRightMenu;
- (void)pushChildViewController:(UIViewController *)vc animated:(BOOL)animated;
- (void)popToChildViewController:(UIViewController *)vc animated:(BOOL)animated;
- (void)showAuthenticationViewWithPopToRoot:(BOOL)status;

/* application events */
- (void)applicationDidFinishedLauchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationDidBecomeActive;
- (void)applicationWillResignActive;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)applicationWillTerminate;
- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;

/* Methods */
- (void)startUp;

@end
