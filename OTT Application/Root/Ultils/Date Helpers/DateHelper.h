//
//  DateHelper.h
//  SportLocker
//
//  Created by SON VU HUNG on 6/13/11.
//  Copyright 2011 Infotech Cosmos. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Configuration for date formats */
#define kDateFormat             @"yyyy-MM-dd'T'HH:mm:ss.SSS"
#define kSubmitDateFormat       @"yyyy-MM-dd"
#define kInputDateFormat        @"yyyy-MM-dd"
#define kDateFormatSSSZ         @"yyyy-MM-dd'T'HH:mm:ss.sssZ"


@interface DateHelper : NSObject

+ (NSString *)stringFromDate:(NSDate *)aDate withFormat:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)dateString;

+ (NSString *)dateToEasyReaderString:(NSDate *)startDate;
+ (NSString *)dateToProxyFormat:(NSDate *)aDate;
+ (NSString *)ageForDate:(NSDate *)date;
+ (NSInteger)calAgeForDate:(NSDate *)date;

+ (NSString *)GMTTimeStringFromDate:(NSDate *)date;
+ (NSString *)localTimeStringFromGMTDateString:(NSString *)date;

+ (BOOL)startDate:(NSDate *)startDate lessThanEndDate:(NSDate *)endDate;
+ (BOOL)startTimeDate:(NSDate *)startDate lessThanEndTimeDate:(NSDate *)endDate;
+ (NSDate *)dateAgoDays:(NSInteger)count fromDate:(NSDate *)date;
+ (NSDate *)dateAgoMonths:(NSInteger)count fromDate:(NSDate *)date;
+ (BOOL)date:(NSDate *)startDate equalToDate:(NSDate *)endDate;
+ (NSString *)utcStringForDate:(NSDate *)date withFormat:(NSString *)dateString;
+ (NSString *)UTCTimeZone;

+ (NSString *)stringFromDateString:(NSString *)dateString
                        withFormatIn:(NSString *)formatIn
                     withFormatOut:(NSString *)formatOut;

@end
