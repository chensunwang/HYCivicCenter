//
//  RealTimeBusTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/10/25.
//

#import <UIKit/UIKit.h>
#import "HYBusinfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RealTimeBusTableViewCell : UITableViewCell

@property (nonatomic, strong) HYBusinfoModel *busInfoModel;
@property (nonatomic, copy) NSString *nextTime;

@end

NS_ASSUME_NONNULL_END
