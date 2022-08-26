//
//  HYDepartDetailBusinessCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/7.
//

#import <UIKit/UIKit.h>
#import "HYBusinessInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYDepartDetailBusinessCellBlock)(NSInteger type);

@interface HYDepartDetailBusinessCell : UITableViewCell

@property (nonatomic, strong) UIViewController * viewController;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger type; // 当前选择的是 1个人业务 2法人业务
@property (nonatomic, assign) BOOL isEnterprise; // 当前身份 true 企业  false 个人
@property (nonatomic, copy) HYDepartDetailBusinessCellBlock departDetailBusinessCellBlock;
@property (nonatomic, strong) UIColor *hyTitleColor;

@end

NS_ASSUME_NONNULL_END
