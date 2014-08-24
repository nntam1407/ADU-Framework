/*============================================================================
 PROJECT: SportLocker
 FILE:    AbstractSocialUser.m
 AUTHOR:  Nguyen Minh Khoai
 DATE:    2/21/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "AbstractSocialUser.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
#define kName                       @"Name"
#define kFirstName                  @"FirstName"
#define kLastName                   @"LastName"
#define kMiddleName                 @"MiddleName"
#define kLink                       @"Link"
#define kProfileImageURL            @"ProfileImageURL"
#define kSocialUserName             @"kSocialUserName"
#define kBirthDay                   @"BirthDay"
#define kUserID                     @"UserID"
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation AbstractSocialUser
@synthesize userId
, name
, firstName
, middleName
, lastName
, link
, username
, birthday
, profileImageURL;

- (void)save {
    
}

- (void)load {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:kName];
        self.firstName = [aDecoder decodeObjectForKey:kFirstName];
        self.lastName = [aDecoder decodeObjectForKey:kLastName];
        self.link = [aDecoder decodeObjectForKey:kLink];
        self.userId = [aDecoder decodeObjectForKey:kUserID];
        self.middleName = [aDecoder decodeObjectForKey:kMiddleName];
        self.username = [aDecoder decodeObjectForKey:kSocialUserName];
        self.birthday = [aDecoder decodeObjectForKey:kBirthDay];
        self.profileImageURL = [aDecoder decodeObjectForKey:kProfileImageURL];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:kName];
    [aCoder encodeObject:self.firstName forKey:kFirstName];
    [aCoder encodeObject:self.lastName forKey:kLastName];
    [aCoder encodeObject:self.link forKey:kLink];
    [aCoder encodeObject:self.userId forKey:kUserID];
    [aCoder encodeObject:self.middleName forKey:kMiddleName];
    [aCoder encodeObject:self.username forKey:kSocialUserName];
    [aCoder encodeObject:self.birthday forKey:kBirthDay];
    [aCoder encodeObject:self.profileImageURL forKey:kProfileImageURL];
}

@end
