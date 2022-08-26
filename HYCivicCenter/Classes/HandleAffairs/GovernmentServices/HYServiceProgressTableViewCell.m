//
//  HYServiceProgressTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/14.
//

#import "HYServiceProgressTableViewCell.h"

@interface HYServiceProgressTableViewCell ()

@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation HYServiceProgressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
        [self traitCollectionDidChange:nil];
    }
    return self;
    
}

- (void)setupUI {
    self.contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    self.containView = [[UIView alloc] init];
    self.containView.layer.cornerRadius = 8;
    self.containView.clipsToBounds = YES;
    self.containView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.containView];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = RFONT(12);
    self.timeLabel.textColor = UIColorFromRGB(0x999999);
    [self.containView addSubview:self.timeLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = RFONT(12);
    // 0x157AFF 审核通过
    // 0xFE8601 挂起
    // 0xFD5C66 外网预审驳回
    self.statusLabel.textColor = UIColorFromRGB(0xFD5C66);
    [self.containView addSubview:self.statusLabel];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = RFONT(17);
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    [self.containView addSubview:self.nameLabel];
}

- (void)setProgressModel:(HYServiceProgressModel *)progressModel {
    _progressModel = progressModel;
    
    self.timeLabel.text = progressModel.finishTime;
    self.nameLabel.text = progressModel.itemName;
    self.statusLabel.text = progressModel.stateName;
    if ([progressModel.stateColor isEqualToString:@"yellow"]) {
        self.statusLabel.textColor = UIColorFromRGB(0xFE8601);
    } else if ([progressModel.stateColor isEqualToString:@"red"]) {
        self.statusLabel.textColor = UIColorFromRGB(0xFD5C66);
    } else if ([progressModel.stateColor isEqualToString:@"blue"]) {
        self.statusLabel.textColor = UIColorFromRGB(0x157AFF);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 16, 8, 16));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(20);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-23);
        make.top.mas_equalTo(20);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.equalTo(self).offset(-16);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(21);
    }];
    
//    [self.applyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.containView.mas_left).offset(16);
//        make.bottom.equalTo(self.containView.mas_bottom).offset(-21);
//    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
