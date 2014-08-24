/*=============================================================================
 PROJECT: SportLocker
 FILE:    string.h
 AUTHOR:  Mai Trung Tin
 =============================================================================*/
#ifndef _STRING_H_H_
#define _STRING_H_H_

/*=============================================================================
 FUNCTION DEFINITION
 =============================================================================*/
/*=============================================================================
 MACRO DEFINITION
 =============================================================================*/
#define StrNew()                        [NSMutableString string]
#define Str4Str(s)                      [NSString stringWithString:s]
#define Str4Fmt(f,_o_...)               [NSString stringWithFormat:f,_o_]

#define IsString(a)                     [a isKindOfClass:[NSString class]]
#define StrIsEqual(a,b)                 [a isEqualToString:b]

#define Str2Int(a)                      [a intValue]
#define Str2Double(a)                   [a doubleValue]
#define Str2Float(a)                    [a floatValue]
#define Str2LongLong(a)                 [a longLongValue]
#define Str2Bool(a)                     [a boolValue]

//#define Str4ChrInt(d)                   strSwap([[[NSString alloc] initWithBytes:((char*)&d) length:sizeof(d) encoding:NSASCIIStringEncoding] autorelease])

#define Str4Chrs(c,l)                   [[[NSString alloc] initWithBytes:((char*)c) length:l encoding:NSASCIIStringEncoding] autorelease]


#define StrLen(a)                       (IsString(a)? [a length] : 0)
#define StrHasTxt(a)                    (0 < StrLen(a))

#define StrRemSpace(a)                  [a stringByReplacingOccurrencesOfString:@" " withString:@""]

#define Str2Rect(a)                     [a CGRectValue]

#define Str2URL(a)                      [NSURL URLWithString:Str4AddPercent(a)]
#define Str4RepPercent(a)               [a stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define Str4AddPercent(a)               [a stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define Str2CompByStr(a,s)              [a componentsSeparatedByString:s]

/* file path */
#define Str4AppendPath(a,s)             [a stringByAppendingPathComponent:s]


#define StrAppend(a,s)                  [a appendString:s]


#endif  /* _STRING_H_H_ */
