//
//  Partner.h
//  RestKitMappingIssue
//
//  Created by Benjamin Linder on 1/14/13.
//  Copyright (c) 2013 Netflower Ltd. & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address;

@interface Partner : NSManagedObject

@property (nonatomic, retain) NSString * addressID;
@property (nonatomic, retain) NSNumber * contracted;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSString * imageID;
@property (nonatomic, retain) NSString * menuID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * partnerID;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) Address *address;

@end
