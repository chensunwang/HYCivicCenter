//
//  MyCouponDetailViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/11.
//

#import "MyCouponDetailViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface MyCouponDetailViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MyCouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"优惠券详情"];
    
    [self configUI];
    
}

- (void)configUI {
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    UIImageView *codeIV = [[UIImageView alloc]init];
    codeIV.userInteractionEnabled = YES;
    codeIV.image = HyBundleImage(@"coupons");
    [self.scrollView addSubview:codeIV];
    
    UILabel *pricceLabel = [[UILabel alloc] init];
    pricceLabel.numberOfLines = 0;
    [codeIV addSubview:pricceLabel];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"￥15" attributes:@{NSFontAttributeName: RFONT(15),NSForegroundColorAttributeName: UIColorFromRGB(0x333333)}];

    [string addAttributes:@{NSFontAttributeName: RFONT(24)} range:NSMakeRange(1, 2)];

    pricceLabel.attributedText = string;
    
    UILabel *couponNameLabel = [[UILabel alloc]init];
    couponNameLabel.textColor = UIColorFromRGB(0x333333);
    couponNameLabel.font = RFONT(15);
    couponNameLabel.text = @"打车出行代金券";
    [codeIV addSubview:couponNameLabel];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = UIColorFromRGB(0x666666);
    timeLabel.text = @"有效期至：2021-08-30 12:00:00";
    timeLabel.font = RFONT(12);
    [codeIV addSubview:timeLabel];
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [confirmBtn setTitle:@"立即核销" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = RFONT(16);
    confirmBtn.layer.cornerRadius = 23;
    confirmBtn.clipsToBounds = YES;
    [confirmBtn setBackgroundColor:UIColorFromRGB(0x157AFF)];
    [self.scrollView addSubview:confirmBtn];
    
    UIImageView *qrcodeIV = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageWithCIImage:[self createQRcodeWithString:@"666888"]];
    qrcodeIV.image = image;
    [self.scrollView addSubview:qrcodeIV];
    
    [codeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(16);
        make.top.equalTo(self.scrollView.mas_top).offset(16);
//        make.right.equalTo(self.scrollView.mas_right).offset(-16);
//        make.height.mas_equalTo(428);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 32, 428));
    }];
    
    [pricceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeIV.mas_left).offset(37);
        make.top.equalTo(codeIV.mas_top).offset(37);
    }];
    
    [couponNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pricceLabel.mas_right).offset(54);
        make.top.equalTo(codeIV.mas_top).offset(26);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pricceLabel.mas_right).offset(54);
        make.top.equalTo(couponNameLabel.mas_bottom).offset(15);
    }];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(codeIV.mas_bottom).offset(-36.5);
        make.centerX.equalTo(codeIV.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(210, 46));
    }];
    
    [qrcodeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(confirmBtn.mas_top).offset(-43);
        make.centerX.equalTo(codeIV.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(154, 154));
    }];
    
    [confirmBtn layoutIfNeeded]; // 重点
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = confirmBtn.bounds;
    
    [confirmBtn.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0x1991FF).CGColor,(__bridge id)UIColorFromRGB(0x0F5CFF).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:bottomView];
    
    UIView *cycleView = [[UIView alloc]init];
    cycleView.layer.borderWidth = 1.5;
    cycleView.layer.borderColor = UIColorFromRGB(0xFE8601).CGColor;
    cycleView.layer.cornerRadius = 6;
    cycleView.clipsToBounds = YES;
    [bottomView addSubview:cycleView];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"使用说明";
    tipLabel.textColor = UIColorFromRGB(0x333333);
    tipLabel.font = RFONT(16);
    [bottomView addSubview:tipLabel];
    
    NSString *detailString = @"2020年4月13日至2020年4月19日活动期间，每个用户仅限最高领取3张。同一ID、同-设备、同一手机号、同一支付账户同一取餐联系电话、同一送餐联系电话、同-送餐地址，均视为同一用户;\n本券使用时间:仅限每天10:30-23:30使用，具体请以餐厅实际营业时间为准;本券不兑换现金，不参与外送服务;";
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.textColor = UIColorFromRGB(0x999999);
    detailLabel.font = RFONT(11);
    detailLabel.numberOfLines = 0;
    detailLabel.text = detailString;
    [bottomView addSubview:detailLabel];
    
    CGRect rect = [detailString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 64, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:RFONT(11)}
                                         context:nil];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left).offset(16);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 32);
        make.top.equalTo(codeIV.mas_bottom);
        make.height.mas_equalTo(110+rect.size.height);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(36);
        make.left.equalTo(bottomView.mas_left).offset(32.5);
    }];
    
    [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tipLabel.mas_left).offset(-4.5);
        make.centerY.equalTo(tipLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(16);
        make.right.equalTo(bottomView.mas_right).offset(-16);
        make.top.equalTo(tipLabel.mas_bottom).offset(14.5);
    }];
}

- (CIImage *)createQRcodeWithString:(NSString *)string {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    [filter setValue:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    CIImage *ciImg = filter.outputImage;
    return ciImg;
    
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 88);
        _scrollView.backgroundColor = UIColorFromRGB(0x157AFF);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
    
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
