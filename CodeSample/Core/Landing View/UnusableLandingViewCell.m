//
//  UnusableLandingViewCell.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/21/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "UnusableLandingViewCell.h"

@implementation UnusableLandingViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ( self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
}

- (void) applyConfiguration:(NSDictionary *)configuration {
    
    [super applyConfiguration:configuration];
    
    self.textLabel.font = [UIFont italicSystemFontOfSize:14.0f];
    self.textLabel.textColor = [UIColor grayColor];
    
    self.detailTextLabel.font = [UIFont italicSystemFontOfSize:8.0f];
    self.detailTextLabel.textColor = [UIColor redColor];
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"There's a problem loading the configuration for class %@.", configuration[kTableViewCellClassNameKey]];
}

@end
