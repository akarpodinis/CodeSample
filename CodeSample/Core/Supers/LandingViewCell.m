//
//  LandingViewCell.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/21/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "LandingViewCell.h"

@implementation LandingViewCell

- (void) applyConfiguration:(NSDictionary *)configuration {
    
    self.textLabel.text = configuration[kTableViewCellTextNameKey];
}

@end
