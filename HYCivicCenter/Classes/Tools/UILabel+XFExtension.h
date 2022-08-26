//
//  UILabel+XFExtension.h
//  HelloFrame
//
//  Created by nuchina on 2021/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (XFExtension)

@property (nonatomic, copy) NSString *verticalText;

+ (instancetype)xf_labelWithFont:(UIFont *)font
                       textColor:(UIColor *)color
                   numberOfLines:(NSInteger)lines
                       alignment:(NSTextAlignment)alignment;

+ (instancetype)xf_labelWithText:(NSString *)text;


@end

NS_ASSUME_NONNULL_END
