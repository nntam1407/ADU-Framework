/*============================================================================
 PROJECT: SportLocker
 FILE:    NSMutableArray+Shuffle.m
 AUTHOR:  Khoai Nguyen
 DATE:    6/12/13
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "NSMutableArray+Shuffle.h"

/*============================================================================
 PRIVATE MACRO
 =============================================================================*/
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation NSMutableArray (Shuffle)
- (void)shuffle {
    static BOOL seeded = NO;
    if(!seeded) {
        seeded = YES;
        srandom((unsigned int)time(NULL));
    }
    
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
	