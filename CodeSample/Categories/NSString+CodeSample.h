//
//  NSString+CodeSample.h
//  CodeSample
//
//  Created by Alexander Karpodinis on 3/21/14.
//  Copyright (c) 2014 AKarpodinis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CodeSample)

/**
 @brief Computes a checksum based on the receiver using the MD5 algorithim
 @return An MD5-hashed string
 */
- (NSString *) md5Hash;

/**
 @brief Computes a salted checksum based on the receiver using the MD5 algorithm
 @return An MD5-hased string with the specified salt
 */
- (NSString *) md5HashWithSalt:(NSString *)salt;

/**
 @brief Detemrines if the receiver is a newline character of some kind in a system-independent manner
 @return \p YES if the receiver is an arrangement of characters that indicates the newline, \p NO otherwise
 */
- (BOOL) isNewline;

@end
