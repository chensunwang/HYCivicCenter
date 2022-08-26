//
//  NSString+Base64.h
//  HelloFrame
//
//  Created by nuchina on 2021/9/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Base64)

/**
 *  转换为Base64编码
 */
 - (NSString *)base64EncodedString;

/**
*  将Base64编码还原
*/
- (NSString *)base64DecodedString;

- (NSString *)stringEncode;

@end

NS_ASSUME_NONNULL_END
