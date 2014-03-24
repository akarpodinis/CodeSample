//
//  BloomFilterComputationOperation.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/24/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "BloomFilterComputationOperation.h"

@interface BloomFilterComputationOperation ()

@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger numberOfHashes;
@property (nonatomic, strong) BloomFilter *filter;

@end

@implementation BloomFilterComputationOperation

- (instancetype) initWithSourceURLString:(NSString *)sourceURLString bitWidth:(NSUInteger)width numberOfHashes:(NSUInteger)numberOfHashes {
    
    if ( self = [super initWithSourceURLString:sourceURLString] ) {
        _width = width;
        _numberOfHashes = numberOfHashes;
        
        _filter = [[BloomFilter alloc] initWithBitWidth:width numberOfHashes:numberOfHashes];
    }
    
    return self;
}

- (void) main {
    
    [self.delegate operation:self didAdvanceToStepName:@"Computing bloom..." stepIndex:1];
    
    NSError *handleCreationError = nil;
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingFromURL:self.sourceURL error:&handleCreationError];
    
    if (!handle) {
        [self.delegate operation:self didFailWithError:handleCreationError];
        [self cancel];
        return;
    }
    
    NSError *attributesError = nil;
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self.sourceURL path] error:&attributesError];
    
    unsigned long long fileSizeOnDisk = 0;
    
    if (fileAttributes) {
        NSNumber *fileSizeNumber = fileAttributes[NSFileSize];
        fileSizeOnDisk = [fileSizeNumber longLongValue];
    } else {
        [handle closeFile];
        [self.delegate operation:self didFailWithError:attributesError];
    }
    
    BOOL atEOF = NO;
    NSMutableString *readChunk = [[NSMutableString alloc] initWithCapacity:1];
    unsigned long long totalBytesRead = 0;
    
    while (!atEOF) {
        @autoreleasepool {
            if ([self isCancelled]) {
                [handle closeFile];
                return;
            }
            
            NSData *readBytes = [handle readDataOfLength:1];
            
            if ([readBytes length] == 0) {
                atEOF = YES;
                break;
            }
            
            NSString *convertedByte = [[NSString alloc] initWithData:readBytes encoding:NSUTF16StringEncoding];
            
            if ([convertedByte isNewline]) {
                [self.filter addValueToFilter:readChunk];
                [readChunk setString:@""];
            } else {
                [readChunk appendString:convertedByte];
            }
            
            totalBytesRead++;
            
            [self.delegate operation:self didProgressToCompletion:(totalBytesRead / (fileSizeOnDisk * 1.0f))];
        }
    }
    
    [handle closeFile];
    
    [self.delegate operation:self didAdvanceToStepName:@"Ready to search" stepIndex:2];
    [self.delegate operation:self didProgressToCompletion:100.0f];
}

@end
