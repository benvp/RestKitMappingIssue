//
//  NFOAuth2Controller.h
//  GushoCustomer
//
//  Created by Benjamin Linder on 10/16/12.
//  Copyright (c) 2012 Netflower Ltd. & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXOAuth2.h"

@class GTMOAuth2Authentication, NXOAuth2Account;

/** The NFOAuth2Controller class handles the OAuth2 Authentication process. */
@interface NFOAuth2Controller : NSObject

/** Checks if the user isAuthenticated.
 * @return True if the user is authenticated. False if not.
*/
@property (nonatomic, assign) BOOL isAuthenticated;

/** The currently logged in account */
@property (nonatomic, strong) NXOAuth2Account *account;

/** Returns the shared singleton instance of NFOAuth2Controller class */
+ (id)sharedInstance;

/** Presents the NFLoginViewController modally if the user is not logged in 
 * @param source The Source ViewController on which the NFLoginViewController will be presented.
 * @param animated Sets if the NFLoginViewController should animate it's presentation.
*/
- (void)performLoginIfRequired:(UIViewController *)source animated:(BOOL)animated;

/** Login user using a username and password 
 * @param username The username
 * @param password The user's password
*/
- (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(NXOAuth2Account *user))successBlock error:(void (^)(NSError *error))errorBlock;

/** Performs a logout on the currently signed in user */
- (void)logoutSuccess:(void (^)())successBlock error:(void (^)(NSError *))errorBlock;

@end
