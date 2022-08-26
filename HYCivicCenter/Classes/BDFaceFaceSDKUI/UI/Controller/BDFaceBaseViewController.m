//
//  BDFaceBaseViewController.m
//  FaceSDKSample_IOS
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BDFaceBaseViewController.h"
#import "BDFaceImageUtils.h"
#import "BDFaceRemindView.h"
#import "BDFaceLogoView.h"
#import "BDUIConstant.h"
#import "BDPopupController.h"

#import "SSFaceDetectionManager.h"

#define scaleValue 0.70
#define scaleValueX 0.80



@interface BDFaceBaseViewController () <SSCaptureDataOutputProtocol>{
    int i;
}
@property (nonatomic, readwrite, retain) UILabel *remindLabel;
@property (nonatomic, readwrite, retain) UIImageView *voiceImageView;
@property (nonatomic, readwrite, retain) BDFaceRemindView * remindView;
@property (nonatomic, readwrite, retain) UILabel * remindDetailLabel;

@property (nonatomic, strong) BDPopupController *popupController;

@property (nonatomic, strong) UIView *videoPreview;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *vPreviewLayer;//视频流不卡顿展示界面

@end

@implementation BDFaceBaseViewController

- (void)dealloc
{
    NSLog(@"dealloc-base");

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setHasFinished:(BOOL)hasFinished {
    _hasFinished = hasFinished;
    if (hasFinished) {
        self.detectionManager.delegate = nil;
    }
}

- (void)warningStatus:(WarningStatus)status warning:(NSString *)warning
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == changeColorStatus) {
            [weakSelf.remindLabel setHidden:false];
            [weakSelf.remindView setHidden:true];
            [weakSelf.remindDetailLabel setHidden:true];
            weakSelf.remindLabel.text = warning;
            weakSelf.remindLabel.textColor = [UIColor whiteColor];
        } else {
            weakSelf.remindLabel.textColor = [UIColor blackColor];
            weakSelf.remindDetailLabel.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1 / 1.0];
            if (status == PoseStatus) {
                [weakSelf.remindLabel setHidden:false];
                [weakSelf.remindView setHidden:false];
                [weakSelf.remindDetailLabel setHidden:false];
                weakSelf.remindDetailLabel.text = warning;
                weakSelf.remindLabel.text = @"请保持正脸";
            } else if (status == occlusionStatus) {
                [weakSelf.remindLabel setHidden:false];
                [weakSelf.remindView setHidden:true];
                [weakSelf.remindDetailLabel setHidden:false];
                weakSelf.remindDetailLabel.text = warning;
                weakSelf.remindLabel.text = @"脸部有遮挡";
            } else {
                [weakSelf.remindLabel setHidden:false];
                [weakSelf.remindView setHidden:true];
                [weakSelf.remindDetailLabel setHidden:true];
                weakSelf.remindLabel.text = warning;
            }
        }
    });
}

- (void)singleActionSuccess:(BOOL)success
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
            
        }else {
            
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 用于播放视频流
    if ( KIS_IPhone_Xr || KIS_IPhone_Xs || KIS_IPhone_Xs_Max) {
        self.previewRect = CGRectMake(ScreenWidth*(1-scaleValueX)/2.0, ScreenHeight*(1-scaleValueX)/2.0, ScreenWidth*scaleValueX, ScreenHeight*scaleValueX);
    } else {
        self.previewRect = CGRectMake(ScreenWidth*(1-scaleValue)/2.0, ScreenHeight*(1-scaleValue)/2.0, ScreenWidth*scaleValue, ScreenHeight*scaleValue);
    }
    
    //     PreviewLayer 方案
    self.videoPreview = [[UIView alloc] initWithFrame:self.view.frame];
    self.vPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
    self.vPreviewLayer.frame = self.view.frame;
    self.vPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;

    [self.videoPreview.layer addSublayer:self.vPreviewLayer];
    [self.view addSubview:self.videoPreview];

    
    // 用于展示视频流的imageview
    self.displayImageView = [[UIImageView alloc] initWithFrame:self.previewRect];
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.displayImageView];
    
    if ( KIS_IPhone_Xr || KIS_IPhone_Xs || KIS_IPhone_Xs_Max) {
        self.circleRect =CGRectMake(ScreenWidth*(1-scaleValueX)/2.0 , 175*ScreenHeight/667, ScreenWidth*scaleValueX, ScreenWidth*scaleValueX);
    } else {
        self.circleRect =CGRectMake(ScreenWidth*(1-scaleValue)/2.0 , 175*ScreenHeight/667, ScreenWidth*scaleValue, ScreenWidth*scaleValue);
    }
    // 画圈和圆形遮罩
    self.detectRect = CGRectMake(self.circleRect.origin.x, self.circleRect.origin.y, self.circleRect.size.width, self.circleRect.size.height); //没有低头取消*5/4扩大框
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.circleRect), CGRectGetMidY(self.circleRect));
    //创建一个View
    self.maskView = [[UIView alloc] initWithFrame:ScreenRect];
    self.maskView.backgroundColor = UIColorFromRGB(0xF0F1F2);
    self.maskView.alpha = 1;
    [self.view addSubview:self.maskView];
    //贝塞尔曲线 画一个带有圆角的矩形
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:ScreenRect cornerRadius:0];
    //贝塞尔曲线 画一个圆形
    if ( KIS_IPhone_Xr || KIS_IPhone_Xs || KIS_IPhone_Xs_Max) {
        [bpath appendPath:[UIBezierPath bezierPathWithArcCenter:centerPoint radius:ScreenWidth*scaleValueX / 2 startAngle:0 endAngle:2 * M_PI clockwise:NO]];
    } else {
        [bpath appendPath:[UIBezierPath bezierPathWithArcCenter:centerPoint radius:ScreenWidth*scaleValue / 2 startAngle:0 endAngle:2 * M_PI clockwise:NO]];
    }
    //创建一个CAShapeLayer 图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    // 添加图层蒙板
    self.maskView.layer.mask = shapeLayer;
    
    CALayer * layer = [CALayer layer];
    layer.frame = self.circleRect;
    layer.cornerRadius = self.circleRect.size.width/2;
    layer.borderWidth = 15;
    layer.borderColor = [UIColor colorWithRed:23 / 255.0 green:29 / 255.0 blue:36 / 255.0 alpha:0.05 / 1.0].CGColor;
    [self.view.layer addSublayer:layer];
    
    CALayer * layer1 = [CALayer layer];
    layer1.frame = self.circleRect;
    layer1.cornerRadius = self.circleRect.size.width/2;
    layer1.borderWidth = 8;
    layer1.borderColor = [UIColor colorWithRed:23 / 255.0 green:29 / 255.0 blue:36 / 255.0 alpha:0.15 / 1.0].CGColor;
    [self.view.layer addSublayer:layer1];
    
    // 进度条view，活体检测页面
    CGRect circleProgressRect =  CGRectMake(CGRectGetMinX(self.circleRect) - 13.7, CGRectGetMinY(self.circleRect) - 13.7, CGRectGetWidth(self.circleRect) + (13.7 * 2), CGRectGetHeight(self.circleRect) + (13.7 * 2));
    self.circleProgressView = [[BDFaceCycleProgressView alloc] initWithFrame:circleProgressRect];
    
    // 动作活体动画
    self.remindAnimationView = [[BDFaceRemindAnimationView alloc] initWithFrame:self.circleRect];
    
    // 提示框（动作）
    self.remindLabel = [[UILabel alloc] init];
    self.remindLabel.frame = CGRectMake(0, 103.3, ScreenWidth, 22);
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    self.remindLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    self.remindLabel.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:self.remindLabel];
    
    // 提示label（遮挡等问题）
    self.remindDetailLabel = [[UILabel alloc] init];
    self.remindDetailLabel.frame = CGRectMake(0, 139.3, ScreenWidth, 16);
    self.remindDetailLabel.font = [UIFont systemFontOfSize:16];
    self.remindDetailLabel.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1 / 1.0];
    self.remindDetailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.remindDetailLabel];
    [self.remindDetailLabel setHidden:true];
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(23.3, KScaleY(42.7), 28, 28);
    [backButton setImage:[UIImage imageNamed:@"icon_titlebar_close"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 音量imageView，可动态播放图片
    _voiceImageView = [[UIImageView alloc] init];
    _voiceImageView.frame = CGRectMake((ScreenWidth-22-20), KScaleY(42.7), 28, 28);
    _voiceImageView.animationImages = [NSArray arrayWithObjects:
                                       [UIImage imageNamed:@"icon_titlebar_voice2"], nil];
    _voiceImageView.animationDuration = 2;
    _voiceImageView.animationRepeatCount = 0;
    NSNumber *soundMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"SoundMode"];
    if (soundMode.boolValue){
        [_voiceImageView startAnimating];
    } else {
        _voiceImageView.image = [UIImage imageNamed:@"icon_titlebar_voice_close"];
    }
    _voiceImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *changeVoidceSet = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeVoidceSet:)];
    [_voiceImageView addGestureRecognizer:changeVoidceSet];
    [self.view addSubview:_voiceImageView];
    
    // 底部logo部分
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 221, ScreenWidth, 221);
    logoImageView.image = [UIImage imageNamed:@"image_guide_bottom"];
    [self.maskView addSubview:logoImageView];
    
    // 设置logo，底部的位置和大小，实例化显示
    BDFaceLogoView* logoView = [[BDFaceLogoView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-15-12), ScreenWidth, 12)];
    [self.view addSubview:logoView];
    
    // 监听重新返回APP
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignAction) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.detectionManager = [SSFaceDetectionManager sharedInstance];
    self.detectionManager.previewRect = self.previewRect;
    self.detectionManager.detectRect = self.detectRect;
    self.detectionManager.delegate = self;
    self.detectionManager.riskDetectionSetting = 0;
    [self.detectionManager connectPreviewLayer:self.vPreviewLayer];
    
    /*
     调试需要时可以打开以下注释
     
     //    黄色框：检测框（视频流返回的位置）
     //    蓝色框：采集框（人脸在采集框中都可以被识别，为了容错设置的宽松了一点）
     //    圆框：采集显示框（人脸应该放置的检测位置）
     //    绿色框：人脸最小框（通过最小框判定人脸是否过远，按照黄色框百分比：0.4宽）
     
//    UIImageView* circleImage= [[UIImageView alloc]init];
//    circleImage = [self creatRectangle:circleImage withRect:self.circleRect withcolor:[UIColor redColor]];
//    [self.view addSubview:circleImage];
//
//    UIImageView* previewImage= [[UIImageView alloc]init];
//    previewImage = [self creatRectangle:previewImage withRect:self.previewRect withcolor:[UIColor yellowColor]];
//    [self.view addSubview:previewImage];
//
//    UIImageView* detectImage= [[UIImageView alloc]init];
//    detectImage = [self creatRectangle:detectImage withRect:self.detectRect withcolor:[UIColor blueColor]];
//    [self.view addSubview:detectImage];
//
//    CGRect _minRect = CGRectMake(CGRectGetMinX(self.detectRect)+CGRectGetWidth(self.detectRect)*(1-[[FaceSDKManager sharedInstance] minRectScale])/2, CGRectGetMinY(self.detectRect)+CGRectGetWidth(self.detectRect)*(1-[[FaceSDKManager sharedInstance] minRectScale])/2, CGRectGetWidth(self.detectRect)*[[FaceSDKManager sharedInstance] minRectScale], CGRectGetWidth(self.detectRect)*[[FaceSDKManager sharedInstance] minRectScale]);
//    UIImageView* minImage= [[UIImageView alloc]init];
//    minImage = [self creatRectangle:minImage withRect:_minRect withcolor:[UIColor greenColor]];
//    [self.view addSubview:minImage];
     */
}

#pragma mark - CaptureDataOutputProtocol

- (void)captureOutputSampleBuffer:(UIImage *)image {
    /*
     需要使用image渲染请打开注释
     */
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        weakSelf.displayImageView.image = image;
//    });
//    [self faceProcesss:image];
}

- (void)livenessActionDidFinishWithCode:(LivenessRemindCode)code {
    [self livenessProcesssWithCode:code];
}

- (void)detectionActionDidFinishWithCode:(DetectRemindCode)code {
    [self detectionProcesssWithCode:code];
}

- (void)colorfulActionDidFinishWithCode:(ColorRemindCode)code imageInfo:(NSDictionary *)imageInfo {
    [self colorfulProcesssWithCode:code imageInfo:imageInfo];
}

- (void)faceSessionCompletionWithStatus:(BDFaceCompletionStatus)status result:(NSDictionary *)result{

    [self faceCallbackWithCode:status result:result];
}

#pragma mark - inner func


- (void)livenessProcesssWithCode:(LivenessRemindCode)code {
}

- (void)detectionProcesssWithCode:(DetectRemindCode)code {
}

- (void)colorfulProcesssWithCode:(ColorRemindCode)code imageInfo:(NSDictionary *)imageInfo {
    
}

- (void)faceCallbackWithCode:(BDFaceCompletionStatus)status result:(NSDictionary *)result {
}


#pragma mark-绘框方法
- (UIImageView *)creatRectangle:(UIImageView *)imageView withRect:(CGRect) rect withcolor:(UIColor *)color{
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    //创建需要画线的视图
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    //起点
    float x = rect.origin.x;
    float y = rect.origin.y;
    float W = rect.size.width;
    float H = rect.size.height;
    [linePath moveToPoint:CGPointMake(x, y)];
    //其他点
    [linePath addLineToPoint:CGPointMake(x + W, y)];
    [linePath addLineToPoint:CGPointMake(x + W, y + H)];
    [linePath addLineToPoint:CGPointMake(x, y + H)];
    [linePath addLineToPoint:CGPointMake(x, y)];
    lineLayer.lineWidth = 2;
    lineLayer.strokeColor = color.CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    imageView.layer.sublayers = nil;
    [imageView.layer addSublayer:lineLayer];
    return imageView;
}
- (void)isTimeOut:(BOOL)isOrNot {
    if (isOrNot){
        // 加载超时的view
        [self outTimeViewLoad];
        [self.popupController showInView:self.view.window duration:0.75 bounced:YES completion:nil];

    }
}

- (void)outTimeViewLoad{
    
    // 显示超时view，并停止视频流工作
    self.remindLabel.text = @"";
    self.remindDetailLabel.text = @"";
}

- (void)outTimeViewUnload{
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.hasFinished = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _hasFinished = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)faceProcesss:(UIImage *)image {
}

- (void)closeAction {
    _hasFinished = YES;
    [self.detectionManager cancel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ButtonFunction
- (IBAction)reStart:(UIButton *)sender{
    [self dismissVc];
    // 对应页面去补充
    dispatch_async(dispatch_get_main_queue(), ^{
        [self outTimeViewUnload];
    });
    // 调用相应的部分设置
    [self selfReplayFunction];
    
}

- (void)selfReplayFunction{
    // 相应的功能在采集/检测时候写
}

- (IBAction)backToPreView:(UIButton *)sender{
    [self dismissVc];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification

- (void)onAppWillResignAction {
    _hasFinished = YES;
}

- (void)onAppBecomeActive {
    _hasFinished = NO;
}


#pragma mark - 声音按钮控制
- (void)changeVoidceSet:(UITapGestureRecognizer *)sender {
    NSNumber *soundMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"SoundMode"];
    NSLog(@"点击");
    if (soundMode.boolValue && _voiceImageView.animating) {
        [_voiceImageView stopAnimating];
        _voiceImageView.image = [UIImage imageNamed:@"icon_titlebar_voice_close"];
        // 之前是开启的，点击后关闭
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"SoundMode"];
//        // 活体声音
        [SSFaceDetectionManager sharedInstance].enableSound = NO;
    } else {
        [_voiceImageView startAnimating];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"SoundMode"];
        // 活体声音
        [SSFaceDetectionManager sharedInstance].enableSound = YES;
    }
}


- (void)captureError {
    NSString *errorStr = @"出现未知错误，请检查相机设置";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        errorStr = @"相机权限受限,请在设置中启用";
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"知道啦");
        }];
        [alert addAction:action];
        UIViewController* fatherViewController = weakSelf.presentingViewController;
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [fatherViewController presentViewController:alert animated:YES completion:nil];
        }];
    });
}
- (BDPopupController *)popupController {
    if (!_popupController) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(KScaleX(32), KScaleY(120), KScaleX(311), KScaleY(428))];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 12;
        view.layer.masksToBounds = YES;
        
        // 成功图片显示和label
        UIImageView *successImageView = [[UIImageView alloc] init];
        successImageView.frame = CGRectMake(KScaleX(112), KScaleY(82), 88, 88);
        successImageView.image = [UIImage imageNamed:@"icon_overtime"];
        successImageView.layer.masksToBounds = YES;
        successImageView.layer.cornerRadius = 44;
        [view addSubview:successImageView];
            
        UILabel *successLabel = [[UILabel alloc] init];
        successLabel.frame = CGRectMake(KScaleX(85), KScaleY(190), 140, 24);
        successLabel.text = @"人脸采集超时";
        successLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
        successLabel.textColor = UIColorFromRGB(0x171D24);
        successLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:successLabel];
        
        // 上下两个button
        UIButton *btnFirst = [[UIButton alloc] init];
        btnFirst.frame = CGRectMake(KScaleX(24), KScaleY(428)-KScaleY(92)-52, KScaleX(263), 52);
        btnFirst.layer.cornerRadius = 26;
        btnFirst.layer.masksToBounds = YES;
        [btnFirst addTarget:self action:@selector(reStart:) forControlEvents:UIControlEventTouchUpInside];
        [btnFirst setTitle:@"重新采集" forState:UIControlStateNormal];
        [btnFirst setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        btnFirst.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [btnFirst setBackgroundImage:[self imageFromColor:KColorFromRGBAlpha(0x0080FF, 1) size:CGSizeMake(ScreenWidth-56-56, 52)] forState:UIControlStateNormal];
        [btnFirst setBackgroundImage:[self imageFromColor:KColorFromRGBAlpha(0x0080FF, 0.6) size:CGSizeMake(ScreenWidth-56-56, 52)] forState:UIControlStateHighlighted];
        [view addSubview:btnFirst];

        UIButton *btnSecond = [[UIButton alloc] init];
        btnSecond.frame = CGRectMake(KScaleX(24), KScaleY(428)-KScaleY(24)-52,  KScaleX(263), 52);
        [btnSecond setBackgroundColor:UIColorFromRGB(0xD9DFE6)];
        btnSecond.layer.cornerRadius = 26;
        [btnSecond addTarget:self action:@selector(backToPreView:) forControlEvents:UIControlEventTouchUpInside];
        [btnSecond setTitle:@"回到首页" forState:UIControlStateNormal];
        [btnSecond setTitleColor:UIColorFromRGB(0x171D24) forState:UIControlStateNormal];
        btnSecond.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [view addSubview:btnSecond];
        
        _popupController = [[BDPopupController alloc] initWithView:view size:view.bounds.size];
        _popupController.presentationStyle = zhPopupSlideStyleTransform;
        _popupController.presentationTransformScale = 1;
        _popupController.dismissonTransformScale = 0.85;
        _popupController.dismissOnMaskTouched = NO;
    }
    return _popupController;
}
-(void)dismissVc{
    [self.popupController dismiss];
}
-(UIImage*)imageFromColor:(UIColor*)color size:(CGSize)size{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size); //创建图片
    CGContextRef context = UIGraphicsGetCurrentContext(); //创建图片上下文
    CGContextSetFillColorWithColor(context, [color CGColor]); //设置当前填充颜色的图形上下文
    CGContextFillRect(context, rect); //填充颜色
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
