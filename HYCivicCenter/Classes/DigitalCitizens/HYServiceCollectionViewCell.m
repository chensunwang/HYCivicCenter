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
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HYServiceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.headerIV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headerIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = RFONT(15);
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        [self.contentView addSubview:self.nameLabel];
        
        self.subNameLabel = [[UILabel alloc]init];
        self.subNameLabel.font = RFONT(12);
        self.subNameLabel.textColor = UIColorFromRGB(0x999999);
        [self.contentView addSubview:self.subNameLabel];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = RFONT(15);
        self.titleLabel.textColor = UIColorFromRGB(0x333333);
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel.numberOfLines = 2;
        
        self.nameLabel.text = @"社会服务";
        self.subNameLabel.text = @"公积金、养老保险";
        self.titleLabel.text = @"社会服务";
        
    }
    return self;
    
}

- (void)setClassifyModel:(HYServiceClassifyModel *)classifyModel {
    _classifyModel = classifyModel;

    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:classifyModel.iconUrl] placeholderImage:HyBundleImage(classifyModel.iconUrl)];
    self.nameLabel.text = classifyModel.serviceName;
    self.subNameLabel.text = classifyModel.remark;
    self.titleLabel.hidden = YES;
    self.nameLabel.hidden = self.subNameLabel.hidden = NO;
}

- (void)setModel:(HYHotServiceModel *)model {
    if (model) {
        if ([model.logoUrl isEqualToString:@"legalAid"]) {  // 法律援助指南
            self.headerIV.image = HyBundleImage(model.logoUrl);
        } else {
            [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
        }
        self.titleLabel.text = model.name;
        self.titleLabel.hidden = NO;
        self.nameLabel.hidden = self.subNameLabel.hidden = YES;
    }
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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(12);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-12);
    }];
    
}

@end
