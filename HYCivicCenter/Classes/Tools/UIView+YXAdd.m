//
//  UIView+YXAdd.m
//  YXP2pMoney
//
//  Created by Houhua Yan on 16/3/3.
//  Copyright © 2016年 yanhouhua. All rights reserved.
//

#import "UIView+YXAdd.h"
@implementation UIView (YXAdd)

//- (CGFloat)left {
//    return self.frame.origin.x;
//}

- (CGFloat)kLeft {
    return self.frame.origin.x;
}

//- (void)setLeft:(CGFloat)x {
//    CGRect frame = self.frame;
//    frame.origin.x = x;
//    self.frame = frame;
//}

- (void)setKLeft:(CGFloat)kLeft {
    CGRect frame = self.frame;
    frame.origin.x = kLeft;
    self.frame = frame;
}

//- (CGFloat)top {
//    return self.frame.origin.y;
//}

- (CGFloat)kTop {
    return self.frame.origin.y;
}

//- (void)setTop:(CGFloat)y {
//    CGRect frame = self.frame;
//    frame.origin.y = y;
//    self.frame = frame;
//}

- (void)setKTop:(CGFloat)kTop {
    CGRect frame = self.frame;
    frame.origin.y = kTop;
    self.frame = frame;
}

//- (CGFloat)right {
//    return self.frame.origin.x + self.frame.size.width;
//}

- (CGFloat)kRight {
    return self.frame.origin.x + self.frame.size.width;
}

//- (void)setRight:(CGFloat)right {
//    CGRect frame = self.frame;
//    frame.origin.x = right - frame.size.width;
//    self.frame = frame;
//}

- (void)setKRight:(CGFloat)kRight {
    CGRect frame = self.frame;
    frame.origin.x = kRight - frame.size.width;
    self.frame = frame;
}

//- (CGFloat)bottom {
//    return self.frame.origin.y + self.frame.size.height;
//}

- (CGFloat)kBottom {
    return self.frame.origin.y + self.frame.size.height;
}

//- (void)setBottom:(CGFloat)bottom {
//    CGRect frame = self.frame;
//    frame.origin.y = bottom - frame.size.height;
//    self.frame = frame;
//}

- (void)setKBottom:(CGFloat)kBottom {
    CGRect frame = self.frame;
    frame.origin.y = kBottom - frame.size.height;
    self.frame = frame;
}

//- (CGFloat)width {
//    return self.frame.size.width;
//}

- (CGFloat)kWidth {
    return self.frame.size.width;
}

//- (void)setWidth:(CGFloat)width {
//    CGRect frame = self.frame;
//    frame.size.width = width;
//    self.frame = frame;
//}

- (void)setKWidth:(CGFloat)kWidth {
    CGRect frame = self.frame;
    frame.size.width = kWidth;
    self.frame = frame;
}

//- (CGFloat)height {
//    return self.frame.size.height;
//}

- (CGFloat)kHeight {
    return self.frame.size.height;
}

//- (void)setHeight:(CGFloat)height {
//    CGRect frame = self.frame;
//    frame.size.height = height;
//    self.frame = frame;
//}

- (void)setKHeight:(CGFloat)kHeight {
    CGRect frame = self.frame;
    frame.size.height = kHeight;
    self.frame = frame;
}

//- (CGFloat)centerX {
//    return self.center.x;
//}

- (CGFloat)kCenterX {
    return self.center.x;
}

//- (void)setCenterX:(CGFloat)centerX {
//    self.center = CGPointMake(centerX, self.center.y);
//}

- (void)setKCenterX:(CGFloat)kCenterX {
    self.center = CGPointMake(kCenterX, self.center.y);
}

//- (CGFloat)centerY {
//    return self.center.y;
//}

- (CGFloat)kCenterY {
    return self.center.y;
}

//- (void)setCenterY:(CGFloat)centerY {
//    self.center = CGPointMake(self.center.x, centerY);
//}

- (void)setKCenterY:(CGFloat)kCenterY {
    self.center = CGPointMake(self.center.x, kCenterY);
}

//- (CGPoint)origin {
//    return self.frame.origin;
//}

- (CGPoint)kOrigin {
    return self.frame.origin;
}

//- (void)setOrigin:(CGPoint)origin {
//    CGRect frame = self.frame;
//    frame.origin = origin;
//    self.frame = frame;
//}

- (void)setKOrigin:(CGPoint)kOrigin {
    CGRect frame = self.frame;
    frame.origin = kOrigin;
    self.frame = frame;
}

//- (CGSize)size {
//    return self.frame.size;
//}

- (CGSize)kSize {
    return self.frame.size;
}

//- (void)setSize:(CGSize)size {
//    CGRect frame = self.frame;
//    frame.size = size;
//    self.frame = frame;
//}

- (void)setKSize:(CGSize)kSize {
    CGRect frame = self.frame;
    frame.size = kSize;
    self.frame = frame;
}

- (void)setMutiBorderRoundingCorners:(UIRectCorner)corners radii:(CGFloat)radii {
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setDottedBorderForView:(UIView *)view corner:(CGFloat)corner {
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = [UIColor redColor].CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5];
    
    //设置路径
    border.path = path.CGPath;
    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = 1.f;
    
    //设置线条的样式
//    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    
    self.layer.cornerRadius = corner;
    self.layer.masksToBounds = YES;
    
    [self.layer addSublayer:border];
}

@end
