//
//  HYGovementItemCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYGovementItemCellBlock)(NSInteger type);

@interface HYGovementItemCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray * deparmentServiceArr; // 部门服务数据
@property (nonatomic, strong) NSMutableArray * countyServiceArr; // 县区服务数据
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, assign) BOOL isEnterprise; // true 企业  false 个人
@property (nonatomic, assign) NSInteger type; // 0:部门 1:县区
@property (nonatomic, copy) HYGovementItemCellBlock govementItemCellBlock;
@property (nonatomic, strong) UIColor *hyTitleColor;

@end

NS_ASSUME_NONNULL_END
