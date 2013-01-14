//
//  NFCoreDataHelper.m
//  GushoVP
//
//  Created by Benjamin Linder on 12/13/12.
//  Copyright (c) 2012 Netflower Ltd. & Co. KG. All rights reserved.
//

#import "NFCoreDataHelper.h"

@implementation NFCoreDataHelper

@synthesize mainManagedObjectContext = _mainManagedObjectContext;

+ (id)sharedInstance{
    static NFCoreDataHelper *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSManagedObjectContext *)mainManagedObjectContext {
    if (_mainManagedObjectContext != nil) {
        return _mainManagedObjectContext;
    }
    
    _mainManagedObjectContext = [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
    
    return _mainManagedObjectContext;
}

#pragma mark - Fetch Requests

- (NSFetchedResultsController *)fetchedResultsControllerForEntityWithName:(NSString *)entityName
                                                                  sortKey:(NSString *)sortKey
                                                                ascending:(BOOL)ascending
                                                                predicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.mainManagedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:ascending];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.mainManagedObjectContext sectionNameKeyPath:nil cacheName:entityName];
    
    /*NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        //Implement Error Handling
        NSLog(@"Error while Fetching Results: %@", error);
    }*/
    
    return fetchedResultsController;
}

- (NSArray *)objectsForEntityWithName:(NSString *)entityName sortKey:(NSString *)sortKey {
    NSArray *results = nil;
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.mainManagedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES]]];
    results = [managedObjectContext executeFetchRequest:request error:&error];
    
    return results;
}

- (NSArray *)objectsForEntityWithName:(NSString *)entityName sortKey:(NSString *)sortKey inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    NSArray *results = nil;
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:sortKey ascending:YES]]];
    results = [managedObjectContext executeFetchRequest:request error:&error];
    
    return results;
}

- (NSArray *)objectsForEntityWithName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate {
    NSArray *result = nil;
    
    NSManagedObjectContext *managedObjectContext = self.mainManagedObjectContext;
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [request setFetchLimit:1];
    [request setPredicate:predicate];
    result = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    return result;
}


@end
