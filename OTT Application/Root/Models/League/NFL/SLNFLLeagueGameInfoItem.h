//
//  SLLeagueGameInfoItem.h
//  SportLocker
//
//  Created by Vinh Huynh on 8/14/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLObject.h"

@interface SLNFLLeagueGameInfoItem : SLObject

@property (nonatomic, strong) NSString              *gameDate;
@property (nonatomic, strong) NSString              *kickOffTime;
@property (nonatomic, strong) NSString              *gQgCTime;
@property (nonatomic, strong) SLNFLLeagueVenueItem     *venue;
@property (nonatomic, strong) NSString              *weather;
@property (nonatomic, strong) NSNumber              *playYardsToFirstDown;
@property (nonatomic, strong) NSNumber              *playYardLine;
@property (nonatomic, strong) NSString              *clockTime;

@end
