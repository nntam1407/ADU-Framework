/*============================================================================
 PROJECT: SportLocker
 FILE:    ContactUser.h
 AUTHOR:  vientc
 DATE:    9/23/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "AbstractSocialUser.h"
//#import <AddressBook/AddressBook.h>
/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   ContactUser
 =============================================================================*/

@interface ContactUser : AbstractSocialUser

@property (nonatomic, strong) NSArray *listEmails;
@property (nonatomic, strong) UIImage *avatarImage;

+ (ContactUser*)contactUserWithFirstName:(NSString*)first lastName:(NSString*)last emails:(NSArray*)arrayOfEmail avatarImage:(UIImage*)avatar;

- (BOOL)containEmails:(NSArray*)emails;

@end
