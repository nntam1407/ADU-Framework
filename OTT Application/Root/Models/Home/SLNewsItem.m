/*============================================================================
 PROJECT: SportLocker
 FILE:    SLNewsItem.m
 AUTHOR:  Khoai Nguyen Minh
 DATE:    7/14/14
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "SLNewsItem.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation SLNewsItem

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    
    BOOL isOptionalProperty = [super propertyIsOptional:propertyName];
    isOptionalProperty |= ([propertyName isEqualToString:@"photoId"] ||
                           [propertyName isEqualToString:@"newsDateTime"] ||
                           [propertyName isEqualToString:@"newsSource"] ||
                           [propertyName isEqualToString:@"playerId"]
                           );
    
    return isOptionalProperty;
}

@end
