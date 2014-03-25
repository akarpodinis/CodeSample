//
//  FibonacciTableViewController.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/22/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "FibonacciTableViewController.h"
#import "FibonacciTableViewDataSource.h"

NSString *const kFibonacciConfigurationShouldSkipSummaryKey = @"kFibonacciConfigurationShouldSkipSummaryKey";
NSString *const kFibonacciTableViewControllerLastResultKey = @"kFibonacciTableViewControllerLastResultKey";

NSString *const kFibonacciAboutFileName = @"About_Fibonacci";
NSString *const kFibonacciAoubtFileExtension = @"txt";

@interface FibonacciTableViewController () <FibonacciTableViewDataSourceCalculationDelegate>

@property (nonatomic, strong) FibonacciTableViewDataSource *fibonacciDataSource;

@end

@implementation FibonacciTableViewController

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Fibonacci numbers";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kFibonacciResultCellReuseIdentifier];
    
    self.fibonacciDataSource = [[FibonacciTableViewDataSource alloc] initWithDelegate:self];
    
    self.tableView.dataSource = self.fibonacciDataSource;
    self.tableView.delegate = self;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kFibonacciConfigurationShouldSkipSummaryKey]) {
        NSURL *aboutURL = [[NSBundle mainBundle] URLForResource:kFibonacciAboutFileName withExtension:kFibonacciAoubtFileExtension];
        
        NSString *message = [NSString stringWithContentsOfURL:aboutURL
                                                 usedEncoding:NULL
                                                        error:NULL];
        
        CodeSampleAlertView *alert = [[CodeSampleAlertView alloc] initWithTitle:@"Fibonacci"
                                                                        message:message
                                                              cancelButtonTitle:@"OK"];

        [alert addButtonWithTitle:@"Don't show again" action:^(UIAlertView *alertView) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFibonacciConfigurationShouldSkipSummaryKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        
        [alert setCompletion:^(UIAlertView *alertView) {
            [self.fibonacciDataSource startCalculation];
        }];
        
        [alert show];
    } else {
        double delayInSeconds = 0.25;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.fibonacciDataSource startCalculation];
        });
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    FibonacciResult *result = [self.fibonacciDataSource stopCalculation];
    
    FibonacciResult *previousResult = [NSKeyedUnarchiver unarchiveObjectWithData:
                                       [[NSUserDefaults standardUserDefaults] objectForKey:kFibonacciTableViewControllerLastResultKey]];
    
    if (!previousResult || [result compare:previousResult] == NSOrderedDescending) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:result] forKey:kFibonacciTableViewControllerLastResultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.fibonacciDataSource = nil;
    self.fibonacciDataSource.delegate = nil;
}

#pragma mark - CodeSampleStatusTracking implementation

+ (NSString *) formattedStatus {
    
    FibonacciResult *result = [NSKeyedUnarchiver unarchiveObjectWithData:
                               [[NSUserDefaults standardUserDefaults] objectForKey:kFibonacciTableViewControllerLastResultKey]];
    
    return [result description];
}

+ (void) clearStatus {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFibonacciTableViewControllerLastResultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - FibonacciTableViewDataSourceCalculationDelegate implementation

- (void) dataSource:(FibonacciTableViewDataSource *)dataSource didUpdateDatasetWithResult:(FibonacciResult *)result atIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;

    dispatch_sync(dispatch_get_main_queue(), ^{
        typeof(self) strongSelf = weakSelf;
        [strongSelf.tableView beginUpdates];
        [strongSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [strongSelf.tableView endUpdates];
    });
}

@end
