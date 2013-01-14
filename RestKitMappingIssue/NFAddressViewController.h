//
//  NFAddressViewController.h
//  RestKitMappingIssue
//
//  Created by Benjamin Linder on 1/14/13.
//  Copyright (c) 2013 Netflower Ltd. & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Partner;

@interface NFAddressViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) Partner *selectedPartner;
@end
