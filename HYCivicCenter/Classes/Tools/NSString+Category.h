//
//  NSString+Category.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Category)

/// 根据字符串长度获取高度
/// @param font 字体
/// @param width 宽度
- (CGFloat)heightForStringWithFont:(UIFont *)font
                             width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
