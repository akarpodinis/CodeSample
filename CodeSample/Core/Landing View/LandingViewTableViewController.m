//
//  LandingViewTableViewController.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/21/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "LandingViewTableViewController.h"
#import "LandingViewCell.h"
#import "LandingViewTableViewControllerDataSource.h"

@interface LandingViewTableViewController () <UITableViewDelegate>

@property (nonatomic, retain) LandingViewTableViewControllerDataSource *landingViewDataSource;

@end

@implementation LandingViewTableViewController

- (id) initWithStyle:(UITableViewStyle)style {
    
    if (self = [super initWithStyle:style]) {
        
        _landingViewDataSource = [[LandingViewTableViewControllerDataSource alloc] init];
        
        for (Class registerableTableViewCellSubclass in _landingViewDataSource.registerableTableViewCellClassNames) {
            if (![registerableTableViewCellSubclass isSubclassOfClass:[NSNull class]]) {
                [self.tableView registerClass:registerableTableViewCellSubclass forCellReuseIdentifier:NSStringFromClass(registerableTableViewCellSubclass)];
            }
        }
        
        self.tableView.dataSource = _landingViewDataSource;
    }
    
    return self;
}

#pragma mark - UITableViewDelegate implementation

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class classToLoad = [self.landingViewDataSource classToLoadFromIndexPath:indexPath];
    
    NSAssert([classToLoad isSubclassOfClass:[UIViewController class]], @"Classes to be loaded from the Landing View must be subclasses of UIViewController.");
    
    UIViewController *viewController = (UIViewController *) [[classToLoad alloc] init];
    
    NSAssert(classToLoad != nil, @"Can't present a nil view controller, initialization failed (%@).", [classToLoad class]);
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Custom transition

@end
