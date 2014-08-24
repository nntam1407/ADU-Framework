//
//  NSStringExtension.h
//  Demo
//
//  Created by Anh Quan on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kValidationTypeNormal = 0,
    kValidationTypeEmpty,
    kValidationTypeContainedWhitespacesPreAndSubfix,
    kValidationTypegUnderLimitCharacters,
    kValidationTypeOverLimitCharacters
} ValidationType;

@interface NSString (AQ_Extensions)

/* validate string */
- (ValidationType)validInAtLeastThreshold:(NSInteger)l1 atMostThreshold:(NSInteger)l2;
- (BOOL)isValidEmail;
- (BOOL)isPhoneNumber;
- (BOOL)isNumber;

- (NSString *)urlEncodedString;
- (NSString *)urlDecodedString;
- (BOOL)isBlank;
- (NSString *)trim;
- (BOOL)containString:(NSString *)subString;
- (NSMutableDictionary *)getParams;
+ (BOOL)isValid:(NSString *)regular;
- (NSString *)md5Encryption;

/* Atribute Text */
+ (NSMutableAttributedString *)stringAtributeWithTitle:(NSString *)text1
                                        withAttributes:(NSDictionary *)attributes1
                                               andDesc:(NSString *)text2
                                        withAttributes:(NSDictionary *)attributes2;
+ (NSMutableAttributedString *)stringAtributeWithTexts:(NSArray *)texts
                                        withAttributes:(NSArray *)atributes;

@end
