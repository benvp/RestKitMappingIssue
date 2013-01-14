//
//  Address.h
//  RestKitMappingIssue
//
//  Created by Benjamin Linder on 1/14/13.
//  Copyright (c) 2013 Netflower Ltd. & Co. KG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Partner;

@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * addressID;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSArray * partnerIDs;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSSet *partners;
@end

@interface Address (CoreDataGeneratedAccessors)

- (void)addPartnersObject:(Partner *)value;
- (void)removePartnersObject:(Partner *)value;
- (void)addPartners:(NSSet *)values;
- (void)removePartners:(NSSet *)values;

@end
