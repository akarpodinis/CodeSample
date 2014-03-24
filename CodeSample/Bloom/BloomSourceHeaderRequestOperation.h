//
//  BloomSourceHeaderRequestOperation.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/24/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "BloomOperation.h"

@interface BloomSourceHeaderRequestOperation : BloomOperation

@property (nonatomic, readonly, strong) NSDictionary *headers;

@end
