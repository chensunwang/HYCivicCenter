//
//  AddHonorCollectionViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/24.
//

#import "AddHonorCollectionViewCell.h"
#import "HYCivicCenterCommand.h"

@implementation AddHonorCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.contentIV = [[UIImageView alloc]init];
        self.contentIV.layer.cornerRadius = 10;
//        self.contentIV.clipsToBounds = YES;
        self.contentIV.backgroundColor = UIColorFromRGB(0x999999);
        [self.contentView addSubview:self.contentIV];
        
        self.addIV = [[UIImageView alloc]init];
        self.addIV.image = HyBundleImage(@"addCard");
        self.addIV.backgroundColor = UIColorFromRGB(0x999999);
        [self.contentView addSubview:self.addIV];
        
        self.addLabel = [[UILabel alloc]init];
        self.addLabel.textColor = UIColorFromRGB(0x333333);
        self.addLabel.font = RFONT(12);
        self.addLabel.text = @"上传图片";
        [self.contentView addSubview:self.addLabel];
        
        self.delBtn = [[UIButton alloc]init];
        [self.delBtn setImage:HyBundleImage(@"deleteHonor") forState:UIControlStateNormal];
//        [self.delBtn setBackgroundColor:[UIColor redColor]];
        self.delBtn.layer.cornerRadius = 10;
        self.delBtn.clipsToBounds = YES;
        [self.contentView addSubview:self.delBtn];
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 0, 10));
    }];
    
    [self.addIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(26);
        make.centerX.equalTo(self.contentView.mas_centerX).offset(-5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-16);
        make.centerX.equalTo(self.contentView.mas_centerX).offset(-5);
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
}

@end
