/*=============================================================================
 PROJECT: SportLocker
 FILE:    array.h
 AUTHOR:  Mai Trung Tin
 =============================================================================*/
#ifndef _ARRAY_H_H_
#define _ARRAY_H_H_

/*=============================================================================
 MACRO DEFINITION
 =============================================================================*/
#define IsArray(f)          IsKindOfClass(f,NSArray)

#define ArrNew()            [NSMutableArray array]
#define Arr4Arr(a)          [NSMutableArray arrayWithArray:a]
#define Arr4Objs(_o_...)    [NSMutableArray arrayWithObjects:_o_,nil]

#define ArrRepObj(a,i,o)    [a replaceObjectAtIndex:i withObject:o]
#define ArrInsObj(a,o,i)    [a insertObject:o atIndex:i]

#define ArrCount(a)         [a count]
#define ArrContain(a,o)     [a containsObject:o]
#define ArrAddObj(a,o)      [a addObject:o]
#define ArrRmObj(a,o)       [a removeObject:o]
#define ArrRmIdx(a,i)       [a removeObjectAtIndex:i]
#define ArrClean(a)         [a removeAllObjects]
#define ArrAddArr(a,o)      [a addObjectsFromArray:o]

#define ArrLastObj(a)       [a lastObject]
#define ArrObj4Idx(a,i)     [a objectAtIndex:i]
#define ArrIdx4Obj(a,o)     [a indexOfObject:o]

#endif  /* _ARRAY_H_H_ */
