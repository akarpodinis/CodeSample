//
//  BloomOperation.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/24/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "BloomOperation.h"

@implementation BloomOperation

- (instancetype) initWithSourceURLString:(NSString *)sourceURLString {
    
    if ( self = [super init] ) {
        
        _sourceURL = [NSURL URLWithString:[sourceURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        if (!_sourceURL) {
            return nil;
        }
    }
    
    return self;
}

@end
