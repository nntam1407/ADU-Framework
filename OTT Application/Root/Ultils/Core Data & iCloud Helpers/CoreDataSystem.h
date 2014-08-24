//
//  CoreDataSystem.h
//  CoreDate&iCloud
//
//  Created by Bao Nhan on 11/13/12.
//  Copyright (c) 2012 SportLocker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+Clone.h"

@protocol CoreDataDelegate <NSObject>
@optional
- (void)persistentStoreDidChange;
@end

@interface CoreDataSystem : NSObject {
    
}

@property (retain, nonatomic) NSMutableArray *delegates;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//Chapter 3: iCloud
@property (nonatomic) BOOL iCloudAvailable;

// Singleton Creation
+ (id)sharedModel:(id<CoreDataDelegate>)delegate;
+ (void)addDelegate:(id<CoreDataDelegate>)delegate;
+ (void)removeDelegate:(id<CoreDataDelegate>)delegate;
+ (id)allocWithZone:(NSZone *)zone;
- (id)initWithDelegate:(id<CoreDataDelegate>)newDelegate;

// Context Operations
- (void)undo;
- (void)redo;
- (void)rollback;
- (void)reset;
- (BOOL)saveContext;
- (void)insertToContext:(id)entity;
- (void)removeFromContext:(id)entity;

// select
- (NSArray *)getSortedEntityWithEntityName:(NSString *)entityName sortKey:(NSString *)sortKey sortAscending:(bool)isAscending;
- (NSArray *)getEntityWithEntityName:(NSString *)entityName;

// query
- (NSArray *)querySortedWithEntityName:(NSString *)entityName
                              queryKey:(NSString *)stringQueryKey
                            queryValue:(id)value
                               sortKey:(NSString *)stringSortKey
                         sortAscending:(bool)isAscending;

- (NSArray *)queryWithEntityName:(NSString *)entityName
                        queryKey:(NSString *)stringQueryKey
                      queryValue:(id)value;

// insert
- (id)insertEntityWithEntityName:(NSString *)entityName;

// Core Data Utilities
- (NSURL *)applicationDocumentsDirectory;

@end

