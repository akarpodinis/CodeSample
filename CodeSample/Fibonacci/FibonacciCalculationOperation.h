//
//  FibonacciCalculationOperation.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/23/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FibonacciResult.h"

@protocol FibonacciCalculationOperationDelegate;

@interface FibonacciCalculationOperation : NSOperation

@property (nonatomic, weak) id<FibonacciCalculationOperationDelegate> delegate;

/**
 @brief The designated initializer for this class.  If at any time the \p delegate is set to \p nil, the operation will cancel itself.
 @param delegate A receiver conforming to the \p FibonacciCalculationOperationDelegate protocol.  Cannot be \p nil.
 */
- (instancetype) initWithDelegate:(id<FibonacciCalculationOperationDelegate>)delegate;

@end

@protocol FibonacciCalculationOperationDelegate

/**
 @brief Delivers a calculated Fibonacci number to the delegate.
 @param operation The \p FibonacciCalculationOperation responsible for the calculation
 @param result The data associated with the completed calculation
 @see FibonacciResult
 */
- (void) fibonacciCalculationOperation:(FibonacciCalculationOperation *)operation didCalculateResult:(FibonacciResult *)result;

@end
