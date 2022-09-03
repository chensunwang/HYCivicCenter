//
//  FaceTipViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/9/10.
//

#import "FaceTipViewController.h"
#import "XFUDButton.h"

#import "FaceSDKManager.h"
#import "BDFaceLivingConfigModel.h"
#import "BDFaceAdjustParamsTool.h"
#import "BDFaceColorfulViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface FaceTipViewController () <BDFaceColorfulVCDelegate>

@end

@implementation FaceTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"人脸识别";
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"人脸识别"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
    
    [self initSDK];
    
    [self initLivenesswithList];
    
}

- (void)configUI {
    
    UIImageView *faceScanIV = [[UIImageView alloc]init];
    faceScanIV.image = HyBundleImage(@"faceScan");
    [self.view addSubview:faceScanIV];
    
    UILabel *tipLabel1 = [[UILabel alloc]init];
    tipLabel1.font = RFONT(14);
    tipLabel1.textColor = UIColorFromRGB(0x666666);
    tipLabel1.text = @"1.请确认由本人亲自操作；";
    [self.view addSubview:tipLabel1];
    
    UILabel *tipLabel2 = [[UILabel alloc]init];
    tipLabel2.font = RFONT(14);
    tipLabel2.textColor = UIColorFromRGB(0x666666);
    tipLabel2.text = @"2.请将脸置于提示框内，并按提示完成动作；";
    [self.view addSubview:tipLabel2];
    
    UILabel *tipLabel3 = [[UILabel alloc]init];
    tipLabel3.font = RFONT(14);
    tipLabel3.textColor = UIColorFromRGB(0x666666);
    tipLabel3.text = @"3.提示音结束后再做动作；";
    [self.view addSubview:tipLabel3];
    
    UIImageView *contentIV = [[UIImageView alloc]init];
    contentIV.image = HyBundleImage(@"faceShadow");
    [self.view addSubview:contentIV];
    
    XFUDButton *faceScreenBtn = [[XFUDButton alloc]init];
    faceScreenBtn.padding = 10;
    [faceScreenBtn setImage:HyBundleImage(@"faceScreen") forState:UIControlStateNormal];
    faceScreenBtn.titleLabel.font = RFONT(10);
    [faceScreenBtn setTitle:@"正对手机" forState:UIControlStateNormal];
    [faceScreenBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [contentIV addSubview:faceScreenBtn];
    
    XFUDButton *lightBtn = [[XFUDButton alloc]init];
    lightBtn.padding = 10;
    [lightBtn setImage:HyBundleImage(@"faceLight") forState:UIControlStateNormal];
    [lightBtn setTitle:@"光线充足" forState:UIControlStateNormal];
    [lightBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    lightBtn.titleLabel.font = RFONT(10);
    [contentIV addSubview:lightBtn];
    
    XFUDButton *facenoHiddBtn = [[XFUDButton alloc]init];
    facenoHiddBtn.padding = 10;
    [facenoHiddBtn setImage:HyBundleImage(@"faceNohidden") forState:UIControlStateNormal];
    [facenoHiddBtn setTitle:@"脸无遮挡" forState:UIControlStateNormal];
    [facenoHiddBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    facenoHiddBtn.titleLabel.font = RFONT(10);
    [contentIV addSubview:facenoHiddBtn];
    
    UIButton *nextBtn = [[UIButton alloc]init];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = RFONT(16);
    nextBtn.layer.cornerRadius = 20;
    nextBtn.clipsToBounds = YES;
    [nextBtn addTarget:self action:@selector(FaceRecognition) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    [faceScanIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight + 40);
        make.size.mas_equalTo(CGSizeMake(155, 152));
    }];
    
    [tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(39);
        make.top.equalTo(faceScanIV.mas_bottom).offset(78);
    }];
    
    [tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(39);
        make.top.equalTo(tipLabel1.mas_bottom).offset(18);
    }];
    
    [tipLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(39);
        make.top.equalTo(tipLabel2.mas_bottom).offset(18);
    }];
    
    [contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(tipLabel3.mas_bottom).offset(18);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(104);
    }];
    
    [faceScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentIV.mas_left).offset(50);
        make.centerY.equalTo(contentIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 80));
    }];
    
    [facenoHiddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentIV.mas_right).offset(-50);
        make.centerY.equalTo(contentIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 80));
    }];
    
    [lightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentIV.mas_centerX);
        make.centerY.equalTo(contentIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 80));
    }];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(27);
        make.right.equalTo(self.view.mas_right).offset(-27);
        make.top.equalTo(contentIV.mas_bottom).offset(48);
        make.height.mas_equalTo(40);
    }];
    
    [nextBtn layoutIfNeeded]; // 重点
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = nextBtn.bounds;
    
    [nextBtn.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0x1991FF).CGColor,(__bridge id)UIColorFromRGB(0x0F5CFF).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
}

- (void)FaceRecognition {
    
//    NSMutableArray *controllersArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//    for (UIViewController *vc in controllersArr) {
//        if ([vc isKindOfClass:[FaceTipViewController class]]) {
//            [controllersArr removeObject:vc];
//            break;
//        }
//    }
//    self.navigationController.viewControllers = controllersArr;
    
    NSArray * colorArr = [[NSArray alloc] initWithObjects:@(FaceLivenessActionTypeLiveEye), @(FaceLivenessActionTypeLiveMouth), nil];
    int r = arc4random() % [colorArr count];
    BDFaceColorfulViewController* cvc = [[BDFaceColorfulViewController alloc] init];
//    cvc.delegate = self;
    cvc.delegate = self;
    cvc.type = self.type;
    BDFaceLivingConfigModel* model = [BDFaceLivingConfigModel sharedInstance];
    [cvc livenesswithList:@[colorArr[r]] order:model.isByOrder numberOfLiveness:model.numOfLiveness];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:cvc];
    navi.navigationBarHidden = true;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:YES completion:nil];
    
    
}

#pragma face
- (void)completeWithImageString:(NSString *)imageString skey:(NSString *)skey deviceId:(NSString *)deviceId {
    
    if ([self.delegate respondsToSelector:@selector(getFaceResultWithImageStr:deviceId:skey:)]) {
        [self.delegate getFaceResultWithImageStr:imageString deviceId:deviceId skey:skey];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) initSDK {
    
    if (![[FaceSDKManager sharedInstance] canWork]){
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
    
//    /// 设置用户设置的配置参数
    [BDFaceAdjustParamsTool setDefaultConfig];
}

- (void)initLivenesswithList {
    // 默认活体检测打开，顺序执行
    /*
     添加当前默认的动作，是否需要按照顺序，动作活体的数量（设置页面会根据这个numOfLiveness来判断选择了几个动作）
     */
    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveEye)];
    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveMouth)];
    [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveYawRight)];
    BDFaceLivingConfigModel.sharedInstance.isByOrder = NO;
    BDFaceLivingConfigModel.sharedInstance.numOfLiveness = 3;
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
