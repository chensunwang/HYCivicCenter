//
//  UIView+YZApperance.m
//  zrlandlord-ios
//
//  Created by quy21 on 2020/5/26.
//

#import "UIView+YZApperance.h"

@implementation UIView (YZApperance)

/**
 *  设置圆角
 *  @param corners 需要设置圆角的方向
 */
-(void)yz_setRoundedWithCorners:(UIRectCorner)corners cornerRadious:(CGFloat)cornerRadious
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadious, cornerRadious)];
    maskPath.lineWidth = 0.f;
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


@end
