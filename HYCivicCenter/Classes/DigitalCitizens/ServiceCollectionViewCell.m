//
//  ServiceCollectionViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/5.
//

#import "ServiceCollectionViewCell.h"
#import "HYCivicCenterCommand.h"

@interface ServiceCollectionViewCell ()

@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailNameLabel;

@end

@implementation ServiceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.headerIV = [[UIImageView alloc]init];
        self.headerIV.layer.cornerRadius = 13;
        self.headerIV.clipsToBounds = YES;
        self.headerIV.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:self.headerIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = RFONT(14);
        [self.contentView addSubview:self.nameLabel];
        
        self.detailNameLabel = [[UILabel alloc]init];
        self.detailNameLabel.textColor = UIColorFromRGB(0x999999);
        self.detailNameLabel.font = RFONT(11);
        [self.contentView addSubview:self.detailNameLabel];
        
        self.nameLabel.text = @"中考成绩查询";
        self.detailNameLabel.text = @" 学生登录系统查询";
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(8);
        make.top.equalTo(self.headerIV.mas_top).offset(4);
    }];
    
    [self.detailNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(8);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    
}

@end
