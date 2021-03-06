/*============================================================================
 PROJECT: SportLocker
 FILE:    SLObject.h
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/14/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "JSONModel.h"

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   SLObject
 =============================================================================*/

@interface SLObject : JSONModel
@property(nonatomic, strong) NSString *kind;
@end
