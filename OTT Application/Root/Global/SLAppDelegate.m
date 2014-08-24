//
//  SLAppDelegate.m
//  SportLocker
//
//  Created by Vinh Huynh on 6/26/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLAppDelegate.h"
//#import <Crashlytics/Crashlytics.h>

@implementation SLAppDelegate

- (void)dealloc {
    NotifUnregAll(self);
    [_networkMonitor stopNotifier];
}


- (CCCoreDataHelper *)dataHelper {
    if (!_dataHelper) {
        _dataHelper  = [CCCoreDataHelper sharedModel:self];
    }
    return _dataHelper;
}

- (DataCenter *)dataCenter {
    if(!_dataCenter) {
        _dataCenter = [[DataCenter alloc] init];
    }
    return _dataCenter;
}

- (UIViewController *)mainViewController {
    if (!_mainViewController) {
        _mainViewController = [[IBHelper sharedUIHelper] loadViewController:@"MainViewController" inStory:@"MainStoryboard"];
    }
    return _mainViewController;
}

#pragma mark - Support Methods

- (BOOL)hasNetwork {
    NetworkStatus status = _networkMonitor.currentReachabilityStatus;
    self.hasNetwork = (status != NotReachable);
    return _hasNetwork;
}

- (void)handleChangeNetworkStatus:(NSNotification *)notification {
    NetworkStatus status = _networkMonitor.currentReachabilityStatus;
    BOOL reachable = (status != NotReachable);
    if(reachable) {
        
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /* Register CoreData */
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[AppHelper appName]];
    
    /* initialize and listen changing network status signal */
    self.networkMonitor = [Reachability reachabilityForInternetConnection];
    
    /* initialize and listen changing network status signal */
    NotifReg(self, @selector(handleChangeNetworkStatus:), kReachabilityChangedNotification);
    [self.networkMonitor startNotifier];
    
    /* open by tapping Push Notification */
    self.remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];

   // [Crashlytics startWithAPIKey:@"bda5d1c8fe79026d7e5b81e050ff3470127fea52"];
    
    /* create root navigation controller */
    self.window.rootViewController = [MainViewController shared];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    /* reset badge number */
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [(MainViewController *)self.mainViewController applicationWillResignActive];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [(MainViewController *)self.mainViewController applicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [(MainViewController *)self.mainViewController applicationWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [(MainViewController *)self.mainViewController applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [(MainViewController *)self.mainViewController applicationWillTerminate];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    self.deviceToken = deviceTokenString;
    DLog(@"deviceToken: %@", deviceTokenString);
    
    /* if user logged in, update device token */
    [(MainViewController *)self.mainViewController didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    self.remoteNotification = userInfo;
    [(MainViewController *)self.mainViewController didReceiveRemoteNotification:userInfo];
}

//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    return [fbService handleOpenURL:url];
//}


@end
