//
//  SSFaceVideoCaptureDevice.h
//  SSDKLib
//
//  Created by Gong,Jialiang on 2021/4/27.
//  Copyright © 2021 bang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SSFaceSDK.h"

/**
 * 流程返回结果类型
 */
typedef NS_ENUM(NSInteger, BDFaceCompletionStatus) {
    BDFaceCompletionStatusSuccess = 1,  // 成功
    BDFaceCompletionStatusNoRisk = 2,   // 无风险
    BDFaceCompletionStatusImagesSuccess = 3, // 图像采集成功
    BDFaceCompletionStatusCameraStarted = 4, // 相机开始
    
    BDFaceCompletionStatusIsRunning = -1,   // 正在采集图像
    BDFaceCompletionStatusResultFail = -2,  // 云端服务执行失败
    BDFaceCompletionStatusIsRiskDevice = -3,    // 风险设备
    BDFaceCompletionStatusCameraError = -5,    // 没有授权镜头
    BDFaceCompletionStatusTimeout = -6, // 超时
    BDFaceCompletionStatusCancel = -7, // 取消
    BDFaceCompletionStatusVideoRecordingFail = -8, // 视频录制错误
    BDFaceCompletionStatusColorMatchFailed = -9, // 炫彩色彩错误
    BDFaceCompletionStatusVideoColorScoreFailed = -10, // 炫彩分数错误
    BDFaceCompletionStatusSDKNotInit = -13, // SDK未初始化
    BDFaceCompletionStatusLicenseFail = -15, // 授权错误
    BDFaceCompletionStatusNetworkError = -16,    // 网络错误
};

/**
 * 活体检测过程中，返回活体总数，当前成功个数，当前活体类型
 */
typedef void (^LivenessProcess) (float numberOfLiveness, float numberOfSuccess, LivenessActionType currenActionType);


@protocol SSCaptureDataOutputProtocol <NSObject>

// 帧图像回传，用于刷新UI使用
- (void)captureOutputSampleBuffer:(UIImage *)image;

// 本次人脸流程回调
- (void)faceSessionCompletionWithStatus:(BDFaceCompletionStatus)status result:(NSDictionary *)result;

// 活体检测状态
- (void)livenessActionDidFinishWithCode:(LivenessRemindCode)code;

// 人脸识别检测
- (void)detectionActionDidFinishWithCode:(DetectRemindCode)code;

// 人脸识别检测
- (void)colorfulActionDidFinishWithCode:(ColorRemindCode)code imageInfo:(NSDictionary *)imageInfo;

@end

__attribute__((visibility("default")))
@interface SSFaceDetectionManager : NSObject

// 图像返回帧处理代理
@property (nonatomic, weak) id<SSCaptureDataOutputProtocol> delegate;

// 采集流程运行状态
@property (nonatomic, assign, readonly) BOOL runningStatus;

// 风险检测超时时间，默认3秒
@property (nonatomic, assign) NSInteger riskDetectionSetting;

// AVCaptureSessionPreset类型枚举，支持低版本所以使用NSString
@property (nonatomic, copy) NSString *sessionPresent;

// 采集图像区域
@property (nonatomic, assign) CGRect previewRect;

// 探测区域
@property (nonatomic, assign) CGRect detectRect;

// 是否开启声音提醒
@property (nonatomic, assign) BOOL enableSound;

// 返回图片类型
@property (nonatomic, assign) BDFaceOutputImageType outputImageType;

// BDFaceDetectionTypeColorfulLiveness流程中是否开启动作活体
@property (nonatomic, assign) BOOL enableLivenessInColorfulFlow;


+ (instancetype)sharedInstance;

- (void)connectPreviewLayer:(AVCaptureVideoPreviewLayer*)pLayer;
/**
 * 创建用于实名认证的参数
 */
- (NSDictionary *)creatFaceVerifyParameters:(NSString *)idCardNumber
                                       name:(NSString *)name
                                 verifyType:(FaceIdCardType)cardType
                                     nation:(NSString *)nation
                                phoneNumber:(NSString *)phoneNumber
                            livenessControl:(FaceLivenessControlType)livenessControl
                            spoofingControl:(FaceSpoofingControlType)spoofingControl
                             qualityControl:(FaceQualityControlType)qualityControl;

/**
 * 创建用于人脸比对的参数
 */
- (NSDictionary *)createFaceMatchParametersWithRegisterImage:(NSString *)registerImageBase64
                                           registerImageType:(FaceRegisterImageType)registerImageType
                                            registerFaceType:(FaceFaceType)registerFaceType
                                                    faceType:(FaceFaceType)faceType
                                                faceSortType:(FaceSortype)faceSortType
                                                 phoneNumber:(NSString *)phoneNumber
                                             livenessControl:(FaceLivenessControlType)livenessControl
                                              qualityControl:(FaceQualityControlType)qualityControl
                                     registerLivenessControl:(FaceLivenessControlType)registerLivenessControl
                                      registerQualityControl:(FaceQualityControlType)registerQualityControl;

/**
 * 创建用于视频录制的参数
 */
- (NSDictionary *)createVideoRecordParametersWithEnableVideoRecording:(BOOL)enableVideoRecording
                                                     enableVideoSound:(BOOL)enableVideoSound
                                                        videoFileName:(NSString *)videoFileName
                                                           imageWidth:(NSUInteger)imageWidth
                                                          imageHeight:(NSUInteger)imageHeight;
/**
 * 开始当前人脸校验流程
 * @param detectionType 业务流程，采集信息用于实名认证、人脸比对
 * @param parameters 流程需要的参数
 * @param flowType 操作流程，人脸采集、人脸活体
 * @param vc 用于进行人脸信息采集的ViewController
 */
- (void)startSessionWithType:(BDFaceResultReportType)detectionType
                  parameters:(NSDictionary *)parameters
                    faceFlow:(BDFaceFlowType)flowType
              viewController:(UIViewController *)vc;


/**
 * 开始当前人脸校验流程，供视频录制时传入参数使用
 * @param detectionType 业务流程，采集信息用于实名认证、人脸比对
 * @param parameters 流程需要的参数
 * @param flowType 操作流程，人脸采集、人脸活体
 * @param vc 用于进行人脸信息采集的ViewController
 * @param videoParameters 需要录制视频的参数
 * @param cameraAutoClose 镜头是否自动关闭
 */
- (void)startSessionWithType:(BDFaceResultReportType)detectionType
                  parameters:(NSDictionary *)parameters
                    faceFlow:(BDFaceFlowType)flowType
              viewController:(UIViewController *)vc
             videoParameters:(NSDictionary *)videoParameters
             cameraAutoClose:(BOOL)cameraAutoClose;

/**
 * 取消当前人脸校验流程
 */
- (void)cancel;

/**
 * 开始视频录制，请与BDFaceCompletionStatusCameraStarted回调后调用
 */
- (void)startRecordingVideo;

/**
 * 结束当前录制，活体验证session流程结束时自动结束，不需要主动调用；BDFaceDetectionTypeVideoRecording 时主动调用
 */
- (void)stopRecordingVideo;

/**
 * 取消录制
 */
- (void)cancelRecording;

/**
 * 活体检测过程中，返回活体总数，当前成功个数，当前活体类型
 */
-(void)livenessProcessHandler:(LivenessProcess)process;

/**
 * 返回无黑边的方法
 * @param array 活体动作数组
 * @param order 是否顺序执行
 * @param numberOfLiveness 活体动作个数
 */
- (void)livenesswithList:(NSArray *)array order:(BOOL)order numberOfLiveness:(NSInteger)numberOfLiveness;


@end





