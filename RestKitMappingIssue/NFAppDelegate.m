//
//  NFAppDelegate.m
//  RestKitMappingIssue
//
//  Created by Benjamin Linder on 1/14/13.
//  Copyright (c) 2013 Netflower Ltd. & Co. KG. All rights reserved.
//

#import "NFAppDelegate.h"
#import "NFOAuth2Controller.h"
#import "RKObjectManager+NFObjectMappings.h"

@implementation NFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Initialize the RestKit
    [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://localhost:3000/v1"]];
    
    //Set activity indicator when network is busy
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    //If the user is already authenticated then add the access token to the authorization header
    if ([[NFOAuth2Controller sharedInstance] isAuthenticated]) {
        NXOAuth2Account *account = [[NFOAuth2Controller sharedInstance] account];
        [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithToken:account.accessToken.accessToken];
    }
    
    //Create the managedObjectModel and create the persistent store and managedobjectcontexts
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"DataModel" ofType:@"momd"]];
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *objectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    [objectStore createPersistentStoreCoordinator];
    [objectStore createManagedObjectContexts];
    
    NSString *storePath = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:@"sample.sqlite"];
    NSError *error = nil;
    [objectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    if (error) {
        NSLog(@"Error creating persistent Store: %@", error);
    }
    
    [RKObjectManager sharedManager].managedObjectStore = objectStore;
    
    
    //Now define the object Mappings
    [[RKObjectManager sharedManager] defineMappings];
    
    return YES;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
