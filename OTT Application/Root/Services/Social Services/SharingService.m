//
//  ShareActionSheet.m
//  HappinessApp
//
//  Created by Nam Tran on 7/27/12.
//  Copyright (c) 2012 On Budget and Time Ltd. All rights reserved.
//

#import "SharingService.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DEFacebookComposeViewController.h"
//#import <GooglePlus/GooglePlus.h>
#import "LinkedInSocialService.h"
#import "ShareLinkedInView.h"
#import "UIView+PopUp.h"

@interface SharingService(){
    UIViewController *sharingController;
}

@property (nonatomic, assign) SharingResultBlock resultBlock;
@end

@implementation SharingService

+ (SharingService *)sharedInstance {
    static SharingService *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
        instance.rootViewController = [appDelegate window].rootViewController;
    });
    return instance;
}

- (void)shareItem:(ShareableItem*)item withType:(SharingType)type returnBlock:(void (^)(SharingService *service, NSError *error))block{
    _resultBlock = block;
    _shareItem = item;
    switch (type) {
        case SharingTypeFacebook:
            [self shareViaFacebook];
            break;
        case SharingTypeTwitter:
            [self shareViaTwitter];
            break;
        case SharingTypeLinkedIn:
            [self shareViaLinkedIn];
            //        case SharingTypeGooglePlus:
            //            [self shareViaGooglePlus];
        default:
            break;
    }
}

#pragma mark - Facebook

- (void)shareViaFacebook {
    
    __weak SharingService *shareService = self;
    if ([SLComposeViewController class]) { //Social framework available
        sharingController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [(SLComposeViewController*)sharingController setInitialText:self.shareItem.title];
        [(SLComposeViewController*)sharingController addImage:self.shareItem.image];
        [(SLComposeViewController*)sharingController addURL:self.shareItem.url];
        
        [(SLComposeViewController*)sharingController setCompletionHandler:^(SLComposeViewControllerResult result){
            switch (result) {
                case SLComposeViewControllerResultDone:
                {
                    if (shareService.resultBlock != nil) {
                        shareService.resultBlock(shareService, nil);
                        shareService.resultBlock = nil;
                    }
                }
                    break;
                case SLComposeViewControllerResultCancelled:
                    break;
                default:
                {
                    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Your message couldn't be shared" forKey:@"NSLocalizedFailureReasonErrorKey"]];
                    if (shareService.resultBlock != nil) {
                        shareService.resultBlock(shareService, error);
                        shareService.resultBlock = nil;
                    }
                }
                    break;
            }
            
            [shareService.rootViewController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
    } else {
        sharingController = [[DEFacebookComposeViewController alloc] init];
        
        [(DEFacebookComposeViewController*)sharingController setInitialText:self.shareItem.title];
        [(DEFacebookComposeViewController*)sharingController addImage:self.shareItem.image];
        [(DEFacebookComposeViewController*)sharingController addURL:[self.shareItem.url absoluteString]];
        
        [(DEFacebookComposeViewController*)sharingController setCompletionHandler:^(DEFacebookComposeViewControllerResult result) {
            switch (result) {
                case DEFacebookComposeViewControllerResultDone:
                {
                    if (shareService.resultBlock != nil) {
                        shareService.resultBlock(shareService, nil);
                        shareService.resultBlock = nil;
                    }
                }
                    break;
                case DEFacebookComposeViewControllerResultCancelled:                    break;
                default:
                {
                    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Your message couldn't be shared" forKey:@"NSLocalizedFailureReasonErrorKey"]];
                    if (shareService.resultBlock != nil) {
                        shareService.resultBlock(shareService, error);
                        shareService.resultBlock = nil;
                    }
                }
                    break;
            }
            
            [shareService.rootViewController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
    }
    [self.rootViewController presentViewController:sharingController animated:YES completion:Nil];
}


#pragma mark - Twitter
- (void)shareViaTwitter {
    NSString *shareMessage = self.shareItem.title;
    //Truncate message
    int maxStringLength = 140;
    if (self.shareItem.image || self.shareItem.url) {
        maxStringLength = 108;
    }
    
    if ([shareMessage length] > maxStringLength) {
        // define the range you're interested in
        NSRange stringRange = {0, MIN([shareMessage length], maxStringLength - 3)};
        // adjust the range to include dependent chars
        stringRange = [shareMessage rangeOfComposedCharacterSequencesForRange:stringRange];
        // Now you can create the short string
        shareMessage = [shareMessage substringWithRange:stringRange];
        shareMessage = [shareMessage stringByAppendingString:@"..."];
    }
    
    __weak SharingService *shareService = self;
    if ([SLComposeViewController class]) {
        sharingController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [(SLComposeViewController*)sharingController setInitialText:shareMessage];
        [(SLComposeViewController*)sharingController addImage:self.shareItem.image];
        [(SLComposeViewController*)sharingController addURL:self.shareItem.url];
        
        [(SLComposeViewController*)sharingController setCompletionHandler:^(SLComposeViewControllerResult result){
            switch (result) {
                case SLComposeViewControllerResultDone:
                {
                    if (shareService.resultBlock != nil) {
                        shareService.resultBlock(shareService, nil);
                        shareService.resultBlock = nil;
                    }
                }
                    break;
                case SLComposeViewControllerResultCancelled:
                    break;
                default:
                {
                    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Your message couldn't be shared" forKey:@"NSLocalizedFailureReasonErrorKey"]];
                    if (shareService.resultBlock != nil) {
                        shareService.resultBlock(shareService, error);
                        shareService.resultBlock = nil;
                    }
                }
                    break;
            }
            [shareService.rootViewController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
    }
    [self.rootViewController presentViewController:sharingController animated:YES completion:Nil];
}

#pragma mark - LinkedIn

- (void)shareViaLinkedIn {
    if ([appDelegate.linkedInService isValidSession]) {
        ShareLinkedInView *shareView = [ShareLinkedInView sharedInstance];
        shareView.shareContent.text = self.shareItem.title;
        [shareView setSharingCallBack:^(NSString *shareContent, BOOL cancel) {
            if (!cancel) {
                [appDelegate.linkedInService shareWithMessage:shareContent imageURL:self.shareItem.imageURL completeBlock:^(LinkedInSocialService *service, NSError *error) {
                    if (self.resultBlock != nil) {
                        self.resultBlock(self, error);
                        self.resultBlock = nil;
                    }
                }];
            }
        }];
        
        [shareView showModalWithOpacityOverlay:0.5];
    }else{
        [appDelegate.linkedInService authenticateWithReturnBlock:^(AbstractSocialService *service, NSError *error) {
            [self shareViaLinkedIn];
        }];
    }
}

- (void)shareViaEmail{
    if ([MFMailComposeViewController canSendMail]) {
        sharingController = [[MFMailComposeViewController alloc] init];
        [(MFMailComposeViewController*)sharingController setMailComposeDelegate:self];
        [(MFMailComposeViewController*)sharingController setSubject:self.shareItem.title];
        
        //Attact image:
        if (self.shareItem.image) {
            NSData *imageData = UIImageJPEGRepresentation(self.shareItem.image, 1);
            [(MFMailComposeViewController*)sharingController addAttachmentData:imageData mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"MyItem.jpg"]];
        }
        [(MFMailComposeViewController*)sharingController setMessageBody:self.shareItem.title isHTML:NO];
        
        [self.rootViewController presentViewController:sharingController animated:YES completion:^{
            
        }];
    }
    else
    {
        //        [Utils showAlertWithMessage:@"Can't share via email. Please go to Settings and set up your email account!"];
    }
}

#pragma mark MFMailComposeViewController Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    
    [self.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
            
        case MFMailComposeResultFailed:
            //            [Utils showAlertWithMessage:@"Your message couldn't be shared"];
            break;
        case MFMailComposeResultSaved:
            
            break;
        case MFMailComposeResultSent:
            //            [Utils showAlertWithMessage:@"Shared via Email"];
            break;
        default:
            break;
    }
}

//#pragma mark - Google Plus
//- (void)shareViaGooglePlus{
//    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
//    [shareBuilder setPrefillText:self.shareItem.title];
//    [shareBuilder setURLToShare:self.shareItem.url];
//    [shareBuilder open];
//}

@end
