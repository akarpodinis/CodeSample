//
//  LandingViewTableViewControllerDataSource.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/21/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "LandingViewTableViewControllerDataSource.h"
#import "LandingViewCell.h"

NSString *const kLandingViewControllerFileName = @"com.karpodinis.resources.LandingViewDataSource";
NSString *const kLandingViewControllerFileExtension= @"plist";

// TODO Add state restoration
@interface LandingViewTableViewControllerDataSource ()

@property (nonatomic, strong) NSArray *configurationList;
@property (nonatomic, readwrite, strong) NSArray *registerableTableViewCellClassNames;

- (BOOL) analyzeCellPropertiesForCorrectness:(NSDictionary *)properties;

@end

@implementation LandingViewTableViewControllerDataSource

- (id) init {
    
    if ( self = [super init] ) {
        NSURL *listURL = [[NSBundle mainBundle] URLForResource:kLandingViewControllerFileName withExtension:kLandingViewControllerFileExtension];
        
        NSCAssert(listURL != nil, @"%@.%@ missing, there's nothing to load", kLandingViewControllerFileName, kLandingViewControllerFileExtension);
        
        _configurationList = [NSArray arrayWithContentsOfURL:listURL];
    }
    
    return self;
}

- (Class) classToLoadFromIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *cellProperties = self.configurationList[indexPath.row];
    
    return NSClassFromString(cellProperties[kTableViewTargetViewControllerClassNameKey]);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.configurationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *cellProperties = self.configurationList[indexPath.row];
    
    LandingViewCell *cell = nil;
    
    if ([self analyzeCellPropertiesForCorrectness:cellProperties]) { // Properties are valid, configure them to be usable
        cell = [tableView dequeueReusableCellWithIdentifier:cellProperties[kTableViewCellClassNameKey] forIndexPath:indexPath];
    } else  {   // Properties are NOT valid, configure the cell to be unusable
        cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellUnusableCellClassName forIndexPath:indexPath];
    }
    
    [cell applyConfiguration:cellProperties];
    
    return cell;
}

#pragma mark - Accessor overrides

- (NSArray *) registerableTableViewCellClassNames {
    
    if (_registerableTableViewCellClassNames) {
        return _registerableTableViewCellClassNames;
    }
    
    @synchronized (@"LandingViewTableViewControllerDataSource.registerableTableViewCellClassNames.lock") {
        NSMutableArray *classes = [[NSMutableArray alloc] initWithCapacity:[self.configurationList count]];
        
        for (NSDictionary *configuration in self.configurationList) {
            
            NSString *className = configuration[kTableViewCellClassNameKey];
            Class loadableClass = NSClassFromString(className);
            
            if (!loadableClass) {
                NSLog(@"Table view cell class specified not found (%@)", className);
                [classes addObject:[NSNull null]];
            } else if (![loadableClass isSubclassOfClass:[UITableViewCell class]]) {
                NSLog(@"Table view cell class specified not a subclass of UITableViewCell (%@)", className);
                [classes addObject:[NSNull null]];
            } else {
                [classes addObject:loadableClass];
            }
        }
        
        [classes addObject:NSClassFromString(kTableViewCellUnusableCellClassName)];
        
        _registerableTableViewCellClassNames = classes;
        
        return _registerableTableViewCellClassNames;
    }
}

#pragma mark - Helper methods

- (BOOL) analyzeCellPropertiesForCorrectness:(NSDictionary *)properties {
    
    if (!properties[kTableViewCellTextNameKey]) {
        NSLog(@"Missing cell text key (%@)", kTableViewCellTextNameKey);
        return NO;
    } else if (!properties[kTableViewCellClassNameKey]) {
        NSLog(@"Missing cell class name (%@)", kTableViewCellClassNameKey);
        return NO;
    } else if (!properties[kTableViewTargetViewControllerClassNameKey]) {
        NSLog(@"Missing target view controller name (%@)", kTableViewTargetViewControllerClassNameKey);
        return NO;
    } else {    // Raw data is good, let's validate based on the loadability of the data itself
        NSString *targetableClassname = properties[kTableViewTargetViewControllerClassNameKey];
        Class loadableTargetClass = NSClassFromString(targetableClassname);
        
        if (!loadableTargetClass) {
            NSLog(@"Targetable class specified not found (%@)", targetableClassname);
            return NO;
        }
        
        if (![loadableTargetClass isSubclassOfClass:[UIViewController class]]) {
            NSLog(@"Targetable class specified not a subclass of UIViewController (%@)", targetableClassname);
            return NO;
        }
        
        NSString *tableViewCellClassName = properties[kTableViewTargetViewControllerClassNameKey];
        Class loadableTableViewCellClass = NSClassFromString(tableViewCellClassName);
        
        if (!loadableTableViewCellClass) {
            NSLog(@"Table view cell class specified not found (%@)", tableViewCellClassName);
            return NO;
        }
        
        if (![loadableTableViewCellClass isSubclassOfClass:[UITableViewCell class]]) {
            NSLog(@"Table view cell class specified not a subclass of UITableViewCell (%@)", tableViewCellClassName);
            return NO;
        }
        
        return YES;
    }
}

@end
