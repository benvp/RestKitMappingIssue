//
//  NFAddressViewController.m
//  RestKitMappingIssue
//
//  Created by Benjamin Linder on 1/14/13.
//  Copyright (c) 2013 Netflower Ltd. & Co. KG. All rights reserved.
//

#import "NFAddressViewController.h"
#import "Partner.h"
#import "Address.h"

@interface NFAddressViewController ()

@end

@implementation NFAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@", self.selectedPartner.address.street, self.selectedPartner.address.zipCode, self.selectedPartner.address.city];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
