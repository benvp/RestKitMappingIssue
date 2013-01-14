//
//  NFPartnerViewController.m
//  RestKitMappingIssue
//
//  Created by Benjamin Linder on 1/14/13.
//  Copyright (c) 2013 Netflower Ltd. & Co. KG. All rights reserved.
//

#import "NFPartnerViewController.h"
#import "NFOAuth2Controller.h"
#import "NFCoreDataHelper.h"
#import "Partner.h"

@interface NFPartnerViewController ()

@end

@implementation NFPartnerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Login to the API and Request the RemoteObjects
    [[NFOAuth2Controller sharedInstance] loginWithUsername:@"ben.linder@me.com" password:@"password" success:^(NXOAuth2Account *user) {
        NSLog(@"logged in successfully");
        [[RKObjectManager sharedManager].HTTPClient setAuthorizationHeaderWithToken:user.accessToken.accessToken];
        //Fetch the data
        [self fetchRemoteData];
    } error:^(NSError *error) {
        NSLog(@"error loggin in: %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchRemoteData {
    NSMutableArray *operations = [NSMutableArray array];
    
    RKManagedObjectRequestOperation *getPartners = [[RKObjectManager sharedManager] appropriateObjectRequestOperationWithObject:nil
                                                                                                                         method:RKRequestMethodGET
                                                                                                                           path:@"partners"
                                                                                                                     parameters:nil];
    
    RKManagedObjectRequestOperation *getAddresses = [[RKObjectManager sharedManager] appropriateObjectRequestOperationWithObject:nil
                                                                                                                          method:RKRequestMethodGET
                                                                                                                            path:@"addresses"
                                                                                                                      parameters:nil];
    
    [operations addObject:getPartners];
    [operations addObject:getAddresses];
    
    [[RKObjectManager sharedManager] enqueueBatchOfObjectRequestOperations:operations progress:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"Running operation %i of %i", numberOfFinishedOperations, totalNumberOfOperations);
    } completion:^(NSArray *operations) {
        NSLog(@"Finished operations");
        
        [self.tableView reloadData];
    }];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchedResultsController *frc = [[NFCoreDataHelper sharedInstance] fetchedResultsControllerForEntityWithName:@"Partner" sortKey:@"name" ascending:YES predicate:nil];
    
    self.fetchedResultsController = frc;
    return _fetchedResultsController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"partnerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Partner *partner = (Partner *)self.fetchedResultsController.fetchedObjects[indexPath.row];
    cell.textLabel.text = partner.name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
