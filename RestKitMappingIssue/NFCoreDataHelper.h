//
//  NFCoreDataHelper.h
//  GushoVP
//
//  Created by Benjamin Linder on 12/13/12.
//  Copyright (c) 2012 Netflower Ltd. & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>

/** The NFCoreDataController class handles the communication with Core Data.
 * It is some kind of a helper class, providing methods to make fetch requests more handy.
 */
@interface NFCoreDataHelper : NSObject

/** The managedObjectContext for the current thread
 *  @return The NSManagedObjectContext from the MainQueue
 */
@property (nonatomic, strong) NSManagedObjectContext *mainManagedObjectContext;


/** Returns the shared singleton instance of NFCoreDataController class */
+ (id)sharedInstance;


#pragma mark - Fetch Requests

/** Helper Method for fetching Data
 * @param entityName The name of the entity to be fetched.
 * @param sortKey the Key to sort the objects for.
 * @return Returns NSArray of fetched Objects with the given entityName
 */
- (NSArray *)objectsForEntityWithName:(NSString *)entityName sortKey:(NSString *)sortKey;
- (NSArray *)objectsForEntityWithName:(NSString *)entityName sortKey:(NSString *)sortKey inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/** Similar to method objectsForEntityWithName:entityName
 * @param entityName The name of the entity to be fetched.
 * @param predicate The predicate used for the fetch request.
 * @return Returns NSArray of fetched Objects with the given entityName and predicate
 */
- (NSArray *)objectsForEntityWithName:(NSString *)entityName usingPredicate:(NSPredicate *)predicate;

/** Similar to method objectsForEntityWithName:entityName but returning an NSFetchedResultsController
 * @param entityName The name of the entity to be fetched.
 * @param sortKey The key used for sorting the fetched data.
 * @param ascending Sets if the data is sorted ascending (YES) or descending (NO)
 * @param predicate The predicate used for the fetch request.
 * @return Returns NSArray of fetched Objects with the given entityName and predicate
 */
- (NSFetchedResultsController *)fetchedResultsControllerForEntityWithName:(NSString *)entityName
                                                                  sortKey:(NSString *)sortKey
                                                                ascending:(BOOL)ascending
                                                                predicate:(NSPredicate *)predicate;

@end
