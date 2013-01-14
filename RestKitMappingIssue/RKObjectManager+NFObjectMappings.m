//
//  RKObjectManager+NFObjectMappings.m
//  RestKitMappingIssue
//
//  Created by Benjamin Linder on 1/14/13.
//  Copyright (c) 2013 Netflower Ltd. & Co. KG. All rights reserved.
//

#import "RKObjectManager+NFObjectMappings.h"

@implementation RKObjectManager (NFObjectMappings)

- (void)defineMappings {
    //// -----------------------------------------------
    // ---------------- Partner Mapping ----------------
    //// -----------------------------------------------
    
    RKEntityMapping *partnerMapping = [RKEntityMapping mappingForEntityForName:@"Partner"
                                                          inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    
    [partnerMapping addAttributeMappingsFromDictionary:@{
     @"id"                  : @"partnerID",
     @"category_id"         : @"categoryID",
     @"average_rating_ids"  : @"averageRatingIDs",
     @"address_id"          : @"addressID",
     @"image_id"            : @"imageID",
     @"menu_id"             : @"menuID",
     @"customer_image_ids"  : @"customerImageIDs",
     @"ratings_count"       : @"ratingsCount",
     @"name"                : @"name",
     @"enabled"             : @"enabled",
     @"rating"              : @"rating",
     @"contracted"          : @"contracted",
     @"created_at"          : @"createdAt",
     @"updated_at"          : @"updatedAt"
     }];
    
    partnerMapping.identificationAttributes = @[ @"partnerID" ];

    
    
    //// -----------------------------------------------
    // ---------------- Address Mapping ----------------
    //// -----------------------------------------------
    
    RKEntityMapping *addressMapping = [RKEntityMapping mappingForEntityForName:@"Address"
                                                          inManagedObjectStore:[RKManagedObjectStore defaultStore]];
    
    [addressMapping addAttributeMappingsFromDictionary:@{
     @"id"              : @"addressID",
     @"partner_ids"     : @"partnerIDs",
     @"street"          : @"street",
     @"city"            : @"city",
     @"longitude"       : @"longitude",
     @"latitude"        : @"latitude",
     @"zip_code"        : @"zipCode",
     @"created_at"      : @"createdAt",
     @"updated_at"      : @"updatedAt"
     }];
    
    addressMapping.identificationAttributes = @[ @"addressID" ];
    
    
    
    // ************************************************************
    ////
    // ---------------------- RELATIONSHIPS -----------------------
    ////
    // ************************************************************
    
    [addressMapping addConnectionForRelationship:@"partners" connectedBy:@{@"partnerIDs" : @"partnerID"}];
    
    
    
    
    
    
    // ************************************************************
    ////
    // ------------------ RESPONSE DESCRIPTORS --------------------
    ////
    // ************************************************************
    
    
    RKResponseDescriptor *partnerDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:partnerMapping
                                                                                      pathPattern:nil
                                                                                          keyPath:@"partners"
                                                                                      statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    RKResponseDescriptor *addressDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:addressMapping
                                                                                      pathPattern:nil
                                                                                          keyPath:@"addresses"
                                                                                      statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    
    NSArray *responseDescriptors = @[partnerDescriptor, addressDescriptor];
    
    [self addResponseDescriptorsFromArray:responseDescriptors];
}

@end
