//
//  UIView+YXAdd.h
//  YXP2pMoney
//
//  Created by Houhua Yan on 16/3/3.
//  Copyright © 2016年 yanhouhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YXAdd)

/**
 *  UIView扩展的一些属性 用于对其frame的操作
 */
@property (nonatomic) CGFloat kLeft;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat kTop;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat kRight;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat kBottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat kWidth;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat kHeight;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat kCenterX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat kCenterY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint kOrigin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  kSize;        ///< Shortcut for frame.size.

/// 设置任意角圆角
/// - Parameters:
///   - corners: 设置的角
///   - radii: 设置圆角的大小
- (void)setMutiBorderRoundingCorners:(UIRectCorner)corners radii:(CGFloat)radii;


/// 添加虚线边框
/// @param view 需要添加边框的空间
- (void)setDottedBorderForView:(UIView *)view corner:(CGFloat)corner;

@end
