//
//  ReceiceCardViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/18.
//

#import "ReceiceCardViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface ReceiceCardViewController ()

@property (nonatomic, strong) UIImageView *cardIV;
@property (nonatomic, strong) UIButton *checkBtn;

@end

@implementation ReceiceCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"立即领卡"];
    
    [self configUI];
    
}

- (void)configUI {
    
    //businessBG
    UIImageView *headerBg = [[UIImageView alloc]init];
    headerBg.image = HyBundleImage(@"businessBG");
    [self.view addSubview:headerBg];
    
    self.cardIV = [[UIImageView alloc]init];
    self.cardIV.layer.cornerRadius = 8;
    self.cardIV.clipsToBounds = YES;
//    self.cardIV.backgroundColor = [UIColor orangeColor];
    self.cardIV.image = HyBundleImage(@"busCard");
    [self.view addSubview:self.cardIV];
    
    UIButton *receiveBtn = [[UIButton alloc]init];
    [receiveBtn setTitle:@"立即领卡" forState:UIControlStateNormal];
    [receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    receiveBtn.titleLabel.font = RFONT(16);
    receiveBtn.layer.cornerRadius = 8;
    receiveBtn.clipsToBounds = YES;
//    [receiveBtn setBackgroundColor:UIColorFromRGB(0x1991FF)];
    [receiveBtn addTarget:self action:@selector(receiveClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:receiveBtn];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"——  先乘车、后付款  ——";
    tipLabel.textColor = UIColorFromRGB(0x333333);
    tipLabel.font = RFONT(12);
    [self.view addSubview:tipLabel];
    
    [headerBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.height.mas_equalTo(145);
    }];
    
    [self.cardIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight + 16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.mas_equalTo(([UIScreen mainScreen].bounds.size.width - 32) * 0.64);
    }];
    
//    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(16);
//        make.top.equalTo(self.cardIV.mas_bottom).offset(24);
//        make.size.mas_equalTo(CGSizeMake(16, 16));
//    }];
    
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.cardIV.mas_bottom).offset(24);
//        make.left.equalTo(self.checkBtn.mas_right).offset(5);
//        make.right.equalTo(self.view.mas_right).offset(-26);
//    }];
    
    [receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.top.equalTo(self.cardIV.mas_bottom).offset(50);
        make.height.mas_equalTo(46);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(receiveBtn.mas_bottom).offset(27);
    }];
    
    [receiveBtn layoutIfNeeded]; // 重点
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = receiveBtn.bounds;
    
    [receiveBtn.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0x1991FF).CGColor,(__bridge id)UIColorFromRGB(0x0F5CFF).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
}

- (void)checkedClicked:(UIButton *)button {
    
    if (button.selected) {
        [button setImage:HyBundleImage(@"checked") forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"checkAgreenBtn"];
    }else {
        [button setImage:HyBundleImage(@"checkBox") forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"checkAgreenBtn"];
    }
    
}

- (void)receiveClicked {
    
//    NSNumber *checkAgree = [[NSUserDefaults standardUserDefaults]objectForKey:@"checkAgreenBtn"];
//    if (!checkAgree.boolValue) {
//        NSLog(@" 请先阅读并勾选xxxxx ");
//        return;
//    }
    
    // 二维码账户开通
    [SVProgressHUD showWithStatus:@"正在领取"];
    [HttpRequest postPathBus:@"" params:@{@"uri":@"/api/hcard/create/account"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if ([responseObject[@"code"] intValue] == 200) {
            // 初次请求开通账户
            if ([responseObject[@"success"] intValue] == 1) { // 开通成功
                if ([self.delegate respondsToSelector:@selector(getBusQrcode)]) {
                    [self.delegate getBusQrcode];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                
                [SVProgressHUD showWithStatus:responseObject[@"message"]];
                [SVProgressHUD dismissWithDelay:1];
                
            }

        }
        [SVProgressHUD dismissWithDelay:0.5];
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
