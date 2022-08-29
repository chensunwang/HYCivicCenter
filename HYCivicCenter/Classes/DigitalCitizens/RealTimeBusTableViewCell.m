//
//  RealTimeBusTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/10/25.
//

#import "RealTimeBusTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface RealTimeBusTableViewCell ()

@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UILabel *busNumLabel;
@property (nonatomic, strong) UIImageView *terminalIV;
@property (nonatomic, strong) UILabel *terminalLabel;
@property (nonatomic, strong) UILabel *nextStationLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *comingStationLabel; // 即将到站
@property (nonatomic, strong) UILabel *nextTimeLabel; // 下一辆X分钟
@property (nonatomic, strong) UILabel *waitLabel; // 等待发车

@end

@implementation RealTimeBusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        self.containView = [[UIView alloc]init];
        self.containView.backgroundColor = [UIColor whiteColor];
        self.containView.layer.cornerRadius = 6;
        self.containView.clipsToBounds = YES;
        [self.contentView addSubview:self.containView];
        
        self.busNumLabel = [[UILabel alloc]init];
        self.busNumLabel.font = RFONT(15);
        self.busNumLabel.textColor = UIColorFromRGB(0x212121);
        [self.containView addSubview:self.busNumLabel];
        
        self.terminalIV = [[UIImageView alloc]init];
        self.terminalIV.image = [UIImage imageNamed:@"terminal"];
        [self.containView addSubview:self.terminalIV];
        
        self.terminalLabel = [[UILabel alloc]init];
        self.terminalLabel.textColor = UIColorFromRGB(0x999999);
        self.terminalLabel.font = RFONT(12);
        [self.containView addSubview:self.terminalLabel];
        
        self.nextStationLabel = [[UILabel alloc]init];
        self.nextStationLabel.font = RFONT(12);
        self.nextStationLabel.textColor = UIColorFromRGB(0x333333);
        [self.containView addSubview:self.nextStationLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        //#157AFF  28  14
        self.timeLabel.hidden = YES;
        [self.containView addSubview:self.timeLabel];
        
        self.nextTimeLabel = [[UILabel alloc]init];
        self.nextTimeLabel.textColor = UIColorFromRGB(0x333333);
        self.nextTimeLabel.font = RFONT(12);
        [self.containView addSubview:self.nextTimeLabel];
        
        self.comingStationLabel = [[UILabel alloc]init];
        self.comingStationLabel.font = RFONT(17);
        self.comingStationLabel.textColor = UIColorFromRGB(0xFF8F1F);
        self.comingStationLabel.text = @"即将到站";
        self.comingStationLabel.hidden = YES;
        [self.containView addSubview:self.comingStationLabel];
        
    }
    return self;
    
}

- (void)setBusInfoModel:(HYBusinfoModel *)busInfoModel {
    _busInfoModel = busInfoModel;
    
    self.busNumLabel.text = busInfoModel.lineName;
    self.terminalLabel.text = busInfoModel.terminusStation.stationName;
    self.nextStationLabel.text = [NSString stringWithFormat:@"下一站 %@",busInfoModel.nextStation.stationName];
    if (busInfoModel.arriveNowStationNeedMinute.intValue < 2) {
        self.comingStationLabel.hidden = NO;
    }else {
        self.timeLabel.hidden = NO;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@分钟",busInfoModel.arriveNowStationNeedMinute] attributes:@{NSFontAttributeName: RFONT(28),NSForegroundColorAttributeName: UIColorFromRGB(0x157AFF)}];

        [string addAttributes:@{NSFontAttributeName: RFONT(14)} range:NSMakeRange(busInfoModel.currentBusMinute.length, 2)];
        self.timeLabel.attributedText = string;
    }
}

- (void)setNextTime:(NSString *)nextTime {
    _nextTime = nextTime;
    
    self.nextTimeLabel.text = [NSString stringWithFormat:@"下一辆 %@分钟",nextTime];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 16, 5, 16));
    }];
    
    [self.busNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(18);
        make.top.equalTo(self.containView.mas_top).offset(17);
    }];
    
    [self.terminalIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.busNumLabel.mas_right).offset(10);
        make.centerY.equalTo(self.busNumLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 3));
    }];
    
    [self.terminalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.terminalIV.mas_right).offset(10);
        make.centerY.equalTo(self.busNumLabel.mas_centerY);
    }];
    
    [self.nextStationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(18);
        make.bottom.equalTo(self.containView.mas_bottom).offset(-14);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containView.mas_right).offset(-16);
        make.top.equalTo(self.containView.mas_top).offset(9);
    }];
    
    [self.nextTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containView.mas_right).offset(-16);
        make.bottom.equalTo(self.containView.mas_bottom).offset(-14);
    }];
    
    [self.comingStationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.containView.mas_right).offset(-16);
        make.top.equalTo(self.containView.mas_top).offset(9);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
