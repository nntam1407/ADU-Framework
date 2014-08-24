//
//  SLLeagueScore.h
//  SportLocker
//
//  Created by Vinh Huynh on 8/14/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLObject.h"

@class SLNFLScoreTeamItem, SLNFLTeamScoreDetailItem;
@interface SLNFLLeagueScoreItem : SLObject

@property (nonatomic, strong) SLNFLScoreTeamItem  *homeTeam;
@property (nonatomic, strong) SLNFLScoreTeamItem  *awayTeam;
@property (nonatomic, strong) SLNFLLeagueGameInfoItem   *gameInfo;
@property (nonatomic, strong) NSString                  *gameStatus;
@property (nonatomic, strong) SLNFLTeamScoreDetailItem  *awayTeamScoreDetail;
@property (nonatomic, strong) SLNFLTeamScoreDetailItem  *homeTeamScoreDetail;


@end
