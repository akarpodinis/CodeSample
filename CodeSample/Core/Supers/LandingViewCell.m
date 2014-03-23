//
//  LandingViewCell.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/21/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "LandingViewCell.h"

NSTimeInterval const kLandingViewCellTotalAnimationTime = 0.75f;

@implementation LandingViewCell

- (void) applyConfiguration:(NSDictionary *)configuration {
    
    self.textLabel.text = configuration[kTableViewCellTextNameKey];
}

- (BOOL) prepareForAnimation {
    
    return NO;
}

- (void) animateIn {
    
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    if ([self prepareForAnimation]) {
        [self animateIn];
    }
}

@end
