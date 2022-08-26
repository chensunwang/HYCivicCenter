//
//  UIColor+BDFaceColorUtils.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/5.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (BDFaceColorUtils)

+ (UIColor *)face_colorWithRGBHex:(UInt32)hex;

// 16进制字符串转颜色 (8位带透明度的)
+ (UIColor *)colorAndAlphaWithHexString:(NSString *)hexString;

// 16进制字符串转颜色（6位）
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
