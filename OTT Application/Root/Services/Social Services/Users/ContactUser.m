/*============================================================================
 PROJECT: SportLocker
 FILE:    ContactUser.m
 AUTHOR:  vientc
 DATE:    9/23/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "ContactUser.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation ContactUser

+ (ContactUser*)contactUserWithFirstName:(NSString*)first lastName:(NSString*)last emails:(NSArray*)arrayOfEmail avatarImage:(UIImage*)avatar{
    ContactUser *user = [ContactUser new];
    user.firstName = first;
    user.lastName = last;
    user.name = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    user.listEmails = arrayOfEmail;
    user.avatarImage = avatar;
    if (!user.avatarImage){
        user.avatarImage = [UIImage imageNamed:@"default_male.png"];
    }
    NSLog(@"%@", avatar);
    return user;
}

- (BOOL)containEmails:(NSArray*)emails{
    for (NSString *email in emails) {
        for (NSString *userEmail in self.listEmails) {
            NSLog(@"email: %@", email);
            NSLog(@"user email: %@", userEmail);
            if ([email isEqualToString:userEmail]) {
                return YES;
            }
        }
    }
    return NO;
}

@end
