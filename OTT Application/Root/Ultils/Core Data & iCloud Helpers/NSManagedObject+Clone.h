/*============================================================================
 PROJECT: SportLocker
 FILE:    NSManagedObject+Clone.h
 AUTHOR:  Khoai Nguyen
 DATE:    6/7/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <CoreData/CoreData.h>

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 Interface:   NSManagedObject_Clone
 =============================================================================*/

@interface NSManagedObject (Clone)
- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context withCopiedCache:(NSMutableDictionary *)alreadyCopied exludeEntities:(NSArray *)namesOfEntitiesToExclude;
- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context exludeEntities:(NSArray *)namesOfEntitiesToExclude;
@end
