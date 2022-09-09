//
//  BDFaceSuccessViewController.m
//  FaceSDKSample_IOS
//
//  Created by 孙明喆 on 2020/3/12.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceSuccessViewController.h"
#import "BDFaceLivingConfigViewController.h"
#import "BDFaceDetectionViewController.h"
#import "BDFaceLivenessViewController.h"
#import "SSFaceSDK.h"
#import "BDFaceLivingConfigModel.h"
#import "BDFaceLogoView.h"
#import "BDFaceImageShow.h"
#import "BDFaceColorfulViewController.h"
#import "BDUIConstant.h"
#import "BDFaceSuccessViewController+BDCheckFace.h"
#import "HYCivicCenterCommand.h"

@interface BDFaceSuccessViewController ()
@end

@implementation BDFaceSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColorFromRGB(0xF0F1F2);

    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(23.3, 43.3, 28, 28);
    [backButton setImage:HyBundleImage(@"icon_titlebar_close") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 成功图片显示和label
    UIImageView *successImageView = [[UIImageView alloc] init];
    successImageView.frame = CGRectMake((ScreenWidth-88) / 2, KScaleY(164), 88, 88);
    successImageView.image = HyBundleImage(@"icon_success"); //icon_overtime
    successImageView.layer.masksToBounds = YES;
    successImageView.layer.cornerRadius = 44;
    successImageView.contentMode = UIViewContentModeScaleAspectFill;

    [self.view addSubview:successImageView];
        
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.frame = CGRectMake(0, KScaleY(276), ScreenWidth, 24);
    successLabel.text = [NSString stringWithFormat:@"%@ ", [[BDFaceImageShow sharedInstance] getAuraLiveColor]];
    successLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
    successLabel.textColor = UIColorFromRGB(0x171D24);
    successLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:successLabel];
    
    // 活体UI默认关闭
    UILabel *liveScoreLabel = [[UILabel alloc] init];
    liveScoreLabel.frame = CGRectMake(0, KScaleY(308), ScreenWidth, 22);
    NSString *liveScoreTxt = [NSString stringWithFormat:@"炫彩活体分值 %.4f ",[[BDFaceImageShow sharedInstance] getColorliveScore]];
    liveScoreLabel.text = liveScoreTxt;
    liveScoreLabel.font = [UIFont systemFontOfSize:16];
    liveScoreLabel.textColor = UIColorFromRGB(0x77787A);
    liveScoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:liveScoreLabel];
    
    
    UILabel *failLabel = [[UILabel alloc] init];
    failLabel.frame = CGRectMake(0, KScaleY(338), ScreenWidth, 24);
    failLabel.text = @"";
    failLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    failLabel.textColor = UIColorFromRGB(0x77787A);
    failLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:failLabel];

    successLabel.text = [NSString stringWithFormat:@"%@", self.sendDic[@"successLabel"]];
    successImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.sendDic[@"successImageView"]]];
    liveScoreLabel.text = [NSString stringWithFormat:@"%@", self.sendDic[@"liveScoreLabel"]];
    failLabel.text = [NSString stringWithFormat:@"%@", self.sendDic[@"failLabel"]];

    
    // 底部logo部分
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 221, ScreenWidth, 221);
    logoImageView.image = HyBundleImage(@"image_guide_bottom");
    [self.view addSubview:logoImageView];
    
    
    // 核验人脸Button
    if (self.success) {
        {
            UIButton *checkFaceButton = [[UIButton alloc] init];
            checkFaceButton.frame = CGRectMake(56, ScreenHeight-213-56, ScreenWidth-56-56, 52);
            checkFaceButton.layer.cornerRadius = 26;
            checkFaceButton.layer.masksToBounds = YES;
            [checkFaceButton addTarget:self action:@selector(checkFaceAction) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:checkFaceButton];
            [checkFaceButton setBackgroundImage:[self imageFromColor:KColorFromRGBAlpha(0x0080FF, 1) size:CGSizeMake(ScreenWidth-56-56, 52)] forState:UIControlStateNormal];
            [checkFaceButton setBackgroundImage:[self imageFromColor:KColorFromRGBAlpha(0x0080FF, 0.6) size:CGSizeMake(ScreenWidth-56-56, 52)] forState:UIControlStateHighlighted];
            checkFaceButton.titleLabel.textColor = [UIColor whiteColor];
            [checkFaceButton setTitle:@"人脸核验" forState:UIControlStateNormal];
            [checkFaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            checkFaceButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        }
        
        // 活体检测Button
        {
            UIButton *checkFaceButton = [[UIButton alloc] init];
            checkFaceButton.frame = CGRectMake(56, ScreenHeight-281-56, ScreenWidth-56-56, 52);
            checkFaceButton.layer.cornerRadius = 26;
            checkFaceButton.layer.masksToBounds = YES;
            [checkFaceButton addTarget:self action:@selector(checkFaceLiveAction) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:checkFaceButton];
            [checkFaceButton setBackgroundImage:[self imageFromColor:KColorFromRGBAlpha(0x0080FF, 1) size:CGSizeMake(ScreenWidth-56-56, 52)] forState:UIControlStateNormal];
            [checkFaceButton setBackgroundImage:[self imageFromColor:KColorFromRGBAlpha(0x0080FF, 0.6) size:CGSizeMake(ScreenWidth-56-56, 52)] forState:UIControlStateHighlighted];
            checkFaceButton.titleLabel.textColor = [UIColor whiteColor];
            [checkFaceButton setTitle:@"活体检测" forState:UIControlStateNormal];
            [checkFaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            checkFaceButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        }
    }


    // 上下两个button
    UIButton *btnFirst = [[UIButton alloc] init];
    btnFirst.frame = CGRectMake(56, ScreenHeight-145-56, ScreenWidth-56-56, 52);
    btnFirst.layer.cornerRadius = 26;
    btnFirst.layer.masksToBounds = YES;
    [btnFirst addTarget:self action:@selector(restartClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFirst];
    [btnFirst setBackgroundImage:[self imageFromColor:KColorFromRGBAlpha(0x0080FF, 1) size:CGSizeMake(ScreenWidth-56-56, 52)] forState:UIControlStateNormal];
    [btnFirst setBackgroundImage:[self imageFromColor:KColorFromRGBAlpha(0x0080FF, 0.6) size:CGSizeMake(ScreenWidth-56-56, 52)] forState:UIControlStateHighlighted];

    
    UIButton *btnSecond = [[UIButton alloc] init];
    btnSecond.frame = CGRectMake(56, ScreenHeight-77-56, ScreenWidth-56-56, 52);
    [btnSecond setBackgroundColor:UIColorFromRGB(0xD9DFE6)];
    btnSecond.layer.cornerRadius = 26;
    [btnSecond addTarget:self action:@selector(backToViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSecond];
    
    // 对应的label
    UILabel *labelFirst = [[UILabel alloc] init];
    labelFirst.frame = CGRectMake(100, ScreenHeight-165-22, ScreenWidth-200, 22);
    labelFirst.text = @"重新采集";
    labelFirst.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    labelFirst.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];
    labelFirst.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelFirst];

    UILabel *labelSecond = [[UILabel alloc] init];
    labelSecond.frame = CGRectMake(100, ScreenHeight-97-22, ScreenWidth-200, 22);
    labelSecond.text = @"回到首页";
    labelSecond.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    labelSecond.textColor = UIColorFromRGB(0x171D24);
    labelSecond.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelSecond];
    
     // 设置logo，底部的位置和大小，实例化显示
    BDFaceLogoView* logoView = [[BDFaceLogoView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-15-12), ScreenWidth, 12)];
    [self.view addSubview:logoView];

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
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BDFaceImageShow sharedInstance] reset];
    
}

#pragma mark - Button
- (IBAction)settingAction:(UIButton *)sender{
    // TODO
    BDFaceLivingConfigViewController *lvc = [[BDFaceLivingConfigViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:YES completion:nil];
}

- (IBAction)restartClick:(UIButton *)sender{
    // TODO

    NSLog(@"点击");
    UIViewController *fatherViewController = self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        NSArray * colorArr = [[NSArray alloc] initWithObjects:@(FaceLivenessActionTypeLiveEye), @(FaceLivenessActionTypeLiveMouth), nil];
        int r = arc4random() % [colorArr count];
        BDFaceColorfulViewController* lvc = [[BDFaceColorfulViewController alloc] init];
        lvc.modalPresentationStyle = UIModalPresentationFullScreen;
        BDFaceLivingConfigModel* model = [BDFaceLivingConfigModel sharedInstance];
        [lvc livenesswithList:@[colorArr[r]] order:model.isByOrder numberOfLiveness:model.numOfLiveness];
        [fatherViewController presentViewController:lvc animated:YES completion:nil];

    }];
}

- (IBAction)backToViewController:(UIButton *)sender{
    // TODO
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)backAction:(UIButton *)sender{
    // TODO
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)checkFaceAction {
#warning develper: imageIdetifier 是图片的唯一标识，具体在开发中和server定
    NSString *imageIdetifier = @"22a576d77da1c9d3af4cb202606ceb54";
    NSString *imageString = self.sendDic[@"image_string"];
    NSString *sKey = self.sendDic[@"skey"];
    NSString *deviceId = self.sendDic[@"device_id"];
    
    [self checkFaceWithImageId:imageIdetifier imageString:imageString deviceId:deviceId sKey:sKey checkLive:NO];
}

- (void)checkFaceLiveAction {
    // 活体检测的时候不需要传入imageIdetifier,传入空字符串即可
    NSString *imageString = self.sendDic[@"image_string"];
    NSString *sKey = self.sendDic[@"skey"];
    NSString *deviceId = self.sendDic[@"device_id"];
    
    [self checkFaceWithImageId:@"" imageString:imageString deviceId:deviceId sKey:sKey checkLive:YES];
}


@end
