//
//  SLTeamScoreDetailItem.h
//  SportLocker
//
//  Created by Vinh Huynh on 8/14/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLObject.h"

@interface SLNFLTeamScoreDetailItem : SLObject

@property (nonatomic, strong) NSNumber          *totalPtsScored;
@property (nonatomic, strong) NSNumber          *ptsFirstQuarter;
@property (nonatomic, strong) NSNumber          *ptsSecondQuarter;
@property (nonatomic, strong) NSNumber          *ptsThirdQuarter;
@property (nonatomic, strong) NSNumber          *remainingTimeouts;
@property (nonatomic, strong) NSNumber          *remainingChallenges;


@end
