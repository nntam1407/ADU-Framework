//
//  SLLeagueTeamItem.h
//  SportLocker
//
//  Created by Vinh Huynh on 8/7/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLObject.h"

@interface SLTeamItem : SLObject

@property (nonatomic, strong) NSString *entityId;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *photoId;
@property (nonatomic, strong) NSString *leagueId;
@property (nonatomic, strong) NSString *entityTypeId;

@end
