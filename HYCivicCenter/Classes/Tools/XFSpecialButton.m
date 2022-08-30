//
//  XFSpecialButton.m
//  HelloFrame
//
//  Created by nuchina on 2022/2/25.
//

#import "XFSpecialButton.h"
#import "HYCivicCenterCommand.h"

@implementation XFSpecialButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.headerIV = [[UIImageView alloc]init];
        [self addSubview:self.headerIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1.0];
        self.nameLabel.font = RFONT(12);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(14);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
        
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.centerX.equalTo(self);
    }];
    
}

@end
