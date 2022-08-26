//
//  HYDDBusinessCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/7.
//

#import <UIKit/UIKit.h>
#import "HYBusinessInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYDDBusinessCell : UITableViewCell

@property (nonatomic, strong) HYBusinessInfoModel * infoModel;
@property (nonatomic, strong) UIViewController * viewController;

@end

// 段头
@interface HYDDBHeaderForSection : UIView

@property (nonatomic, strong) HYBusinessInfoModel * model;
@property (nonatomic, strong) UIViewController * viewController;
@property (nonatomic, strong) UIColor *hyTitleColor;

@end

NS_ASSUME_NONNULL_END
