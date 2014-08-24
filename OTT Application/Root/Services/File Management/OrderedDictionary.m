//
//  OrderedDictionary.m
//  OrderedDictionary
//
//  Created by Matt Gallagher on 19/12/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#import "OrderedDictionary.h"

NSString *DescriptionForObject(NSObject *object, id locale, NSUInteger indent) {
	NSString *objectString;
    
	if ([object isKindOfClass:[NSString class]]) {
		objectString = (NSString *)[[object retain] autorelease];
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
		objectString = [(NSDictionary *)object descriptionWithLocale:locale indent:indent];
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:)]) {
		objectString = [(NSSet *)object descriptionWithLocale:locale];
	}
	else {
		objectString = [object description];
	}
	return objectString;
}

@implementation OrderedDictionary
@synthesize dictionary, array;

- (id)init {
	return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)capacity {
	self = [super init];
    
	if (self != nil) {
		self.dictionary = [[[NSMutableDictionary alloc] initWithCapacity:capacity] autorelease];
		self.array = [[[NSMutableArray alloc] initWithCapacity:capacity] autorelease];;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
	if (self != nil) {
		self.dictionary = [aDecoder decodeObjectForKey:@"dictionary"];
		self.array = [aDecoder decodeObjectForKey:@"array"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:dictionary forKey:@"dictionary"];
    [aCoder encodeObject:array forKey:@"array"];
}

- (void)dealloc {
	[dictionary release];
	[array release];
	[super dealloc];
}

- (id)copy {
	return [self mutableCopy];
}

- (void)setObject:(id)anObject forKey:(id)aKey {
	if (![dictionary objectForKey:aKey]) {
		[array addObject:aKey];
	}
	[dictionary setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey {
	[dictionary removeObjectForKey:aKey];
	[array removeObject:aKey];
}

- (NSUInteger)count {
    if(dictionary) {
        return [dictionary count];
    }
    return 0;
}

- (void)removeAllObjects {
    [dictionary removeAllObjects];
    [array removeAllObjects];
}

- (id)objectForKey:(id)aKey {
	return [dictionary objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator {
	return [array objectEnumerator];
}

- (NSEnumerator *)reverseKeyEnumerator {
	return [array reverseObjectEnumerator];
}

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex {
	if ([dictionary objectForKey:aKey]) {
		[self removeObjectForKey:aKey];
	}
	[array insertObject:aKey atIndex:anIndex];
	[dictionary setObject:anObject forKey:aKey];
}

- (id)keyAtIndex:(NSUInteger)anIndex {
	return [array objectAtIndex:anIndex];
}

- (id)objectAtIndex:(NSUInteger)index {
    if(index < self.count) {
        return [self objectForKey:[self keyAtIndex:index]];
    }
    return nil;
}

- (void)addObjectsFromDictionary:(OrderedDictionary *)dict {
    if(dict.count > 0) {
        [dictionary addEntriesFromDictionary:dict.dictionary];
        [array addObjectsFromArray:dict.array];
    }
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
	NSMutableString *indentString = [NSMutableString string];
	NSUInteger i, count = level;
    
	for (i = 0; i < count; i++) {
		[indentString appendFormat:@"    "];
	}
	
	NSMutableString *description = [NSMutableString string];
	[description appendFormat:@"%@{\n", indentString];
    
	for (NSObject *key in dictionary) {
		[description appendFormat:@"%@    %@ = %@;\n",
         indentString,
         DescriptionForObject(key, locale, level),
         DescriptionForObject([self objectForKey:key], locale, level)];
	}
	[description appendFormat:@"%@}\n", indentString];
	return description;
}

@end
