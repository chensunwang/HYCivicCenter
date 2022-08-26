//
//  BusRouteCollectionViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/10/26.
//

#import "BusRouteCollectionViewCell.h"

@implementation BusRouteCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.carIV = [[UIImageView alloc]init];
        self.carIV.hidden = YES;
        self.carIV.image = [UIImage imageNamed:@"busCar"];
        [self.contentView addSubview:self.carIV];
        
        self.circleIV = [[UIImageView alloc]init];
        [self.contentView addSubview:self.circleIV];
        
        self.routeIV = [[UIImageView alloc]init];
        self.routeIV.hidden = NO;
        [self.contentView addSubview:self.routeIV];
        
        self.stationNumLabel = [[UILabel alloc]init];
        self.stationNumLabel.textColor = UIColorFromRGB(0x212121);
        self.stationNumLabel.font = RFONT(14);
        [self.contentView addSubview:self.stationNumLabel];
        
        self.stationLabel = [[UILabel alloc]init];
        self.stationLabel.font = RFONT(14);
        self.stationLabel.textColor = UIColorFromRGB(0x212121);
        [self.contentView addSubview:self.stationLabel];
        
    }
    return self;
    
}

- (void)setStationString:(NSString *)station withStationNum:(NSString *)stationNum withCurrentStation:(NSInteger)currentIndex totalStation:(NSInteger)total withBusInfoArr:(nonnull NSArray *)busInfoArr {
    
    self.circleIV.image = [UIImage imageNamed:@"circle2"];
    self.routeIV.image = [UIImage imageNamed:@"route"];
    self.stationLabel.verticalText = station;
    
    if (currentIndex == 0) {
        self.circleIV.image = [UIImage imageNamed:@"circle1"];
    }
    
    if (currentIndex == total - 1) {
        self.circleIV.image = [UIImage imageNamed:@"circle1"];
        self.routeIV.image = [UIImage imageNamed:@""];
    }
    
//    __weak typeof(self) weakSelf = self;
    [busInfoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         
        HYBusinfoModel *busInfoModel = obj;
        if ([stationNum isEqualToString:@(abs(busInfoModel.stationNo.intValue)).stringValue]) {
//            self.circleIV.image = [UIImage imageNamed:@"circle3"];
            self.carIV.hidden = NO;
        }
        
    }];
    
}

- (void)currentIndex:(NSInteger)index totalStation:(NSInteger)total withBusInfoArr:(NSArray *)busInfoArr {
    
    if (index == 0) {
        self.circleIV.image = [UIImage imageNamed:@"circle1"];
        self.routeIV.hidden = NO;
    }else if (index == total - 1) {
        self.circleIV.image = [UIImage imageNamed:@"circle1"];
        self.routeIV.hidden = YES;
    }else {
        self.routeIV.hidden = NO;
    }
    self.stationNumLabel.text = [NSString stringWithFormat:@"%ld",(long)(index + 1)];
    
}

- (void)setStationModel:(HYSearchStationModel *)stationModel {
    _stationModel = stationModel;
    
    if ([stationModel.currentBus isEqualToString:@"1"]) {
        self.circleIV.image = [UIImage imageNamed:@"circle3"];
    }else {
        self.circleIV.image = [UIImage imageNamed:@"circle2"];
    }
//    self.circleIV.image = [UIImage imageNamed:@"circle2"];
    self.routeIV.image = [UIImage imageNamed:@"route"];
//    self.stationNumLabel.text = stationModel.labelNo;
    self.stationLabel.verticalText = stationModel.stationName;
    self.carIV.hidden = [stationModel.stationHaveCar isEqualToString:@"1"]?NO:YES;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.carIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(30);
        make.left.equalTo(self.contentView.mas_centerX).offset(-7);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.circleIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(2);
        make.top.equalTo(self.carIV.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [self.routeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleIV.mas_right);
        make.centerY.equalTo(self.circleIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 4));
    }];
    
    [self.stationNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleIV.mas_bottom).offset(2);
        make.centerX.equalTo(self.circleIV.mas_centerX);
    }];
    
    [self.stationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stationNumLabel.mas_bottom);
//        make.left.equalTo(self.contentView.mas_left);
        make.centerX.equalTo(self.stationNumLabel.mas_centerX);
    }];
    
}

@end
