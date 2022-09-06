//
//  HYSearchView.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//

#import "HYSearchView.h"
#import "HYCivicCenterCommand.h"

@interface HYSearchView ()

@property (nonatomic, strong) UIView * searchView;
@property (nonatomic, strong) UIImageView * searchImgV;

@end

@implementation HYSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
    }
    return self;
}

- (void)setupUI {
    self.searchView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(16);
        make.right.equalTo(self).offset(-59);
        make.height.mas_equalTo(32);
    }];
    self.searchView.layer.cornerRadius = 16;
    
    self.searchImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.searchView addSubview:self.searchImgV];
    [self.searchImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView);
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(16);
    }];
    self.searchImgV.image = HyBundleImage(@"search");//HyBundleImage(@"search");
    
    
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.searchView addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView);
        make.left.equalTo(self.searchImgV.mas_right).offset(11);
        make.right.equalTo(self.searchView).offset(-11);
        make.height.mas_equalTo(23);
    }];
    self.searchTF.placeholder = @"请输入搜索内容";
    self.searchTF.font = MFONT(12);
    self.searchTF.returnKeyType = UIReturnKeySearch;
     
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self addSubview:self.searchBtn];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    self.searchBtn.titleLabel.font = MFONT(15);
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.searchView.backgroundColor = UIColor.whiteColor;
    [self.searchBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
}

@end
