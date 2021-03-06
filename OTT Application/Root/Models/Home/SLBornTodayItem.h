/*============================================================================
 PROJECT: SportLocker
 FILE:    SLBornTodayItem.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/14/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "SLShortProfileItem.h"

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   SLBornTodayItem
 =============================================================================*/


@interface SLBornTodayItem : SLShortProfileItem
@property(nonatomic, strong) NSString *dob;
@property(nonatomic, strong) NSString *currentTeamId;
@property(nonatomic, strong) NSNumber *age;

@end
