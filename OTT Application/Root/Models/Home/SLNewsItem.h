/*============================================================================
 PROJECT: SportLocker
 FILE:    SLNewsItem.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/14/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "SLObject.h"

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   SLNewsItem
 =============================================================================*/


@interface SLNewsItem : SLObject
@property(nonatomic, strong) NSString *leagueId;
@property(nonatomic, strong) NSString *caption;
@property(nonatomic, strong) NSString *photoId;
@property(nonatomic, strong) NSString *entityTypeId;
@property(nonatomic, strong) NSString *subtitle;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *newsSource;

@end
