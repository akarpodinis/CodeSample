//
//  CodeSampleAlertView.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/23/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "CodeSampleAlertView.h"

@interface CodeSampleAlertView () <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *actionArray;

@end

@implementation CodeSampleAlertView

- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    
    if ( self = [super initWithTitle:title
                             message:message
                            delegate:self
                   cancelButtonTitle:cancelButtonTitle
                   otherButtonTitles:nil] ) {
        
        if (cancelButtonTitle) {
            _actionArray = [[NSArray alloc] initWithObjects:[NSNull null], nil];
        } else {
            _actionArray = [[NSArray alloc] init];
        }
    }
    
    return self;
}

- (NSInteger) addButtonWithTitle:(NSString *)title action:(void (^)(UIAlertView *alertView))action {

    NSAssert(action, @"Action for button cannot be NULL.  Use -addButtonWithTitle: instead.");
    
    @synchronized(@"CodeSampleAlertView.addButtonWithTitle:action:.lock") {
        
        self.actionArray = [self.actionArray arrayByAddingObject:action];

        NSInteger addedIndex = [self addButtonWithTitle:title];
        
        if (self.delegate && self.delegate != self) {
            return addedIndex;
        }
        
        self.delegate = self;
        
        return self.numberOfButtons - 1;
    }
}

#pragma mark - UIAlertView overrides

- (NSInteger) addButtonWithTitle:(NSString *)title {
    
    NSInteger newButtonIndex = [super addButtonWithTitle:title];
    
    @synchronized(@"CodeSampleAlertView.addButtonWithTitle:.lock") {
        if (newButtonIndex != self.numberOfButtons - 1) {
            self.actionArray = [self.actionArray arrayByAddingObject:[NSNull null]];
        }
        
        return newButtonIndex;
    }
}

#pragma mark - UIAlertViewDelegate implementation

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    id potentialBlock = self.actionArray[buttonIndex];
    
    if ([potentialBlock isKindOfClass:[NSNull class]]) {
        self.delegate = nil;
        
        if (self.completion) {
            self.completion(self);
        }
        
        return;
    }
    
    void (^block) (UIAlertView *alertView) = potentialBlock;
    
    if (block) {
        block(self);
    }
    
    self.delegate = nil;
    
    if (self.completion) {
        self.completion(self);
    }
}

@end
