//
//  BusRouteInfoView.m
//  HelloFrame
//
//  Created by nuchina on 2021/10/29.
//

#import "BusRouteInfoView.h"
#import "HYCivicCenterCommand.h"

@implementation BusRouteInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromRGB(0xE5F1FF);
        
        self.numLabel = [[UILabel alloc]init];
        self.numLabel.textColor = UIColorFromRGB(0x333333);
        self.numLabel.font = RFONT(12);
        self.numLabel.backgroundColor = [UIColor whiteColor];
        self.numLabel.layer.cornerRadius = 4;
        self.numLabel.clipsToBounds = YES;
        [self addSubview:self.numLabel];
        
        self.terminusLabel = [[UILabel alloc]init];
        self.terminusLabel.textColor = UIColorFromRGB(0x999999);
        self.terminusLabel.font = RFONT(12);
        [self addSubview:self.terminusLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = UIColorFromRGB(0x157AFF);
        self.timeLabel.font = RFONT(14);
        [self addSubview:self.timeLabel];
        
        self.soundIV = [[UIImageView alloc]init];
        self.soundIV.image = HyBundleImage(@"busSignal");
        [self addSubview:self.soundIV];
        
        self.numLabel.text = @"6路";
        self.terminusLabel.text = @"开往南昌西站";
        self.timeLabel.text = @"即将到站";
        
    }
    return self;
    
}

- (void)setStationNum:(NSString *)lineName withTerminalStation:(NSString *)stationName withTime:(NSString *)time {
    
    self.numLabel.text = [NSString stringWithFormat:@" %@ ",lineName];
    self.terminusLabel.text = stationName;
    self.timeLabel.text = time;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(13);
        make.top.equalTo(self.mas_top).offset(9);
    }];
    
    [self.terminusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(13);
        make.top.equalTo(self.numLabel.mas_bottom).offset(12);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(13);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    [self.soundIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(5);
        make.centerY.equalTo(self.timeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
}

@end
