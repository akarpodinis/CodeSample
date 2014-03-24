//
//  BloomCruncherViewController.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/24/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "BloomCruncherViewController.h"
#import "BloomSourceHeaderRequestOperation.h"
#import "BloomSourceDownloadOperation.h"
#import "BloomFilterComputationOperation.h"

NSString *const kBloomCruncherNibName = @"BloomCruncherView";

@interface BloomCruncherViewController () <BloomOperationDelegate>

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, assign) NSUInteger totalOperationsNeeded;
@property (nonatomic, copy) NSString *sourceURLString;

@property (nonatomic, strong) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) IBOutlet UIProgressView *overallProgress;
@property (nonatomic, strong) IBOutlet UIProgressView *currentTaskProgress;
@property (nonatomic, strong) IBOutlet UILabel *searchOutputLabel;
@property (nonatomic, strong) IBOutlet UITextField *searchTermInputField;
@property (nonatomic, strong) IBOutlet UIButton *searchButton;

- (void) beginProcess;
- (void) createAndStartBloomComputationWithDependency:(BloomOperation *)dependency;
- (IBAction) searchWithSender:(id)sender;

@end

@implementation BloomCruncherViewController

- (instancetype) initWithSourceURLString:(NSString *)source {
    
    if ( self = [super initWithNibName:kBloomCruncherNibName bundle:nil] ) {
        _sourceURLString = source;
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    [self beginProcess];
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.operationQueue cancelAllOperations];
}

#pragma mark - BloomOperationDelegate implementation

- (void) operation:(BloomOperation *)operation didAdvanceToStepName:(NSString *)stepName stepIndex:(NSInteger)index {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLabel.text = stepName;
        self.currentTaskProgress.progress = 0.0f;
    });
}

- (void) operation:(BloomOperation *)operation didProgressToCompletion:(double)percent {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.overallProgress.progress = percent / self.totalOperationsNeeded;
        self.currentTaskProgress.progress = percent;
    });
    
    if (percent >= 1.0f && [operation isKindOfClass:[BloomSourceHeaderRequestOperation class]]) {
        
        BloomSourceHeaderRequestOperation *headerOperation = (BloomSourceHeaderRequestOperation *)operation;
        
        NSDecimalNumber *contentLength = [NSDecimalNumber decimalNumberWithString:headerOperation.headers[@"Content-Length"]];
        
        BloomSourceDownloadOperation *downloadOperation =
        [[BloomSourceDownloadOperation alloc] initWithSourceURLString:self.sourceURLString
                                                          contentSize:[contentLength unsignedLongLongValue]
                                                     finalDestination:[self localURLForSourceString]];
        downloadOperation.delegate = self;
        
        [self.operationQueue addOperation:downloadOperation];
    } else if (percent >= 1.0f && [operation isKindOfClass:[BloomSourceDownloadOperation class]]) {
        [self createAndStartBloomComputationWithDependency:operation];
    } else {
        // Animate in the search box and output fields
        [UIView animateWithDuration:0.35f animations:^{
            
            self.searchOutputLabel.alpha = 1.0f;
            self.searchTermInputField.alpha = 1.0f;
            self.searchButton.alpha = 1.0f;
        }];
    }
}

- (void) operation:(BloomOperation *)operation didFailWithError:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLabel.text = @"Progress halted";
        [self.operationQueue cancelAllOperations];
    });
    
    CodeSampleAlertView *alert = [[CodeSampleAlertView alloc] initWithTitle:@"Opps"
                                                                    message:error.localizedDescription
                                                          cancelButtonTitle:@"Cancel"];
    
    __weak typeof(self) weakSelf = self;
    
    [alert addButtonWithTitle:@"Try again." action:^(UIAlertView *alertView) {
        [weakSelf beginProcess];
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
    
    NSLog(@"%@", error);
}

#pragma mark - Support

- (void) beginProcess {
    
    self.overallProgress.progress = 0.0f;
    self.currentTaskProgress.progress = 0.0f;
    
    self.progressLabel.text = @"Starting...";
    
    NSError *existsError = nil;
    
    if ([[self localURLForSourceString] checkResourceIsReachableAndReturnError:&existsError]) {
        [self createAndStartBloomComputationWithDependency:nil];
        self.totalOperationsNeeded = 1;
    } else {
        BloomSourceHeaderRequestOperation *headerRequestOp = [[BloomSourceHeaderRequestOperation alloc] initWithSourceURLString:self.sourceURLString];
        
        headerRequestOp.delegate = self;
        
        [self.operationQueue addOperation:headerRequestOp];
        
        self.totalOperationsNeeded = 3;
    }
}

- (void) createAndStartBloomComputationWithDependency:(BloomOperation *)dependency {
    
    BloomFilterComputationOperation *operation = [[BloomFilterComputationOperation alloc] initWithSourceURLString:[[self localURLForSourceString] path]
                                                                                                         bitWidth:10000
                                                                                                   numberOfHashes:3];
    
    operation.delegate = self;
    
    if (dependency) {
        [operation addDependency:dependency];
    }
    
    [self.operationQueue addOperation:operation];
}

- (NSURL *) localURLForSourceString {
    
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *tmpDirURL = [paths lastObject];
    
    tmpDirURL = [tmpDirURL URLByAppendingPathComponent:[self.sourceURLString md5Hash]];
    
    return tmpDirURL;
}

#pragma mark - Actions

- (IBAction) searchWithSender:(id)sender {
    
}

@end
