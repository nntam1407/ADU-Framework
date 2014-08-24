/*============================================================================
 PROJECT: SportLocker
 FILE:    LinkedInUser.m
 AUTHOR:  vientc
 DATE:    9/20/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "LinkedInUser.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation LinkedInUser

+(LinkedInUser*)linkedInUserFromDictionary:(NSDictionary*)userDic{
    LinkedInUser *user = [LinkedInUser new];
    user.firstName = [userDic valueForKey:@"firstName"];
    user.lastName = [userDic valueForKey:@"lastName"];
    user.name = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    user.profileImageURL = [userDic valueForKey:@"pictureUrl"];
//    user.link = [[userDic valueForKey:@"siteStandardProfileRequest"] valueForKey:@"url"];
    user.username = [userDic objectForKey:@"email"];
    user.userId = [userDic valueForKey:@"id"];
    return user;
}

@end
