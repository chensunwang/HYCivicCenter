//
//  CommintStationView.h
//  HelloFrame
//
//  Created by nuchina on 2021/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommintStationView : UIView

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *signalIV;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *stationNumLabel;

- (void)setTimeString:(NSString *)time speed:(NSString *)speed stationNum:(NSString *)stationNum;

@end

NS_ASSUME_NONNULL_END
