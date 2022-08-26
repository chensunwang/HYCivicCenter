//
//  BDFaceBaseViewController.h
//  FaceSDKSample_IOS
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDFaceCircleView.h"
#import "BDFaceCycleProgressView.h"
#import "BDFaceRemindAnimationView.h"
#import "SSFaceSDK.h"

typedef enum : NSUInteger {
    CommonStatus,
    PoseStatus,
    occlusionStatus,
    changeColorStatus
} WarningStatus;

@interface BDFaceBaseViewController : UIViewController

@property (nonatomic, readwrite, assign) BOOL hasFinished;
/**
 *  视频i流回显view
 */
@property (nonatomic, readwrite, retain) UIImageView *displayImageView;

/**
 * 人脸检测view，与视频流rect 一致
 */
@property (nonatomic, readwrite, assign) CGRect previewRect;

/**
 *  人脸预览view ，最大预览框之内，最小预览框之外，根据该view 提示离远离近
 */

@property (nonatomic, readwrite, assign) CGRect detectRect;

/**
 *  圆形遮罩view大小
 */

@property (nonatomic, readwrite, assign) CGRect circleRect;
/**
 *  超时弹出view
 */
@property (nonatomic, readwrite, retain) UIView *timeOutView;

/**
 *  进度条view，活体检测页面
 */
@property (nonatomic, readwrite, retain) BDFaceCycleProgressView *circleProgressView;

/*
 *  动作活体动画
 */
@property (nonatomic,readwrite,retain) BDFaceRemindAnimationView *remindAnimationView;

/*
 *  采集界面遮挡view
 */
@property (nonatomic, strong) UIView * maskView;

@property (nonatomic, readwrite, retain) SSFaceDetectionManager *detectionManager;


- (void)isTimeOut:(BOOL)isOrNot;

- (void)selfReplayFunction; // 重新开始

- (void)faceProcesss:(UIImage *)image;

- (void)closeAction;

- (void)onAppWillResignAction;
- (void)onAppBecomeActive;

- (void)warningStatus:(WarningStatus)status warning:(NSString *)warning;
- (void)singleActionSuccess:(BOOL)success;

- (UIImageView *)creatRectangle:(UIImageView *)imageView withRect:(CGRect) rect withcolor:(UIColor *)color;

@end
