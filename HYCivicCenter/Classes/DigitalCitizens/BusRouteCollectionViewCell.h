//
//  BusRouteCollectionViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/10/26.
//

#import <UIKit/UIKit.h>
#import "HYSearchStationModel.h"
#import "HYBusinfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BusRouteCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *carIV;
@property (nonatomic, strong) UIImageView *circleIV;
@property (nonatomic, strong) UIImageView *routeIV;
@property (nonatomic, strong) UILabel *stationNumLabel;
@property (nonatomic, strong) UILabel *stationLabel;
@property (nonatomic, strong) HYSearchStationModel *stationModel;

//- (void)setStationString:(NSString *)station withStationNum:(NSString *)stationNum withCurrentStation:(NSInteger)currentIndex totalStation:(NSInteger)total withBusInfoArr:(NSArray *)busInfoArr;

- (void)currentIndex:(NSInteger)index totalStation:(NSInteger)total withBusInfoArr:(NSArray *)busInfoArr;

@end

NS_ASSUME_NONNULL_END
