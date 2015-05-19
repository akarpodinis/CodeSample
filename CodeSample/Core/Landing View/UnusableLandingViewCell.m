//
//  UnusableLandingViewCell.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/21/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "UnusableLandingViewCell.h"

@interface UnusableLandingViewCell ()

@property (nonatomic, assign) CGPoint detailTextLabelOriginalCenter;

@end

@implementation UnusableLandingViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ( self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] ) {
        
    }
    
    return self;
}

#pragma mark - Superclass overrides

- (void) applyConfiguration:(NSDictionary *)configuration {
    
    [super applyConfiguration:configuration];
    
    self.textLabel.font = [UIFont italicSystemFontOfSize:14.0f];
    self.textLabel.textColor = [UIColor grayColor];
    
    self.detailTextLabel.font = [UIFont italicSystemFontOfSize:8.0f];
    self.detailTextLabel.textColor = [UIColor redColor];
    
    self.detailTextLabel.text = [NSString stringWithFormat:@"Can't load configuration for class %@.", configuration[kTableViewTargetViewControllerClassNameKey]];
}

- (BOOL) prepareForAnimation {
    
    if (!CGPointEqualToPoint(self.detailTextLabel.center, self.detailTextLabelOriginalCenter)) {
        self.detailTextLabel.alpha = 0.0f;
        self.detailTextLabelOriginalCenter = self.detailTextLabel.center;
        self.detailTextLabel.center = CGPointMake(self.detailTextLabel.center.x + 25, self.detailTextLabel.center.y);
        return YES;
    } else {
        return NO;
    }
}

- (void) animateIn {
    
    [UIView animateWithDuration:kLandingViewCellTotalAnimationTime
                          delay:0.25f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.detailTextLabel.alpha = 1.0f;
                         self.detailTextLabel.center = self.detailTextLabelOriginalCenter;
                     }
                     completion:nil];
}

@end
