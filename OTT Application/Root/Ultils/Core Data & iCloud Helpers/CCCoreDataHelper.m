//
//  CCCoreDataHelper.m
//  CoreDate&iCloud
//
//  Created by Bao Nhan on 11/13/12.
//  Copyright (c) 2012 SportLocker. All rights reserved.
//

#import "CCCoreDataHelper.h"

typedef enum {
    kCompoundPredicateTypeAnd,
    kCompoundPredicateTypeOr
} CompoundPredicateType;

#define kFieldKey @"kFieldKey"
#define kOperationKey @"kOperationKey"
#define kValueKey @"kValueKey"

NSDictionary *operationDictionary(NSString *field, NSString *operation, NSString *value) {
    return @{kFieldKey:field, kOperationKey:operation, kValueKey:value};
}

@implementation CCCoreDataHelper

#pragma mark - Support Methods

- (void)deleteObject:(NSManagedObject *)object {
    [self removeFromContext:object];
    [self saveContext];
}

- (NSFetchRequest *)createFetchRequestForEntity:(NSString *)entityName inContext:(NSManagedObjectContext *)context {
    /* create entity desciption */
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchRequest *fetchReqest = [[NSFetchRequest alloc] init];
    [fetchReqest setEntity:entity];
    return fetchReqest;
}

- (NSFetchRequest *)createFetchRequestInTable:(NSString *)table
                                   parameters:(NSArray *)parameters
                                    queryType:(CompoundPredicateType)type {
    /* get current context */
    NSManagedObjectContext *context = [self managedObjectContext];
    
    /* create fetch request */
    NSFetchRequest *fetchRequest = [self createFetchRequestForEntity:table inContext:context];
    NSMutableArray *parr = [NSMutableArray array];
    
    for (NSDictionary *dict in parameters) {
        
        /* format operation */
        NSString *formatString = @"";
        if([[dict valueForKey:kOperationKey] isEqualToString:@"="]) {
            formatString = @"%K=%@";
        } else if ([[dict valueForKey:kOperationKey] isEqualToString:@"!="]) {
            formatString = @"%K!=%@";
        }
        
        [parr addObject:[NSPredicate predicateWithFormat:formatString, [dict valueForKey:kFieldKey], [dict valueForKey:kValueKey]]];
    }
    
    /* swith to corresponding types */
    switch (type) {
        case kCompoundPredicateTypeAnd: {
            NSPredicate *andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:parr];
            [fetchRequest setPredicate:andPredicate];
        } break;
            
        default:
            break;
    }
    return fetchRequest;
}

- (NSArray *)getObjectsInTable:(NSString *)table parameters:(NSArray *)parameters {
    /* create fetch request */
    NSFetchRequest *fetchRequest = [self createFetchRequestInTable:table
                                                        parameters:parameters
                                                         queryType:kCompoundPredicateTypeAnd];
    /* get current context */
    NSManagedObjectContext *context = [self managedObjectContext];
    
    /* get object information */
    return [context executeFetchRequest:fetchRequest error:nil];
}

- (id)getObjectInTable:(NSString *)table parameters:(NSArray *)parameters {
    /* get object information */
    id result = nil;
    NSArray *objects = [self getObjectsInTable:table parameters:parameters];
    for (NSManagedObject *object in objects) {
        result = object;
        break;
    }
    return result;
}

- (NSArray *)getObjectsFromTable:(NSString *)name {
    /* get current context */
    NSManagedObjectContext *context = [self managedObjectContext];
    
    /* create fetch request */
    NSFetchRequest *fetchRequest = [self createFetchRequestForEntity:name inContext:context];
    
    NSArray *objects = [context executeFetchRequest:fetchRequest error:nil];
    return (objects.lastObject ? objects : nil);
}

- (NSInteger)countChildrenInTable:(NSString *)table parameters:(NSArray *)parameters {
    /* create fetch request */
    NSFetchRequest *fetchRequest = [self createFetchRequestInTable:table
                                                        parameters:parameters
                                                         queryType:kCompoundPredicateTypeAnd];
    /* get current context */
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSError *error = nil;
    NSInteger count = [context countForFetchRequest:fetchRequest error:&error];
    if(error) {
        count = 0;
    }
    return count;
}

- (id)specificationValueInTable:(NSString *)table
                     parameters:(NSArray *)parameters
                      operation:(NSDictionary *)operation {
    
    /* get all objects matching with request */
    NSArray *objs = [self getObjectsInTable:table parameters:parameters];
    
    if(objs.count > 0) {
        NSString *key = [operation.allKeys objectAtIndex:0];
        
        NSString *sqlString = [NSString stringWithFormat:@"@%@.%@", key, [operation valueForKey:key]];
        return [objs valueForKeyPath:sqlString];
    }
    return nil;
}

@end
