//
//  UIButton+Gradient.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/11.
//

#import "UIButton+Gradient.h"

@implementation UIButton (Gradient)

- (UIButton *)gradientButtonWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs percentageArray:(NSArray *)percent gradientType:(GradientType)type {
    
    UIImage *backImage = [[UIImage alloc]createImageWithSize:btnSize gradientColors:clrs percentage:percent gradientType:type];
    
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    
    return self;
}

@end
