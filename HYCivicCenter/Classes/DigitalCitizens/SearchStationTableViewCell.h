//
//  SearchStationTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/10/25.
//

#import <UIKit/UIKit.h>
#import "HYSearchStationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchStationTableViewCell : UITableViewCell

@property (nonatomic, strong) HYSearchLineModel *lineModel;
@property (nonatomic, strong) HYSearchStationModel *stationModel;

@end

NS_ASSUME_NONNULL_END
