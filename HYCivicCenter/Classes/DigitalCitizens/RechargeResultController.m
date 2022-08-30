//
//  RechargeResultController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/30.
//

#import "RechargeResultController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface RechargeResultController ()

@property (nonatomic, strong) UIImageView *resultIV;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UIButton *backHomeBtn;

@end

@implementation RechargeResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"充值结果"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
    
}

- (void)configUI {
    
    self.resultIV = [[UIImageView alloc]init];
    if (self.type == 1) {
        self.resultIV.image = [UIImage imageNamed:BundleFile(@"rechargeSuccess")];
    }else {
        self.resultIV.image = [UIImage imageNamed:BundleFile(@"rechargefail")];
    }
    [self.view addSubview:self.resultIV];
    
    self.resultLabel = [[UILabel alloc]init];
    self.resultLabel.textColor = UIColorFromRGB(0x333333);
    self.resultLabel.font = RFONT(15);
    if (self.type == 1) {
        self.resultLabel.text = @"充值成功";
    }else {
        self.resultLabel.text = @"充值失败";
    }
    
    self.resultLabel.numberOfLines = 0;
    [self.view addSubview:self.resultLabel];
    
    self.backHomeBtn = [[UIButton alloc]init];
    [self.backHomeBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.backHomeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backHomeBtn.layer.cornerRadius = 8;
    self.backHomeBtn.clipsToBounds = YES;
    [self.backHomeBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backHomeBtn];
    
    [self.resultIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight + 50);
        make.size.mas_equalTo(CGSizeMake(150, 130));
    }];
    
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.resultIV.mas_bottom).offset(42);
    }];
    
    [self.backHomeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resultLabel.mas_bottom).offset(66);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 100, 46));
    }];
    
    [self.backHomeBtn layoutIfNeeded]; // 重点
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.backHomeBtn.bounds;
    
    [self.backHomeBtn.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0x1991FF).CGColor,(__bridge id)UIColorFromRGB(0x0F5CFF).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
}

- (void)backClicked {
    
    if ([self.delegate respondsToSelector:@selector(rechargeReload)]) {
        [self.delegate rechargeReload];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
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
