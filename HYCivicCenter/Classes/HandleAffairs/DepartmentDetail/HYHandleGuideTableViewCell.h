//
//  HYHandleGuideTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2022/1/8.
//

#import <UIKit/UIKit.h>
#import "HYItemTotalInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYHandleGuideTableViewCell : UITableViewCell

@property (nonatomic, strong) HYGuideItemInfoModel *infoModel;  // 基本信息/咨询途径/监督投诉model

@property (nonatomic, strong) HYChargeModel *chargeModel;  // 收费明细model

@property (nonatomic, strong) HYHandlingProcessModel *processModel;  // 办事流程model

@property (nonatomic, strong) HYConditionModel *conditionModel;  // 受理条件model

@property (nonatomic, strong) HYOutMapModel *outMapModel;  // 流程图model

@end

NS_ASSUME_NONNULL_END
