//
//  DateHelper.m
//  SportLocker
//
//  Created by SON VU HUNG on 6/13/11.
//  Copyright 2011 Infotech Cosmos. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+ (NSString *)stringFromDate:(NSDate *)aDate withFormat:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NotNullString(dateString)];
	NSString *dateOfBirth = [dateFormatter stringFromDate:aDate];
    return dateOfBirth;
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [DateHelper stringFromDate:date withFormat:kDateFormat];
}

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format {
    if(![dateString isEqual:[NSNull null]] && dateString.length > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        NSDate * selected = [dateFormatter dateFromString:NotNullString(dateString)];
        return selected;
    }
    return nil;
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    return [DateHelper dateFromString:dateString withFormat:kDateFormat];
}

+ (NSString *)dateHourToProxyFormat:(NSDate *)aDate {
    aDate = [aDate dateByAddingTimeInterval:1];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Adelaide"]];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:aDate];
	
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [dateFormatter stringFromDate:aDate];
	
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:aDate];
    
    [dateFormatter setDateFormat:@"HH"];
    NSString *hour = [dateFormatter stringFromDate:aDate];
    
    [dateFormatter setDateFormat:@"mm"];
    NSString *min = [dateFormatter stringFromDate:aDate];
    
    [dateFormatter setDateFormat:@"ss"];
    NSString *second = [dateFormatter stringFromDate:aDate];
	
    
	NSString *dateOfBirth = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year,month,day,hour,min,second];
    return dateOfBirth;
}

+ (NSString *)dateToProxyFormat:(NSDate *)aDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:aDate];
	
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [dateFormatter stringFromDate:aDate];
	
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:aDate];
	
	NSString *dateOfBirth = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    return dateOfBirth;
}

+ (NSString *)dateToEasyReaderString:(NSDate *)startDate {
    
    NSDate *now = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:now options:0];
    NSInteger months = [components month];
    NSInteger days = [components day];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    NSInteger seconds = [components second];
    
    if (months > 0) {
        if (months == 1) {
            return [NSString stringWithFormat:@"%ld month ago",(long)months];
        }
        else {
            return [NSString stringWithFormat:@"%ld months ago",(long)months];
        }
    }
    else if (days > 0) {
        if (days == 1) {
            return [NSString stringWithFormat:@"%ld day ago",(long)days];
        }
        else {
            return [NSString stringWithFormat:@"%ld days ago",(long)days];
        }
    }
    else if (hours > 0) {
        if (hours == 1) {
            return [NSString stringWithFormat:@"%ld hour ago",(long)hours];
        }
        else{
            return [NSString stringWithFormat:@"%ld hours ago",(long)hours];
        }
    }
    else if (minutes > 0) {
        if (minutes == 1) {
            return [NSString stringWithFormat:@"%ld minute ago",(long)minutes];
        }
        else{
            return [NSString stringWithFormat:@"%ld minutes ago",(long)minutes];
        }
    }
    else if (seconds > 0) {
        if (seconds == 1) {
            return [NSString stringWithFormat:@"%ld second ago",(long)seconds];
        }
        else{
            return [NSString stringWithFormat:@"%ld seconds ago",(long)seconds];
        }
    }
    return [NSString stringWithFormat:@"%@", [startDate description]];
}

+ (NSString *)ageForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:date];
    
    NSInteger age = 0;
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
        age = [dateComponentsNow year] - [dateComponentsBirth year] - 1;
    } else {
        age = [dateComponentsNow year] - [dateComponentsBirth year];
    }
    
    return [NSString stringWithFormat:@"%ld year old", (long)age];
}

+ (NSInteger)calAgeForDate:(NSDate *)date {
    
    NSInteger age = 0;
    
    if(date) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
        NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:date];
        
        if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
            (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
            age = [dateComponentsNow year] - [dateComponentsBirth year] - 1;
        } else {
            age = [dateComponentsNow year] - [dateComponentsBirth year];
        }
    }
    return age;
}

+ (NSString *)GMTTimeStringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = kDateFormat;
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    NSString *timeStamp = [dateFormatter stringFromDate:date];
    return timeStamp;
}

+ (NSString *)localTimeStringFromGMTDateString:(NSString *)date {
    NSDateFormatter *gmtTimeFormatter = [[NSDateFormatter alloc] init];
    gmtTimeFormatter.dateFormat = kDateFormat;
    
    NSDate *gmtDate = [gmtTimeFormatter dateFromString:date];
    gmtTimeFormatter.timeZone = [NSTimeZone systemTimeZone];
    return [gmtTimeFormatter stringFromDate:gmtDate];
}

+ (BOOL)startDate:(NSDate *)startDate lessThanEndDate:(NSDate *)endDate {
    return ([endDate timeIntervalSinceNow] >= [startDate timeIntervalSinceNow]);
}

+ (NSDateComponents *)componentsFromDate:(NSDate *)date {
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dataComps = [gregorianCal components: (NSHourCalendarUnit | NSMinuteCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    return dataComps;
}

+ (BOOL)startTimeDate:(NSDate *)startDate lessThanEndTimeDate:(NSDate *)endDate {
    /* get hours and minutes of start date */
    NSDateComponents *startDateComponents = [DateHelper componentsFromDate:startDate];
    
    /* get hours and minutes of end date */
    NSDateComponents *endDateComponents = [DateHelper componentsFromDate:endDate];
    
    return ([endDateComponents hour] > [startDateComponents hour]
            || ([endDateComponents hour] == [startDateComponents hour] && [endDateComponents minute] > [startDateComponents minute]));
}

+ (NSDate *)dateAgoDays:(NSInteger)count fromDate:(NSDate *)date {
    return [date dateByAddingTimeInterval:count * 24 * 60 * 60];
}

+ (NSDate *)dateAgoMonths:(NSInteger)count fromDate:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:count];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:dateComponents toDate:date options:0];
}

+ (BOOL)date:(NSDate *)startDate equalToDate:(NSDate *)endDate {
    /* get hours and minutes of start date */
    NSDateComponents *startDateComponents = [DateHelper componentsFromDate:startDate];
    
    /* get hours and minutes of end date */
    NSDateComponents *endDateComponents = [DateHelper componentsFromDate:endDate];
    
    return (startDateComponents.month == endDateComponents.month && startDateComponents.year == endDateComponents.year);
}

+ (NSString *)utcStringForDate:(NSDate *)date withFormat:(NSString *)dateString {
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:date];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:date];
    
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:dateString];
    [dateFormatters setDateStyle:NSDateFormatterShortStyle];
    [dateFormatters setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatters setDoesRelativeDateFormatting:YES];
    [dateFormatters setTimeZone:[NSTimeZone systemTimeZone]];
    
    return [dateFormatters stringFromDate:destinationDate];
}

+ (NSString *)UTCTimeZone {
    NSDateFormatter *localTimeZoneFormatter = [NSDateFormatter new];
    localTimeZoneFormatter.timeZone = [NSTimeZone localTimeZone];
    localTimeZoneFormatter.dateFormat = @"Z";
    NSString *localTimeZoneOffset = [localTimeZoneFormatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"UTC %@", localTimeZoneOffset];
}

+ (NSString *)stringFromDateString:(NSString *)dateString
                      withFormatIn:(NSString *)formatIn
                     withFormatOut:(NSString *)formatOut
{
    NSDate *dateIn = [DateHelper dateFromString:dateString withFormat:formatIn];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:NotNullString(formatOut)];
	NSString *date = [dateFormatter stringFromDate:dateIn];
    return date;
    
}

@end
