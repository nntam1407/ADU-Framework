/*============================================================================
 PROJECT: SportLocker
 FILE:    Ultils.m
 AUTHOR:  Nguyen Quang Khai
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/

#import "Utils.h"
#include <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <zlib.h>

/*============================================================================
 MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/
/*----------------------------------------------------------------------------
 Interface:   Ultils
 -----------------------------------------------------------------------------*/
@interface Utils()

@end

@implementation Utils

/*----------------------------------------------------------------------------
 Method:      validateEmail:
 check email's format
 -----------------------------------------------------------------------------*/
+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

/* Helper OAuth */
static NSString * AFEncodeBase64WithData(NSData *data) {
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

static NSString * AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()',";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    
    return (  NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding)));
}

+ (NSString *)AFNounce {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    return (NSString *)CFBridgingRelease(string);
}

+ (NSString *)AFHMACSHA1Signature:(NSURLRequest *)request
                   consumerSecret:(NSString *)consumerSecret
                      tokenSecret:(NSString *)tokenSecret
                   stringEncoding:(NSStringEncoding)stringEncoding {
    
    NSString *secret = tokenSecret ? tokenSecret : @"";
    NSString *secretString = [NSString stringWithFormat:@"%@&%@", consumerSecret, secret];
    NSData *secretStringData = [secretString dataUsingEncoding:stringEncoding];
    
    NSString *queryString = AFPercentEscapedQueryStringPairMemberFromStringWithEncoding([[[[[request URL] query] componentsSeparatedByString:@"&"] sortedArrayUsingSelector:@selector(compare:)] componentsJoinedByString:@"&"], stringEncoding);
    NSString *requestString = [NSString stringWithFormat:@"%@&%@&%@", [request HTTPMethod], AFPercentEscapedQueryStringPairMemberFromStringWithEncoding([[[request URL] absoluteString] componentsSeparatedByString:@"?"][0], stringEncoding), queryString];
    NSData *requestStringData = [requestString dataUsingEncoding:stringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CCHmacContext cx;
    CCHmacInit(&cx, kCCHmacAlgSHA1, [secretStringData bytes], [secretStringData length]);
    CCHmacUpdate(&cx, [requestStringData bytes], [requestStringData length]);
    CCHmacFinal(&cx, digest);
    
    return AFEncodeBase64WithData([NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH]);
}

+ (NSString *)appendParams:(NSMutableDictionary *)params {
    NSString *url = @"";
    
    NSInteger index = 0;
    for (id key in params) {
        if(index == 0) {
            url  = [url stringByAppendingFormat:@"%@=%@", key, [params objectForKey:key]];
        } else {
            url  = [url stringByAppendingFormat:@"&%@=%@", key, [params objectForKey:key]];
        }
        index++;
    }
    return url;
}

//+ (UInt32)getCrc32:(NSData *)data {
//    unsigned long result = crc32(0, data.bytes, data.length);
//    return result;
//}
//
//+ (uint32_t)CRC32ValueWithData: (NSData*)data {
//    uLong crc = crc32(0L, Z_NULL, 0);
//    crc = crc32(crc, [data bytes], [data length]);
//    return crc;
//}
/*----------------------------------------------------------------------------
 Method:      validatePhoneNumber
 Description: validate phone number
 ----------------------------------------------------------------------------*/
+ (BOOL)validatePhoneNumber:(NSString *)phoneNumber {
    
    if(!phoneNumber || phoneNumber.length == 0) {
        return NO;
    }
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [phoneNumber length]);
    NSArray *matches = [detector matchesInString:phoneNumber options:0 range:inputRange];
    
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
/*----------------------------------------------------------------------------
 Method:      showAlertWithMessage:
 show message
 -----------------------------------------------------------------------------*/
+ (void)showAlertWithMessage:(NSString *)mess {
    if(IsKindOfClass(mess, [NSString class]) && mess && [mess length] > 0) {
        [[MessageBox sharedMessageBox] showBoxWithTitle:nil
                                                message:mess
                                               delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"OK", @"UIButton")
                                      otherButtonTitles:nil];
    }
}

+ (void)showConfirmAlertWithMessage:(NSString *)mess delegate:(id)delegate{
    if(IsKindOfClass(mess, [NSString class]) && mess && [mess length] > 0) {
        [[MessageBox sharedMessageBox] showBoxWithTitle:nil
                                                message:mess
                                               delegate:delegate
                                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"UIButton")
                                      otherButtonTitles:@[NSLocalizedString(@"OK", @"UIButton")]];
    }
}

/* For updating vatar */
+ (UIImage *)stretchImagedName:(NSString *)imageName leftPadding:(CGFloat)leftPadding topPadding:(CGFloat)padding {
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image stretchableImageWithLeftCapWidth:leftPadding  topCapHeight:padding];
    return image;
}

+ (UIImage *)stretchImagedName:(NSString *)imageName topPadding:(CGFloat)padding {
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2  topCapHeight:(image.size.height/2 + padding)];
    return image;
}

+ (UIImage *)middleStretchImagedName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return image;
}

+ (UIImage *)tiledImageName:(NSString *)imageName edgeInset:(UIEdgeInsets)inset {
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image resizableImageWithCapInsets:inset];
    return image;
}

/* for align control */

+ (CGSize)constrainedBoundsForText:(NSString *)text
                              font:(UIFont *)font
                     lineBreakMode:(NSInteger)lineBreakMode
                     textAlignment:(NSInteger)textAlignment
                         limitSize:(CGSize)limitSize {
    CGSize size = CGSizeZero;
    if(SupportiOS7) {
        /// Make a copy of the default paragraph style
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        
        /// Set line break mode
        paragraphStyle.lineBreakMode = lineBreakMode;
        
        /// Set text alignment
        paragraphStyle.alignment = textAlignment;
        
        NSDictionary *attributes = @{ NSFontAttributeName:font,
                                      NSParagraphStyleAttributeName: paragraphStyle};
        
        size = [text boundingRectWithSize:limitSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attributes
                                  context:nil].size;
        
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        size = [text sizeWithFont:font
                constrainedToSize:limitSize
                    lineBreakMode:lineBreakMode];
#endif
    }
    return size;
}

+ (CGSize)constrainSizeForLabel:(UILabel *)label autoFitSize:(AutoFitSize)mode {
    
    CGSize limitSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if(mode == AutoFitSizeWidth) {
        limitSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    } else if(mode == AutoFitSizeHeight) {
        limitSize = CGSizeMake(MAXFLOAT, label.frame.size.height);
    }
    
    return [Utils constrainedBoundsForText:label.text
                                      font:label.font
                             lineBreakMode:label.lineBreakMode
                             textAlignment:NSTextAlignmentLeft
                                 limitSize:limitSize];
}

+ (CGSize)constrainSizeForControl:(UIView *)label autoFitSize:(AutoFitSize)mode {
    
    CGSize limitSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if(mode == AutoFitSizeWidth) {
        limitSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    } else if(mode == AutoFitSizeHeight) {
        limitSize = CGSizeMake(MAXFLOAT, label.frame.size.height);
    }
    
    NSString *text = [label performSelector:@selector(text)];
    UIFont *font = [label performSelector:@selector(font)];
    
    return [Utils constrainedBoundsForText:text
                                      font:font
                             lineBreakMode:NSLineBreakByTruncatingTail
                             textAlignment:NSTextAlignmentLeft
                                 limitSize:limitSize];
}

+ (void)markupBorderForRestaurantImage:(UIImageView *)imageView {
    imageView.layer.borderColor = UIColorFromRGB(0x6e9900).CGColor;
    imageView.layer.borderWidth = 1;
    imageView.layer.cornerRadius = 3;
    imageView.clipsToBounds = YES;
}

+ (UIColor *)colorFromHexaCode:(NSString *)hexaStr {
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexaStr];
    
    [scanner setScanLocation:0];
    [scanner scanHexInt:&result];
    
    UIColor *cellColor = UIColorFromRGB(result);
    return cellColor;
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

static int networkActivityIndicatorCount = 0;

+ (void)showNetworkActivityIndicator {
    networkActivityIndicatorCount++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+ (void)hideNetworkActivityIndicator {
    networkActivityIndicatorCount--;
    if (networkActivityIndicatorCount == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

/* for emergency */
+ (BOOL)isText:(NSString *)text includedInArray:(NSMutableArray *)arr {
    BOOL need = NO;
    NSString *str = [[text lowercaseString] trim];
    for (NSString *tmp in arr) {
        NSString *trimTmp = [tmp trim];
        if([str isEqualToString:trimTmp]) {
            need = YES;
            break;
        }
    }
    return need;
}

+ (NSArray *)wordsInText:(NSString *)text {
    NSArray *result = [text componentsSeparatedByString:@" "];
    
    return result;
}

/* for chatting */
+ (NSString *)formatSentDate:(NSDate *)sentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy @ h:mm a"];
    return [formatter stringFromDate:sentDate];
}

/* for time */
+ (NSString *)shortTime:(NSString *)timeString {
    NSString *result = @"";
    if(timeString.length > 0) {
        NSArray *components = [timeString componentsSeparatedByString:@" "];
        if (components.count > 1) {
            NSString *type = [components[1] lowercaseString];
            if([type containString:@"second"]) {
                type = @"sec";
            } else if ([type containString:@"minute"]) {
                type = @"min";
            } else if ([type containString:@"hour"]) {
                type = @"hr";
            } else if ([type containString:@"day"]) {
                type = @"day";
            } else if ([type containString:@"week"]) {
                type = @"wk";
            } else if ([type containString:@"month"]) {
                type = @"mon";
            } else if ([type containString:@"year"]) {
                type = @"yr";
            }
            result = [NSString stringWithFormat:@"%@%@", components[0], type];
        }
    }
    return result;
}

/* Conver hexa string to int */
+ (int)intValueWithHexaString:(NSString *)hexaString {
    unsigned int outVal;
    
    NSScanner* scanner = [NSScanner scannerWithString:hexaString];
    [scanner scanHexInt:&outVal];
    
    return outVal;
}

/* Encrypt */
+ (NSString *)sha512:(NSString *)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
    return input;
}

+ (NSString *)sizeToString:(double)convertedValue {
    
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes", @"KB", @"MB", @"GB", @"TB", nil];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

/*----------------------------------------------------------------------------
 Method:      sizeForText:label:
 Calculate size for text with font and line break mode
 -----------------------------------------------------------------------------*/
+ (CGSize)sizeForText:(NSString *)text label:(UILabel *)label {
    CGRect rect = label.frame;
    CGSize size = CGSizeZero;
    
    if(SupportiOS7) {
        /// Make a copy of the default paragraph style
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        
        /// Set text alignment
        paragraphStyle.alignment = label.textAlignment;
        
        NSDictionary *attributes = @{ NSFontAttributeName: label.font,
                                      NSParagraphStyleAttributeName: paragraphStyle };
        
        size = [text boundingRectWithSize:CGSizeMake(rect.size.width, MAXFLOAT)
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attributes
                                  context:nil].size;
        
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_7_0
        size = [text sizeWithFont:label.font
                constrainedToSize:CGSizeMake(rect.size.width, MAXFLOAT)
                    lineBreakMode:label.lineBreakMode];
#endif
    }
    return size;
}

+ (NSString *)convertArray:(NSArray *)objs
toStringWithSeperateString:(NSString *)string
                usingBlock:(NSString *(^)(id obj))block {
    __block NSString *result = @"";
    [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(idx == (objs.count - 1)) {
            result = [result stringByAppendingString:block(obj)];
        } else {
            result = [result stringByAppendingFormat:@"%@%@", block(obj), string];
        }
    }];
    return result;
    
}

+ (NSString *)convertArray:(NSArray *)objs toStringWithSeperateCommaUsingBlock:(NSString *(^)(id obj))block {
    return [Utils convertArray:objs
    toStringWithSeperateString:@","
                    usingBlock:block];
}

+ (NSString *)valueToString:(double)convertedValue {
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"", @"K", @"M", nil];
    
    while (convertedValue > 1000) {
        convertedValue /= 1000;
        multiplyFactor++;
    }
    
    NSInteger value = convertedValue;
    if(convertedValue - value > 0) {
        return [NSString stringWithFormat:@"4.2%f %@", convertedValue, [tokens objectAtIndex:multiplyFactor]];
    } else {
        return [NSString stringWithFormat:@"%ld %@", (long)value, [tokens objectAtIndex:multiplyFactor]];
    }
}

@end
