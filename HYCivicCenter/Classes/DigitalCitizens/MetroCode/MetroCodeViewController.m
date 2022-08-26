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

#import "HYMyServiceViewController.h" // 我的服务
#import "HYServiceProgressViewController.h" // 进度查询
#import "HYHotServiceViewController.h" // 热门服务
#import "HYSpecialServiceViewController.h" // 专项服务
#import "HYAreaServiceViewController.h" // 县区服务
#import "HYGuessBusinessViewController.h"
#import "HYHomeSearchViewController.h"
#import "HYHandleAffairsViewController.h"
#import "HYHandleAffairsViewController.h"

@interface MetroCodeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *myArr;
@property (nonatomic, strong) NSMutableArray *datasArr;

@end

NSString *const metroCell = @"metroCell";
@implementation MetroCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self configUI];
    
    [self loadClassifyData];
    
}

- (void)loadClassifyData {
    
    [HttpRequest getPath:@"/phone/v2/service/getAvailableService" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
       
        SLog(@" 获取分类 == %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.datasArr = [HYServiceClassifyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableView reloadData];
        }
        
    }];
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
//    [self.tableView registerClass:[DigitalTableViewCell class] forCellReuseIdentifier:metroCell];
    [self.tableView registerClass:[HYServiceTableViewCell class] forCellReuseIdentifier:metroCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
//    [self.view addSubview:self.collectionView];
//    [self.collectionView registerClass:[HYServiceCollectionViewCell class] forCellWithReuseIdentifier:metroCell];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
    
}

- (UIView *)headerView {
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 374)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UIImageView *bgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, -40, SCREEN_WIDTH, 145)];
    bgIV.image = [UIImage imageNamed:@"businessBG"];
    [contentView addSubview:bgIV];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH - 32, 358)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 8;
    topView.clipsToBounds = YES;
    [contentView addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = RFONT(15);
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.text = @"扫码乘地铁，方便快捷";
    [topView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [topView addSubview:lineView];
    
    UIImageView *metroIV = [[UIImageView alloc]init];
    metroIV.image = [UIImage imageNamed:@"metro"];
    [topView addSubview:metroIV];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.font = RFONT(12);
    tipLabel.textColor = UIColorFromRGB(0x333333);
    tipLabel.text = @"前往鹭鹭行进行扫码乘车";
    [topView addSubview:tipLabel];
    
    UIButton *gotoBtn = [[UIButton alloc]init];
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
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0x1991FF).CGColor,(__bridge id)UIColorFromRGB(0x0F5CFF).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    return contentView;
    
}

- (UIView *)footerView {
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return contentView;
    
}

#pragma UITableView
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
        cell.datasArr = self.myArr;
        cell.indexpath = indexPath;
    }else {
        cell.datasArr = self.datasArr;
        cell.indexpath = indexPath;
    }
    
//    DigitalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:metroCell];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    NSArray *imagesArr = @[@"homeCard",@"homeHonor"];
//    NSArray *namesArr = @[@"个人名片",@"荣誉墙"];
//    NSArray *subNamesArr = @[@"创建自己的电子版名片，可互相分享",@"展示用户的相关荣誉证书，用户可以自己编辑"];
//    cell.headerIV.image = [UIImage imageNamed:imagesArr[indexPath.row]];
//    cell.nameLabel.text = namesArr[indexPath.row];
//    cell.subNameLabel.text = subNamesArr[indexPath.row];
    
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UIImageView *headerIV = [[UIImageView alloc]init];
    [contentView addSubview:headerIV];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = RFONT(15);
    nameLabel.textColor = UIColorFromRGB(0x212121);
    [contentView addSubview:nameLabel];
    
    NSArray *imagesArr = @[@"myService",@"currenService"];
    NSArray *namesArr = @[@"我的",@"可享服务"];
    headerIV.image = [UIImage imageNamed:imagesArr[section]];
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

- (void)goMetroApp {
    
    // 办事首页
    HYHandleAffairsViewController *handleVC = [[HYHandleAffairsViewController alloc] init];
    [self.navigationController pushViewController:handleVC animated:YES];
    
    // 我的服务
//    HYMyServiceViewController *myserviceVC = [[HYMyServiceViewController alloc]init];
//    [self.navigationController pushViewController:myserviceVC animated:YES];
    
    // 进度查询
//    HYServiceProgressViewController *serviceVC = [[HYServiceProgressViewController alloc]init];
//    [self.navigationController pushViewController:serviceVC animated:YES];
    
    // 热门服务
//    HYHotServiceViewController *hotServiceVC = [[HYHotServiceViewController alloc]init];
//    [self.navigationController pushViewController:hotServiceVC animated:YES];
    
    // 专项服务
//    HYSpecialServiceViewController *serviceVC = [[HYSpecialServiceViewController alloc]init];
//    [self.navigationController pushViewController:serviceVC animated:YES];
    
    // 县区服务
//    HYAreaServiceViewController *areaVC = [[HYAreaServiceViewController alloc]init];
//    [self.navigationController pushViewController:areaVC animated:YES];
    
    // 猜你想办
//    HYGuessBusinessViewController *guessVC = [[HYGuessBusinessViewController alloc]init];
//    [self.navigationController pushViewController:guessVC animated:YES];
    
    // 搜索
//    HYHomeSearchViewController *homeSearchVC = [[HYHomeSearchViewController alloc]init];
//    [self.navigationController pushViewController:homeSearchVC animated:YES];
    
    return;
    
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit",@"eventId": @"E0023",@"applicationId":@"H022"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ",responseObject);
    }];
    
    NSURL *url = [NSURL URLWithString:@"MSXNCB://"];
    NSURL *metroUrl = [NSURL URLWithString:@"https://apps.apple.com/cn/app/id1434799948"];
    
    if (@available(iOS 10.0, *)) {
        BOOL result = [[UIApplication sharedApplication]canOpenURL:url];
        if (result) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                if(success){
                    NSLog(@"success");
                }else{
                    NSLog(@"error");
                }
            }];
        }else {
            
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
        }else {
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

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.rowHeight = 80;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self headerView];
        _tableView.tableFooterView = [self footerView];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
    
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
        HYServiceClassifyModel *cardModel = [[HYServiceClassifyModel alloc]init];
        cardModel.iconUrl = @"homeCard";
        cardModel.serviceName = @"个人名片";
        cardModel.remark = @"创建电子名片";
        [_myArr addObject:cardModel];
        
        HYServiceClassifyModel *honorModel = [[HYServiceClassifyModel alloc]init];
        honorModel.iconUrl = @"homeHonor";
        honorModel.serviceName = @"荣誉墙";
        honorModel.remark = @"展示荣誉证书";
        [_myArr addObject:honorModel];
    }
    return _myArr;
    
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
