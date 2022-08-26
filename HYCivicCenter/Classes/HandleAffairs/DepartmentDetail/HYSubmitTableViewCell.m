//
//  HYSubmitTableViewCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/11.
//

#import "HYSubmitTableViewCell.h"

@interface HYSubmitTableViewCell ()

@end

@implementation HYSubmitTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    self.submitBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.equalTo(self).offset(-8);
        make.height.mas_equalTo(46);
        make.centerY.equalTo(self);
    }];
    [self.submitBtn setTitle:@"开始提交" forState:UIControlStateNormal];
    self.submitBtn.layer.cornerRadius = 23;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - 52, 46) colorArray:@[UIColorFromRGB(0x1991F1), UIColorFromRGB(0x0F5CFF)] percentageArray:@[@(0.5),@(1)] gradientType:GradientFromLeftToRight];
    [self.submitBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

// 设置渐变颜色
- (void)setGradientColor:(UIButton *)button colors:(NSArray *)colors start:(CGPoint)start end:(CGPoint)end radius:(CGFloat)radius {
    CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
    gradient.startPoint = start;
    gradient.endPoint = end;
    gradient.colors = colors;
    gradient.frame = button.bounds;
    gradient.cornerRadius = radius;
    [button.layer insertSublayer:gradient atIndex:0];
}

- (void)btnClicked:(UIButton *)sender {
    if (self.submitTableViewCellBlock) {
        self.submitTableViewCellBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
