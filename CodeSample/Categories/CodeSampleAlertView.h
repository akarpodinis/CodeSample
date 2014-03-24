//
//  CodeSampleAlertView.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/23/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeSampleAlertView : UIAlertView

/**
 @brief A completion handler to invoke as the alert is being dismissed.
 */
@property (nonatomic, copy) void (^completion) (UIAlertView *alertView);

/**
 The designated initializer for this class.
 @param title A title passed through to the super class
 @param message A message passed through to the super class
 @param cancelButtonTitle A cancel button title passed through to the super class
 */
- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

/**
 @brief Adds a button to the alert view and associates a block to execute when the button with the specified title is tapped.  If a delegate is specified when
creating the alert view, the specified block is not invoked and instead the delegate callback is used.  \p action cannot be \p NULL.
 @pre No \p UIAlertViewDelegate has been supplied to the receiver
 @pre \p action cannot be \p NULL
 @param title The text to use as the button title
 @param action A block to invoke when the button with the specified title is tapped
 @return The index of the newly-added button
 */
- (NSInteger) addButtonWithTitle:(NSString *)title action:(void (^)(UIAlertView *alertView))action;

@end
