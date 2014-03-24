//
//  BloomSourceDownloadOperation.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/24/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "BloomSourceDownloadOperation.h"

NSString *const kBloomSourceDownloadOperationErrorDomain = @"com.karpodinis.codesample.BLoomSourceDownloadOperationErrorDomain";

@interface BloomSourceDownloadOperation () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *downloadConnection;
@property (nonatomic, strong) NSFileHandle *handle;
@property (nonatomic, assign) unsigned long long sizeToDownload;
@property (nonatomic, assign) unsigned long long sizeDownloaded;
@property (nonatomic, copy) NSURL *finalDestination;

- (NSURL *) incompleteFileURL;

@end

@implementation BloomSourceDownloadOperation

- (instancetype) initWithSourceURLString:(NSString *)sourceURLString
                             contentSize:(unsigned long long)size
                        finalDestination:(NSURL *)destination {
    
    if ( self = [super initWithSourceURLString:sourceURLString] ) {
        
        _sizeToDownload = size;
        _finalDestination = destination;
    }
    
    return self;
}

- (void) main {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.sourceURL];
    
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    if (![[NSFileManager defaultManager] createFileAtPath:[[self incompleteFileURL] path]
                                                contents:nil
                                               attributes:nil]) {
        [self.delegate operation:self didFailWithError:[NSError errorWithDomain:kBloomSourceDownloadOperationErrorDomain
                                                                           code:-1
                                                                       userInfo:@{@"path": [[self incompleteFileURL] path],
                                                                                  @"url": self.sourceURL}]];
        [self cancel];
    }

    
    NSError *fileHandleCreationError = nil;
    self.handle = [NSFileHandle fileHandleForWritingToURL:[self incompleteFileURL] error:&fileHandleCreationError];
    
    if (!self.handle) {
        [self.delegate operation:self didFailWithError:fileHandleCreationError];
        [self cancel];
    }

    
    [self.delegate operation:self didAdvanceToStepName:@"Downloading..." stepIndex:2];
    
    self.downloadConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    [self.downloadConnection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.downloadConnection start];
}

#pragma mark - NSURLConncetionDelegate implementation

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if ([self isCancelled]) {
        [self.handle closeFile];
        [connection cancel];
        return;
    }
    
    @try {
        [self.handle writeData:data];
        
        self.sizeDownloaded += [data length];
        
        [self.delegate operation:self didProgressToCompletion:(self.sizeDownloaded / (self.sizeToDownload * 1.0f))];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception while downloading source dictionary: %@", exception);
        [self cancel];
        [[NSFileManager defaultManager] removeItemAtURL:[self incompleteFileURL] error:NULL];
        [self.delegate operation:self didFailWithError:[NSError errorWithDomain:kBloomSourceDownloadOperationErrorDomain
                                                                           code:-1
                                                                       userInfo:@{@"url": self.sourceURL}]];
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self.handle closeFile];
    
    if ([self isCancelled]) {
        [connection cancel];
        return;
    }
    
    NSError *moveError = nil;
    
    [[NSFileManager defaultManager] replaceItemAtURL:self.finalDestination
                                       withItemAtURL:[self incompleteFileURL]
                                      backupItemName:nil
                                             options:NSFileManagerItemReplacementUsingNewMetadataOnly
                                    resultingItemURL:NULL
                                               error:&moveError];
    
    [[NSFileManager defaultManager] removeItemAtURL:[self incompleteFileURL] error:NULL];
    
    if (moveError) {
        [self.delegate operation:self didFailWithError:moveError];
    } else {
        [self.delegate operation:self didProgressToCompletion:100.0f];
    }
}

#pragma mark - NSURLConnectionDataDelegate implementation

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    
    NSDecimalNumber *decodedNumber = [NSDecimalNumber decimalNumberWithString:[httpResponse allHeaderFields][@"Content-Length"]];
    
    self.sizeToDownload = [decodedNumber unsignedLongLongValue];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [[NSFileManager defaultManager] removeItemAtURL:[self incompleteFileURL] error:nil];
    [self.handle closeFile];
    [self.delegate operation:self didFailWithError:error];
}

#pragma mark - Support

- (NSURL *) incompleteFileURL {
    
    NSURL *tmpDirURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    
    tmpDirURL = [tmpDirURL URLByAppendingPathComponent:[[self.sourceURL absoluteString] md5Hash]];
    tmpDirURL = [tmpDirURL URLByAppendingPathExtension:@"INCOMPLETE"];
    
    return tmpDirURL;
}

@end
