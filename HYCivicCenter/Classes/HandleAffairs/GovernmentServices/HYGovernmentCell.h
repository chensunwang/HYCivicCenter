//
//  HYGovernmentCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYGovernmentCellBlock)(void);

@interface HYGovernmentCell : UITableViewCell

@property (nonatomic, copy) HYGovernmentCellBlock governmentCellBlock;
@property (nonatomic, strong) UIViewController * viewController;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, assign) BOOL isEnterprise;  // true 企业  false 个人
@property (nonatomic, assign) BOOL isLogin;
/// 导航栏标题颜色 防止与你项目中导航栏冲突 需要重新设置为你导航栏标题的颜色
@property (nonatomic, strong) UIColor *hyTitleColor;

@end

NS_ASSUME_NONNULL_END
