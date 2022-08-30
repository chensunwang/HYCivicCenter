//
//  HYUploadImageCollectionViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2022/1/14.
//

#import "HYUploadImageCollectionViewCell.h"
#import "HYCivicCenterCommand.h"

@implementation HYUploadImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.headerIV = [[UIImageView alloc] init];
        [self.contentView addSubview:self.headerIV];
        self.headerIV.layer.cornerRadius = 4;
        self.headerIV.layer.borderWidth = 0.3;
        self.headerIV.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        
        self.addBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.addBtn];
        [self.addBtn setImage:[UIImage imageNamed:BundleFile(@"icon_add_img")] forState:UIControlStateNormal];
        [self.addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.deleteBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.deleteBtn];
        [self.deleteBtn setImage:[UIImage imageNamed:BundleFile(@"icon_delete_img")] forState:UIControlStateNormal];
        [self.deleteBtn setHidden:YES];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake(19, 19));
    }];
}

- (void)addBtnClicked:(UIButton *)sender {
    if (self.uploadImageCollectionViewCellBlock != nil) {
        self.uploadImageCollectionViewCellBlock(@"add");
    }
}

- (void)deleteBtnClicked:(UIButton *)sender {
    if (self.uploadImageCollectionViewCellBlock != nil) {
        self.uploadImageCollectionViewCellBlock(@"delete");
    }
}

@end
