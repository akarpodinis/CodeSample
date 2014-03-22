//
//  FibonacciLandingViewTableViewCell.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/21/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "FibonacciLandingViewTableViewCell.h"

@implementation FibonacciLandingViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        // Initialization code
    }
    
    return self;
}

- (void) applyConfiguration:(NSDictionary *)configuration {
    
    [super applyConfiguration:configuration];
    
    // TODO load a bit of flavor stuff about what's happened with Fibonacci so far
    // Ideas include how many computations have been done and displayed and what the highest number calculated is
}

@end
