/*============================================================================
 PROJECT: SportLocker
 FILE:    FacebookUser.m
 AUTHOR:  Nguyen Minh Khoai
 DATE:    2/21/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "FacebookUser.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation FacebookUser

- (NSString *)accessToken{
    return [[FBSession activeSession] accessTokenData].accessToken;
}

+ (FacebookUser*)facebookUserFromDictionary:(NSDictionary<FBGraphUser> *)userDic{
    FacebookUser *result = [[FacebookUser alloc] init];
    result.name = userDic.name;
    result.firstName = userDic.first_name;
    result.middleName = userDic.middle_name;
    result.lastName = userDic.last_name;
    result.link = userDic.link;
    result.username = [userDic objectForKey:@"email"];
    result.userId = userDic.objectID;
    result.birthday = userDic.birthday;
    result.profileImageURL = [[[userDic objectForKey:@"picture"] objectForKey:@"data"] valueForKey:@"url"];
    return result;
}

@end
