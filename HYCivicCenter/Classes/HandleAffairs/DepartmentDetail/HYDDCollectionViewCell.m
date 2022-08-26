//
//  HYDDCollectionViewCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/7.
//
//  热门办事中collectionView的cell

#import "HYDDCollectionViewCell.h"

@interface HYDDCollectionViewCell ()

@property (nonatomic, strong) UIImageView * iconImgV;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation HYDDCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _iconImgV = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_iconImgV];
        [self.contentView addSubview:_titleLabel];
        
        self.titleLabel.text = @"异地长期居住证办理";
        self.titleLabel.font = MFONT(12);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self traitCollectionDidChange:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgV.mas_bottom).offset(11);
        make.centerX.width.equalTo(self);
        make.height.mas_equalTo(12);
    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColor.whiteColor;
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
}

- (void)setHotModel:(HYHotHandleAffairsModel *)hotModel {
    if (hotModel) {
        _hotModel = hotModel;
        
        [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:hotModel.hotPic]];
        self.titleLabel.text = hotModel.hotName;
    }
}

@end

