//
//  SLAppDelegate.h
//  SportLocker
//
//  Created by Vinh Huynh on 6/26/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "Reachability.h"
#import "BaseNavigationController.h"
#import "MainViewController.h"
#import "DataCenter.h"

@interface SLAppDelegate : UIResponder <UIApplicationDelegate, CoreDataDelegate >
@property (strong, nonatomic)   UIWindow *window;
@property (strong, nonatomic)   Reachability *networkMonitor;
@property (strong, nonatomic)   DataCenter *dataCenter;
@property (nonatomic, strong)   MainViewController *mainViewController;
@property (nonatomic, strong)   PKRevealController *revealController;
@property (nonatomic, strong)   CCCoreDataHelper    *dataHelper;
@property (nonatomic, strong)   NSString *deviceToken;
@property (nonatomic, strong)   NSDictionary *remoteNotification;
@property (nonatomic, assign)   BOOL  hasNetwork;
@property (nonatomic, strong)   LinkedInSocialService *linkedInService;
@property (nonatomic, strong)   FacebookSocialService *facebookService;
@property (nonatomic, strong)   TwitterSocialService *twitterService;

@end
