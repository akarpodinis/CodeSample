//
//  FibonacciResult.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/23/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "FibonacciResult.h"

NSString *const kFibonacciResultCalculationTimeKey = @"kFibonacciResultCalculationTimeKey";
NSString *const kFibonacciResultIndexKey = @"kFibonacciResultIndexKey";
NSString *const kFibonacciResultNumberKey = @"kFibonacciResultNumberKey";

@implementation FibonacciResult

- (instancetype) initWithCalculationTime:(NSTimeInterval)calculationTime index:(NSNumber *)index number:(NSNumber *)number {
    
    if ( self = [super init] ) {
        
        _calculationTime = calculationTime;
        _index = index;
        _number = number;
    }
    
    return self;
}

- (NSComparisonResult) compare:(FibonacciResult *)other {
    
    NSComparisonResult indexComparisonResult = [self.index compare:other.index];
    
    if (indexComparisonResult == NSOrderedSame) {
        return [@(other.calculationTime) compare:@(self.calculationTime)];  // Order here is reversed, see header for explanation
    } else {
        return indexComparisonResult;
    }
}

#pragma mark - NSSecureCoding implementation

+ (BOOL) supportsSecureCoding {
    
    return YES;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    if ( self = [super init] ) {
        _calculationTime = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:kFibonacciResultCalculationTimeKey] doubleValue];
        _index = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kFibonacciResultIndexKey];
        _number = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:kFibonacciResultNumberKey];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:@(self.calculationTime) forKey:kFibonacciResultCalculationTimeKey];
    [aCoder encodeObject:self.index forKey:kFibonacciResultIndexKey];
    [aCoder encodeObject:self.number forKey:kFibonacciResultNumberKey];
}

#pragma mark - Superclass overrides

- (NSString *) description {
    
    return [NSString stringWithFormat:@"F(%ld) = %ld (%f sec)", (long)[_index integerValue], (long)[_number integerValue], _calculationTime];
}

@end
