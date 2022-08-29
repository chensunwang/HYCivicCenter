//
//  OpenIDCardViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/9/8.
//

#import "OpenIDCardViewController.h"
#import "HYAesUtil.h"
#import "HYCivicCenterCommand.h"

@interface OpenIDCardViewController ()

@property (nonatomic, strong) UITextField *veriCodeTF;
@property (nonatomic, strong) UIButton *getCodeBtn;

@end

@implementation OpenIDCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"开通网证";
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self configUI];
    
}

- (void)configUI {
    
    UIImageView *bgIV = [[UIImageView alloc]init];
    bgIV.image = [UIImage imageNamed:@"openCertiBg"];
    [self.view addSubview:bgIV];
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 8;
    contentView.clipsToBounds = YES;
    [self.view addSubview:contentView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"手机号开通";
    nameLabel.font = RFONT(17);
    nameLabel.textColor = UIColorFromRGB(0x333333);
    [contentView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = [NSString stringWithFormat:@"手机号： %@",self.phone];
    phoneLabel.textColor = UIColorFromRGB(0x333333);
    phoneLabel.font = RFONT(17);
    [contentView addSubview:phoneLabel];
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [contentView addSubview:line1];
    
    self.veriCodeTF = [[UITextField alloc]init];
    self.veriCodeTF.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.veriCodeTF.placeholder = @"请输入验证码";
    self.veriCodeTF.textColor = UIColorFromRGB(0x333333);
    self.veriCodeTF.font = RFONT(17);
    [contentView addSubview:self.veriCodeTF];
    
    self.getCodeBtn = [[UIButton alloc]init];
    [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getCodeBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    self.getCodeBtn.titleLabel.font = RFONT(12);
    self.getCodeBtn.layer.cornerRadius = 2;
    self.getCodeBtn.clipsToBounds = YES;
    self.getCodeBtn.layer.borderWidth = 1;
    self.getCodeBtn.layer.borderColor = UIColorFromRGB(0x0F5DFF).CGColor;
    [self.getCodeBtn addTarget:self action:@selector(getCodeClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:self.getCodeBtn];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [contentView addSubview:line2];
    
//    UIButton *checkBtn = [[UIButton alloc]init];
//    checkBtn.layer.borderWidth = 1;
//    checkBtn.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
//    checkBtn.layer.cornerRadius = 2;
//    checkBtn.clipsToBounds = YES;
//    [checkBtn addTarget:self action:@selector(checkClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [contentView addSubview:checkBtn];
//
//    UILabel *agreeLabel = [[UILabel alloc] init];
//    agreeLabel.numberOfLines = 0;
//    [contentView addSubview:agreeLabel];
//
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"登录即代表你同意《用户协议》和《隐私政策》" attributes:@{NSFontAttributeName: RFONT(11),NSForegroundColorAttributeName: UIColorFromRGB(0x999999)}];
//    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:17/255.0 green:100/255.0 blue:255/255.0 alpha:1.0]} range:NSMakeRange(8, 6)];
//    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:22/255.0 green:131/255.0 blue:255/255.0 alpha:1.0]} range:NSMakeRange(15, 6)];
//    agreeLabel.attributedText = string;
    
    UIButton *submitBtn = [[UIButton alloc]init];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = RFONT(16);
    [submitBtn addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = 20;
    submitBtn.clipsToBounds = YES;
    [contentView addSubview:submitBtn];
    
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.height.mas_equalTo(153);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.top.equalTo(self.view.mas_top).offset(66 + kTopNavHeight);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.mas_equalTo(358);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(22);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(50);
        make.left.equalTo(contentView.mas_left).offset(21);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(21);
        make.right.equalTo(contentView.mas_right).offset(-21);
        make.top.equalTo(phoneLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.veriCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(21);
        make.top.equalTo(line1.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(160, 48));
    }];
    
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-21);
        make.centerY.equalTo(self.veriCodeTF.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 36));
    }];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(40);
        make.bottom.equalTo(contentView.mas_bottom).offset(-40);
        make.right.equalTo(contentView.mas_right).offset(-40);
        make.height.mas_equalTo(40);
    }];
    
    [submitBtn layoutIfNeeded]; // 重点
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = submitBtn.bounds;
    
    [submitBtn.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0x1991FF).CGColor,(__bridge id)UIColorFromRGB(0x0F5CFF).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
}

- (void)checkClicked:(UIButton *)buton {
        
}

// 获取验证码
- (void)getCodeClicked {
    
    NSString *phoneEncrypt = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYPhoneEncrypt"];
    NSString *phone = [HYAesUtil aesDecrypt:phoneEncrypt];
    
    [HttpRequest postPathGov:@"" params:@{@"uri": @"/apiFile/haiDunBase/sendSms",@"bsn":self.bsn?:@"",@"phone":phone?:@"",@"source":@"2"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            //304460
        if ([responseObject[@"success"] intValue] == 1) {
            [SVProgressHUD showWithStatus:@"获取验证码成功"];
            __block int timeout = 59;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
            dispatch_source_set_event_handler(_timer, ^{
                if (timeout <= 0) {
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.getCodeBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                        [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                        self.getCodeBtn.userInteractionEnabled = YES;
                    });
                } else {
                    int seconds = timeout % 60;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.getCodeBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
                        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"(%@s)",strTime] forState:UIControlStateNormal];
                        self.getCodeBtn.userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            [SVProgressHUD dismiss];
        } else if ([responseObject[@"success"] intValue] == 0) {
            [SVProgressHUD showWithStatus:responseObject[@"message"]];
            [SVProgressHUD dismissWithDelay:0.5];
        }
    }];
}

// 提交/验证短信验证码
- (void)submitClicked {
    
    [HttpRequest postPathGov:@"" params:@{@"uri": @"/apiFile/haiDunBase/matcheCode", @"bsn": self.bsn ? : @"", @"phone": self.phone ? : @"", @"vcode": self.veriCodeTF.text, @"source": @"2"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
        if ([responseObject[@"success"] intValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
