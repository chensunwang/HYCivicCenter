//
//  HYSpecialServiceViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYSpecialServiceViewController : UIViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *headerArr;
@property (nonatomic, assign) BOOL isEnterprise; // true 企业  false 个人
/// 导航栏标题颜色 防止与你项目中导航栏冲突 需要重新设置为你导航栏标题的颜色
@property (nonatomic, strong) UIColor *hyTitleColor;

@end

NS_ASSUME_NONNULL_END
