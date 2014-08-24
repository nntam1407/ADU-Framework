/*============================================================================
 PROJECT: SportLocker
 FILE:    TwitterUser.m
 AUTHOR:  vientc
 DATE:    5/2/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "TwitterUser.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation TwitterUser

+(TwitterUser*)twitterUserFromDictionary:(NSDictionary*)userDic{
    TwitterUser *result = [[TwitterUser alloc] init];
    result.name = [userDic valueForKey:@"name"];
    result.profileImageURL = [userDic valueForKey:@"profile_image_url"];
    result.username = [userDic valueForKey:@"screen_name"];
    result.link = [NSString stringWithFormat:@"https://twitter.com/%@", result.username];
    return result;
}

@end
