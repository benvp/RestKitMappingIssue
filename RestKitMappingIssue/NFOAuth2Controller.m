//
//  NFOAuth2Controller.m
//  GushoCustomer
//
//  Created by Benjamin Linder on 10/16/12.
//  Copyright (c) 2012 Netflower Ltd. & Co. KG. All rights reserved.
//

#import "NFOAuth2Controller.h"
#import <RestKit/RestKit.h>

@interface NFOAuth2Controller ()

@property (nonatomic, strong) NFAppDelegate *appDelegate;

@end

@implementation NFOAuth2Controller

@synthesize isAuthenticated = _isAuthenticated;
@synthesize account = _account;
@synthesize appDelegate = _appDelegate;


+ (id)sharedInstance {
    static NFOAuth2Controller *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.appDelegate = (NFAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [[NXOAuth2AccountStore sharedStore] setClientID:@"bd8848d0b01bd52340ac6e1981479ee8f9960edf60f75c86f0531bae7c70cbb7"
                                                 secret:@"1adbd0b455b18d07d4448b7b83ca9b9c2a9d2f4b99887f4dfdb2b7bc8e6c06d3"
                                       authorizationURL:[NSURL URLWithString:@"http://gushoapi.herokuapp.com/oauth/authorize"]
                                               tokenURL:[NSURL URLWithString:@"http://gushoapi.herokuapp.com/oauth/token"]
                                            redirectURL:[NSURL URLWithString:@"http://gushoapi.herokuapp.com/callback"]
                                         forAccountType:@"RestKitMappingIssue"];
        
        //Check if we already have a user and assign the tokens to restkit
        self.account = [[[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"RestKitMappingIssue"] lastObject];
        if (self.account) {
            RKObjectManager *objectManager = [RKObjectManager sharedManager];
            [objectManager.HTTPClient setAuthorizationHeaderWithToken:self.account.accessToken.accessToken];
        }
    }
    
    return self;
}

- (BOOL)isAuthenticated {
    if (self.account) {
        if (self.account.accessToken.hasExpired) {            
            __block id accessTokenChanged;
            __block BOOL notifReceived = NO;
            accessTokenChanged = [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountDidChangeAccessTokenNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
                
                //Set the new Token to RestKit
                RKObjectManager *objectManager = [RKObjectManager sharedManager];
                [objectManager.HTTPClient setAuthorizationHeaderWithToken:self.account.accessToken.accessToken];
                
                _isAuthenticated = YES;
                notifReceived = YES;
                
                [[NSNotificationCenter defaultCenter] removeObserver:accessTokenChanged];
            }];
            
            [self.account.oauthClient refreshAccessToken];
            
            //Wait until the token has been refreshed
            while (notifReceived == NO && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
        } else if (self.account.accessToken) {
            _isAuthenticated = YES;
        }       
    } else {
        _isAuthenticated = NO;
    }
    
    return _isAuthenticated;
}

- (void)performLoginIfRequired:(UIViewController *)source animated:(BOOL)animated {
    if (!self.isAuthenticated) {
        UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        [source presentModalViewController:viewController animated:animated];
    }
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(NXOAuth2Account *))successBlock error:(void (^)(NSError *))errorBlock {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"RestKitMappingIssue" username:username password:password];
    
    __block id accountObserver = nil;
    __block id loginFailedObserver = nil;

    accountObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification object:[NXOAuth2AccountStore sharedStore] queue:nil usingBlock:^(NSNotification *note) {

        self.account = [note.userInfo objectForKey:NXOAuth2AccountStoreNewAccountUserInfoKey];
        
        //Run the success Block
        successBlock(self.account);
        
        [[NSNotificationCenter defaultCenter] removeObserver:accountObserver];
    }];
    
    loginFailedObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification object:[NXOAuth2AccountStore sharedStore] queue:nil usingBlock:^(NSNotification *note) {
        NSError *error = [note.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
        
        //Run the failure Block
        errorBlock(error);
        
        [[NSNotificationCenter defaultCenter] removeObserver:loginFailedObserver];
    }];
}

- (void)logoutSuccess:(void (^)())successBlock error:(void (^)(NSError *))errorBlock {
    [[RKObjectManager sharedManager].HTTPClient deletePath:@"/logout" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200 || operation.response.statusCode == 204) {            
            NSError *error = nil;
            if(![[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext] save:&error]) {
                errorBlock(error);
            } else {
                //Delete stored tokens from the keychain
                for (NXOAuth2Account *account in [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"RestKitMappingIssue"]) {
                    [[NXOAuth2AccountStore sharedStore] removeAccount:account];
                }
                
                [[NSUserDefaults standardUserDefaults] setValue:@"default" forKey:@"SQLiteFilenamePrefix"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                /*[RKManagedObjectStore setDefaultStore:nil];
                self.appDelegate.persistentStoreCoordinator = nil;*/
                
                self.isAuthenticated = NO;
                self.account = nil;
                
                //Run the successBlock
                successBlock();
            }
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gusho" message:[NSString stringWithFormat:@"Logout failed with the following HTTP-Status Code: %i", operation.response.statusCode] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Run the failure Block
        errorBlock(error);
    }];
}

@end
