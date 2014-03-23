//
//  LandingViewCell.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/21/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import <UIKit/UIKit.h>

/** The total animation time that is permitted for animating components of all \p LandingViewCells.  If you're subclassing this, be sure to complete all
animations in this time interval. */
extern NSTimeInterval const kLandingViewCellTotalAnimationTime;

@interface LandingViewCell : UITableViewCell

/**
 @brief This method is invoked during the calling table view delegate's \p -tableView:cellForRowAtIndexPath: to configure or reconfigure the cell.
You must call \p super when overriding this method.
 @param configuration The dictionary of configuration information to be loaded for this cell
 @note If subclassing, a call to \p super is required.
 */
- (void) applyConfiguration:(NSDictionary *)configuration NS_REQUIRES_SUPER;

/**
 @brief Coupled with \p -animateIn, this method allows the implementer to configure this cell's properties for animation.
For performance considerations, you should treat this like you would treat a call to \p -[UITableViewCell prepareForReuse].  The default implementation does
nothing.
 @post Returning \p YES will follow up this call with a call to \p -prepareForAnimation
 @return \p YES if the cell was changed and needs animation, \p NO otherwise.  Defaults to \p NO.
 */
- (BOOL) prepareForAnimation;

/**
 @brief This method is invoked during the cell's \p -layoutSubviews call.  The default implementation does nothing.
 @pre The previous call to \p -prepareForAnimation returned \p YES.
 */
- (void) animateIn;

@end
