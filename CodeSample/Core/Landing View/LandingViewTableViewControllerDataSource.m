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
- (BOOL) testClassNameForExistense:(NSString *)className kindOfSubclass:(Class)subclass;

@end

@implementation LandingViewTableViewControllerDataSource

- (id) init {
    
    if ( self = [super init] ) {
        NSURL *listURL = [[NSBundle mainBundle] URLForResource:kLandingViewControllerFileName withExtension:kLandingViewControllerFileExtension];
        
        NSCAssert(listURL != nil, @"%@.%@ missing, there's nothing to load", kLandingViewControllerFileName, kLandingViewControllerFileExtension);
        
        NSArray *rawList = [NSArray arrayWithContentsOfURL:listURL];
        
        NSMutableArray *finalList = [[NSMutableArray alloc] initWithCapacity:[rawList count]];
        
        for (NSDictionary *configuration in rawList) {
            if ([configuration[kActiveKey] boolValue]) {
                [finalList addObject:configuration];
            }
        }
        
        _configurationList = [finalList copy];
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
    
    BOOL isTargetClassValid = [self testClassNameForExistense:properties[kTableViewTargetViewControllerClassNameKey]
                                               kindOfSubclass:[UIViewController class]];
    
    BOOL isLoadableLandingCellClassValid = [self testClassNameForExistense:properties[kTableViewCellClassNameKey]
                                                            kindOfSubclass:[UITableViewCell class]];
    
    BOOL hasCellText = properties[kTableViewCellTextNameKey] != nil;
    
    return isTargetClassValid && isLoadableLandingCellClassValid && hasCellText;
}

- (BOOL) testClassNameForExistense:(NSString *)className kindOfSubclass:(Class)subclass {
    
    Class loadableClass = NSClassFromString(className);
    
    if (!className) {
        NSLog(@"Class name not specified");
        return NO;
    } else if (!loadableClass) {
        NSLog(@"Class not loadable (%@)", className);
        return NO;
    } else if (![loadableClass isSubclassOfClass:subclass]) {
        NSLog(@"Loaded class (%@) not a subclass of %@", className, NSStringFromClass(subclass));
        return NO;
    } else {
        return YES;
    }
}

@end
