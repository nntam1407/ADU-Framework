//
//  ShareActionSheet.h
//  HappinessApp
//
//  Created by Nam Tran on 7/27/12.
//  Copyright (c) 2012 On Budget and Time Ltd. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "ShareableItem.h"

typedef enum{
    SharingTypeFacebook = 0,
    SharingTypeTwitter,
    SharingTypeLinkedIn
//    ,
//    SharingTypeGooglePlus
}SharingType;

@class SharingService;
typedef void (^SharingResultBlock)(SharingService *service, NSError *error);

@interface SharingService : NSObject<MFMailComposeViewControllerDelegate>
@property (nonatomic, retain) UIViewController *rootViewController;
@property (nonatomic, strong) ShareableItem *shareItem;

+ (SharingService *)sharedInstance;
- (void)shareItem:(ShareableItem*)item withType:(SharingType)type returnBlock:(void (^)(SharingService *service, NSError *error))block;

@end

