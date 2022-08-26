//
//  BusRouteInfoView.h
//  HelloFrame
//
//  Created by nuchina on 2021/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusRouteInfoView : UIButton

@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *terminusLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *soundIV;

- (void)setStationNum:(NSString *)lineName withTerminalStation:(NSString *)stationName withTime:(NSString *)time;

@end

NS_ASSUME_NONNULL_END
