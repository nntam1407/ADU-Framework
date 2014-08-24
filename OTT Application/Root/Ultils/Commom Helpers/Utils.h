/*============================================================================
 PROJECT: SportLocker
 FILE:    Ultils.h
 AUTHOR:  Nguyen Quang Khai
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/

#import <Foundation/Foundation.h>

/*============================================================================
 MACRO
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

/*----------------------------------------------------------------------------
 Interface:   Ultils
 -----------------------------------------------------------------------------*/
@class User;
@interface Utils : NSObject

+ (void)showAlertWithMessage:(NSString*)mess;
+ (void)showConfirmAlertWithMessage:(NSString *)mess delegate:(id)delegate;
+ (NSString *)base64forData:(NSData*)theData;

/* for Images */
+ (UIImage *)stretchImagedName:(NSString *)imageName leftPadding:(CGFloat)leftPadding topPadding:(CGFloat)padding;
+ (UIImage *)stretchImagedName:(NSString *)imageName topPadding:(CGFloat)padding;
+ (UIImage *)middleStretchImagedName:(NSString *)imageName;
+ (UIImage *)tiledImageName:(NSString *)imageName edgeInset:(UIEdgeInsets)inset;
+ (UIColor *)colorFromHexaCode:(NSString *)haxaStr;
+ (UIImage *)imageFromColor:(UIColor *)color;

/* Handle deprecations */
+ (CGSize)constrainedBoundsForText:(NSString *)text
                              font:(UIFont *)font
                     lineBreakMode:(NSInteger)lineBreakMode
                     textAlignment:(NSInteger)textAlignment
                         limitSize:(CGSize)limitSize;

/* for align control */
typedef enum {
    AutoFitSizeWidth,
    AutoFitSizeHeight,
    AutoFitSizeBoth
} AutoFitSize;

+ (CGSize)constrainSizeForLabel:(UILabel *)label autoFitSize:(AutoFitSize)mode;
+ (CGSize)constrainSizeForControl:(UIView *)label autoFitSize:(AutoFitSize)mode;

/* Show loading indicator */
+ (void)showNetworkActivityIndicator;
+ (void)hideNetworkActivityIndicator;

/* for emergency */
+ (BOOL)isText:(NSString *)text includedInArray:(NSMutableArray *)arr;
+ (NSArray *)wordsInText:(NSString *)text;

/* for chatting */
+ (NSString *)formatSentDate:(NSDate *)sentDate;

/* for time */
+ (NSString *)shortTime:(NSString *)timeString;

/* Conver hexa string to int */
+ (int)intValueWithHexaString:(NSString *)hexaString;

/* for encrypt */
+ (NSString *)sha512:(NSString *)input;

/* for oauth */
+ (NSString *)appendParams:(NSMutableDictionary *)params;
+ (NSString *)AFNounce;
+ (NSString *)AFHMACSHA1Signature:(NSURLRequest *)request
                   consumerSecret:(NSString *)consumerSecret
                      tokenSecret:(NSString *)tokenSecret
                   stringEncoding:(NSStringEncoding)stringEncoding;


/* get crc32 of file */
//+ (uint32_t)CRC32ValueWithData:(NSData *)data;
//+ (UInt32)getCrc32:(NSData *)data;
+ (NSString *)sizeToString:(double)convertedValue;
+ (CGSize)sizeForText:(NSString *)text label:(UILabel *)label;

+ (NSString *)convertArray:(NSArray *)objs
toStringWithSeperateString:(NSString *)string
                usingBlock:(NSString *(^)(id obj))block;

+ (NSString *)convertArray:(NSArray *)objs toStringWithSeperateCommaUsingBlock:(NSString *(^)(id obj))block;
+ (NSString *)valueToString:(double)convertedValue;

@end
