//
//  SLLeagueVenueItem.h
//  SportLocker
//
//  Created by Vinh Huynh on 8/14/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLObject.h"

@interface SLNFLLeagueVenueItem : SLObject

@property (nonatomic, strong) NSString      *venueId;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString      *address1;
@property (nonatomic, strong) NSString      *city;
@property (nonatomic, strong) NSString      *state;
@property (nonatomic, strong) NSString      *country;
@property (nonatomic, strong) NSNumber      *zip;
@property (nonatomic, strong) NSString      *surface;
@property (nonatomic, strong) NSNumber      *capacity;
@property (nonatomic, strong) NSNumber      *numberOfExecutiveSuites;
@property (nonatomic, strong) NSNumber      *brokeGround;
@property (nonatomic, strong) NSNumber      *opened;
@property (nonatomic, strong) NSString      *constructionCost;
@property (nonatomic, strong) NSString      *owners;
@property (nonatomic, strong) NSString      *currentTenants;
@property (nonatomic, strong) NSString      *constructionCostInCurrentDollars;
@property (nonatomic, strong) NSNumber      *linkable;

@end
