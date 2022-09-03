//
//  BusRouteBusCollectionViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/3.
//

#import "BusRouteBusCollectionViewCell.h"
#import "HYCivicCenterCommand.h"

@interface BusRouteBusCollectionViewCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *signalIV;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *stationNumLabel;

@end

@implementation BusRouteBusCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.timeLabel = [[UILabel alloc]init];
        [self addSubview:self.timeLabel];
        
        self.signalIV = [[UIImageView alloc]init];
        self.signalIV.image = HyBundleImage(@"busSignal");
        [self addSubview:self.signalIV];
        
        self.speedLabel = [[UILabel alloc]init];
        self.speedLabel.textColor = UIColorFromRGB(0x157AFF);
        self.speedLabel.font = RFONT(12);
        [self addSubview:self.speedLabel];
        
        self.stationNumLabel = [[UILabel alloc]init];
        self.stationNumLabel.font = RFONT(11);
        self.stationNumLabel.textColor = UIColorFromRGB(0x666666);
        [self addSubview:self.stationNumLabel];
        
    }
    return self;
    
}

- (void)setBusInfoModel:(HYBusinfoModel *)busInfoModel {
    _busInfoModel = busInfoModel;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@分钟",busInfoModel.arriveNowStationNeedMinute] attributes:@{NSFontAttributeName: RFONT(28),NSForegroundColorAttributeName: UIColorFromRGB(0x157AFF)}];

    [string addAttributes:@{NSFontAttributeName: RFONT(14)} range:NSMakeRange(busInfoModel.arriveNowStationNeedMinute.length, 2)];
    self.timeLabel.attributedText = string;
    NSString *distance = @"0m";
    if (busInfoModel.distanceMeter.intValue == 0) {
        distance = @"0m";
    }else if (busInfoModel.distanceMeter.intValue > 0 && busInfoModel.distanceMeter.intValue < 1000) {
        distance = [NSString stringWithFormat:@"%@m",busInfoModel.distanceMeter];
    }else if (busInfoModel.distanceMeter.intValue >= 1000) {
        distance = [NSString stringWithFormat:@"%fkm",busInfoModel.distanceMeter.intValue / 1000.0];
    }
    self.speedLabel.text = [NSString stringWithFormat:@"%@站/%@",busInfoModel.arriveNowStationNumber,distance];
    self.stationNumLabel.text = [NSString stringWithFormat:@"最近一辆"];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(21);
    }];
    
    [self.signalIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(18);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
    
    [self.stationNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-19);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.stationNumLabel.mas_top).offset(-3);
    }];
    
}

@end
