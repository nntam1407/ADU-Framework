//
//  SLNFLScoreTeamItem.h
//  SportLocker
//
//  Created by Vinh Huynh on 8/15/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLObject.h"

@interface SLNFLScoreTeamItem : SLObject

@property (nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logoImageId;
@property (nonatomic, copy) NSString *linkable;


@end
