//
//  LivingConfigViewController.m
//  FaceSDKSample_IOS
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BDFaceLivingConfigViewController.h"
#import "BDFaceLivingConfigModel.h"
#import "SSFaceSDK.h"
#import "BDFaceLogoView.h"
#import "BDFaceSelectConfigController.h"
#import "UIColor+BDFaceColorUtils.h"
#import "BDFaceToastView.h"
#import "BDFaceAdjustParamsFileManager.h"
#import "BDUIConstant.h"
#import "HYCivicCenterCommand.h"

#define SoundSwitch @"SoundMode"
#define LiveDetect @"LiveMode"
#define ByOrder @"ByOrder"


static float const BDFaceActionValue = 0.8f;

@interface BDFaceLivingConfigViewController ()
@property (strong, nonatomic) UISwitch *voiceSwitch;
@property (strong, nonatomic) UIImageView *warningView;
@property (strong, nonatomic) UILabel *waringLabel;
@property (strong, nonatomic) UIView *liveView;
@property (assign, nonatomic) NSInteger totalSelected;
@property (assign, nonatomic) NSInteger currentSelectedCount;
@property (strong, nonatomic) UILabel *stateLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) float actionValue;

@end

@implementation BDFaceLivingConfigViewController{
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.totalSelected = 6;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.actionValue = [[FaceSDKManager sharedInstance] liveThresholdValue];
    self.view.backgroundColor = UIColorFromRGB(0xF0F1F2);

    // 顶部
    UILabel *titeLabel = [[UILabel alloc] init];
    titeLabel.frame = CGRectMake(0, 10+KBDXStatusHeight, ScreenWidth, 20);
    titeLabel.text = @"设置";
    titeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    titeLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    titeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titeLabel];
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(16, 8+KBDXStatusHeight, 28, 28);
    [backButton setImage:HyBundleImage(@"icon_titlebar_back") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 提示
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.frame = CGRectMake(16, 16+KBDNaviHeight, 302.7, 14);
    noticeLabel.text = @"提示: 正式使用时，开发者可将前端设置功能隐藏";
    noticeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    [noticeLabel setTextAlignment:NSTextAlignmentLeft];
    noticeLabel.textColor = KColorFromRGB(0x91979E);
    [self.view addSubview:noticeLabel];
    
    UIImage *backSelectImage = HyBundleImage(@"icon_live_list");
    
    // 语音播报部分
    {
        UIImageView *imageView1 = [[UIImageView alloc] init];
        imageView1.frame = CGRectMake(0, 42+KBDNaviHeight, ScreenWidth, 52);
        imageView1.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:imageView1];
        
        
        UIImageView *img1 = [[UIImageView alloc] init];
        img1.frame = CGRectMake(16, 42+KBDNaviHeight+11, 30, 30);
        img1.image = HyBundleImage(@"living_config1");
        [self.view addSubview:img1];
        
        
        UILabel *voiceLabel = [[UILabel alloc] init];
        voiceLabel.frame = CGRectMake(58, 60+KBDNaviHeight, 72, 18);
        voiceLabel.text = @"语音播报";
        voiceLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        voiceLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
        
        // 音量开启/关闭的switch button
        self.voiceSwitch = [[UISwitch alloc] init];
        // UISwitch 系统默认大小，fram 不起作用
        self.voiceSwitch.frame = CGRectMake(ScreenWidth-48-16, 49+KBDNaviHeight+3, 48, 23);
        [self.voiceSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        NSNumber *soundeMode = [[NSUserDefaults standardUserDefaults] objectForKey:SoundSwitch];
        self.voiceSwitch.on = soundeMode.boolValue;
        [self.view addSubview:voiceLabel];
        [self.view addSubview:self.voiceSwitch];
        [self changeSwitchColor:self.voiceSwitch];
    }
    
    // 质量控制部分
    {
        UIButton *qualityButton = [[UIButton alloc] init];
        qualityButton.frame = CGRectMake(0, KBDNaviHeight+110, ScreenWidth, 52);
        [qualityButton setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:qualityButton];
        [qualityButton addTarget:self action:@selector(toSettingPage) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *img2 = [[UIImageView alloc] init];
        img2.frame = CGRectMake(16, 110+KBDNaviHeight+11, 30, 30);
        img2.image = HyBundleImage(@"living_config2");
        [self.view addSubview:img2];
        
        UILabel *qualityLabel = [[UILabel alloc] init];
        qualityLabel.frame = CGRectMake(58, KBDNaviHeight+128, 72, 18);
        qualityLabel.text = @"质量控制";
        qualityLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        qualityLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
        [self.view addSubview:qualityLabel];
        UIImageView *rightArrow = [[UIImageView alloc] init];
        rightArrow.frame = CGRectMake(ScreenWidth-30-16, KBDNaviHeight+120, 30, 30);
        rightArrow.image = HyBundleImage(@"right_arrow");
        [rightArrow setContentMode:UIViewContentModeCenter];
        [self.view addSubview:rightArrow];
        
        CGRect stateLabelRect = rightArrow.frame;
        CGFloat stateLabelWidth = 60.0f;
        stateLabelRect.origin.x = CGRectGetMinX(rightArrow.frame) - stateLabelWidth;
        stateLabelRect.size.width = stateLabelWidth;
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:stateLabelRect];
        [self.view addSubview:stateLabel];
        stateLabel.textAlignment = NSTextAlignmentRight;
        stateLabel.textColor =  [UIColor colorWithRed:23 / 255.0 green:29 / 255.0 blue:36 / 255.0 alpha:1 / 1.0];
        stateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        self.stateLabel = stateLabel;
        
    }
    // 活体检测部分，switch和label
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.frame = CGRectMake(0, KBDNaviHeight+178, ScreenWidth, 52);
    imageView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView2];
    UILabel *liveLabel = [[UILabel alloc] init];
    
    UIImageView *img3 = [[UIImageView alloc] init];
    img3.frame = CGRectMake(16, 178+KBDNaviHeight+11, 30, 30);
    img3.image = HyBundleImage(@"living_config1");
    [self.view addSubview:img3];
    
    
    liveLabel.frame = CGRectMake(58, KBDNaviHeight+196, 120, 18);
    liveLabel.text = @"动作活体检测";
    liveLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    liveLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    [self.view addSubview:liveLabel];
    UISwitch *liveSwitch = [[UISwitch alloc] init];
    liveSwitch.frame = CGRectMake(ScreenWidth-48-16, KBDNaviHeight+185+3, 48, 23);
    [liveSwitch addTarget:self action:@selector(isRunLiveDetect:) forControlEvents:UIControlEventValueChanged];
    NSNumber *liveMode = [[NSUserDefaults standardUserDefaults] objectForKey:LiveDetect];
    liveSwitch.on = liveMode.boolValue;
    [self.view addSubview:liveSwitch];
    [self changeSwitchColor:liveSwitch];
    
    // 提示
    UILabel *noticeLabel1 = [[UILabel alloc] init];
    noticeLabel1.frame = CGRectMake(0, KBDNaviHeight+238, ScreenWidth-32, 36);
    noticeLabel1.text = @"建议开启，开启后在完成随机展示眨眼或张嘴动作后，进入炫瞳活体页面";
    noticeLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    noticeLabel1.numberOfLines = 2;
    CGSize size = [noticeLabel1 sizeThatFits:CGSizeMake(noticeLabel1.frame.size.width, MAXFLOAT)];
    noticeLabel1.frame = CGRectMake(16, KBDNaviHeight+238, (ScreenWidth-32), size.height);
    [noticeLabel1 setTextAlignment:NSTextAlignmentLeft];
    noticeLabel1.textColor = KColorFromRGB(0x91979E);
    [self.view addSubview:noticeLabel1];
    
    
    // 活体检测阈值调节部分
    UIImageView *imageView3 = [[UIImageView alloc] init];
    imageView3.frame = CGRectMake(0, KBDNaviHeight+298, ScreenWidth, 52);
    imageView3.backgroundColor = [UIColor whiteColor];
    imageView3.userInteractionEnabled = YES;
    [self.view addSubview:imageView3];
    
    UIImageView *img4 = [[UIImageView alloc] init];
    img4.frame = CGRectMake(16, 11, 30, 30);
    img4.image = HyBundleImage(@"living_config4");
    [imageView3 addSubview:img4];
    
    UILabel *thresholdLabel = [[UILabel alloc] init];
    thresholdLabel.frame = CGRectMake(58, 15, 120, 22);
    thresholdLabel.text = @"活体检测阈值";
    thresholdLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    thresholdLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    [imageView3 addSubview:thresholdLabel];

    
    self.leftButton = [[UIButton alloc]init];
    self.leftButton.frame = CGRectMake(ScreenWidth-116-28, 12, 28, 28);
    [imageView3 addSubview:self.leftButton];
    [self.leftButton addTarget:self action:@selector(minusNumber) forControlEvents:UIControlEventTouchUpInside];

    [self.leftButton setImage:HyBundleImage(@"left_button_normal") forState:UIControlStateNormal];
    [self.leftButton setImage:HyBundleImage(@"left_button_highlight") forState:UIControlStateHighlighted];
    
    self.textLabel = [[UILabel alloc]init];
    [imageView3 addSubview:self.textLabel];
    self.textLabel.frame = CGRectMake(ScreenWidth-56-52, 14, 56, 24);
    self.textLabel.text = [NSString stringWithFormat:@"%.2f",self.actionValue];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor colorWithRed:23 / 255.0 green:29 / 255.0 blue:36 / 255.0 alpha:1 / 1.0];
    self.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(ScreenWidth-28-16, 12, 28, 28);
    [imageView3 addSubview:self.rightButton];
    [self.rightButton addTarget:self action:@selector(addNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setImage:HyBundleImage(@"right_button_normal") forState:UIControlStateNormal];
    [self.rightButton setImage:HyBundleImage(@"right_button_highlight") forState:UIControlStateHighlighted];
    
    
    // 提示
    UILabel *noticeLabel2 = [[UILabel alloc] init];
    noticeLabel2.frame = CGRectMake(16, KBDNaviHeight+358, 302.7, 14);
    noticeLabel2.text = @"设置范围0-1，推荐阈值为0.80";
    noticeLabel2.textAlignment = NSTextAlignmentLeft;
    noticeLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    noticeLabel2.textColor = KColorFromRGB(0x91979E);
    [self.view addSubview:noticeLabel2];
    
}

- (void)minusNumber{
    self.actionValue -= 0.05;
    if (self.actionValue<0) {
        self.actionValue=0;
        [self.leftButton setImage:HyBundleImage(@"left_button_unable") forState:UIControlStateNormal];
    } else {
        [self.leftButton setImage:HyBundleImage(@"left_button_normal") forState:UIControlStateNormal];
        [self.rightButton setImage:HyBundleImage(@"right_button_normal") forState:UIControlStateNormal];
    }
    [[FaceSDKManager sharedInstance] setliveThresholdValue:self.actionValue];
    self.textLabel.text = [NSString stringWithFormat:@"%.2f",self.actionValue];
}

- (void)addNumber{
    self.actionValue += 0.05;
    if (self.actionValue>1) {
        self.actionValue=1;
        [self.rightButton setImage:HyBundleImage(@"right_button_unable") forState:UIControlStateNormal];
    } else {
        [self.leftButton setImage:HyBundleImage(@"left_button_normal") forState:UIControlStateNormal];
        [self.rightButton setImage:HyBundleImage(@"right_button_normal") forState:UIControlStateNormal];
    }
    
    [[FaceSDKManager sharedInstance] setliveThresholdValue:self.actionValue];
    self.textLabel.text = [NSString stringWithFormat:@"%.2f",self.actionValue];
}
- (void)viewWillAppear:(BOOL)animated {
    self.stateLabel.text = [BDFaceAdjustParamsFileManager currentSelectionText];
}

- (void)toSettingPage {
    BDFaceSelectConfigController *lvc = [[BDFaceSelectConfigController alloc] init];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (IBAction)backAction:(UIButton *)sender {
    // 判定是否选择了两个动作或以上，在开启动作活体时候。
    NSNumber *liveMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"LiveMode"];
    if (BDFaceLivingConfigModel.sharedInstance.numOfLiveness >= 1 || !liveMode.boolValue){
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        [self.view addSubview:self.warningView];
        [self.view addSubview:self.waringLabel];
        
    }
    NSNumber *orderMode = [[NSUserDefaults standardUserDefaults] objectForKey:ByOrder];
    BDFaceLivingConfigModel.sharedInstance.isByOrder = orderMode.boolValue;
}

- (void)changeSwitchColor:(UISwitch *)view {
    view.onTintColor = [UIColor face_colorWithRGBHex:0x0080FF];
    view.layer.cornerRadius = CGRectGetHeight(view.frame) / 2.0f;
}
# pragma mark - switch button部分

- (IBAction)switchAction:(UISwitch *)sender {
    if (sender.isOn) {
        [SSFaceDetectionManager sharedInstance].enableSound = YES;
        // warning 本地存储是为了Demo呈现Switch开关状态, 实际上SDK声音开关运用跟本地存储无关
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:SoundSwitch];
        NSLog(@"打开了声音");
    } else {
//        // 活体声音
        [SSFaceDetectionManager sharedInstance].enableSound = NO;
        // warning 本地存储是为了Demo呈现Switch开关状态, 实际上SDK声音开关运用跟本地存储无关
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:SoundSwitch];
        NSLog(@"关闭了声音");
    }
}

- (IBAction)isRunLiveDetect:(UISwitch *)sender{
    if (sender.isOn) {
        self.liveView.hidden = NO;
        // warning 本地存储是为了Demo呈现Switch开关状态, 实际上SDK声音开关运用跟本地存储无关
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:LiveDetect];
        NSLog(@"打开了活体检测");
    } else {
         self.liveView.hidden = YES;
        // warning 本地存储是为了Demo呈现Switch开关状态, 实际上SDK声音开关运用跟本地存储无关
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:LiveDetect];
        NSLog(@"关闭了活体检测");
    }
}

@end
