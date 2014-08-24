//
//  CoreDataSystem.m
//  CoreDate&iCloud
//
//  Created by Bao Nhan on 11/13/12.
//  Copyright (c) 2012 SportLocker. All rights reserved.
//

#import "CoreDataSystem.h"
#import "iCloudSystem.h"

#define iCloudSyncIfAvailable YES
#define ManagedObjectModelFileName @"DealHits"

static CoreDataSystem *sharedModel = nil;

@implementation CoreDataSystem

@synthesize delegates = _delegates;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//iCloud
@synthesize iCloudAvailable = _iCloudAvailable;

#pragma mark - Singleton Creation

+ (id)sharedModel:(id<CoreDataDelegate>)delegate {
	@synchronized(self) {
		if(sharedModel == nil)
			sharedModel = [[self alloc] initWithDelegate:delegate];
		else {
			if(delegate)
				[sharedModel.delegates addObject:delegate];
		}
	}
	return sharedModel;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if(sharedModel == nil)  {
            sharedModel = [super allocWithZone:zone];
            return sharedModel;
        }
    }
    return nil;
}

+ (void)addDelegate:(id<CoreDataDelegate>)delegate {
	[sharedModel.delegates addObject:delegate];
}

+ (void)removeDelegate:(id<CoreDataDelegate>)delegate {
	[sharedModel.delegates removeObjectIdenticalTo:delegate];
}

- (id)initWithDelegate:(id<CoreDataDelegate>)newDelegate {
    self = [super init];
	if(self) {
        
        @autoreleasepool {
            _delegates = [[NSMutableArray alloc] init];
            if(newDelegate)
                [_delegates addObject:newDelegate];
            
            //Test for iCloud availability
            if(iCloudSyncIfAvailable) {
                self.iCloudAvailable = [iCloudSystem checkiCLoudAvaiable];
            }
            
            _managedObjectContext = [self managedObjectContext];
        }
	}
	return self;
}

#pragma mark - Get Entity

- (NSArray *)getSortedEntityWithEntityName:(NSString *)entityName
                                   sortKey:(NSString *)sortKey
                             sortAscending:(bool)isAscending {
    
    @autoreleasepool {
        // Create a new fetch request
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // Set the entity of the fetch request to be our Issues object
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                                  inManagedObjectContext:_managedObjectContext];
        [request setEntity:entity];
        
        // Set up the request sorting
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:sortKey
                                            ascending:isAscending];
        
        [request setSortDescriptors:@[sortDescriptor]];
        
        // Fetch the results
        // Since there is no predicate defined for this request,
        // The results will be all issues in the managed object context
        NSError *error = nil;
        NSArray *fetchResults = [_managedObjectContext executeFetchRequest:request
                                                                     error:&error];
        return fetchResults;
    }
}

- (NSArray *)getEntityWithEntityName:(NSString *)entityName {
    @autoreleasepool {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                                  inManagedObjectContext:_managedObjectContext];
        [request setEntity:entity];
        
        NSError *error = nil;
        NSArray *fetchResults = [_managedObjectContext executeFetchRequest:request
                                                                     error:&error];
        return fetchResults;
    }
}

#pragma mark - Query Entity

- (NSArray *)querySortedWithEntityName:(NSString *)entityName
                              queryKey:(NSString *)stringQueryKey
                            queryValue:(id)value
                               sortKey:(NSString *)stringSortKey
                         sortAscending:(bool)isAscending {
    
    @autoreleasepool {
        // Create a new Fetch Request
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // Set the entity of our request to a Reminder in our
        // our managed object context
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                                  inManagedObjectContext:_managedObjectContext];
        [request setEntity:entity];
        
        // Set up a predicate limiting the results of the request
        // We only want the issue with the name provided
        NSPredicate *query = [NSPredicate predicateWithFormat:@"%K == %@", stringQueryKey, value];
        [request setPredicate:query];
        
        // Set up the request sorting
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:stringSortKey
                                            ascending:isAscending];
        
        [request setSortDescriptors:@[sortDescriptor]];
        
        // Fetch the results
        NSError *error = nil;
        NSArray *fetchResults = [_managedObjectContext executeFetchRequest:request
                                                                     error:&error];
        return fetchResults;
    }
}

- (NSArray *)queryWithEntityName:(NSString *)entityName
                        queryKey:(NSString *)stringQueryKey
                      queryValue:(id)value {
    @autoreleasepool {
        // Create a new Fetch Request
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // Set the entity of our request to a Reminder in our
        // our managed object context
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                                  inManagedObjectContext:_managedObjectContext];
        [request setEntity:entity];
        
        // Set up a predicate limiting the results of the request
        // We only want the issue with the name provided
        NSPredicate *query = [NSPredicate predicateWithFormat:@"%@ == %@", stringQueryKey, value];
        [request setPredicate:query];
        
        // Fetch the results
        NSError *error = nil;
        NSArray *fetchResults = [_managedObjectContext executeFetchRequest:request
                                                                     error:&error];
        return fetchResults;
    }
}

#pragma mark - Insert Entity

- (id)insertEntityWithEntityName:(NSString *)entityName {
    
    id newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                 inManagedObjectContext:_managedObjectContext];
    return newObject;
}

#pragma mark - Managed Object Context

- (BOOL)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return NO;
        }
    } else {
        NSLog(@"Managed Object Context is nil");
        return NO;
    }
    NSLog(@"Context Saved, iCloud should sync if enabled");
    
    return YES;
}

- (void)insertToContext:(id)entity {
    [_managedObjectContext insertObject:entity];
}

- (void)removeFromContext:(id)entity {
    [_managedObjectContext deleteObject:entity];
}
#pragma mark - Undo/Redo Operations


- (void)undo {
    [_managedObjectContext undo];
    
}

- (void)redo {
    [_managedObjectContext redo];
}

- (void)rollback {
    [_managedObjectContext rollback];
}

- (void)reset {
    [_managedObjectContext reset];
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    @autoreleasepool {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            
            NSManagedObjectContext *moc = [[NSManagedObjectContext alloc]
                                           initWithConcurrencyType:NSMainQueueConcurrencyType];
            
            [moc performBlockAndWait:^(void) {
                // Set up an undo manager, not included by default
                NSUndoManager *undoManager = [[NSUndoManager alloc] init];
                [undoManager setGroupsByEvent:NO];
                [moc setUndoManager:undoManager];
                
                // Set persistent store
                [moc setPersistentStoreCoordinator:coordinator];
                
                // iCloud
                if(iCloudSyncIfAvailable) {
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(persistentStoreDidChange:)
                                                                 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                               object:coordinator];
                }
            }];
            
            _managedObjectContext = moc;
        }
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:ManagedObjectModelFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    @autoreleasepool {
        // Set up persistent Store Coordinator
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        // Set up SQLite db and options dictionary
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", ManagedObjectModelFileName]];
        NSDictionary *options = nil;
        
        // If we want to use iCloud, set up
        if(iCloudSyncIfAvailable && _iCloudAvailable) {
            options = [iCloudSystem setUp];
        } else if(!_iCloudAvailable) {
            NSLog(@"Attempted to set up iCloud Core Data Stack, but iCloud is unvailable");
        }
        
        // Add the persistent store to the persistent store coordinator
        NSError *error = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeURL
                                                             options:options
                                                               error:&error]) {
            // Handle the error
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - iCloud Functionality

- (void)persistentStoreDidChange:(NSNotification*)notification {
    [_managedObjectContext performBlockAndWait:^(void) {
        [_managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        
        for(id<CoreDataDelegate>delegate in _delegates) {
            if([delegate respondsToSelector:@selector(persistentStoreDidChange)])
                [delegate performSelector:@selector(persistentStoreDidChange)];
        }
    }];
}

@end

