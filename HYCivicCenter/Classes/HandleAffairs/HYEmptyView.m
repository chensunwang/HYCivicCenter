//
//  HYEmptyView.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/31.
//

#import "HYEmptyView.h"
#import "HYCivicCenterCommand.h"

@interface HYEmptyView ()  // 155 * 204

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HYEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.iconImageView = [[UIImageView alloc] init];
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(155);
        make.height.mas_equalTo(139);
    }];
    self.iconImageView.image = [UIImage imageNamed:BundleFile(@"cardHolder")];
    
    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.width.equalTo(self);
        make.height.mas_equalTo(16);
    }];
    self.titleLabel.text = @"没有更多了";
    self.titleLabel.textColor = UIColorFromRGB(0x212121);
    self.titleLabel.font = MFONT(17);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
