//
//  BloomFilter.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/24/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloomFilter : NSObject

/**
 The designated initializer for this class.
 @param width The width of the bit array to store hits in
 @param hashes The number of times to hash
 */
- (instancetype) initWithBitWidth:(NSUInteger)width numberOfHashes:(NSUInteger)hashes;

/**
 @brief Adds the specified string value to the filter.
 @param value The string to add to the filter
 */
- (void) addValueToFilter:(NSString *)value;

/**
 @brief Check to see if the specified string may be present in the filter.
 @note Bloom filters guarnatee that a return of \p NO indicates that the value is NOT in the data set.  A return of \p YES indicates that the value is
PROBABLY in the data set.
 @return \p YES if the value may be found in the data set, \p NO otherwise
 */
- (BOOL) lookUp:(NSString *)value;

/**
 @brief Calculates the probability that any value looked up in the filter will be a false positive.
 @return A number less than 1 indicating the percent chance than a lookup will be a false positive.
 */
- (CGFloat) falsePositiveProbability;

@end
