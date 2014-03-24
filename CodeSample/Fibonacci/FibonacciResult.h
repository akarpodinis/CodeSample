//
//  FibonacciResult.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/23/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FibonacciResult : NSObject <NSSecureCoding>

@property (nonatomic, readonly, assign) NSTimeInterval calculationTime;
@property (nonatomic, readonly, strong) NSNumber *index;
@property (nonatomic, readonly, strong) NSNumber *number;

/**
 @brief The designated inititalizer for this class.
 @param calculationTime The time it took to calculate the specified index
 @param index The index of the number calculated
 @param number The number calculated at the specified index
 */
- (instancetype) initWithCalculationTime:(NSTimeInterval)calculationTime index:(NSNumber *)index number:(NSNumber *)number;

/**
 @brief Compares two \p FibonacciResult objects.  If the reciver's index and the \p other index are equal, the lower \p calculationTime wins out.
 @return An \p NSComparisonResult illustrating the relationship between the receiver and the specified \p FibonacciResult
 */
- (NSComparisonResult) compare:(FibonacciResult *)other;

@end
