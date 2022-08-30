//
//  BDFaceColorfulViewController.m
//  FaceSDKSample_IOS
//
//  Created by 之哥 on 2020/12/29.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceColorfulViewController.h"
#import "SSFaceSDK.h"
#import <AVFoundation/AVFoundation.h>
#import "BDFaceSuccessViewController.h"
#import "BDFaceImageShow.h"
#import "BDFaceToastView.h"
#import "BDFaceLivingConfigModel.h"
#import "BDUIConstant.h"

@interface BDFaceColorfulViewController () <CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *fitImage;
@property (nonatomic, assign) BOOL isPaint;
@property (nonatomic, assign) BOOL isliveness;
@property (nonatomic, assign) BOOL colorFinshed;
@property (nonatomic, assign) BOOL colorQuality; //炫彩颜色质量判断按钮，判断是否底层进行质量检测
@property (nonatomic, strong) NSString *docPath;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, copy) NSString *testDirectory;
//动作活体
@property (nonatomic, strong) NSArray *livenessArray;
@property (nonatomic, assign) BOOL order;
@property (nonatomic, assign) NSInteger numberOfLiveness;
@property (nonatomic, strong) NSDate *timeoutTime;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) FaceCropImageInfo *bestImageInfo; //动作活体 加炫彩活体时的bestimage
@property (nonatomic, copy) NSString *originalImageEncryptStr;
@property (nonatomic, copy) NSString *cropImageWithBlackEncryptStr;
@property (nonatomic, copy) NSString *originalImageStr;
@property (nonatomic, copy) NSString *cropImageWithBlackStr;
@property (nonatomic, strong) NSDictionary *resultDic;

@property (nonatomic, strong) UIImage *iconImage;

@end

@implementation BDFaceColorfulViewController

#pragma mark - VC生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iconImage = [[UIImage alloc] init];
    self.colorFinshed = NO;
    NSNumber *LiveMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"LiveMode"];
    self.isliveness = LiveMode.boolValue;
    
    [SSFaceDetectionManager sharedInstance].enableLivenessInColorfulFlow = self.isliveness;
    // 提示动画设置
    [self.view addSubview:self.remindAnimationView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.remindAnimationView setActionImages];
    });
    /*
     炫彩活体流程开始
     */
    [self faceColorfulLiveness];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"进入新的界面");
    _timeoutTime = NSDate.date;
}
-(void)dealloc{
    NSLog(@"dealloc-BDFaceColorfulViewController");
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.maskView) {
        [self.maskView removeFromSuperview];
        self.maskView = nil;
    }
}

- (void)onAppWillResignAction {
    [super onAppWillResignAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onAppBecomeActive {
    [super onAppBecomeActive];
    [[SSFaceDetectionManager sharedInstance] livenesswithList:_livenessArray order:_order numberOfLiveness:_numberOfLiveness];
}

- (void)livenesswithList:(NSArray *)livenessArray order:(BOOL)order numberOfLiveness:(NSInteger)numberOfLiveness {
    _livenessArray = [NSArray arrayWithArray:livenessArray];
    _order = order;
    _numberOfLiveness = numberOfLiveness;
    [[SSFaceDetectionManager sharedInstance] livenesswithList:_livenessArray order:_order numberOfLiveness:_numberOfLiveness];
}

#pragma mark - SDK 变更
//活体+炫彩+录制
- (void)faceColorfulLiveness {
    NSDictionary *parameters =  [self.detectionManager creatFaceVerifyParameters:@"身份证" name:@"姓名" verifyType:KFaceIdCardTypeDefault nation:nil phoneNumber:@"电话" livenessControl:nil spoofingControl:nil qualityControl:nil];
    NSDictionary *videoParas = [self.detectionManager createVideoRecordParametersWithEnableVideoRecording:YES enableVideoSound:YES videoFileName:@"whatmean" imageWidth:480 imageHeight:640];

    [self.detectionManager startSessionWithType:BDFaceResultReportTypeVerifySec parameters:parameters faceFlow:BDFaceDetectionTypeColorfulLiveness viewController:self videoParameters:videoParas cameraAutoClose:YES];
}

- (void)livenessProcesssWithCode:(LivenessRemindCode)remindCode {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isAnimating = [self.remindAnimationView isActionAnimating];
        if (!self.isAnimating) {
            [self.remindAnimationView hiddenLayer];
        }
    });
    
    switch (remindCode) {
        case LivenessRemindCodeOK: {
            [self warningStatus:CommonStatus warning:@"屏幕即将闪烁请保持正脸"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.remindAnimationView stopActionAnimating];
            });
            [self singleActionSuccess:true];
            break;
        }
        case LivenessRemindCodePitchOutofDownRange:
            [self warningStatus:PoseStatus warning:@"请略微抬头" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodePitchOutofUpRange:
            [self warningStatus:PoseStatus warning:@"请略微低头" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeYawOutofRightRange:
            [self warningStatus:PoseStatus warning:@"请略微向右转头" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeYawOutofLeftRange:
            [self warningStatus:PoseStatus warning:@"请略微向左转头" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodePoorIllumination:
            [self warningStatus:CommonStatus warning:@"请使环境光线再亮些" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeNoFaceDetected:
            [self warningStatus:CommonStatus warning:@"把脸移入框内" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeImageBlured:
            [self warningStatus:PoseStatus warning:@"请握稳手机" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeOcclusionLeftEye:
            [self warningStatus:occlusionStatus warning:@"左眼有遮挡" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeOcclusionRightEye:
            [self warningStatus:occlusionStatus warning:@"右眼有遮挡" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeOcclusionNose:
            [self warningStatus:occlusionStatus warning:@"鼻子有遮挡" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeOcclusionMouth:
            [self warningStatus:occlusionStatus warning:@"嘴巴有遮挡" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeOcclusionLeftContour:
            [self warningStatus:occlusionStatus warning:@"左脸颊有遮挡" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeOcclusionRightContour:
            [self warningStatus:occlusionStatus warning:@"右脸颊有遮挡" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeOcclusionChinCoutour:
            [self warningStatus:occlusionStatus warning:@"下颚有遮挡" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeLeftEyeClosed:
            [self warningStatus:occlusionStatus warning:@"左眼未睁开" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeRightEyeClosed:
            [self warningStatus:occlusionStatus warning:@"右眼未睁开" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeTooClose:
            [self warningStatus:CommonStatus warning:@"请将脸部离远一点" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeTooFar:
            [self warningStatus:CommonStatus warning:@"请将脸部靠近一点" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeBeyondPreviewFrame:
            [self warningStatus:CommonStatus warning:@"把脸移入框内" conditionMeet:false];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeLiveEye:
            [self warningStatus:CommonStatus warning:@"眨眨眼" conditionMeet:true];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeLiveMouth:
            [self warningStatus:CommonStatus warning:@"张张嘴" conditionMeet:true];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeLiveYawRight:
            [self warningStatus:CommonStatus warning:@"向右缓慢转头" conditionMeet:true];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeLiveYawLeft:
            [self warningStatus:CommonStatus warning:@"向左缓慢转头" conditionMeet:true];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeLivePitchUp:
            [self warningStatus:CommonStatus warning:@"缓慢抬头" conditionMeet:true];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeLivePitchDown:
            [self warningStatus:CommonStatus warning:@"缓慢低头" conditionMeet:true];
            [self singleActionSuccess:false];
            break;
        case LivenessRemindCodeSingleLivenessFinished:
        {
            [[SSFaceDetectionManager sharedInstance] livenessProcessHandler:^(float numberOfLiveness, float numberOfSuccess, LivenessActionType currenActionType) {
                NSLog(@"Finished 非常好 %d %d %d", (int)numberOfLiveness, (int)numberOfSuccess, (int)currenActionType);
               dispatch_async(dispatch_get_main_queue(), ^{
                   [self.circleProgressView setPercent:(CGFloat)(numberOfSuccess / numberOfLiveness)];
               });
            }];
            [self warningStatus:CommonStatus warning:@"非常好" conditionMeet:true];
            [self singleActionSuccess:true];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.remindAnimationView stopActionAnimating];
            });
        }
            break;
        case LivenessRemindCodeFaceIdChanged:
        {
            [[SSFaceDetectionManager sharedInstance] livenessProcessHandler:^(float numberOfLiveness, float numberOfSuccess, LivenessActionType currenActionType) {
                NSLog(@"face id changed %d %d %d", (int)numberOfLiveness, (int)numberOfSuccess, (int)currenActionType);
               dispatch_async(dispatch_get_main_queue(), ^{
                   [self.circleProgressView setPercent:0];
               });
            }];
            [self warningStatus:CommonStatus warning:@"把脸移入框内" conditionMeet:true];
        }
            break;
        case LivenessRemindCodeVerifyInitError:
            [self warningStatus:CommonStatus warning:@"验证失败"];
            break;
        case LivenessRemindActionCodeTimeout:{
            [[SSFaceDetectionManager sharedInstance] livenessProcessHandler:^(float numberOfLiveness, float numberOfSuccess, LivenessActionType currenActionType) {
                NSLog(@"动作超时 %d %d %d", (int)numberOfLiveness, (int)numberOfSuccess, (int)currenActionType);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.remindAnimationView startActionAnimating:(int)currenActionType];
                });
            }];
            break;
        }
        case LivenessRemindCodeConditionMeet: {
        }
            break;
        default:
            break;
    }
}

- (void)colorfulProcesssWithCode:(ColorRemindCode)code imageInfo:(NSDictionary *)images {
    __weak typeof(self) weakSelf = self;
    
    switch (code) {
       case ColorRemindCodeOK: {
           [weakSelf singleActionSuccess:true];
           break;
       }
       
        case ColorRemindCodeSuccess:{
            [weakSelf warningStatus:CommonStatus warning:@"人脸采集成功" conditionMeet:true];
            [[BDFaceImageShow sharedInstance] setAuraLiveColor:@"人脸采集成功"];
            [[BDFaceImageShow sharedInstance] setColorliveScore:[images[@"score"] floatValue]];
            [[BDFaceImageShow sharedInstance] setColorMatchNum:[images[@"num"] intValue]];
            [weakSelf singleActionSuccess:false];
            self.resultDic = images;
            break;
        }
        case ColorRemindCodeColorMatchFailed:
            [weakSelf warningStatus:CommonStatus warning:@"人脸采集失败" conditionMeet:true];
            [[BDFaceImageShow sharedInstance] setAuraLiveColor:@"颜色人脸采集失败"];
            [[BDFaceImageShow sharedInstance] setColorliveScore:[images[@"score"] floatValue]];
            [[BDFaceImageShow sharedInstance] setColorMatchNum:[images[@"num"] intValue]];
            [weakSelf singleActionSuccess:false];
            self.resultDic = images;
            if (images[@"originalImageStr"] != nil) {
                NSData * imageData =  [[NSData alloc] initWithBase64EncodedString:images[@"originalImageStr"] options:NSDataBase64Encoding64CharacterLineLength];
                self.iconImage = [UIImage imageWithData:imageData];
            }

            break;
        case ColorRemindCodeScoreFailed:
            [weakSelf warningStatus:CommonStatus warning:@"人脸采集失败" conditionMeet:true];
            [[BDFaceImageShow sharedInstance] setAuraLiveColor:@"颜色人脸采集失败"];
            [[BDFaceImageShow sharedInstance] setColorliveScore:[images[@"score"] floatValue]];
            [[BDFaceImageShow sharedInstance] setColorMatchNum:[images[@"num"] intValue]];
            [weakSelf singleActionSuccess:false];
            self.resultDic = images;
            break;
        case ColorRemindCodeBreak:{
            [weakSelf warningStatus:CommonStatus warning:@"请调整人脸" conditionMeet:true];
            [weakSelf changeColorWhite];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.remindAnimationView stopActionAnimating];
            });
            [weakSelf singleActionSuccess:false];
            break;
        }
        case ColorRemindCodeComplete:{
            weakSelf.colorFinshed = YES;
            [weakSelf warningStatus:PoseStatus warning:@"ColorRemindCodeComplete"];
            [weakSelf singleActionSuccess:false];
            
            break;
        }
        case ColorRemindCodeChangeColor:
            [weakSelf warningStatus:changeColorStatus warning:@"变光中,请保持正脸"];
            [weakSelf colorCircleExpand:images[@"color"]];
            [weakSelf singleActionSuccess:false];
            break;
       case ColorRemindCodePitchOutofDownRange:
           [weakSelf warningStatus:PoseStatus warning:@"请略微抬头"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodePitchOutofUpRange:
           [weakSelf warningStatus:PoseStatus warning:@"请略微低头"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodeYawOutofLeftRange:
           [weakSelf warningStatus:PoseStatus warning:@"请略微向右转头"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodeYawOutofRightRange:
           [weakSelf warningStatus:PoseStatus warning:@"请略微向左转头"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodePoorIllumination:
           [weakSelf warningStatus:CommonStatus warning:@"请使环境光线再亮些"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodeNoFaceDetected:
            [weakSelf resertAction];
            [weakSelf removeSublayer];
            [weakSelf warningStatus:CommonStatus warning:@"把脸移入框内"];
            [weakSelf singleActionSuccess:false];
            break;
        case ColorRemindCodeFaceIdChanged:
            [weakSelf resertAction];
            [weakSelf removeSublayer];
            [weakSelf warningStatus:CommonStatus warning:@"把脸移入框内"];
            [weakSelf singleActionSuccess:false];
            break;
       case ColorRemindCodeImageBlured:
           [weakSelf warningStatus:PoseStatus warning:@"请握稳手机"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodeOcclusionLeftEye:
           [weakSelf warningStatus:occlusionStatus warning:@"左眼有遮挡"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodeOcclusionRightEye:
           [weakSelf warningStatus:occlusionStatus warning:@"右眼有遮挡"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodeOcclusionNose:
           [weakSelf warningStatus:occlusionStatus warning:@"鼻子有遮挡"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodeOcclusionMouth:
           [weakSelf warningStatus:occlusionStatus warning:@"嘴巴有遮挡"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodeOcclusionLeftContour:
           [weakSelf warningStatus:occlusionStatus warning:@"左脸颊有遮挡"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodeOcclusionRightContour:
           [weakSelf warningStatus:occlusionStatus warning:@"右脸颊有遮挡"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodeOcclusionChinCoutour:
           [weakSelf warningStatus:occlusionStatus warning:@"下颚有遮挡"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodeTooClose:
           [weakSelf warningStatus:CommonStatus warning:@"请将脸部离远一点"];
           [weakSelf singleActionSuccess:false];
           break;
       case ColorRemindCodeTooFar:
           [weakSelf warningStatus:CommonStatus warning:@"请将脸部靠近一点"];
           [weakSelf singleActionSuccess:false];
           break;
        case ColorRemindCodeBeyondPreviewFrame:{
            [weakSelf resertAction];
            [weakSelf removeSublayer];
           [weakSelf warningStatus:CommonStatus warning:@"把脸移入框内"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.remindAnimationView stopActionAnimating];
            });
           [weakSelf singleActionSuccess:false];
           break;
        }
       case ColorRemindCodeVerifyInitError:
           [weakSelf warningStatus:CommonStatus warning:@"验证失败"];
           break;
           break;
       default:
           break;
   }
}


- (void)faceCallbackWithCode:(BDFaceCompletionStatus)status result:(NSDictionary *)result {
//    NSLog(@">>>>>>> call back status:%ld, result:%@", (long)status, result);
    __weak typeof(self) weakSelf = self;
    if (status == BDFaceCompletionStatusCameraStarted) {
        if ([FaceSDKManager sharedInstance].recordAbility) {
            [self.detectionManager startRecordingVideo];
        }
    } else if (status == BDFaceCompletionStatusSuccess) {
    /*
     兼哥在此做操作，"result"是返回结果
     */
        // 私有化配置，从这里拿到人脸和相关数据，并传递到下个页面
        NSString *imageString = result[@"data"];
        NSData * imageData = [imageString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *imageDataDic = [NSJSONSerialization JSONObjectWithData:imageData options:NSJSONReadingMutableLeaves error:nil];
        imageString = imageDataDic[@"data"];
        NSString *sKey = result[@"skey"];
        NSString *deviceId = result[@"x-device-id"];
        self.resultDic = [NSMutableDictionary dictionaryWithDictionary:self.resultDic];
        [self.resultDic setValue:imageString forKey:@"image_string"];
        [self.resultDic setValue:sKey forKey:@"skey"];
        [self.resultDic setValue:deviceId forKey:@"device_id"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:true completion:^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(getFaceImg:)]) {
                    [weakSelf.delegate getFaceImg:weakSelf.iconImage];
                }
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(completeWithImageString:skey:deviceId:)]) {
                    [weakSelf.delegate completeWithImageString:imageString skey:sKey deviceId:deviceId];
                }
                
                if (weakSelf.type == 1){
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"FaceResultNoti" object:self.resultDic];
                }else if (weakSelf.type == 2) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"certiFaceResult" object:self.resultDic];
                }
                
            }];
        });
        
//        [self persentToVc:self.resultDic success:YES];

    } else if (status == BDFaceCompletionStatusVideoRecordingFail || status == BDFaceCompletionStatusColorMatchFailed) {
        
        [self persentToVc:self.resultDic success:NO];
        
    } else if (status == BDFaceCompletionStatusTimeout) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.circleProgressView setPercent:0];
            [self isTimeOut:YES];
        });

    } else if (status < 0) {
        NSLog(@">>>>>>> call back status < 0:%ld, result:%@", (long)status, result);
    }
}

-(void)resertAction{
    NSNumber *LiveMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"LiveMode"];
    self.isliveness = LiveMode.boolValue;
   
    [[SSFaceDetectionManager sharedInstance] livenesswithList:_livenessArray order:_order numberOfLiveness:_numberOfLiveness];
}
/*
 获取当前时间戳，并且输出对应时间
 */
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time1=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time1];
    NSTimeInterval time=[timeString doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

- (void)colorCircleExpand:(UIColor *)color{
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:self.circleRect];
    CGFloat radius = [self radiusOfBubbleInView:self.view startPoint:CGPointMake(CGRectGetMidX(self.circleRect), CGRectGetMidY(self.circleRect))];
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.circleRect, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.bounds = self.view.layer.bounds;
    maskLayer.position = self.view.layer.position;
    maskLayer.fillColor = color.CGColor;
    [self.maskView.layer addSublayer:maskLayer];
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = 0.5f;
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.autoreverses = NO;
    animation.duration = 0.25f;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    animation.toValue = (__bridge id _Nullable)(color.CGColor);
    [maskLayer addAnimation:animation forKey:@"keyPath_backgroundColor"];
}
//遍历view的四个角 获取最长的半径
-(CGFloat)radiusOfBubbleInView:(UIView*)view startPoint:(CGPoint)startPoint{
    
    //获取四个角所在的点
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(view.bounds.size.width, 0);
    CGPoint point3 = CGPointMake(0, view.bounds.size.height);
    CGPoint point4 = CGPointMake(view.bounds.size.width, view.bounds.size.height);
    NSArray *pointArrar = @[[NSValue valueWithCGPoint:point1], [NSValue valueWithCGPoint:point2], [NSValue valueWithCGPoint:point3], [NSValue valueWithCGPoint:point4]];
    //做一个冒泡排序获得最长的半径
    CGFloat radius = 0;
    for (NSValue *value in pointArrar) {
        CGPoint point = [value CGPointValue];
        CGFloat apartX = point.x - startPoint.x;
        CGFloat apartY = point.y - startPoint.y;
        CGFloat realRadius = sqrt(apartX*apartX + apartY*apartY);
        if (radius <= realRadius) {
            radius = realRadius;
        }
    }
    return radius;
}
- (void)warningStatus:(WarningStatus)status warning:(NSString *)warning conditionMeet:(BOOL)meet{
    [self warningStatus:status warning:warning];
}
/*
 移除当前view上的颜色动画
 */
-(void)changeColorWhite{
    [self colorCircleExpand:UIColorFromRGB(0xF0F1F2)];
}
-(void)removeSublayer{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.maskView.backgroundColor = UIColorFromRGB(0xF0F1F2);
        NSArray<CALayer *> *subLayers = self.maskView.layer.sublayers;
        NSArray<CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *, id> * _Nullable bindings) {
            return [evaluatedObject isKindOfClass:[CAShapeLayer class]];
        }]];
        [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperlayer];
        }];
    });
    
}
-(void) persentToVc:(NSDictionary *) dic success:(BOOL)success {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController* fatherViewController = self.presentingViewController;
        [self dismissViewControllerAnimated:YES completion:^{
            BDFaceSuccessViewController *avc = [[BDFaceSuccessViewController alloc] init];
            avc.modalPresentationStyle = UIModalPresentationFullScreen;
            avc.sendDic = dic;
            avc.success = success;
            [fatherViewController presentViewController:avc animated:YES completion:nil];
            [self closeAction];
        }];
        
    });
}
- (void)selfReplayFunction{
    NSNumber *LiveMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"LiveMode"];
    self.isliveness = LiveMode.boolValue;
    [[SSFaceDetectionManager sharedInstance] livenesswithList:_livenessArray order:_order numberOfLiveness:_numberOfLiveness];
    [self faceColorfulLiveness];
}

@end
