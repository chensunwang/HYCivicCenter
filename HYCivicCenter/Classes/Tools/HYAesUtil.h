//
//  HYAesUtil.h
//  HelloFrame
//
//  Created by nuchina on 2021/11/11.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYAesUtil : NSObject

/**
 * AES加密
 */
+ (NSString *)aesEncrypt:(NSString *)sourceStr;
 
/**
 * AES解密
 */
+ (NSString *)aesDecrypt:(NSString *)secretStr;

@end

NS_ASSUME_NONNULL_END
