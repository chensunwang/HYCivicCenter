//
//  CommintStationView.m
//  HelloFrame
//
//  Created by nuchina on 2021/10/26.
//

#import "CommintStationView.h"
#import "HYCivicCenterCommand.h"

@implementation CommintStationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.timeLabel = [[UILabel alloc]init];
        [self addSubview:self.timeLabel];
        
        self.signalIV = [[UIImageView alloc]init];
        self.signalIV.image = [UIImage imageNamed:BundleFile(@"busSignal")];
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

- (void)setTimeString:(NSString *)time speed:(NSString *)speed stationNum:(NSString *)stationNum {
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@分钟",time] attributes:@{NSFontAttributeName: RFONT(28),NSForegroundColorAttributeName: UIColorFromRGB(0x157AFF)}];

    [string addAttributes:@{NSFontAttributeName: RFONT(14)} range:NSMakeRange(time.length, 2)];
    self.timeLabel.attributedText = string;
    self.speedLabel.text = speed;
    self.stationNumLabel.text = stationNum;
    
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
