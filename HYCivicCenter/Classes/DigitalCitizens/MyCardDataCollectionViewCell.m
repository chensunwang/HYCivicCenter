//
//  MyCardDataCollectionViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/21.
//

#import "MyCardDataCollectionViewCell.h"

@implementation MyCardDataCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.dataLabel = [[UILabel alloc]init];
        self.dataLabel.textColor = UIColorFromRGB(0x333333);
        self.dataLabel.font = BFONT(18);
        [self.contentView addSubview:self.dataLabel];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x808080);
        self.nameLabel.font = RFONT(12);
        [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-16);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
}

@end
