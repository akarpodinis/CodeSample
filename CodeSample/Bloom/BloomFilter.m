//
//  BloomFilter.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/24/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "BloomFilter.h"

@interface BloomFilter ()

@property (nonatomic, assign) NSUInteger bitWidth;
@property (nonatomic, assign) NSUInteger numberOfHashes;
@property (nonatomic, assign) CFMutableBitVectorRef bits;
@property (nonatomic, assign) NSUInteger count;

@end

@implementation BloomFilter

- (instancetype) initWithBitWidth:(NSUInteger)width numberOfHashes:(NSUInteger)hashes {
    
    if ( self = [super init] ) {
        
        _bitWidth = width;
        _numberOfHashes = hashes;
        _bits = CFBitVectorCreateMutable(kCFAllocatorDefault, 0);
        CFBitVectorSetAllBits(_bits, 0);
        CFBitVectorSetCount(_bits, width);
    }
    
    return self;
}

- (void) addValueToFilter:(NSString *)value {
    
    NSDecimalNumber *hashAsString = [[NSDecimalNumber alloc] initWithString:[value md5Hash]];
    
    uint32_t lastHash = [hashAsString unsignedIntegerValue];
    
    for (int i = 0; i < self.numberOfHashes; i++) {
        CFBitVectorSetBitAtIndex(self.bits, (lastHash % self.bitWidth), 1);
        
        NSDecimalNumber *newHash = [[NSDecimalNumber alloc] initWithString:[value md5HashWithSalt:[hashAsString stringValue]]];
        
        lastHash = [newHash unsignedIntegerValue];
    }
    
    self.count += 1;
}

- (BOOL) lookUp:(NSString *)value {
    
    BOOL found = NO;
    
    BOOL foundWord = YES;

    NSDecimalNumber *hashAsString = [[NSDecimalNumber alloc] initWithString:[value md5Hash]];
    
    uint32_t lastHash = [hashAsString unsignedIntegerValue];

    for (int i = 0; i < self.numberOfHashes; i++) {
        foundWord = foundWord && CFBitVectorGetBitAtIndex(self.bits, (lastHash % self.bitWidth));
        
        if(!foundWord) {
            break;
        } else {
            NSDecimalNumber *newHash = [[NSDecimalNumber alloc] initWithString:[value md5HashWithSalt:[hashAsString stringValue]]];
            lastHash = [newHash unsignedIntegerValue];
        }
    }

    return found;
}

// Derived using the following formula, which is used to calculate the number of bits needed for a given filter:
// m = -n*ln(p) / (ln(2)^2)
// m = number of bits in the filter
// n = number of items in the filter
// p = false positive rate
// ln = natual log
- (CGFloat) falsePositiveProbability {
    
    return exp( (log(2) * 2 * self.bitWidth) / (self.count * -1) );
}

@end
