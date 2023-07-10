//
//  MetroCodeViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/9/1.
//
//  地铁码页面

#import "MetroCodeViewController.h"
#import "DigitalTableViewCell.h"
#import "MyBusinessCardController.h"
#import "HonorWallViewController.h"
#import "CouponMainViewController.h"

#import "HYServiceCollectionViewCell.h"
#import "HYServiceTableViewCell.h"
#import "HYServiceClassifyModel.h"
#import "HYCivicCenterCommand.h"

#import "HYHotServiceModel.h"
#import "HYLegalAidGuideViewController.h"
#import "HYHandleAffairsWebVIewController.h"
#import "HYOnLineBusinessMainViewController.h"
#import "HYRealNameAlertView.h"
#import "FaceRecViewController.h"

@interface MetroCodeViewController () <UITableViewDelegate, UITableViewDataSource, FaceRecResultDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *myArr;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) BOOL isLogin;  // 是否已经登录
@property (nonatomic, copy) NSString * jumpUrl;  // 传给网页的url
@property (nonatomic, copy) NSString * code;  // 传给网页的code
@property (nonatomic, copy) NSString * titleStr;  // 传给网页的title

@end

NSString *const metroCell = @"metroCell";
@implementation MetroCodeViewController

- (void)loadView {
    [super loadView];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYServiceTableViewCell class] forCellReuseIdentifier:metroCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
    [self loadClassifyData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    MainApi *api = [MainApi sharedInstance];
    if (api.token.length > 0) {
        self.isLogin = YES;
    }
}

- (void)loadClassifyData {
//    [HttpRequest getPath:@"/phone/v2/service/getAvailableService" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
//
//        SLog(@" 获取分类 == %@ ", responseObject);
//        if ([responseObject[@"code"] intValue] == 200) {
//            self.datasArr = [HYServiceClassifyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
//            [self.tableView reloadData];
//        }
//    }];
    
    [HttpRequest getPathZWBS:@"phone/item/event/getHotList" params:@{@"pageNum": @"1", @"pageSize": @"6"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 热门服务分类== %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.datasArr = [HYHotServiceModel mj_objectArrayWithKeyValuesArray:responseObject[@"rows"]];
            
            HYHotServiceModel *legalModel = [[HYHotServiceModel alloc] init];
            legalModel.name = @"法律援助指南";
            legalModel.logoUrl = @"legalAid";
            [self.datasArr addObject:legalModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            SLog(@"%@", responseObject[@"msg"]);
        }
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        return 80;
    }
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:metroCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.myArr = self.myArr;
        cell.type = 1;
    } else {
        cell.datasArr = self.datasArr;
        cell.type = 2;
        __weak typeof(self) weakSelf = self;
        cell.serviceTableViewCellBlock = ^(NSInteger index) {
            SLog(@"index:%ld", (long)index);
            [weakSelf serviceJumpUrl:index];
        };
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UIImageView *headerIV = [[UIImageView alloc] init];
    [contentView addSubview:headerIV];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = RFONT(15);
    nameLabel.textColor = UIColorFromRGB(0x212121);
    [contentView addSubview:nameLabel];
    
    NSArray *imagesArr = @[@"myService", @"currenService"];
    NSArray *namesArr = @[@"我的", @"可享服务"];
    headerIV.image = HyBundleImage(imagesArr[section]);
    nameLabel.text = namesArr[section];
    
    [headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.bottom.equalTo(contentView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerIV.mas_right).offset(5);
        make.centerY.equalTo(headerIV.mas_centerY);
    }];
    
    return contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (void)serviceJumpUrl:(NSInteger)index {
    if (!_isLogin) {
        return;
    }
    HYHotServiceModel *model = self.datasArr[index];
    if ([model.name isEqualToString:@"法律援助指南"]) {
        HYLegalAidGuideViewController *legalAidVC = [[HYLegalAidGuideViewController alloc] init];
        legalAidVC.hyTitleColor = self.hyTitleColor;
        [self.navigationController pushViewController:legalAidVC animated:YES];
    } else {
        // 判断逻辑如下：先判断是否实名认证 -- 再判断是否人脸识别 -- 再判断内外链（外链直接跳转，内链区分个人和企业 -- 个人直接跳转，企业判断是否企业认证）
        NSString *idCard = [[NSUserDefaults standardUserDefaults] valueForKey:@"HYIdCard"];
        NSString *isEnterprise = [[NSUserDefaults standardUserDefaults] valueForKey:@"HYIsEnterprise"];
        if (!idCard || [idCard isEqualToString:@""]) { // 需要实名认证
//            [self showAlertForReanNameAuth];
            self.code = model.link;
            self.jumpUrl = model.jumpUrl;
            self.titleStr = model.name;
            FaceRecViewController *vc = [[FaceRecViewController alloc] init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            if (model.needFaceRecognition.intValue == 1) { // 跳转人脸识别
                self.code = model.link;
                self.jumpUrl = model.jumpUrl;
                self.titleStr = model.name;
                FaceRecViewController *vc = [[FaceRecViewController alloc] init];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                if ([model.outLinkFlag intValue] == 1) { // 外链
                    HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
                    webVC.code = model.link;
                    webVC.titleStr = model.name;
                    webVC.jumpUrl = model.jumpUrl;
                    [self.navigationController pushViewController:webVC animated:YES];
                } else if ([model.servicePersonFlag intValue] == 1 || isEnterprise) { // 内链个人  内链企业且已企业认证
                    HYOnLineBusinessMainViewController * mainVC = [[HYOnLineBusinessMainViewController alloc] init];
                    mainVC.serviceModel = model;
                    mainVC.hyTitleColor = self.hyTitleColor;
                    [self.navigationController pushViewController:mainVC animated:YES];
                } else { // 内链
                    // 提示企业认证
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"该事项只针对企业，请先进行企业实名认证" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:confirm];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        }
    }
    
}

#pragma mark - FaceRecResultDelegate

- (void)getFaceResult:(BOOL)result {
    if (result) {
        HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
        webVC.code = self.code;
        webVC.titleStr = self.titleStr;
        webVC.jumpUrl = self.jumpUrl;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)goMetroApp {
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit", @"eventId": @"E0023", @"applicationId": @"H022"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ", responseObject);
    }];
    
    NSURL *url = [NSURL URLWithString:@"MSXNCB://"];
    NSURL *metroUrl = [NSURL URLWithString:@"https://apps.apple.com/cn/app/id1434799948"];
    
    if (@available(iOS 10.0, *)) {
        BOOL result = [[UIApplication sharedApplication]canOpenURL:url];
        if (result) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"success");
                } else {
                    NSLog(@"error");
                }
            }];
        } else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否跳转到App Store下载？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:metroUrl options:@{} completionHandler:nil];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:confirmAction];
            [alertVC addAction:cancelAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    } else {
        // Fallback on earlier versions
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        } else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否跳转到App Store下载？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:metroUrl];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC addAction:confirmAction];
            [alertVC addAction:cancelAction];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    }
}
/*
- (void)showAlertForReanNameAuth {
    HYRealNameAlertView *alertV = [[HYRealNameAlertView alloc] init];
    __weak typeof(self) weakSelf = self;
    alertV.alertResult = ^(NSInteger index) {
        if (index == 2) {
            [weakSelf jumpRealNameAuthVC];
        }
    };
    [alertV showAlertView];
}

- (void)jumpRealNameAuthVC {  // 实名认证
    
    // 类名
    NSString *class = [NSString stringWithFormat:@"%@", @"RealNameListVC"];
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
    [self.navigationController pushViewController:instance animated:true];
    
}
*/
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self headerView];
        _tableView.tableFooterView = [self footerView];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIView *)headerView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 374)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, -40, [UIScreen mainScreen].bounds.size.width, 145)];
    bgIV.image = HyBundleImage(@"businessBG");
    [contentView addSubview:bgIV];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(16, 16, [UIScreen mainScreen].bounds.size.width - 32, 358)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 8;
    topView.clipsToBounds = YES;
    [contentView addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = RFONT(15);
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.text = @"扫码乘地铁，方便快捷";
    [topView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [topView addSubview:lineView];
    
    UIImageView *metroIV = [[UIImageView alloc] init];
    metroIV.image = HyBundleImage(@"metro");
    [topView addSubview:metroIV];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.font = RFONT(12);
    tipLabel.textColor = UIColorFromRGB(0x333333);
    tipLabel.text = @"前往鹭鹭行进行扫码乘车";
    [topView addSubview:tipLabel];
    
    UIButton *gotoBtn = [[UIButton alloc] init];
    [gotoBtn setTitle:@"立即前往" forState:UIControlStateNormal];
    [gotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    gotoBtn.titleLabel.font = RFONT(16);
    gotoBtn.layer.cornerRadius = 8;
    gotoBtn.clipsToBounds = YES;
    [gotoBtn addTarget:self action:@selector(goMetroApp) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:gotoBtn];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(topView.mas_top).offset(19);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.top.equalTo(titleLabel.mas_bottom).offset(19);
        make.right.equalTo(topView.mas_right).offset(-16);
        make.height.mas_equalTo(0.5);
    }];
    
    [metroIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.top.equalTo(lineView.mas_bottom).offset(37);
        make.size.mas_equalTo(CGSizeMake(250, 130));
    }];
    
    [gotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topView.mas_bottom).offset(-32);
        make.left.equalTo(topView.mas_left).offset(40);
        make.right.equalTo(topView.mas_right).offset(-40);
        make.height.mas_equalTo(46);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(gotoBtn.mas_top).offset(-19);
        make.centerX.equalTo(topView.mas_centerX);
    }];
    
    [gotoBtn layoutIfNeeded]; // 重点
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = gotoBtn.bounds;
    
    [gotoBtn.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0x1991FF).CGColor, (__bridge id)UIColorFromRGB(0x0F5CFF).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    return contentView;
}

- (UIView *)footerView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 16)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return contentView;
}

- (NSMutableArray *)datasArr {
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
}

- (NSMutableArray *)myArr {
    if (!_myArr) {
        _myArr = [NSMutableArray array];
        HYServiceClassifyModel *cardModel = [[HYServiceClassifyModel alloc] init];
        cardModel.iconUrl = @"homeCard";
        cardModel.serviceName = @"个人名片";
        cardModel.remark = @"创建电子名片";
        [_myArr addObject:cardModel];
        
        HYServiceClassifyModel *honorModel = [[HYServiceClassifyModel alloc] init];
        honorModel.iconUrl = @"homeHonor";
        honorModel.serviceName = @"荣誉墙";
        honorModel.remark = @"展示荣誉证书";
        [_myArr addObject:honorModel];
    }
    return _myArr;
}

@end
