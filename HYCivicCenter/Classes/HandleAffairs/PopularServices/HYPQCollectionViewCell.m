//
//  HYPQCollectionViewCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//

#import "HYPQCollectionViewCell.h"
#import "HYCivicCenterCommand.h"

@interface HYPQCollectionViewCell ()

@property (nonatomic, strong) UIImageView * imgV;
@property (nonatomic, strong) UILabel * titleLab;

@end

@implementation HYPQCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
    }
    return self;
}

- (void)setModel:(HYHotServiceModel *)model {
    if (model) {
        if ([model.logoUrl isEqualToString:@"legalAid"] || [model.logoUrl isEqualToString:@"moreService"]) {
            self.imgV.image = [UIImage imageNamed:BundleFile(model.logoUrl)];
        } else {
            [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]];
        }
        self.titleLab.text = model.name;
    }
}

- (void)setupUI {
    self.imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.imgV];
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(39);
    }];
    self.imgV.image = [UIImage imageNamed:BundleFile(@"legalAid")];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.centerX.width.equalTo(self);
        make.height.mas_equalTo(12);
    }];
    self.titleLab.text = @"工伤认定";
    self.titleLab.font = MFONT(12);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColor.whiteColor;
    self.titleLab.textColor = UIColorFromRGB(0x212121);
}

@end
