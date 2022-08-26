//
//  HYRealNameAlertView.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/17.
//
//  实名认证弹窗

#import "HYRealNameAlertView.h"

#define AlertW 230

@interface HYRealNameAlertView ()

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation HYRealNameAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message leftBtn:(NSString *)left rightBtn:(NSString *)right leftHandle:(SEL _Nonnull)leftHandle rightHandle:(SEL _Nonnull)rightHandle {
    self = [super init];
    if (self) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
    }
    return self;
}

- (void)setupUI {
    self.frame = UIScreen.mainScreen.bounds;
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AlertW, 214)];
    self.alertView.layer.cornerRadius = 11.0;
    self.alertView.layer.position = self.center;
    [self addSubview:self.alertView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, AlertW - 32, 16)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = MFONT(17);
    self.titleLabel.text = @"实名认证";
    [self.alertView addSubview:self.titleLabel];
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(21, 42, 188, 69)];
    self.logoImageView.image = [UIImage imageNamed:@"icon_real_name"];
    [self.alertView addSubview:self.logoImageView];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 125, AlertW - 38, 30)];
    self.messageLabel.text = @"因业务需求，使用本服务前需完成实名认证。";
    self.messageLabel.font = RFONT(12);
    self.messageLabel.numberOfLines = 2;
    [self.alertView addSubview:self.messageLabel];
    
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(26, 174, 70, 28)];
    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    self.leftButton.layer.cornerRadius = 7;
    [self.alertView addSubview:self.leftButton];
    [self.leftButton addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(133, 174, 70, 28)];
    [self.rightButton setTitle:@"确认" forState:UIControlStateNormal];
    self.rightButton.layer.cornerRadius = 7;
    [self.alertView addSubview:self.rightButton];
    [self.rightButton addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    self.alertView.backgroundColor = UIColor.whiteColor;
    self.titleLabel.textColor = UIColorFromRGB(0x212121);
    self.messageLabel.textColor = UIColorFromRGB(0x666666);
    [self.leftButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.leftButton setBackgroundColor:UIColorFromRGB(0xC6C6CB)];
    [self.rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.rightButton setBackgroundColor:UIColorFromRGB(0x157AFF)];
}

- (void)showAlertView {
    UIWindow *rootWindow = [[UIApplication sharedApplication] keyWindow];
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation {
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)cancelBtnClicked {
    if (self.alertResult) {
        self.alertResult(1);
    }
    [self removeFromSuperview];
}

- (void)confirmBtnClicked {
    if (self.alertResult) {
        self.alertResult(2);
    }
    [self removeFromSuperview];
}

@end
