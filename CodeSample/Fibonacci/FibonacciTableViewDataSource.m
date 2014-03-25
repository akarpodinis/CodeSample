//
//  FibonacciTableViewDataSource.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/23/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "FibonacciTableViewDataSource.h"
#import "FibonacciCalculationOperation.h"

NSString *const kFibonacciResultCellReuseIdentifier = @"kFibonacciResultCellReuseIdentifier";

@interface FibonacciTableViewDataSource () <FibonacciCalculationOperationDelegate>

@property (nonatomic, strong) NSOperationQueue *calculationQueue;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, assign) NSInteger currentlyCalculatingIndex;

@property (nonatomic, strong) UITableViewCell *calculatingCell;

@end

@implementation FibonacciTableViewDataSource

- (instancetype) initWithDelegate:(id<FibonacciTableViewDataSourceCalculationDelegate>)delegate {
    
    if ( self = [super init] ) {
        
        _calculationQueue = [[NSOperationQueue alloc] init];
        _currentlyCalculatingIndex = 0;
        _results = [[NSMutableArray alloc] init];
        
        _delegate = delegate;
    }
    
    return self;
}

- (void) startCalculation {
    
    self.currentlyCalculatingIndex = 0;
    
    FibonacciCalculationOperation *operation = [[FibonacciCalculationOperation alloc] init];
    
    operation.delegate = self;
    
    [self.calculationQueue addOperation:operation];
}

- (FibonacciResult *) stopCalculation {
    
    [self.calculationQueue cancelAllOperations];
    
    FibonacciResult *lastResult = [self.results lastObject];
    
    return lastResult;
}

#pragma mark - UITableViewDataSource implementation

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.results count] + 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.currentlyCalculatingIndex) {
        if (!self.calculatingCell) {
            self.calculatingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            self.calculatingCell.accessoryView = activityIndicator;
            [activityIndicator startAnimating];
            
            self.calculatingCell.textLabel.text = @"Calculating...";
        }
        
        return self.calculatingCell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFibonacciResultCellReuseIdentifier];
        
        cell.textLabel.text = [self.results[indexPath.row] description];
        
        return cell;
    }
}

#pragma mark - FibonacciCalculationOperationDelegate implementation

- (void) fibonacciCalculationOperation:(FibonacciCalculationOperation *)operation didCalculateResult:(FibonacciResult *)result {
    
    [self.results addObject:result];
    
    self.currentlyCalculatingIndex = [result.index intValue] + 1;
    
    [self.delegate dataSource:self didUpdateDatasetWithResult:result atIndexPath:[NSIndexPath indexPathForRow:[result.index intValue] inSection:0]];
}

@end
