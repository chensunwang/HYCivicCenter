//
//  HYServiceCollectionViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/23.
//

#import "HYServiceCollectionViewCell.h"
#import "HYCivicCenterCommand.h"

@interface HYServiceCollectionViewCell ()

@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subNameLabel;

@end

@implementation HYServiceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.headerIV = [[UIImageView alloc]init];
        [self.contentView addSubview:self.headerIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = RFONT(15);
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        [self.contentView addSubview:self.nameLabel];
        
        self.subNameLabel = [[UILabel alloc]init];
        self.subNameLabel.font = RFONT(12);
        self.subNameLabel.textColor = UIColorFromRGB(0x999999);
        [self.contentView addSubview:self.subNameLabel];
        
        self.nameLabel.text = @"社会服务";
        self.subNameLabel.text = @"公积金、养老保险";
        
    }
    return self;
    
}

- (void)setClassifyModel:(HYServiceClassifyModel *)classifyModel {
    _classifyModel = classifyModel;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:classifyModel.iconUrl] placeholderImage:[UIImage imageNamed:classifyModel.iconUrl]];
    self.nameLabel.text = classifyModel.serviceName;
    self.subNameLabel.text = classifyModel.remark;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(12);
        make.top.equalTo(self.headerIV.mas_top).offset(-4);
    }];
    
    [self.subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(12);
        make.bottom.equalTo(self.headerIV.mas_bottom).offset(4);
    }];
    
}

@end
