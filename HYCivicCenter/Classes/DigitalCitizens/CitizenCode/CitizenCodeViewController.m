//
//  CitizenCodeViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/9/1.
//
//  市民码页面
/*
#import "CitizenCodeViewController.h"
#import "DigitalTableViewCell.h"
#import "MyBusinessCardController.h"
#import "HonorWallViewController.h"
#import "CouponMainViewController.h"
#import "OpenIDCardViewController.h"// 开通网证

//#import "FaceSDKManager.h"

#import <CTID_Verification/CTID_Verification.h>
#import "NSString+Base64.h"

#import "HYGovServiceViewController.h"
#import "HYBusinessServiceViewController.h"
#import "HYSocialServiceViewController.h"
#import "HYObtainCertiViewController.h"
#import "HYServiceTableViewCell.h"
#import "HYServiceClassifyModel.h"
#import "HYCivicCenterCommand.h"

#import "HYHotServiceModel.h"
#import "HYLegalAidGuideViewController.h"
#import "HYHandleAffairsWebVIewController.h"
#import "HYOnLineBusinessMainViewController.h"
#import "HYRealNameAlertView.h"

@interface CitizenCodeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *codeIV;
@property (nonatomic, strong) UIImageView *citizenIV;
@property (nonatomic, strong) UIImageView *homeMaskIV;
@property (nonatomic, strong) UIButton *netDownloadBtn;
@property (nonatomic, strong) UIButton *showCodeBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *randomNum;
@property (nonatomic, copy) NSString *bsn;
@property (nonatomic, copy) NSString *idcardAuthInfo;
@property (nonatomic, copy) NSString *skey;
@property (nonatomic, copy) NSString *qrcodeBsn;
@property (nonatomic, copy) NSString *qrRandomNum;
@property (nonatomic, copy) NSString *codeAuthInfo;
@property (nonatomic, strong) NSDictionary *faceDic;
@property (nonatomic, copy) NSString *image_str;
//@property (nonatomic, copy) NSString *seky;
@property (nonatomic, copy) NSString *deviceID;
@property (nonatomic, assign) NSInteger showCodetype;

@property (nonatomic, strong) NSMutableArray *myArr;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) BOOL isLogin;  // 是否已经登录
@property (nonatomic, copy) NSString * jumpUrl;  // 传给网页的url
@property (nonatomic, copy) NSString * code;  // 传给网页的code
@property (nonatomic, copy) NSString * titleStr;  // 传给网页的title
@property (nonatomic, assign) BOOL isEnterprise;  // true 企业  false 个人
@property (nonatomic, assign) NSInteger faceRecognition;  // 人脸识别类型 网证下载1/热门服务2

@end

NSString *const citizenCell = @"citizenCell";
@implementation CitizenCodeViewController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    // businessBG 145
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 85)];
    bgIV.image = HyBundleImage(@"balanceBg");
    [self.view addSubview:bgIV];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYServiceTableViewCell class] forCellReuseIdentifier:citizenCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSDK];
    
    [self initLivenesswithList];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceResult:) name:@"FaceResultNoti" object:nil];
    
    [self loadClassifyData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    MainApi *api = [MainApi sharedInstance];
    if (api.token.length > 0) {
        self.isLogin = YES;
        [self loadData];
    }
    
    if (api.isShow) {
        NSString *imgStream = [[NSUserDefaults standardUserDefaults]objectForKey:@"imgStream"];
        NSString *imgWidth = [[NSUserDefaults standardUserDefaults]objectForKey:@"imgwidth"];
        self.homeMaskIV.hidden = YES;
        self.netDownloadBtn.hidden = YES;
        self.citizenIV.hidden = NO;
        UIImageView *imageView = [CtidVerifySdk creatQRCodeImageWithImgStreamStr:imgStream width:[imgWidth integerValue] withFrame:CGRectMake(0, 0, 265, 265)];
        self.codeIV.alpha = 1;
        self.codeIV.image = imageView.image;
    } else {
        self.codeIV.image = [self createQRCodeWithCodeStr:@"O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs="];
        self.codeIV.alpha = 0.5;
        self.citizenIV.hidden = YES;
        self.homeMaskIV.hidden = NO;
        self.netDownloadBtn.hidden = NO;
    }
}

- (void)loadData {
    [HttpRequest postPath:@"/phone/v2/getUserByToken" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 获取当前用户信息== %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.idCard = responseObject[@"data"][@"idCard"];
            self.name = responseObject[@"data"][@"nickName"];
            self.phone = responseObject[@"data"][@"phone"];
            NSString *enterprise = responseObject[@"data"][@"isEnterprise"];
            if ([enterprise isEqualToString:@"true"]) {
                self.isEnterprise = YES;
            } else {
                self.isEnterprise = NO;
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"nickName"] ? : @"" forKey:@"HYName"];
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"idCard"] forKey:@"HYIdCard"];
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"phone"] ? : @"" forKey:@"HYPhone"];
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"isEnterprise"] forKey:@"HYIsEnterprise"];
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"phoneEncrypt"] ? : @"" forKey:@"HYPhoneEncrypt"];
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"uuid"] forKey:@"CurrentUuid"];
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"word"] forKey:@"CurrentWord"];
            
            if ([responseObject[@"data"][@"idCard"] length] == 0) {
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您还未进行实名认证，请先进行实名认证" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertVC addAction:confirmAction];
                [self presentViewController:alertVC animated:YES completion:nil];
            }
        }
    }];
}

- (void)initSDK {
    if (![[FaceSDKManager sharedInstance] canWork]) {
        NSLog(@"授权失败，请检测ID 和 授权文件是否可用");
        return;
    }
    
    // 初始化SDK配置参数，可使用默认配置
    // 设置最小检测人脸阈值
    [[FaceSDKManager sharedInstance] setMinFaceSize:200];
    // 设置截取人脸图片高
    [[FaceSDKManager sharedInstance] setCropFaceSizeWidth:480];
    // 设置截取人脸图片宽
    [[FaceSDKManager sharedInstance] setCropFaceSizeHeight:640];
    // 设置人脸遮挡阀值
    [[FaceSDKManager sharedInstance] setOccluThreshold:0.5];
    // 设置亮度阀值
    [[FaceSDKManager sharedInstance] setMinIllumThreshold:40];
    [[FaceSDKManager sharedInstance] setMaxIllumThreshold:240];
    // 设置图像模糊阀值
    [[FaceSDKManager sharedInstance] setBlurThreshold:0.3];
    // 设置头部姿态角度
    [[FaceSDKManager sharedInstance] setEulurAngleThrPitch:10 yaw:10 roll:10];
    // 设置人脸检测精度阀值
    [[FaceSDKManager sharedInstance] setNotFaceThreshold:0.6];
    // 设置抠图的缩放倍数
    [[FaceSDKManager sharedInstance] setCropEnlargeRatio:2.5];
    // 设置照片采集张数
    [[FaceSDKManager sharedInstance] setMaxCropImageNum:1];
    // 设置超时时间
    [[FaceSDKManager sharedInstance] setConditionTimeout:15];
    // 设置开启口罩检测，非动作活体检测可以采集戴口罩图片
    [[FaceSDKManager sharedInstance] setIsCheckMouthMask:false];
    // 设置开启口罩检测情况下，非动作活体检测口罩过滤阈值，默认0.8 不需要修改
    [[FaceSDKManager sharedInstance] setMouthMaskThreshold:0.8f];
    // 设置原始图缩放比例
    [[FaceSDKManager sharedInstance] setImageWithScale:0.8f];
    // 初始化SDK功能函数
    [[FaceSDKManager sharedInstance] initCollect];
    // 设置人脸过远框比例
    [[FaceSDKManager sharedInstance] setMinRect:0.4];
    // 活体检测阈值
    [[FaceSDKManager sharedInstance] setliveThresholdValue:0.8];
    //视频录制能力
    [[FaceSDKManager sharedInstance] setRecordAbility:false];
    //炫彩颜色判断能力
    [[FaceSDKManager sharedInstance] setColorJudgeAbility:false];
    
    // 设置用户设置的配置参数
//    [BDFaceAdjustParamsTool setDefaultConfig];
}

- (void)initLivenesswithList {
    // 默认活体检测打开，顺序执行
    /*
     添加当前默认的动作，是否需要按照顺序，动作活体的数量（设置页面会根据这个numOfLiveness来判断选择了几个动作）
     */
//    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveEye)];
//    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveMouth)];
//    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveYawRight)];
//    BDFaceLivingConfigModel.sharedInstance.isByOrder = NO;
//    BDFaceLivingConfigModel.sharedInstance.numOfLiveness = 3;
/*
}

- (void)loadClassifyData {
//    [HttpRequest getPath:@"/phone/v2/service/getAvailableService" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@" 获取分类 == %@ ", responseObject);
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

- (void)faceResult:(NSNotification *)noti {
    NSDictionary *resultDic = noti.object;
    self.faceDic = resultDic;
    
    [[NSUserDefaults standardUserDefaults] setValue:self.faceDic forKey:@"FaceDic"];
    
    // 网证下载
    [HttpRequest postPathGov:@"" params:@{@"uri": @"/apiFile/haiDunBase/downloadNet", @"file": resultDic[@"image_string"], @"nickname": self.name ? : @"", @"idCard": self.idCard ? : @"", @"bsn": self.bsn, @"idcardAuthData": self.idcardAuthInfo ? : @"", @"source": @"2", @"skey": resultDic[@"skey"], @"deviceId": resultDic[@"device_id"], @"app": @"ios"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 网证下载33== %@ ", responseObject);
        if ([responseObject[@"success"] intValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"ctid"] ? : @"" forKey:@"CTID"];
        } else if ([responseObject[@"code"] intValue] == 500) {
            // 跳转开通网证
            OpenIDCardViewController *idcardVC = [[OpenIDCardViewController alloc] init];
            idcardVC.bsn = self.bsn;
            idcardVC.phone = self.phone;
            [self.navigationController pushViewController:idcardVC animated:YES];
        }
    }];
}

// 刷新
- (void)refreshClicked {
    NSString *imageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"HYImageStr"];
    NSString *skey = [[NSUserDefaults standardUserDefaults] objectForKey:@"HYSkey"];
    NSString *deviceID = [[NSUserDefaults standardUserDefaults] objectForKey:@"HYDeviceid"];
    [self applyQrcodeWithImageStr:imageStr withSkey:skey withDeviceId:deviceID];
}

- (UIImage *)createQRCodeWithCodeStr:(NSString *)codeStr {
    //1.生成coreImage框架中的滤镜来生产二维码
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
//    NSString *str = codeStr;
    [filter setValue:[codeStr dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //4.获取生成的图片
    CIImage *ciImg = filter.outputImage;
    //放大ciImg,默认生产的图片很小
    
    //5.设置二维码的前景色和背景颜色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    //5.1设置默认值
    [colorFilter setDefaults];
    [colorFilter setValue:ciImg forKey:@"inputImage"];
    [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor1"];
    //5.3获取生存的图片
    ciImg = colorFilter.outputImage;
    
    CGAffineTransform scale = CGAffineTransformMakeScale(10, 10);
    ciImg = [ciImg imageByApplyingTransform:scale];
    
    //6.在中心增加一张图片
    UIImage *img = [UIImage imageWithCIImage:ciImg];
    //7.生存图片
    //7.1开启图形上下文
    UIGraphicsBeginImageContext(img.size);
    
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    //7.3在中心划入其他图片
    
//    UIImage *centerImg = HyBundleImage(@"citizenBg");
//    
//    CGFloat centerW = 36;
//    CGFloat centerH = 36;
//    CGFloat centerX = (img.size.width)*0.5;
//    CGFloat centerY = (img.size.height)*0.5;
//    
//    [centerImg drawInRect:CGRectMake(centerX - 18, centerY - 18, centerW, centerH)];
    
    //7.4获取绘制好的图片
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    
    //7.5关闭图像上下文
    UIGraphicsEndImageContext();
    return finalImg;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:citizenCell];
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
        if (!_idCard || [_idCard isEqualToString:@""]) { // 需要实名认证
            [self showAlertForReanNameAuth];
        } else {
            if (model.needFaceRecognition.intValue == 1) { // 跳转人脸识别
                self.code = model.link;
                self.jumpUrl = model.jumpUrl;
                self.titleStr = model.name;
                self.faceRecognition = 2;
//                FaceTipViewController *faceTipVC = [[FaceTipViewController alloc] init];
//                faceTipVC.delegate = self;
//                [self.navigationController pushViewController:faceTipVC animated:YES];
            } else {
                if ([model.outLinkFlag intValue] == 1) { // 外链
                    HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
                    webVC.code = model.link;
                    webVC.titleStr = model.name;
                    webVC.jumpUrl = model.jumpUrl;
                    [self.navigationController pushViewController:webVC animated:YES];
                } else if ([model.servicePersonFlag intValue] == 1 || self.isEnterprise) { // 内链个人  内链企业且已企业认证
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

// 网证下载
- (void)netDownLoadClicked {
    NSString *urlString = @"/apiFile/haiDunBase/applyNet?source=2";
    NSString *encodeUrl = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet URLQueryAllowedCharacterSet] invertedSet]];
    [HttpRequest postPathGov:@"" params:@{@"uri": encodeUrl} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 网证下载申请 == %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200 && [responseObject[@"success"] intValue] == 1) {
            self.bsn = responseObject[@"data"][@"bsn"];
            self.randomNum = responseObject[@"data"][@"randomNum"];

            CtidVerifySdk *ctidVerifyTool = [[CtidVerifySdk alloc] init];
            CTIDReq *req = [[CTIDReq alloc] init];
            req.randomNumber = self.randomNum;
            req.organizeId = @"00001405";
            req.appId = @"0002";
            req.type = 3;
            ctidVerifyTool.resultDictBlock = ^(NSDictionary *resultDict) {
                NSLog(@" 获取身份认证数据== %@ ",resultDict);
                if ([resultDict[@"resultCode"] intValue] == 0) {
                    self.idcardAuthInfo = resultDict[@"resultInfo"];
                }
            };
            [ctidVerifyTool getAuthIDCardData:req];
            [self faceScan];
        }
    }];
}

// 人脸识别
- (void)faceScan {
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"click", @"eventId": @"E0020", @"applicationId": @"H002"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@" 埋点 == %@ ", responseObject);
    }];
    
//    FaceTipViewController *faceTipVC = [[FaceTipViewController alloc] init];
////        faceTipVC.type = 1;
//    self.faceRecognition = 1;
//    faceTipVC.delegate = self;
//    [self.navigationController pushViewController:faceTipVC animated:YES];
}


#pragma mark - FaceResultDelegate
- (void)getFaceResultWithImageStr:(NSString *)imageStr deviceId:(NSString *)deviceid skey:(NSString *)skey {
    if (self.faceRecognition == 1) {  // 网证下载
        [HttpRequest postPathPointParams:@{@"buriedPointType": @"click", @"eventId": @"E0020", @"applicationId": @"H001"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            NSLog(@" 埋点 == %@ ", responseObject);
        }];
        
        [[NSUserDefaults standardUserDefaults] setValue:imageStr ? : @"" forKey:@"HYImageStr"];
        [[NSUserDefaults standardUserDefaults] setValue:skey ? : @"" forKey:@"HYSkey"];
        [[NSUserDefaults standardUserDefaults] setValue:deviceid ? : @"" forKey:@"HYDeviceid"];
        if (self.showCodetype == 2) {
            [self applyQrcodeWithImageStr:imageStr withSkey:skey withDeviceId:deviceid];
        } else {
            // 网证下载
            [HttpRequest postPathGov:@"" params:@{@"uri": @"/apiFile/haiDunBase/downloadNet", @"file": imageStr, @"nickname": self.name ? : @"", @"idCard": self.idCard ? : @"", @"bsn": self.bsn, @"idcardAuthData": self.idcardAuthInfo ? : @"", @"source": @"2", @"skey": skey, @"deviceId": deviceid, @"app": @"ios"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
                NSLog(@" 网证下载33== %@ ", responseObject);
                
                if ([responseObject[@"success"] intValue] == 1) {
                    [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"ctid"] ? : @"" forKey:@"CTID"];
                    [self applyQrcodeWithImageStr:imageStr withSkey:skey withDeviceId:deviceid];
                } else if ([responseObject[@"code"] intValue] == 500 && [responseObject[@"message"] isEqualToString:@"continue"]) {
                    // 跳转开通网证
                    OpenIDCardViewController *idcardVC = [[OpenIDCardViewController alloc] init];
                    idcardVC.bsn = self.bsn;
                    idcardVC.phone = self.phone;
                    [self.navigationController pushViewController:idcardVC animated:YES];
                } else if ([responseObject[@"success"] intValue] == 0) {
                    [SVProgressHUD showWithStatus:responseObject[@"message"]];
                    [SVProgressHUD dismissWithDelay:1];
                }
            }];
        }
    } else {  // 热门服务
        SLog(@" skey == %@ ", skey);
        [HttpRequest postPathZWBS:@"phone/item/event/api" params:@{@"uri": @"/apiFile/discernFace", @"app": @"ios", @"file": imageStr, @"deviceId": deviceid, @"skey": skey} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@" 人脸识别== %@ ", responseObject);
            if ([responseObject[@"success"] intValue] == 1) {
                HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
                webVC.code = self.code;
                webVC.titleStr = self.titleStr;
                webVC.jumpUrl = self.jumpUrl;
                [self.navigationController pushViewController:webVC animated:YES];
            } else {
                SLog(@"%@", responseObject[@"message"]);
            }
        }];
    }
    
}

// 亮码
- (void)showCodeClicked {
    self.showCodetype = 2;
    [self faceScan];
}

// 二维码赋码申请
- (void)applyQrcodeWithImageStr:(NSString *)image_str withSkey:(NSString *)skey withDeviceId:(NSString *)device_id {
    CtidVerifySdk *ctidVerifyTool = [[CtidVerifySdk alloc] init];
    CTIDReq *req = [[CTIDReq alloc] init];
    req.organizeId = @"00001405";
    req.appId = @"0002";
    req.type = 0;
    NSDictionary *resultDic = [ctidVerifyTool getApplyData:req];
    NSLog(@" 二维码赋码数据==%@ ", resultDic);
    if ([resultDic[@"resultCode"] intValue] == 0) {
        self.codeAuthInfo = resultDic[@"resultInfo"];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"/apiFile/haiDunBase/applyQrCode?source=2&applyData=%@&authMode=G120", self.codeAuthInfo];
    NSString *tempString = [self URLEncodedString:urlString];
    NSDictionary *dic = @{
        @"uri": tempString
    };
    NSLog(@" 赋码申请参数 == %@ ", dic);
    [HttpRequest postPathGov:@"" params:dic resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 赋码申请== %@ ", responseObject);
        if ([responseObject[@"success"] intValue] == 1) {
            self.qrcodeBsn = responseObject[@"data"][@"bsn"] ? : @"";
            self.qrRandomNum = responseObject[@"data"][@"randomNum"] ? : @"";
            NSString *ctid = [[NSUserDefaults standardUserDefaults] valueForKey:@"CTID"];
            CtidVerifySdk *ctidVerifyTool = [[CtidVerifySdk alloc] init];
            CTIDReq *ctidReq = [[CTIDReq alloc] init];
            ctidReq.organizeId = @"00001405";
            ctidReq.appId = @"0002";
            ctidReq.randomNumber = self.qrRandomNum;
            ctidReq.ctid = ctid;
            NSDictionary *resultDic = [ctidVerifyTool getReqQRCodeData:ctidReq];
            NSLog(@" 网证获取二维码赋码数据== %@ ", resultDic);
            if ([resultDic[@"resultCode"] isEqualToString:@"0"]) {
                // NSLog(@" 网证获取二维码赋码数据== %@ ", resultDic);
            }
            
            if ([self.faceDic allKeys].count == 0) {
                NSDictionary *faceDic = [[NSUserDefaults standardUserDefaults] valueForKey:@"FaceDic"];
                self.faceDic = faceDic;
            }
            [SVProgressHUD showWithStatus:@"正在加载中"];
            [HttpRequest postPathGov:@"" params:@{@"uri": @"/apiFile/haiDunBase/assignOrCode", @"app": @"ios", @"authMode": @"G120", @"bsn": self.qrcodeBsn, @"checkData": resultDic[@"resultInfo"], @"deviceId": device_id, @"file": image_str, @"skey": skey, @"source": @"2"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
                NSLog(@" 二维码赋码== %@ ", responseObject);
                    if ([responseObject[@"success"] intValue] == 1) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.homeMaskIV.hidden = YES;
                            self.netDownloadBtn.hidden = YES;
                            self.showCodeBtn.hidden = YES;
                            UIImageView *imageView = [CtidVerifySdk creatQRCodeImageWithImgStreamStr:responseObject[@"data"][@"imgStream"] width:[responseObject[@"data"][@"width"] integerValue] withFrame:CGRectMake(0, 0, 265, 265)];
                            self.citizenIV.hidden = NO;
                            self.codeIV.alpha = 1;
                            self.codeIV.image = imageView.image;
                            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"imgStream"] forKey:@"imgStream"];
                            [[NSUserDefaults standardUserDefaults] setValue:responseObject[@"data"][@"width"] forKey:@"imgwidth"];
                            MainApi *api = [MainApi sharedInstance];
                            api.isShow = YES;
                        });
                    }
                [SVProgressHUD dismiss];
            }];
        }
    }];
}

- (NSString *)URLEncodedString:(NSString *)urlStr {
    NSString *encodeString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"] invertedSet]];
    return encodeString;
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

- (NSMutableArray *)datasArr {
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
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
//        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.tableFooterView = [self footerView];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIView *)headerView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 490)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, -40, [UIScreen mainScreen].bounds.size.width, 145)];
    bgIV.image = HyBundleImage(@"businessBG");
    [contentView addSubview:bgIV];
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 16, [UIScreen mainScreen].bounds.size.width - 32, 400);
    topView.layer.cornerRadius = 8;
    topView.clipsToBounds = YES;
    topView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:topView];
    
    UIImageView *contentIV = [[UIImageView alloc] init];
    contentIV.backgroundColor = [UIColor whiteColor];
    contentIV.layer.cornerRadius = 30;
    contentIV.clipsToBounds = YES;
    [contentView addSubview:contentIV];
    
    UIImageView *netCerIV = [[UIImageView alloc] init];
    netCerIV.image = HyBundleImage(@"netCerti");
    [contentIV addSubview:netCerIV];
    
    UIButton *sceneBtn = [[UIButton alloc] init];
    [sceneBtn setBackgroundColor:UIColorFromRGB(0xF8FCFF)];
    [sceneBtn setImage:HyBundleImage(@"scene") forState:UIControlStateNormal];
    [sceneBtn setTitle:@" 使用场景介绍" forState:UIControlStateNormal];
    sceneBtn.titleLabel.font = RFONT(12);
    [sceneBtn setTitleColor:UIColorFromRGB(0xFE8601) forState:UIControlStateNormal];
    [topView addSubview:sceneBtn];
    
    self.codeIV = [[UIImageView alloc] init];
    self.codeIV.image = [self createQRCodeWithCodeStr:@"O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs="];
    self.codeIV.alpha = 0.5;
    [topView addSubview:self.codeIV];
    
    self.citizenIV = [[UIImageView alloc] init];
    self.citizenIV.image = HyBundleImage(@"citizenBg");
    self.citizenIV.hidden = YES;
    [self.codeIV addSubview:self.citizenIV];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"市民码是基于CTID平台签发的“居民身份网络可信凭证”，内置公安部一所权威认可的可信读卡模块，实现网证身份认证。";
    tipLabel.numberOfLines = 0;
    tipLabel.font = RFONT(12);
    tipLabel.textColor = UIColorFromRGB(0x999999);
    [topView addSubview:tipLabel];
    
    UIButton *refreshBtn = [[UIButton alloc] init];
    [refreshBtn setImage:HyBundleImage(@"refresh") forState:UIControlStateNormal];
    [refreshBtn setTitle:@" 刷新二维码" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = RFONT(12);
    [refreshBtn setBackgroundColor:UIColorFromRGB(0xE5F1FF)];
    refreshBtn.layer.cornerRadius = 13.5;
    refreshBtn.clipsToBounds = YES;
    [refreshBtn addTarget:self action:@selector(refreshClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:refreshBtn];
    
    self.homeMaskIV = [[UIImageView alloc] init];
    self.homeMaskIV.image = HyBundleImage(@"homeMask");
    self.homeMaskIV.userInteractionEnabled = YES;
    [contentView addSubview:self.homeMaskIV];
    
    UIImageView *mainIV = [[UIImageView alloc] init];
    mainIV.image = HyBundleImage(@"citizenBg");
    [self.homeMaskIV addSubview:mainIV];
    
    NSString *CTID = [[NSUserDefaults standardUserDefaults]valueForKey:@"CTID"];
    
    self.showCodeBtn = [[UIButton alloc] init];
    [self.showCodeBtn setTitle:@"亮码" forState:UIControlStateNormal];
    [self.showCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.showCodeBtn setBackgroundColor:UIColorFromRGB(0x3776FF)];
    self.showCodeBtn.layer.cornerRadius = 4;
    self.showCodeBtn.clipsToBounds = YES;
//    self.showCodeBtn.hidden = YES;
    self.showCodeBtn.hidden = CTID.length == 0;
    [self.showCodeBtn addTarget:self action:@selector(showCodeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.homeMaskIV addSubview:self.showCodeBtn];
    
    self.netDownloadBtn = [[UIButton alloc] init];
    [self.netDownloadBtn setTitle:@"网证下载" forState:UIControlStateNormal];
    [self.netDownloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.netDownloadBtn setBackgroundColor:UIColorFromRGB(0x3776FF)];
    self.netDownloadBtn.titleLabel.font = RFONT(15);
    self.netDownloadBtn.layer.cornerRadius = 4;
    self.netDownloadBtn.clipsToBounds = YES;
    self.netDownloadBtn.hidden = CTID.length > 0;
    [self.netDownloadBtn addTarget:self action:@selector(netDownLoadClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.homeMaskIV addSubview:self.netDownloadBtn];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(30, 16, 0, 16));
    }];
    
    [contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.centerY.equalTo(contentView.mas_top).offset(30);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [netCerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentIV.mas_centerX);
        make.centerY.equalTo(contentIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
    
    [sceneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(40);
        make.left.right.equalTo(topView);
        make.height.mas_equalTo(21);
    }];
    
    [self.codeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sceneBtn.mas_bottom).offset(16);
        make.centerX.equalTo(topView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(265, 265));
    }];
    
    [self.citizenIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.codeIV.mas_centerX);
        make.centerY.equalTo(self.codeIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topView.mas_bottom).offset(-18);
        make.centerX.equalTo(topView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(130, 27));
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(refreshBtn.mas_top).offset(-18);
        make.left.equalTo(topView.mas_left).offset(40);
        make.right.equalTo(topView.mas_right).offset(-40);
    }];
    
    [self.homeMaskIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    
    [self.netDownloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_bottom).offset(-164);
        make.centerX.equalTo(contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 36));
    }];
    
    [self.showCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_bottom).offset(-164);
        make.centerX.equalTo(contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 36));
    }];
    
    [mainIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_bottom).offset(-230);
        make.centerX.equalTo(contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    return contentView;
}

- (UIView *)footerView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 16)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return contentView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FaceResultNoti" object:nil];
}

@end
*/
