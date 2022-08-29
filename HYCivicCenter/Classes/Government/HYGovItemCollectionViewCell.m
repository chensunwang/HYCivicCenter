//
//  HYGovItemCollectionViewCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/21.
//

#import "HYGovItemCollectionViewCell.h"
#import "HYCivicCenterCommand.h"

@interface HYGovItemCollectionViewCell ()

@property (nonatomic, strong) UIImageView * logoImgV;
@property (nonatomic, strong) UILabel * titlelabel;
@property (nonatomic, strong) UILabel * subTitlelabel;

@end

@implementation HYGovItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
    }
    return self;
}

- (void)setupUI {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    
    self.logoImgV = [[UIImageView alloc] init];
    self.titlelabel = [[UILabel alloc] init];
    self.subTitlelabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:self.logoImgV];
    [self.contentView addSubview:self.titlelabel];
    [self.contentView addSubview:self.subTitlelabel];
    
    [self.logoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(16);
        make.width.height.mas_equalTo(36);
    }];
    
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(self);
        make.top.equalTo(self.logoImgV.mas_bottom).offset(20);
        make.height.mas_equalTo(16);
    }];
    self.titlelabel.text = @"南昌经开区";
    self.titlelabel.font = MFONT(15);
    self.titlelabel.textAlignment = NSTextAlignmentCenter;
    
    [self.subTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self).offset(-19);
        make.left.mas_equalTo(25);
        make.right.equalTo(self).offset(-25);
    }];
    self.subTitlelabel.text = @"医疗保障局、公安局、自然资源";
    self.subTitlelabel.font = MFONT(12);
    self.subTitlelabel.numberOfLines = 2;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColor.whiteColor;
    self.titlelabel.textColor = UIColorFromRGB(0x333333);
    self.subTitlelabel.textColor = UIColorFromRGB(0x999999);
}

- (void)setDepartmentModel:(HYDepartmentCountryModel *)departmentModel {
    if (departmentModel) {
        [self.logoImgV sd_setImageWithURL:[NSURL URLWithString:departmentModel.icon]];
        self.titlelabel.text = departmentModel.title;
        self.subTitlelabel.text = departmentModel.subTitle;
    }
}

@end
