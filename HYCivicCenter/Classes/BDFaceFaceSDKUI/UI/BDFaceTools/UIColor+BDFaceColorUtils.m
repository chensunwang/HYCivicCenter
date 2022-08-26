//
//  UIColor+BDFaceColorUtils.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/5.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "UIColor+BDFaceColorUtils.h"

@implementation UIColor (BDFaceColorUtils)

+ (UIColor *)face_colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorAndAlphaWithHexString:(NSString *)hexString
{
    hexString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([hexString hasPrefix:@"#"]) hexString = [hexString substringFromIndex:1];
    if ([hexString hasPrefix:@"0X"]) hexString = [hexString substringFromIndex:2];
    
    if (hexString.length == 8) {
        NSString *alphaString = [hexString substringToIndex:2];
        NSString *colorString = [hexString substringFromIndex:2];
        
        NSString *temp = [NSString stringWithFormat:@"%lu",strtoul([alphaString UTF8String],0,16)];

        CGFloat alpha = temp.integerValue / 255.0f;
        return [self colorWithHexString:colorString alpha:alpha];
    } else {
        return [self colorWithHexString:hexString alpha:1];
    }
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    hexString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    UIColor *defaultColor = [UIColor clearColor];
    
    if (hexString.length < 6) return defaultColor;
    if ([hexString hasPrefix:@"#"]) hexString = [hexString substringFromIndex:1];
    if ([hexString hasPrefix:@"0X"]) hexString = [hexString substringFromIndex:2];
    if (hexString.length != 6 && hexString.length != 8) {
         return defaultColor;
    }
    
    //method1
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned int hexNumber;
    if (![scanner scanHexInt:&hexNumber]) return defaultColor;
    
    //method2
    const char *char_str = [hexString cStringUsingEncoding:NSASCIIStringEncoding];
    int hexNum;
    sscanf(char_str, "%x", &hexNum);

    if (hexString.length == 8) {
         alpha = (float)(unsigned char)(hexNum>>24)/0xff;
    } else {
        if (hexNumber > 0xFFFFFF) return nil;
    }

    CGFloat red   = ((hexNumber >> 16) & 0xFF) / 255.0;
    CGFloat green = ((hexNumber >> 8) & 0xFF) / 255.0;
    CGFloat blue  = (hexNumber & 0xFF) / 255.0;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    return color;
}
@end
