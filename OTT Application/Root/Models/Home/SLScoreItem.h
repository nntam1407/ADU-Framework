//
//  SLScoreItem.h
//  SportLocker
//
//  Created by Vinh Huynh on 6/30/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLObject.h"

@interface SLScoreItem : SLObject

@property(nonatomic, strong) NSString *league;
@property(nonatomic, strong) NSString *team1Name;
@property(nonatomic, strong) NSString *team1Id;
@property(nonatomic, strong) NSNumber *team1Score;
@property(nonatomic, strong) NSString *team2Name;
@property(nonatomic, strong) NSString *team2Id;
@property(nonatomic, strong) NSNumber *team2Score;
@property(nonatomic, strong) NSString *gameDetails;
@property(nonatomic, strong) NSString *endDate;
@property(nonatomic, strong) NSString *team1PhotoId;
@property(nonatomic, strong) NSString *team2PhotoId;

@end

