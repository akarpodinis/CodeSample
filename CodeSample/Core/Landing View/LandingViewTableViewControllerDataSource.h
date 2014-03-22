//
//  LandingViewTableViewControllerDataSource.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/21/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LandingViewTableViewControllerDataSource : NSObject <UITableViewDataSource>

/**
 @brief Creates a list of the \p UITableViewCell \p Classes for the caller to register with \p -registerClass:forCellReuseIdentifier: .
 @post The returned \p Classes are part of the bundle
 @post The returned \p Classes are subclasses of \p UITableViewCell
 @post \p -count messages will return a number equal to the number of entries in the root array of the \p LandingViewDataSource plist plus one
(the unusable cell's reuse identifier)
 @return A \p NSArray of \p Class objects as specified in the \p LandingViewDataSource plist.  Any indecies that are unable to be loaded are instead \p NSNull.
 */
@property (nonatomic, readonly, strong) NSArray *registerableTableViewCellClassNames;

/**
 @brief Creates an instance of the \p Class object to load when the specified index path is tapped by the user.
 @post The returned \p Class is part of the bundle
 @post The returned \p Class is a subclass of \p UIViewController
 @param The \p NSIndexPath received from a call to \p -tableView:didSelectRowAtIndexPath:
 @return A \p Class object as specified in the \p LandingViewDataSource plist, or \p nil if there was trouble loading it
 */
- (Class) classToLoadFromIndexPath:(NSIndexPath *)indexPath;

@end
