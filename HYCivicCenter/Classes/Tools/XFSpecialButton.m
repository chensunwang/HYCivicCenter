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
        self.nameLabel.textColor = UIColorFromRGB(0x212121);
        self.nameLabel.font = RFONT(12);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(14);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
        
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
}

@end
