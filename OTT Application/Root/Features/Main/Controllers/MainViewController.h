/*============================================================================
 PROJECT: SportLocker
 FILE:    MainViewController.h
 AUTHOR:  Ho Huu Tai
 DATE:    7/8/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>
#import "PKRevealController.h"

/*============================================================================
 MACRO
 =============================================================================*/
#define KAuthenticatedNotification  @"KAuthenticatedNotification"

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   MainViewController
 =============================================================================*/


@interface MainViewController : PKRevealController
@property (assign, nonatomic) BOOL enablePinToZoomAtPoint;

+ (MainViewController *)shared;
- (void)startUp:(BOOL)animate;

#pragma mark - Application event
- (void)applicationDidFinishedLauching;
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

@end
