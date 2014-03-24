//
//  BloomSourceTableViewController.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/23/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "BloomSourceTableViewController.h"
#import "BloomSourceDataSource.h"
#import "CodeSampleStatusTracking.h"
#import "BloomSourceCell.h"

NSString *const kBloomSourceShouldSkipSummaryKey = @"kBloomSourceShouldSkipSummaryKey";
NSString *const kBloomSourceSummaryFilename = @"About_Bloom";
NSString *const kBloomSourceSummaryFileExtension = @"txt";

@interface BloomSourceTableViewController () <CodeSampleStatusTracking, UITableViewDelegate>

@property (nonatomic, strong) BloomSourceDataSource *bloomSourceDataSource;

@end

@implementation BloomSourceTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    
    if ( self = [super initWithStyle:style] ) {

    }
    
    return self;
}

#pragma mark - Superclass overrides

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    self.bloomSourceDataSource.editing = editing;
    
    NSArray *pathForInsertRow = @[[NSIndexPath indexPathForRow:[self.bloomSourceDataSource.sourcesLoadedFromDisk count] inSection:0]];
    
    if (editing) {
        [self.tableView insertRowsAtIndexPaths:pathForInsertRow withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [self.tableView deleteRowsAtIndexPaths:pathForInsertRow withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView registerClass:[BloomSourceCell class] forCellReuseIdentifier:kBloomSourceDataSourceCellReuseIdentifier];
    
    self.bloomSourceDataSource = [[BloomSourceDataSource alloc] init];
    self.tableView.dataSource = self.bloomSourceDataSource;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Dictionary source";
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kBloomSourceShouldSkipSummaryKey]) {
        NSURL *aboutURL = [[NSBundle mainBundle] URLForResource:kBloomSourceSummaryFilename withExtension:kBloomSourceSummaryFileExtension];
        
        NSString *message = [NSString stringWithContentsOfURL:aboutURL
                                                 usedEncoding:NULL
                                                        error:NULL];
        
        CodeSampleAlertView *alert = [[CodeSampleAlertView alloc] initWithTitle:@"Bloom filters"
                                                                        message:message
                                                              cancelButtonTitle:@"OK"];
        
        [alert addButtonWithTitle:@"Don't show again" action:^(UIAlertView *alertView) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kBloomSourceShouldSkipSummaryKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        
        [alert setCompletion:^(UIAlertView *alertView) {
//            [self.fibonacciDataSource startCalculation];
        }];
        
        [alert show];
    } else {
//        [self.fibonacciDataSource startCalculation];
    }
}

#pragma mark - CodeSampleStatusTracking implementation

+ (NSString *) formattedStatus {
    return nil;
}

+ (void) clearStatus {
    
}

#pragma mark - UITableViewDelegate implementation

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.editing && indexPath.row == [self.bloomSourceDataSource.sourcesLoadedFromDisk count]) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return [self.bloomSourceDataSource.sourcesLoadedFromDisk[indexPath.row][kBloomSourceDataSourceDeletableKey] boolValue];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row >= [self.bloomSourceDataSource.sourcesLoadedFromDisk count]) {
        return [NSIndexPath indexPathForRow:[self.bloomSourceDataSource.sourcesLoadedFromDisk count] - 1 inSection:proposedDestinationIndexPath.section];
    } else {
        return proposedDestinationIndexPath;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.editing) {
        return;
    }
    
    
}

@end
