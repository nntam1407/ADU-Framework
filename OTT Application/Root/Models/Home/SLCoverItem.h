//
//  SLCoverItem.h
//  SportLocker
//
//  Created by Vinh Huynh on 6/26/14.
//  Copyright (c) 2014 SportLocker. All rights reserved.
//

#import "SLObject.h"

@interface SLCoverItem : SLObject
@property(nonatomic, strong) NSString *caption;
@property(nonatomic, strong) NSString *subtitle;
@property(nonatomic, strong) NSString *photoId;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *entityTypeId;
@property(nonatomic, strong) NSString *leagueId;
@property(nonatomic, strong) NSString *date;
@end
