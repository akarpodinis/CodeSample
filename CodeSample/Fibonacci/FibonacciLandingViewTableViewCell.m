//
//  FibonacciLandingViewTableViewCell.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/21/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "FibonacciLandingViewTableViewCell.h"
#import "CodeSampleStatusTracking.h"

@interface FibonacciLandingViewTableViewCell ()

@property (nonatomic, assign) CGPoint detailTextLabelOriginalCenter;

@end

@implementation FibonacciLandingViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if ( self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] ) {

    }
    
    return self;
}

- (void) applyConfiguration:(NSDictionary *)configuration {
    
    [super applyConfiguration:configuration];
    
    Class<CodeSampleStatusTracking> targetClass = NSClassFromString(configuration[kTableViewTargetViewControllerClassNameKey]);
    
    self.detailTextLabel.text = [targetClass formattedStatus];
    self.detailTextLabel.font = [UIFont italicSystemFontOfSize:8.0f];
    self.detailTextLabel.textColor = [UIColor blueColor];
}

- (BOOL) prepareForAnimation {
    
    if (!CGPointEqualToPoint(self.detailTextLabel.center, self.detailTextLabelOriginalCenter)) {
        self.detailTextLabel.alpha = 0.0f;
        self.detailTextLabelOriginalCenter = self.detailTextLabel.center;
        self.detailTextLabel.center = CGPointMake(self.detailTextLabel.center.x + 25, self.detailTextLabel.center.y);
        return YES;
    } else {
        return NO;
    }}

- (void) animateIn {
    
    [UIView animateWithDuration:kLandingViewCellTotalAnimationTime
                          delay:0.25f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.detailTextLabel.alpha = 1.0f;
                         self.detailTextLabel.center = self.detailTextLabelOriginalCenter;
                     }
                     completion:NULL];
}

@end
