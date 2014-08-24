//
//  NSStringExtension.m
//  Demo
//
//  Created by Anh Quan on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSStringExtension.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (AQ_Extensions)

- (NSString *)urlEncodedString {
	// Escape even the "reserved" characters for URLs
	// as defined in http://www.ietf.org/rfc/rfc2396.txt
	NSString *encodedString =
    (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          ( CFStringRef)self,
                                                                          NULL,
                                                                          CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
                                                                          kCFStringEncodingUTF8);
	return (!encodedString) ? @"" : encodedString;
}

- (NSString *)urlDecodedString{
	NSString *decodedCFString =
    (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                          ( CFStringRef) self,
                                                                                          CFSTR(""),
                                                                                          kCFStringEncodingUTF8);
    
	return (!decodedCFString) ? @"" : [decodedCFString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isBlank {
	BOOL blank = YES;
	NSString *trimString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if ([trimString length] > 0) {
		blank = NO;
	}
	return blank;
}


- (BOOL)containString:(NSString *)subString {
    NSRange range = [self rangeOfString:subString];
    return (range.location != NSNotFound);
}


- (NSMutableDictionary *)getParams {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *queryElements = [self componentsSeparatedByString:@"&"];
    for (NSString *element in queryElements) {
        NSArray *keyVal = [element componentsSeparatedByString:@"="];
        if (keyVal.count > 0) {
            NSString *variableKey = keyVal[0];
            NSString *value = (keyVal.count >= 2) ? [element substringFromIndex:[variableKey length] + 1] : nil;
            
            if(value) {
                dic[variableKey] = value;
            }
        }
    }
    return dic;
}


+ (BOOL)isValid:(NSString *)regular {
    NSPredicate *regExPredicate =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    return [regExPredicate evaluateWithObject:self];
}


- (NSString *)md5Encryption {
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

/* validate string */
- (ValidationType)validInAtLeastThreshold:(NSInteger)l1 atMostThreshold:(NSInteger)l2 {
    
    ValidationType type = kValidationTypeNormal;
    
    /* string is empty */
    if(self.length == 0) {
        type = kValidationTypeEmpty;
    } else if([self trim].length < self.length) {
        type = kValidationTypeContainedWhitespacesPreAndSubfix;
    } else if(self.length < l1) {
        return kValidationTypegUnderLimitCharacters;
    } else if(self.length > l2) {
        return kValidationTypeOverLimitCharacters;
    }
    return type;
}

- (BOOL)isValidEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isPhoneNumber {
    if(!self || self.length == 0) {
        return NO;
    }
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [self length]);
    NSArray *matches = [detector matchesInString:self options:0 range:inputRange];
    
    // no match at all
    if ([matches count] == 0) {
        return NO;
    }
    
    // found match but we need to check if it matched the whole string
    NSTextCheckingResult *result = (NSTextCheckingResult *)matches[0];
    
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
        // it matched the whole string
        return YES;
    }
    else {
        // it only matched partial string
        return NO;
    }
}

- (BOOL)isNumber {
    if (self.length == 0) {
        return NO;
    }
    NSDecimal decimalValue;
    NSScanner *sc = [NSScanner scannerWithString:self];
    [sc scanDecimal:&decimalValue];
    return [sc isAtEnd];
}

/* Create atributed string from two text */
+ (NSMutableAttributedString *)stringAtributeWithTitle:(NSString *)text1
                                        withAttributes:(NSDictionary *)attributes1
                                               andDesc:(NSString *)text2
                                        withAttributes:(NSDictionary *)attributes2
{
    /* Text 1 */
    NSMutableAttributedString *stringForText = [[NSMutableAttributedString alloc] init];
    if (text1 != nil && ![text1 isEqualToString:@""]) {
        NSAttributedString *firstText = [[NSAttributedString alloc] initWithString:text1
                                                                        attributes:attributes1];
        [stringForText appendAttributedString:firstText];
        
    }
    /* text 2 */
    if (text2 != nil && ![text2 isEqualToString:@""] ) {
        NSAttributedString *secondText = [[NSAttributedString alloc]
                                          initWithString:text2
                                          attributes:attributes2];
        
        [stringForText appendAttributedString:secondText];
    }
    return stringForText;
}
/* Create atributed string from multil text */
+ (NSMutableAttributedString *)stringAtributeWithTexts:(NSArray *)texts
                                        withAttributes:(NSArray *)atributes
{
    /* check valid data */
    if (texts.count != atributes.count || texts.count == 0) {
        return nil;
    }
    
    /* set up atributed */
    NSMutableAttributedString *stringForText = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < texts.count; i ++) {
        if (texts[i] != nil && ![texts[i] isEqualToString:@""]) {
            NSAttributedString *atributeText = [[NSAttributedString alloc] initWithString:texts[i]
                                                                            attributes:atributes[i]];
            [stringForText appendAttributedString:atributeText];
            
        }
    }
    return stringForText;
}

@end
