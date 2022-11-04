//
//  AppDelegate.h
//  iNC-iOS
//
//  Created by yz on 2022/7/7.
//

#import "YSNCNavView.h"
#import "HYCivicCenterCommand.h"

@implementation YSNCNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self layout];
    }
    
    return self;
}

- (void)dealloc
{
    
}

//背景
- (UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] init];
        _headView.backgroundColor = UIColor.orangeColor;
        [self addSubview:_headView];
    }
    return _headView;
}

//标题
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.userInteractionEnabled = YES;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

//副标题
- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.textColor = [UIColor blackColor];
        _subTitleLabel.font = [UIFont boldSystemFontOfSize:10];
        _subTitleLabel.userInteractionEnabled = YES;
        [self addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

//返回按钮
- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
        [self addSubview:_backBtn];
    }
    return _backBtn;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:253/255.0 alpha:1.0];
        [self addSubview:_lineView];
    }
    return _lineView;
}
- (void)layout
{
    self.headView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopNavHeight);
    self.titleLabel.frame = CGRectMake(80, kStatusBarHeight, [UIScreen mainScreen].bounds.size.width - 80 * 2, kTopNavHeight);
    self.subTitleLabel.frame = CGRectMake(80, kStatusBarHeight + kTopNavHeight - 12, [UIScreen mainScreen].bounds.size.width - 80 * 2, 10);
    self.backBtn.frame = CGRectMake(0, kStatusBarHeight, 30, 44);
    self.backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    self.lineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, self.frame.size.width, 0.5);
}
@end
