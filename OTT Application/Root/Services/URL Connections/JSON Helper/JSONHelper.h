//
//  JSONHelper.h
//  Halalgems
//
//  Created by Nguyen Minh Khoai on 12/20/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JSONHelper : NSObject
+ (BOOL)isValidJSONFromDictionary:(NSDictionary *)dict error:(NSError **)error;
@end
