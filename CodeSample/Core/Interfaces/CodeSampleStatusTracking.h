//
//  CodeSampleStatusTracking.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/23/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CodeSampleStatusTracking <NSObject>

/**
 @brief Indicates that the class comforming to this protocol should return a string summarizing the status of the underlying coding task.
 @return An NSString suitable for display in the \p detailTextLabel of a \p LandingViewCell.
 */
+ (NSString *) formattedStatus;

/**
 @brief Indicates that the class conforming to this protocol should clear any saved status of the underlying coding task.
 */
+ (void) clearStatus;

@end
