/*=============================================================================
 PROJECT: SportLocker
 FILE:    number.h
 AUTHOR:  Mai Trung Tin
 =============================================================================*/
#ifndef _NUMBER_H_H_
#define _NUMBER_H_H_

/*=============================================================================
 MACRO DEFINITION
 =============================================================================*/
#define ShortSwap(a)          ((a&0xFF00)>>8) | ((a&0x00FF)<<8)
#define LongSwap(a)           (ShortSwap((a&0xFFFF0000)>>16) | ShortSwap((a&0x0000FFFF)<<16)) 

#define IsNumber(n)           IsKindOfClass(n,NSNumber)
#define NumIsEqual(n,m)       (0 == [n compare:m])

#define Num4Int(i)            [NSNumber numberWithInt:i]
#define Num2Int(n)            (IsNumber(n)? [n intValue] : 0)

#define Num4Integer(i)        [NSNumber numberWithInteger:i]
#define Num2Integer(n)        (IsNumber(n)? [n integerValue] : 0)

#define Num4Bool(i)           [NSNumber numberWithBool:i]
#define Num2Bool(n)           (IsNumber(n)? [n boolValue]   : NO  )

#define Num4Float(i)          [NSNumber numberWithFloat:i]
#define Num2Float(n)          (IsNumber(n)? [n floatValue]  : 0.0 )

#define Num4UInt8(i)          [NSNumber numberWithUnsignedChar:i]
#define Num2UInt8(n)          (IsNumber(n)? [n unsignedCharValue] : 0)


#endif  /* _NUMBER_H_H_ */
