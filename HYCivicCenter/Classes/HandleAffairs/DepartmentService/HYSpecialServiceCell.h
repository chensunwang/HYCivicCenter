//
//  HYDepartmentServiceCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYDepartmentServiceCellBlock)(NSInteger index, BOOL flag);

@interface HYDepartmentServiceCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray * specialArray;
@property (nonatomic, strong) NSMutableArray * departmentArray;
@property (nonatomic, strong) NSMutableArray * countyArray;
@property (nonatomic, strong) UIViewController * viewController;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, assign) BOOL isEnterprise; // true 企业  false 个人
/// 导航栏标题颜色 防止与你项目中导航栏冲突 需要重新设置为你导航栏标题的颜色
@property (nonatomic, strong) UIColor *hyTitleColor;

@property (nonatomic, copy) HYDepartmentServiceCellBlock specialServiceCellBlock;

@end

NS_ASSUME_NONNULL_END
