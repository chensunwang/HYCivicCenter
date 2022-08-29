//
//  MyCertificateContentCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/10.
//

#import "MyCertificateContentCell.h"
#import "HYCivicCenterCommand.h"

@interface MyCertificateContentCell ()

@property (nonatomic, strong) UIImageView *lineIV;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *contentIV;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *cardNameLabel;
@property (nonatomic, strong) UILabel *cardNumLabel;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UIButton *codeBtn;

@end

@implementation MyCertificateContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lineIV = [[UIImageView alloc]init];
        self.lineIV.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.lineIV];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = UIColorFromRGB(0x333333);
        self.timeLabel.font = RFONT(12);
        [self.contentView addSubview:self.timeLabel];
        
        self.contentIV = [[UIImageView alloc]init];
        self.contentIV.userInteractionEnabled = YES;
        self.contentIV.layer.cornerRadius = 8;
        self.contentIV.clipsToBounds = YES;
        [self.contentView addSubview:self.contentIV];
        
        self.headerIV = [[UIImageView alloc]init];
        self.headerIV.layer.cornerRadius = 24;
        self.headerIV.clipsToBounds = YES;
        self.headerIV.backgroundColor = [UIColor yellowColor];
        [self.contentIV addSubview:self.headerIV];
        
        self.cardNameLabel = [[UILabel alloc]init];
        self.cardNameLabel.textColor = UIColorFromRGB(0x333333);
        self.cardNameLabel.font = RFONT(18);
        [self.contentIV addSubview:self.cardNameLabel];
        
        self.cardNumLabel = [[UILabel alloc]init];
        self.cardNumLabel.textColor = UIColorFromRGB(0x666666);
        self.cardNumLabel.font = RFONT(12);
        [self.contentIV addSubview:self.cardNumLabel];
        
        self.bottomBtn = [[UIButton alloc]init];
        [self.bottomBtn setTitle:@"查看电子证件" forState:UIControlStateNormal];
        self.bottomBtn.titleLabel.font = RFONT(12);
        [self.bottomBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        self.bottomBtn.alpha = 0.2;
        [self.contentIV addSubview:self.bottomBtn];
        
        self.codeBtn = [[UIButton alloc]init];
        [self.codeBtn setBackgroundColor:[UIColor greenColor]];
        [self.bottomBtn addSubview:self.codeBtn];
        
        self.timeLabel.text = @"2021-07-20";
        self.contentIV.backgroundColor = [UIColor orangeColor];
        self.cardNumLabel.text = @"362201100000000000";
        self.cardNameLabel.text = @"身份证";
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.lineIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(16);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineIV.mas_right).offset(16);
        make.top.equalTo(self.contentView.mas_top).offset(5);
    }];
    
    [self.contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineIV.mas_right).offset(16);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-16);
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentIV.mas_left).offset(16);
        make.top.equalTo(self.contentIV.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(16);
        make.top.equalTo(self.headerIV.mas_top).offset(5);
    }];
    
    [self.cardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(16);
        make.top.equalTo(self.cardNameLabel.mas_bottom).offset(14.5);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentIV);
        make.height.mas_equalTo(40);
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomBtn.mas_right).offset(-16);
        make.centerY.equalTo(self.bottomBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
