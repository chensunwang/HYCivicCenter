//
//  HYOnLineHandleHeader.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/14.
//

#import "HYOnLineHandleHeader.h"

@interface HYOnLineHandleHeader ()

@property(nonatomic, strong) UIView *leftView;

@end

@implementation HYOnLineHandleHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
    }
    return self;
}

- (void)setupUI {
    self.leftView = [[UIView alloc] init];
    [self addSubview:self.leftView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = MFONT(15);
    [self addSubview:self.nameLabel];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(3, 12));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftView.mas_right).offset(9);
        make.centerY.equalTo(self);
    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColor.whiteColor;
    self.leftView.backgroundColor = UIColorFromRGB(0x157AFF);
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
}

@end
