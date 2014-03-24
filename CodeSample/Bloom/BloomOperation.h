//
//  BloomOperation.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/24/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BloomOperationDelegate;

/**
 Abstract-ish class representing general Bloom related operations.
 */
@interface BloomOperation : NSOperation

@property (nonatomic, weak) id<BloomOperationDelegate> delegate;
@property (nonatomic, assign) NSInteger currentStep;
@property (nonatomic, assign) NSInteger totalSteps;
@property (nonatomic, strong) NSURL *sourceURL;

/**
 @brief The designated initializer for this class.
 @return A valid instance of a BloomOperation, or \p nil if the \p sourceURLString could not be parsed into a URL
 */
- (instancetype) initWithSourceURLString:(NSString *)sourceURLString;

@end

@protocol BloomOperationDelegate

/**
 @brief Communicates to the delegate object that the specified operation advanced to the specified step.
 @param operation The \p BloomOperation object in question
 @param stepName The human-readable name of the currently-executing step
 @param index The index of the currently-executing step, less than or equal to \p totalSteps
 */
- (void) operation:(BloomOperation *)operation didAdvanceToStepName:(NSString *)stepName stepIndex:(NSInteger)index;

/**
 @brief Communicates to the delegate object that the specified operation completed a specified percentage of the current operational step.
 @param operation The \p BloomOperation object in question
 @param percent A value less than 1 indicating the percentage currently completed of the current operational step
 */
- (void) operation:(BloomOperation *)operation didProgressToCompletion:(double)percent;

/**
 @brief Communicates to the delegate object that the specified operation failed with the specified error
 @param operation The \p BloomOperation object in question
 @param error The error that is the cause for the failure of the operation
 */
- (void) operation:(BloomOperation *)operation didFailWithError:(NSError *)error;

@end
