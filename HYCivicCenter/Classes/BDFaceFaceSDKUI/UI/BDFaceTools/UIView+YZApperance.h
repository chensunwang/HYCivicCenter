//
//  UIView+YZApperance.h
//  zrlandlord-ios
//
//  Created by quy21 on 2020/5/26.
//

#import <UIKit/UIKit.h>


@interface UIView (YZApperance)

/**
 设置view 部分或全部圆角

 @param corners 圆角方向，上左下右 四个角。
 @param cornerRadious 圆角半径
 */
-(void)yz_setRoundedWithCorners:(UIRectCorner)corners cornerRadious:(CGFloat)cornerRadious;


@end

