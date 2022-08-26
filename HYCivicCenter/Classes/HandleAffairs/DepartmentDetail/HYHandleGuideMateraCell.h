//
//  HYHandleGuideMateraCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/4/12.
//

#import <UIKit/UIKit.h>
#import "HYItemTotalInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYHandleGuideMateraCell : UITableViewCell

@property (nonatomic, strong) NSArray *materials;  // 办理材料model

@end


@interface HYMateraCellTableViewCell : UITableViewCell

@property (nonatomic, strong) HYMaterialModel *model;

@end

NS_ASSUME_NONNULL_END
