//
//  HYSSTableViewCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//

#import <UIKit/UIKit.h>
#import "HYServiceContentTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYSSTableViewCell : UITableViewCell

@property (nonatomic, strong) HYServiceContentModel * specialModel;
@property (nonatomic, strong) HYDepartmentCountryModel * departmentModel;

@end

NS_ASSUME_NONNULL_END
