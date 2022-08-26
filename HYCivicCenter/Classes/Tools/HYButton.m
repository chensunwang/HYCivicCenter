//
//  HYButton.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/13.
//

#import "HYButton.h"

@implementation HYButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.backgroundColor = UIColorFromRGB(0xF8FCFF);
        self.bgView.layer.cornerRadius = 24;
        self.bgView.clipsToBounds = YES;
        [self addSubview:self.bgView];
        
        self.headerIV = [[UIImageView alloc]init];
        self.headerIV.userInteractionEnabled = YES;
        [self addSubview:self.headerIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = RFONT(16);
        self.nameLabel.textColor = UIColorFromRGB(0xF8FCFF);
        [self addSubview:self.nameLabel];
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
//        make.centerY.equalTo(self.bgView.mas_centerY);
        make.top.equalTo(self.mas_top).offset(25);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.bgView.mas_bottom).offset(12);
    }];
    
}

@end
