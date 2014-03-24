//
//  FibonacciCalculationOperation.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/23/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "FibonacciCalculationOperation.h"

@implementation FibonacciCalculationOperation

- (instancetype) initWithDelegate:(id<FibonacciCalculationOperationDelegate>)delegate {
    
    if ( self = [super init] ) {
        _delegate = delegate;
    }
    
    return self;
}

- (void) main {
    
    if (!self.delegate) {
        [self cancel];
    }
    
    for (NSInteger i = 0; i < INT_MAX; i++) {
        NSDate *startTime = [NSDate date];
        
        NSInteger calculatedNumber = [self fibonacci:i];
        
        FibonacciResult *result = [[FibonacciResult alloc] initWithCalculationTime:[[NSDate date] timeIntervalSinceDate:startTime]
                                                                             index:@(i)
                                                                            number:@(calculatedNumber)];

        if (![self isCancelled]) {
            [self.delegate fibonacciCalculationOperation:self didCalculateResult:result];
        }
    }
}

- (NSInteger) fibonacci:(NSInteger)number {
    
    if ([self isCancelled]) {
        return 0;
    } else {
        return ( number < 2 ? 1 : [self fibonacci:number - 1] + [self fibonacci:number - 2] );
    }
}

@end
