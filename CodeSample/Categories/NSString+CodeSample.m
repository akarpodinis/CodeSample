//
//  NSString+CodeSample.m
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/21/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import "NSString+CodeSample.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CodeSample)

- (NSString *)md5Hash {
	
	const char *cStr = [self UTF8String];
	
	unsigned char result[16];
	
	CC_MD5( cStr, strlen(cStr), result );
	
	return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]] lowercaseString];
}

- (NSString *)md5HashWithSalt:(NSString *)salt {
	
	return [[self stringByAppendingString:salt] md5Hash];
}

- (BOOL) isNewline {
    
    return [self length] > 0 && [[NSCharacterSet newlineCharacterSet] characterIsMember:[self characterAtIndex:0]];
}

@end
