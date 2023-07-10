//
//  BusTransportViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/27.
//
//  公交码页面

#import "BusTransportViewController.h"
#import "RideRecordViewController.h"
#import "RechargeViewController.h"
#import "DigitalTableViewCell.h"
#import "MyBusinessCardController.h"
#import "HonorWallViewController.h"
#import "CouponMainViewController.h"
#import "NSString+Base64.h"
#import "ReceiceCardViewController.h"
#import "BusRouteViewController.h"
#import "BusRouteInfoView.h"
#import <CoreLocation/CoreLocation.h>
#import "RealTimeBusViewController.h"
#import "HYBusinfoModel.h"
#import "XFLRButton.h"

#import "HYServiceTableViewCell.h"
#import "HYServiceClassifyModel.h"
#import "HYCivicCenterCommand.h"
#import "HYHotServiceModel.h"
#import "HYLegalAidGuideViewController.h"
#import "HYHandleAffairsWebVIewController.h"
#import "HYOnLineBusinessMainViewController.h"
#import "HYRealNameAlertView.h"
#import "FaceRecViewController.h"

@interface BusTransportViewController () <UITableViewDelegate, UITableViewDataSource, GetQRCodeDelegate, CLLocationManagerDelegate, FaceRecResultDelegate>

@property (nonatomic, strong) UIImageView *codeIV;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) NSInteger qrNums;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIImageView *maskView;
@property (nonatomic, strong) UILabel *receiveLabel;
@property (nonatomic, strong) UIButton *receiveBtn;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UIButton *toRechargeBtn;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *stationName;
@property (nonatomic, copy) NSString *stationDistance;
@property (nonatomic, strong) NSDictionary *busInfoDic;
@property (nonatomic, strong) NSMutableArray *allkeysArr;
@property (nonatomic, strong) NSMutableArray *busInfoArr;
@property (nonatomic, assign) BOOL isApply;
@property (nonatomic, strong) UIImageView *busHolderIV;
@property (nonatomic, strong) NSMutableArray *myArr;

@property (nonatomic, assign) BOOL isLogin;  // 是否已经登录
@property (nonatomic, copy) NSString * jumpUrl;  // 传给网页的url
@property (nonatomic, copy) NSString * code;  // 传给网页的code
@property (nonatomic, copy) NSString * titleStr;  // 传给网页的title

@end

NSString *const busTransPortCell = @"busCell";
@implementation BusTransportViewController

- (void)loadView {
    [super loadView];
    
    self.title = @"公交出行";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYServiceTableViewCell class] forCellReuseIdentifier:busTransPortCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(applyQRCode)];
    self.tableView.mj_header = header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self loadData];
    
    [self loadClassifyData];
    
    [self getLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    MainApi *api = [MainApi sharedInstance];
    if (api.token.length > 0) {
        self.isLogin = YES;
    }
}

- (void)loadData {
    // 账户查询
    [HttpRequest postPathBus:@"" params:@{@"uri": @"/api/hcard/query/account"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSLog(@" 账户查询== %@ ",responseObject);
        if ([responseObject[@"success"] intValue] == 0 && [responseObject[@"code"] intValue] == 200) { // 领卡
            self.maskView.hidden = NO;
            self.balanceLabel.hidden = YES;
            self.toRechargeBtn.hidden = YES;
            self.receiveBtn.hidden = NO;
            self.receiveLabel.hidden = NO;
        } else if ([responseObject[@"success"] intValue] == 1) {
            [self applyQRCode];
        }
    }];
}

- (void)loadClassifyData {
//    [HttpRequest getPath:@"/phone/v2/service/getAvailableService" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
//        SLog(@" 获取分类 == %@ ",responseObject);
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

- (void)applyQRCode {
    // 申请二维码
    [HttpRequest postPathBus:@"" params:@{@"uri":@"/api/hcard/apply/qrcord"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        self.isApply = YES;
        if ([responseObject[@"success"] intValue] == 1) {
            self.maskView.hidden = YES;
            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"data"][@"qrData"][0] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
            self.codeIV.alpha = 1;
            self.codeIV.image = decodedImage;
        } else {
            if ([responseObject[@"message"] containsString:@"余额不足"]) {
                self.maskView.hidden = NO;
                self.balanceLabel.hidden = NO;
                self.toRechargeBtn.hidden = NO;
                self.receiveBtn.hidden = YES;
                self.receiveLabel.hidden = YES;
            }
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

// delegate
- (void)getBusQrcode {
    [self applyQRCode];
}

- (void)loadBusInfo {
    [HttpRequest getPath:@"/phone/v2/bus/getNearestBusStation" params:@{@"coordinateType": @"WGS84", @"lat": self.latitude ? : @"", @"lng": self.longitude ? : @""} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if ([responseObject[@"code"] intValue] == 200) {
            NSString *stationName = responseObject[@"data"][@"stationName"];
            self.stationName = stationName;
            self.stationDistance = responseObject[@"data"][@"distanceMeter"];
            [HttpRequest getPath:@"/phone/v2/bus/getNearestBusLine" params:@{@"stationName":stationName, @"pageNum": @"1", @"pageSize": @"2"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
                self.busInfoDic = responseObject[@"data"];
                [self.allkeysArr removeAllObjects];
                [self.busInfoArr removeAllObjects];
                NSArray *arr = [responseObject[@"data"] allKeys];
                [self.allkeysArr addObjectsFromArray:arr];
                for (NSInteger i = 0; i < arr.count; i++) {
                    NSMutableArray *busInfoArr = [HYBusinfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][arr[i]]];
                    [self.busInfoArr addObject:busInfoArr];
                }
                [self.tableView reloadData];
            }];
        }
    }];
}

- (void)getLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
}

- (UIView *)headerView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 496)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 145)];
    bgIV.image = HyBundleImage(@"businessBG");
    [contentView addSubview:bgIV];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(16, 16, [UIScreen mainScreen].bounds.size.width - 32, 480)];
    topView.layer.cornerRadius = 8;
    topView.clipsToBounds = YES;
    topView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:topView];
    
    UIButton *titleBtn = [[UIButton alloc] init];
    [titleBtn setBackgroundColor:UIColorFromRGB(0xF8FCFF)];
    [titleBtn setImage:HyBundleImage(@"scene") forState:UIControlStateNormal];
    [titleBtn setTitle:@" 洪城一卡通" forState:UIControlStateNormal];
    titleBtn.titleLabel.font = RFONT(12);
    [titleBtn setTitleColor:UIColorFromRGB(0xFE8601) forState:UIControlStateNormal];
    [topView addSubview:titleBtn];
    
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.textColor = UIColorFromRGB(0x333333);
//    titleLabel.font = RFONT(15);
//    titleLabel.text = @"洪城一卡通";
//    [topView addSubview:titleLabel];
    
    self.codeIV = [[UIImageView alloc] init];
//    self.codeIV.backgroundColor = [UIColor blueColor];
    self.codeIV.image = [self createQRCodeWithCodeStr:@"O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs="];
    self.codeIV.userInteractionEnabled = YES;
    self.codeIV.alpha = 0.5;
    [topView addSubview:self.codeIV];
    
    UIImageView *busIV = [[UIImageView alloc] init];
    busIV.image = HyBundleImage(@"bus");
    [self.codeIV addSubview:busIV];
    
    self.maskView = [[UIImageView alloc] init];
    self.maskView.image = HyBundleImage(@"busMask");
    self.maskView.userInteractionEnabled = YES;
    self.maskView.hidden = YES;
    [topView addSubview:self.maskView];
    
    self.balanceLabel = [[UILabel alloc] init];
    self.balanceLabel.text = @"余额不足，";
    self.balanceLabel.textColor = UIColorFromRGB(0x333333);
    self.balanceLabel.font = RFONT(14);
    self.balanceLabel.textAlignment = NSTextAlignmentRight;
    self.balanceLabel.hidden = YES;
    [self.maskView addSubview:self.balanceLabel];
    
    self.toRechargeBtn = [[UIButton alloc] init];
    [self.toRechargeBtn setTitle:@"请充值" forState:UIControlStateNormal];
    [self.toRechargeBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    self.toRechargeBtn.titleLabel.font = RFONT(17);
    [self.toRechargeBtn addTarget:self action:@selector(rechargeClicked) forControlEvents:UIControlEventTouchUpInside];
    self.toRechargeBtn.hidden = YES;
    [self.maskView addSubview:self.toRechargeBtn];
    
    self.receiveLabel = [[UILabel alloc] init];
    self.receiveLabel.text = @"请立即去";
    self.receiveLabel.textColor = UIColorFromRGB(0x333333);
    self.receiveLabel.font = RFONT(14);
    self.receiveLabel.textAlignment = NSTextAlignmentRight;
    self.receiveLabel.hidden = YES;
    [self.maskView addSubview:self.receiveLabel];
    
    self.receiveBtn = [[UIButton alloc] init];
    [self.receiveBtn setTitle:@"领卡" forState:UIControlStateNormal];
    [self.receiveBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    self.receiveBtn.titleLabel.font = RFONT(17);
    self.receiveBtn.hidden = YES;
    [self.receiveBtn addTarget:self action:@selector(receiveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:self.receiveBtn];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"该二维码来源洪城一卡通";
    tipLabel.font = RFONT(12);
    tipLabel.textColor = UIColorFromRGB(0x999999);
    [topView addSubview:tipLabel];
    
    UIButton *refreshBtn = [[UIButton alloc] init];
    [refreshBtn setImage:HyBundleImage(@"refresh") forState:UIControlStateNormal];
    [refreshBtn setTitle:@" 刷新二维码" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    [refreshBtn setBackgroundColor:UIColorFromRGB(0xE5F1FF)];
    refreshBtn.layer.cornerRadius = 13.5;
    refreshBtn.clipsToBounds = YES;
    refreshBtn.titleLabel.font = RFONT(12);
    [refreshBtn addTarget:self action:@selector(refreshClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:refreshBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [topView addSubview:lineView];
    
    UIButton *riderecordBtn = [[UIButton alloc] init];
    [riderecordBtn setImage:HyBundleImage(@"busRecord") forState:UIControlStateNormal];
    [riderecordBtn setTitle:@"乘车记录" forState:UIControlStateNormal];
    [riderecordBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    riderecordBtn.titleLabel.font = RFONT(14);
    [riderecordBtn addTarget:self action:@selector(rideRecordClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:riderecordBtn];
    
    UIButton *rechargeBtn = [[UIButton alloc] init];
    [rechargeBtn setImage:HyBundleImage(@"myBalance") forState:UIControlStateNormal];
    [rechargeBtn setTitle:@"我的余额" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = RFONT(14);
    [rechargeBtn addTarget:self action:@selector(rechargeClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rechargeBtn];
    
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(40);
        make.left.right.equalTo(topView);
        make.height.mas_equalTo(21);
    }];
    
    [self.codeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBtn.mas_bottom).offset(19);
        make.centerX.equalTo(topView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(265, 265));
    }];
    
    [busIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.codeIV.mas_centerX);
        make.centerY.equalTo(self.codeIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.top.equalTo(titleBtn.mas_bottom).offset(19);
        make.centerX.equalTo(topView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(265, 265));
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maskView.mas_centerY);
        make.right.equalTo(self.maskView.mas_centerX);
    }];

    [self.toRechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maskView.mas_centerY);
        make.left.equalTo(self.maskView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [self.receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maskView.mas_centerY);
        make.right.equalTo(self.maskView.mas_centerX);
    }];
    
    [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.maskView.mas_centerY);
        make.left.equalTo(self.maskView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeIV.mas_bottom).offset(10);
        make.centerX.equalTo(topView.mas_centerX);
    }];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(19);
        make.centerX.equalTo(topView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(130, 27));
    }];
    
    [riderecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(topView);
        make.size.mas_equalTo(CGSizeMake(([UIScreen mainScreen].bounds.size.width - 32)/2, 56));
    }];
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(topView);
        make.size.mas_equalTo(CGSizeMake(([UIScreen mainScreen].bounds.size.width - 32)/2, 56));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.bottom.equalTo(riderecordBtn.mas_top);
        make.right.equalTo(topView.mas_right).offset(-16);
        make.height.mas_equalTo(0.5);
    }];
    
    return contentView;
}

- (UIView *)footerView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 16)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return contentView;
}

- (UIImage *)createQRCodeWithCodeStr:(NSString *)codeStr {
    //1.生成coreImage框架中的滤镜来生产二维码
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
//    NSString *str = codeStr;
    [filter setValue:[codeStr dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //4.获取生成的图片
    CIImage *ciImg= filter.outputImage;
    //放大ciImg,默认生产的图片很小
    
    //5.设置二维码的前景色和背景颜色
    CIFilter *colorFilter=[CIFilter filterWithName:@"CIFalseColor"];
    //5.1设置默认值
    [colorFilter setDefaults];
    [colorFilter setValue:ciImg forKey:@"inputImage"];
    [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor1"];
    //5.3获取生成的图片
    ciImg = colorFilter.outputImage;
    
    CGAffineTransform scale=CGAffineTransformMakeScale(10, 10);
    ciImg = [ciImg imageByApplyingTransform:scale];
    
    //6.在中心增加一张图片
    UIImage *img=[UIImage imageWithCIImage:ciImg];
    //7.生存图片
    //7.1开启图形上下文
    UIGraphicsBeginImageContext(img.size);
    
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    //7.3在中心划入其他图片
    
    //7.4获取绘制好的图片
    UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
    
    //7.5关闭图像上下文
    UIGraphicsEndImageContext();
    return finalImg;
}

// 乘车记录
- (void)rideRecordClicked {
    if (self.isApply == NO) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请先领取公交卡" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ReceiceCardViewController *receiveVC = [[ReceiceCardViewController alloc] init];
            receiveVC.delegate = self;
            [self.navigationController pushViewController:receiveVC animated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:confirmAction];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        RideRecordViewController *recordVC = [[RideRecordViewController alloc] init];
        [self.navigationController pushViewController:recordVC animated:YES];
    }
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
    HYServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:busTransPortCell];
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
    if (section == 0 && self.stationName.length > 0) {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 186 + 29)];
        contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        UIView *busInfoView = [[UIView alloc] init];
        busInfoView.backgroundColor = [UIColor whiteColor];
        busInfoView.layer.cornerRadius = 8;
        busInfoView.clipsToBounds = YES;
        [contentView addSubview:busInfoView];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = UIColorFromRGB(0x333333);
        nameLabel.font = RFONT(15);
    //    nameLabel.text = @"高新创业大道口";
        nameLabel.text = self.stationName;
        [busInfoView addSubview:nameLabel];
        
        UILabel *distanceLabel = [[UILabel alloc] init];
        distanceLabel.textColor = UIColorFromRGB(0x999999);
        distanceLabel.font = RFONT(12);
    //    distanceLabel.text = @"90m";
        if (self.stationDistance.intValue > 0 && self.stationDistance.intValue < 1000) {
            distanceLabel.text = [NSString stringWithFormat:@"距你%@m", self.stationDistance];
        } else {
            distanceLabel.text = [NSString stringWithFormat:@"距你%.fkm", self.stationDistance.intValue / 1000.0];
        }
    //    distanceLabel.text = [NSString stringWithFormat:@"%@",self.stationDistance];
        [busInfoView addSubview:distanceLabel];
        
        XFLRButton *moreBusBtn = [[XFLRButton alloc] init];
        moreBusBtn.padding = 7;
        [moreBusBtn setTitle:@"更多实时公交" forState:UIControlStateNormal];
        [moreBusBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        moreBusBtn.titleLabel.font = RFONT(12);
        [moreBusBtn setImage:HyBundleImage(@"moreBus") forState:UIControlStateNormal];
        [moreBusBtn addTarget:self action:@selector(moreBusClicked) forControlEvents:UIControlEventTouchUpInside];
        [busInfoView addSubview:moreBusBtn];
        
        self.busHolderIV = [[UIImageView alloc] init];
        self.busHolderIV.image = HyBundleImage(@"busHolderIV");
        self.busHolderIV.hidden = self.busInfoArr.count > 0;
        [busInfoView addSubview:self.busHolderIV];
        
        for (NSInteger i = 0; i < self.busInfoArr.count; i++) {
            CGFloat width = ([UIScreen mainScreen].bounds.size.width - 32 - 44 - 13) / 2.0;
    //        HYBusinfoModel *infoModel = self.busInfoDic[self.allkeysArr[i]][0];
            NSArray *busArr = self.busInfoDic[self.allkeysArr[i]];
            NSDictionary *busDic = busArr[0];
            BusRouteInfoView *infoView = [[BusRouteInfoView alloc] initWithFrame:CGRectMake(i * (width +13) + 22, 52, width, 85)];
            infoView.layer.cornerRadius = 4;
            infoView.clipsToBounds = YES;
            NSString *stationtime = @"";
            if ([busDic[@"arriveNowStationNeedMinute"] intValue] < 2) {
                stationtime = @"即将到站";
            }else {
                stationtime = [NSString stringWithFormat:@"%@分钟·%@站", busDic[@"arriveNowStationNeedMinute"], busDic[@"arriveNowStationNumber"]];
            }
            [infoView setStationNum:busDic[@"lineName"] withTerminalStation:busDic[@"terminusStation"][@"stationName"] withTime:stationtime];
            infoView.tag = 1000 + i;
            [infoView addTarget:self action:@selector(busInfoClicked:) forControlEvents:UIControlEventTouchUpInside];
            [busInfoView addSubview:infoView];
        }
        
        UIView *titleInfoView = [[UIView alloc] init];
        titleInfoView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [contentView addSubview:titleInfoView];
        
        UIImageView *headerIV = [[UIImageView alloc] init];
        headerIV.image = HyBundleImage(@"myService");
        [contentView addSubview:headerIV];
        
        UILabel *titleName = [[UILabel alloc] init];
        titleName.font = RFONT(15);
        titleName.textColor = UIColorFromRGB(0x212121);
        titleName.text = @"我的";
        [contentView addSubview:titleName];
        
        [busInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(16, 16, 45, 16));
        }];
        
        [self.busHolderIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(52, 16, 45, 16));
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(busInfoView.mas_left).offset(18);
            make.top.equalTo(busInfoView.mas_top).offset(20);
        }];
        
        [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).offset(15);
            make.centerY.equalTo(nameLabel.mas_centerY);
        }];
        
        [moreBusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(busInfoView.mas_right).offset(-20);
            make.centerY.equalTo(nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        
        [titleInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(0);
            make.top.equalTo(busInfoView.mas_bottom);
            make.right.equalTo(contentView.mas_right);
            make.height.mas_equalTo(45);
        }];
        
        [headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleInfoView.mas_left).offset(16);
            make.bottom.equalTo(titleInfoView.mas_bottom).offset(-10);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        [titleName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerIV.mas_right).offset(5);
            make.centerY.equalTo(headerIV.mas_centerY);
        }];
        
        return contentView;
    }
    
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
    if (section == 0) {
        if (self.stationName.length > 0) {
            return 186 + 45;
        }
        return 45;
    }
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
            [self showAlertForReanNameAuth];
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

#pragma LocationDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@" 定位失败== %@ ",error);
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未开启定位服务，是否需要开启？" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    }];
//    UIAlertAction *queren = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSURL *setingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        [[UIApplication sharedApplication]openURL:setingsURL];
//    }];
//    [alert addAction:cancel];
//    [alert addAction:queren];
//    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@" 定位完成== %@ ", locations);
    [self.locationManager stopUpdatingLocation];//停止定位
    //地理反编码
    CLLocation *currentLocation = [locations lastObject];
    self.latitude = @(currentLocation.coordinate.latitude).stringValue;
    self.longitude = @(currentLocation.coordinate.longitude).stringValue;
    [self loadBusInfo];
//    currentLocation.coordinate.latitude;
    NSLog(@" 当前经纬度== %f == %f ", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
}

// 刷新二维码
- (void)refreshClicked {
    [self applyQRCode];
//    if (self.datasArr.count > 0) {
//        if (self.currentIndex < self.qrNums) {
//            self.codeIV.image = [self createQRCodeWithCodeStr:self.datasArr[self.currentIndex]];
//            self.currentIndex ++;
//        }
//    }
}

// 领卡
- (void)receiveClick {
    ReceiceCardViewController *receiveVC = [[ReceiceCardViewController alloc] init];
    receiveVC.delegate = self;
    [self.navigationController pushViewController:receiveVC animated:YES];
}

// 充值
- (void)rechargeClicked {
    if (self.isApply == NO) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请先领取公交卡" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ReceiceCardViewController *receiveVC = [[ReceiceCardViewController alloc] init];
            receiveVC.delegate = self;
            [self.navigationController pushViewController:receiveVC animated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:confirmAction];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }
}

- (void)busInfoClicked:(UIButton *)button {
    NSInteger index = button.tag - 1000;
    NSDictionary *infoDic = self.busInfoDic[self.allkeysArr[index]][0];
//    NSLog(@"点击公交信息==%@ == %@ ",infoDic[@"lineNo"],infoDic[@"isUpDown"]);
    BusRouteViewController *routeVC = [[BusRouteViewController alloc] init];
    routeVC.isUpDown = infoDic[@"isUpDown"];
    routeVC.lineNo = infoDic[@"lineNo"];
    routeVC.stationName = self.stationName?:@"";
    [self.navigationController pushViewController:routeVC animated:YES];
}

// 更多实时公交
- (void)moreBusClicked {
    RealTimeBusViewController *realtimeVC = [[RealTimeBusViewController alloc] init];
    realtimeVC.keyword = self.stationName;
    [self.navigationController pushViewController:realtimeVC animated:YES];
}

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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
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

- (NSMutableArray *)busInfoArr {
    if (!_busInfoArr) {
        _busInfoArr = [NSMutableArray array];
    }
    return _busInfoArr;
}

- (NSMutableArray *)allkeysArr {
    if (!_allkeysArr) {
        _allkeysArr = [NSMutableArray array];
    }
    return _allkeysArr;
}

@end
