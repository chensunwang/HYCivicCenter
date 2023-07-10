//
//  HYGovernmentCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//
//  政务服务cell

#import "HYGovernmentCell.h"
#import "HYMyServiceViewController.h" // 我的服务
#import "HYServiceProgressViewController.h" // 进度查询
#import "HYRealNameAlertView.h"
#import "HYCivicCenterCommand.h"

@interface HYGovernmentCell ()

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIImageView * topImgV;

// 进度查询
@property (nonatomic, strong) UIImageView * leftImgV;
@property (nonatomic, strong) UILabel * leftTitleLab;
@property (nonatomic, strong) UILabel * leftSubTitleLab;
@property (nonatomic, strong) UIButton * leftBtn;

@property (nonatomic, strong) UIImageView * middleImgV;

// 我的服务
@property (nonatomic, strong) UIImageView * rightImgV;
@property (nonatomic, strong) UILabel * rightTitleLab;
@property (nonatomic, strong) UILabel * rightSubTitleLab;
@property (nonatomic, strong) UIButton * rightBtn;

@end

@implementation HYGovernmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUI {
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(22, 10, 6, 10));
    }];
    self.bgView.layer.cornerRadius = 10;
    
    self.topImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.topImgV];
    [self.topImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
        make.height.mas_equalTo(125);
    }];
    NSLog(@"ResourceBundle:%@", ResourceBundle);
    self.topImgV.image = HyBundleImage(@"hotServiceBG");
    
    self.leftImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.leftImgV];
    [self.leftImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(39);
        make.bottom.equalTo(self.bgView).offset(-23);
        make.width.height.mas_equalTo(30);
    }];
    self.leftImgV.image = HyBundleImage(@"icon_progressService");
    
    self.leftTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.leftTitleLab];
    [self.leftTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImgV.mas_right).offset(11);
        make.top.equalTo(self.leftImgV);
        make.height.mas_equalTo(16);
    }];
    self.leftTitleLab.text = @"进度查询";
    self.leftTitleLab.font = MFONT(16);
    
    self.leftSubTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.leftSubTitleLab];
    [self.leftSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTitleLab);
        make.bottom.equalTo(self.leftImgV).offset(2);
        make.height.mas_equalTo(12);
    }];
    self.leftSubTitleLab.text = @"立即查看";
    self.leftSubTitleLab.font = RFONT(12);
    
    self.leftBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(self.topImgV.mas_bottom);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.5 - 10);
        make.bottom.equalTo(self.bgView);
    }];
    [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.middleImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.middleImgV];
    [self.middleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.topImgV.mas_bottom).offset(18);
        make.bottom.equalTo(self.bgView).offset(-18);
        make.width.mas_equalTo(1);
    }];
    self.middleImgV.image = HyBundleImage(@"icon_banshi_middle");
    
    self.rightImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.rightImgV];
    [self.rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleImgV.mas_right).offset(39);
        make.top.width.height.equalTo(self.leftImgV);
    }];
    self.rightImgV.image = HyBundleImage(@"icon_myService");
    
    self.rightTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.rightTitleLab];
    [self.rightTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightImgV.mas_right).offset(11);
        make.top.equalTo(self.rightImgV);
        make.height.mas_equalTo(16);
    }];
    self.rightTitleLab.text = @"我的服务";
    self.rightTitleLab.font = MFONT(16);
    
    self.rightSubTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.rightSubTitleLab];
    [self.rightSubTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightTitleLab);
        make.bottom.equalTo(self.rightImgV).offset(2);
        make.height.mas_equalTo(12);
    }];
    self.rightSubTitleLab.text = @"立即查看";
    self.rightSubTitleLab.font = RFONT(12);
    
    self.rightBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-10);
        make.top.equalTo(self.topImgV.mas_bottom);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.5 - 10);
        make.bottom.equalTo(self.bgView);
    }];
    [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColorFromRGB(0xEBEFF5);
    self.bgView.backgroundColor = UIColor.whiteColor;
    self.leftTitleLab.textColor = UIColorFromRGB(0x212121);
    self.leftSubTitleLab.textColor = UIColorFromRGB(0x999999);
    self.leftBtn.backgroundColor = UIColor.clearColor;
    self.rightTitleLab.textColor = UIColorFromRGB(0x212121);
    self.rightSubTitleLab.textColor = UIColorFromRGB(0x999999);
    self.rightBtn.backgroundColor = UIColor.clearColor;
}

- (void)leftBtnClicked:(UIButton *)sender {
    if (!_isLogin) {
        return;
    }
    if (!_idCard || [_idCard isEqualToString:@""]) {  // 需要实名认证
//        [self showAlertForReanNameAuth];
        if (self.governmentCellBlock != nil) {
            self.governmentCellBlock();
        }
    } else {
        HYServiceProgressViewController *progressVC = [[HYServiceProgressViewController alloc] init];
        progressVC.hyTitleColor = _hyTitleColor;
        [self.viewController.navigationController pushViewController:progressVC animated:YES];
    }
}

- (void)rightBtnClicked:(UIButton *)sender {
    if (!_isLogin) {
        return;
    }
    if (!_idCard || [_idCard isEqualToString:@""]) {  // 需要实名认证
//        [self showAlertForReanNameAuth];
        if (self.governmentCellBlock != nil) {
            self.governmentCellBlock();
        }
    } else {
        HYMyServiceViewController *myServiceVC = [[HYMyServiceViewController alloc] init];
        myServiceVC.isEnterprise = _isEnterprise;
        myServiceVC.hyTitleColor = _hyTitleColor;
        [self.viewController.navigationController pushViewController:myServiceVC animated:YES];
    }
}

/*
- (void)showAlertForReanNameAuth {
    HYRealNameAlertView *alertV = [[HYRealNameAlertView alloc] init];
    alertV.alertResult = ^(NSInteger index) {
        if (index == 2) {
            [self jumpRealNameAuthVC];
        }
    };
    [alertV showAlertView];
}

- (void)jumpRealNameAuthVC {  // 实名认证
    
    // 类名
    NSString *class =[NSString stringWithFormat:@"%@", @"RealNameListVC"];
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];

    // 从一个字串返回一个类
    Class newClass = objc_getClass(className);
    if (!newClass)
    {
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象
    UIViewController *instance = [[newClass alloc] init];
    instance.hidesBottomBarWhenPushed = true;
    [self.viewController.navigationController pushViewController:instance animated:true];
    
}
*/
@end
