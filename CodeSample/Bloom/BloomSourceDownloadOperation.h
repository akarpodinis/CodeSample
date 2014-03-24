//
//  BloomSourceDownloadOperation.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/24/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BloomOperation.h"

extern NSString *const kBloomSourceDownloadOperationErrorDomain;

@interface BloomSourceDownloadOperation : BloomOperation

@property (nonatomic, readonly, assign) BOOL continuingPartialDownload;

- (instancetype) initWithSourceURLString:(NSString *)sourceURLString
                             contentSize:(unsigned long long)size
                        finalDestination:(NSURL *)destination;

@end
