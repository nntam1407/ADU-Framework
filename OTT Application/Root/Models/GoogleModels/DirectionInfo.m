//
//  DirectionInfo.m
//  Findereat
//
//  Created by Nguyen Minh Khoai on 10/18/12.
//  Copyright (c) 2012 Nguyen The Phu. All rights reserved.
//
#import "DirectionInfo.h"
#import "RouteInfo.h"

#define kDistanceMaximum 1000

@implementation DirectionInfo
@synthesize routes, addressA, addressB, distance, duration;

- (id)init {
    self = [super init];
    if (self) {
        self.routes = [NSMutableArray array];
    }
    return self;
}

- (NSString *)flattenHtml:(NSString *)html {
    NSScanner *theScanner;
    NSString *text = nil;

    theScanner = [NSScanner scannerWithString:html];

    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL];

        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text];

        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@" "];
    } // while //

    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    return html;
}

- (void)setupWithDictionary:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSArray *legs = [dict objectForKey:@"legs"];
        if (legs && [legs count] > 0) {
            NSDictionary *legDict = [legs objectAtIndex:0];

            /* get common information */
            NSDictionary *distanceDict = [legDict objectForKey:@"distance"];
            self.distance = [distanceDict objectForKey:@"text"];

            self.routes = [NSMutableArray array];
            NSNumber *number = [distanceDict objectForKey:@"value"];
            if (([number longValue] / 1000) <= kDistanceMaximum) {

                NSDictionary *durationDict = [legDict objectForKey:@"duration"];
                self.duration = [durationDict objectForKey:@"text"];

                self.addressB = [legDict objectForKey:@"end_address"];
                self.addressA = [legDict objectForKey:@"start_address"];

                /* get routes */
                NSArray *routeDicts = [legDict objectForKey:@"steps"];
                for (NSDictionary *routeDict in routeDicts) {
                    RouteInfo *routeInfo = [[RouteInfo alloc] init];

                    /* Distance */
                    NSDictionary *distanceDict = [routeDict objectForKey:@"distance"];
                    routeInfo.distance = [distanceDict objectForKey:@"text"];

                    /* Duration */
                    NSDictionary *durationDict = [routeDict objectForKey:@"duration"];
                    routeInfo.duration = [durationDict objectForKey:@"text"];

                    /* instruction */
                    routeInfo.instructions = [routeDict objectForKey:@"html_instructions"];

                    routeInfo.instructions = [self flattenHtml:routeInfo.instructions];

                    [routes addObject:routeInfo];
                }
            }
        }
    }
}

- (void)dealloc {
    self.routes = nil;
    self.addressA = nil;
    self.addressB = nil;
}
@end
