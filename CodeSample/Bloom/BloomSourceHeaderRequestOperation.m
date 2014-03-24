//
//  BloomSourceHeaderRequestOperation.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/24/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "BloomSourceHeaderRequestOperation.h"

@interface BloomSourceHeaderRequestOperation () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *headConnection;
@property (nonatomic, strong) NSDictionary *headers;

@end

@implementation BloomSourceHeaderRequestOperation

- (void) main {
    
    [self.delegate operation:self didAdvanceToStepName:@"Checking headers..." stepIndex:1];
    [self.delegate operation:self didProgressToCompletion:0.5f];
    
    [NSThread sleepForTimeInterval:1.0];
    
    if ([self isCancelled]) {
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.sourceURL];
    
    request.HTTPMethod = @"HEAD";
    
    self.headConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    [self.headConnection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.headConnection start];
}

# pragma mark - NSURLConnectionDelegate implementation

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self.delegate operation:self didFailWithError:error];
    
    [self cancel];
}

#pragma mark - NSURLConnectionDataDelegate implementation

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    if ([self isCancelled]) {
        [connection cancel];
        return;
    }
    
    [self.delegate operation:self didAdvanceToStepName:@"Collecting headers..." stepIndex:2];
    [self.delegate operation:self didProgressToCompletion:0.75f];
    
    [NSThread sleepForTimeInterval:0.5];

    self.headers = ((NSHTTPURLResponse *) response).allHeaderFields;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if ([self isCancelled]) {
        return;
    }
    
    [self.delegate operation:self didAdvanceToStepName:@"Header download completed." stepIndex:3];
    [self.delegate operation:self didProgressToCompletion:1.0f];
}

@end
