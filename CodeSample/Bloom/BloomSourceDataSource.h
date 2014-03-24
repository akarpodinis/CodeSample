//
//  BloomSourceDataSource.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/23/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kBloomSourceDataSourceCellReuseIdentifier;

extern NSString *const kBloomSourceDataSourceDeletableKey;
extern NSString *const kBloomSourceDataSourceURLKey;
extern NSString *const kBloomSourceDataSourceDescriptionKey;

@interface BloomSourceDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sourcesLoadedFromDisk;
@property (nonatomic, assign) BOOL editing;

@end
