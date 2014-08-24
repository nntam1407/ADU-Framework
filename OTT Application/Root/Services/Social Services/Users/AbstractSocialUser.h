/*============================================================================
 PROJECT: SportLocker
 FILE:    AbstractSocialUser.h
 AUTHOR:  Nguyen Minh Khoai
 DATE:    2/21/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <Foundation/Foundation.h>

/*============================================================================

 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   AbstractSocialUser
 =============================================================================*/


@interface AbstractSocialUser : NSObject<NSCoding> {
    NSString    *userId;
    NSString    *name;
    NSString    *firstName;
    NSString    *middleName;
    NSString    *lastName;
    NSString    *link;
    NSString    *username;
    NSString    *birthday;
    NSString    *profileImageURL;
}

@property (nonatomic, strong)   NSString    *userId;
@property (nonatomic, strong)   NSString    *name;
@property (nonatomic, strong)   NSString    *firstName;
@property (nonatomic, strong)   NSString    *middleName;
@property (nonatomic, strong)   NSString    *lastName;
@property (nonatomic, strong)   NSString    *link;
@property (nonatomic, strong)   NSString    *username;
@property (nonatomic, strong)   NSString    *birthday;
@property (nonatomic, strong)   NSString    *profileImageURL;
@property (nonatomic, strong)   NSString    *accessToken;
@property (nonatomic, strong)   NSString    *gender;
- (void)save;
- (void)load;

@end
