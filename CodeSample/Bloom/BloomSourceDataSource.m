//
//  BloomSourceDataSource.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/23/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "BloomSourceDataSource.h"

NSString *const kBloomSourceDataSourceFileName = @"com.karpodinis.resources.BloomSources";
NSString *const kBloomSourceDataSourceFilExtension = @"plist";

NSString *const kBloomSourceDataSourceDeletableKey = @"BloomSourceDeletable";
NSString *const kBloomSourceDataSourceURLKey = @"BloomDictionaryURL";
NSString *const kBloomSourceDataSourceDescriptionKey = @"BloomDictionaryDescription";

NSString *const kBloomSourceDataSourceCellReuseIdentifier = @"kBloomSourceDataSourceCellReuseIdentifier";

NSInteger const kBloomSourceAddNewTag = 1000;

@interface BloomSourceDataSource ()

@property (nonatomic, strong) UITableViewCell *insertionCell;

@end

@implementation BloomSourceDataSource

- (instancetype) init {
    
    if ( self = [super init] ) {
        
        NSURL *onDiskSourceURL = [[NSBundle mainBundle] URLForResource:kBloomSourceDataSourceFileName withExtension:kBloomSourceDataSourceFilExtension];
        
        _sourcesLoadedFromDisk = [NSMutableArray arrayWithContentsOfURL:onDiskSourceURL];
    }
    
    return self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.sourcesLoadedFromDisk count] + ( tableView.editing ? 1 : 0 );
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBloomSourceDataSourceCellReuseIdentifier];
    
    if (tableView.editing && indexPath.row == [self.sourcesLoadedFromDisk count]) {
        
        if (!self.insertionCell) {
            UITextField *input = [[UITextField alloc] initWithFrame:cell.contentView.bounds];
            
            input.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            input.placeholder = @"Tap to add a new source URL...";
            input.adjustsFontSizeToFitWidth = YES;
            input.minimumFontSize = 11.0f;
            input.tag = kBloomSourceAddNewTag;
            input.autocapitalizationType = UITextAutocapitalizationTypeNone;
            input.keyboardType = UIKeyboardTypeURL;
            
            [cell.contentView addSubview:input];
            
            self.insertionCell = cell;
            self.insertionCell.detailTextLabel.text = nil;
            self.insertionCell.showsReorderControl = NO;
        }
        
        return self.insertionCell;
    } else {
        cell.textLabel.text = self.sourcesLoadedFromDisk[indexPath.row][kBloomSourceDataSourceDescriptionKey];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.detailTextLabel.text = self.sourcesLoadedFromDisk[indexPath.row][kBloomSourceDataSourceURLKey];
        cell.detailTextLabel.font = [UIFont italicSystemFontOfSize:8.0f];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.showsReorderControl = YES;
        
        [[cell.contentView viewWithTag:kBloomSourceAddNewTag] removeFromSuperview];
        
        return cell;
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row < [self.sourcesLoadedFromDisk count];
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [self.sourcesLoadedFromDisk exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete: {
            [self.sourcesLoadedFromDisk removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case UITableViewCellEditingStyleInsert: {
            UITextField *inputField = (UITextField *)[self.insertionCell.contentView viewWithTag:kBloomSourceAddNewTag];

            [self.sourcesLoadedFromDisk addObject:[@{ kBloomSourceDataSourceURLKey: inputField.text,
                                                      kBloomSourceDataSourceDeletableKey: @YES,
                                                      kBloomSourceDataSourceDescriptionKey: @"" } mutableCopy]];
            
            CodeSampleAlertView *input = [[CodeSampleAlertView alloc] initWithTitle:@"Source input" message:@"Describe this URL" cancelButtonTitle:nil];
            
            input.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            __weak typeof(self) weakSelf = self;
            
            [input addButtonWithTitle:@"Add" action:^(UIAlertView *alertView) {
                __strong typeof(self) strongSelf = weakSelf;
                
                NSMutableDictionary *sourceData = strongSelf.sourcesLoadedFromDisk[indexPath.row];
                NSString *description = [alertView textFieldAtIndex:0].text;
                
                if (description) {
                    sourceData[kBloomSourceDataSourceDescriptionKey] = description;
                    
                    [tableView beginUpdates];
                    [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[strongSelf.sourcesLoadedFromDisk count] inSection:0]]
                                     withRowAnimation:UITableViewRowAnimationTop];
                    [tableView endUpdates];
                    
                    [alertView textFieldAtIndex:0].text = nil;
                } else {
                    [strongSelf.sourcesLoadedFromDisk removeObjectAtIndex:indexPath.row];
                }
            }];
            
            [input addButtonWithTitle:@"Cancel" action:^(UIAlertView *alertView) {
                __strong typeof(self) strongSelf = weakSelf;
                
                [strongSelf.sourcesLoadedFromDisk removeObjectAtIndex:indexPath.row];
            }];
            
            input.completion = ^(UIAlertView *alertView) {
                [tableView reloadData];
            };
            
            [input show];
            
            break;
        }
        case UITableViewCellEditingStyleNone:   // Unused
            break;
    }
}

#pragma mark - Property accessors

- (void) setEditing:(BOOL)editing {
    
    if (editing) {
        
    } else {
        NSURL *oldURL = [[NSBundle mainBundle] URLForResource:kBloomSourceDataSourceFileName withExtension:kBloomSourceDataSourceFilExtension];
        
        [self.sourcesLoadedFromDisk writeToURL:oldURL atomically:YES];
        
        [[self.insertionCell.contentView viewWithTag:kBloomSourceAddNewTag] removeFromSuperview];
        self.insertionCell = nil;
    }
}

@end
