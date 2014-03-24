//
//  BloomFilterComputationOperation.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/24/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "BloomOperation.h"
#import "BloomFilter.h"

@interface BloomFilterComputationOperation : BloomOperation

@property (nonatomic, readonly, strong) BloomFilter *filter;

- (instancetype) initWithSourceURLString:(NSString *)sourceURLString bitWidth:(NSUInteger)width numberOfHashes:(NSUInteger)hashes;

@end
