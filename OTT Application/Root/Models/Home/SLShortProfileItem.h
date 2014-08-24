/*============================================================================
 PROJECT: SportLocker
 FILE:    SLShortProfileItem.h
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
 Interface:   SLShortProfileItem
 =============================================================================*/


@interface SLShortProfileItem : SLObject
@property(nonatomic, strong) NSString *caption;
@property(nonatomic, strong) NSString *entityId;
@property(nonatomic, strong) NSString *entityTypeId;
@property(nonatomic, strong) NSString *leagueId;
@property(nonatomic, strong) NSString *photoId;
@property(nonatomic, strong) NSString *subtitle;
@property(nonatomic, strong) NSString *currentTeamId;

@end
