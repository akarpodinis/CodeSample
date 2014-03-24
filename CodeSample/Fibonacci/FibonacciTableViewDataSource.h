//
//  FibonacciTableViewDataSource.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/23/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FibonacciResult.h"

extern NSString *const kFibonacciResultCellReuseIdentifier;

@protocol FibonacciTableViewDataSourceCalculationDelegate;

@interface FibonacciTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, weak) id<FibonacciTableViewDataSourceCalculationDelegate> delegate;

/**
 @brief The designated initializer for this class.
 */
- (instancetype) initWithDelegate:(id<FibonacciTableViewDataSourceCalculationDelegate>)delegate;

/**
 @brief Starts the process of calculating Fibonacci numbers, starting from 0 to INT_MAX.
 */
- (void) startCalculation;

/**
 @brief Terminates the process of calculating Fibonacci numbers.
 @return The last completely calculated Fibonacci number packaged as a \p Fibonacci result
 */
- (FibonacciResult *) stopCalculation;

@end

@protocol FibonacciTableViewDataSourceCalculationDelegate

/**
 @brief Communicates back up to the table view controller that the data has been updated and the table should have it's data reloaded.
 @param dataSource The data source sending the delegate messages
 @param result The result that was recently added
 @param indexPath The index path that the result can be found at
 */
- (void) dataSource:(FibonacciTableViewDataSource *)dataSource didUpdateDatasetWithResult:(FibonacciResult *)result atIndexPath:(NSIndexPath *)indexPath;

@end
