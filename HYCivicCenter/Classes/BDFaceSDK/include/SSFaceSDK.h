//
//  IDLFaceSDK.h
//  IDLFaceSDK
//
//  Created by Tong,Shasha on 2017/5/15.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>


#define ATTR_VISIBILITY __attribute__((visibility("default")))
//
///**
// * 活体检测的类型
// */
typedef NS_ENUM(NSInteger, LivenessActionType) {
    LivenessActionTypeLiveEye = 0,
    LivenessActionTypeLiveMouth = 1,
    LivenessActionTypeLiveYawRight = 2,
    LivenessActionTypeLiveYawLeft = 3,
    LivenessActionTypeLivePitchUp = 4,
    LivenessActionTypeLivePitchDown = 5,
    LivenessActionTypeLiveYaw = 6,
    LivenessActionTypeNoAction = 7,
};

///**
// * 活体检测的返回状态
// */
typedef NS_ENUM(NSUInteger, LivenessRemindCode) {
    LivenessRemindCodeOK = 0,   //成功
    LivenessRemindCodeBeyondPreviewFrame,    //出框
    LivenessRemindCodeNoFaceDetected, //没有检测到人脸
    LivenessRemindCodeMuchIllumination,
    LivenessRemindCodePoorIllumination,   //光照不足
    LivenessRemindCodeImageBlured,    //图像模糊
    LivenessRemindCodeTooFar,    //太远
    LivenessRemindCodeTooClose,  //太近
    LivenessRemindCodePitchOutofDownRange,    //头部偏低
    LivenessRemindCodePitchOutofUpRange,  //头部偏高
    LivenessRemindCodeYawOutofLeftRange,  //头部偏左
    LivenessRemindCodeYawOutofRightRange, //头部偏右
    LivenessRemindCodeOcclusionLeftEye,   //左眼有遮挡
    LivenessRemindCodeOcclusionRightEye,  //右眼有遮挡
    LivenessRemindCodeOcclusionNose, //鼻子有遮挡
    LivenessRemindCodeOcclusionMouth,    //嘴巴有遮挡
    LivenessRemindCodeOcclusionLeftContour,  //左脸颊有遮挡
    LivenessRemindCodeOcclusionRightContour, //右脸颊有遮挡
    LivenessRemindCodeOcclusionChinCoutour,  //下颚有遮挡
    LivenessRemindCodeTimeout,  //超时
    LivenessRemindCodeLiveEye,   //眨眨眼
    LivenessRemindCodeLiveMouth, //张大嘴
    LivenessRemindCodeLiveYawLeft,   //向右摇头
    LivenessRemindCodeLiveYawRight,  //向左摇头
    LivenessRemindCodeLivePitchUp,   //向上抬头
    LivenessRemindCodeLivePitchDown, //向下低头
    LivenessRemindCodeLiveYaw,   //摇摇头
    LivenessRemindCodeSingleLivenessFinished,    //完成一个活体动作
    LivenessRemindActionCodeTimeout, // 当前活体动作超时
    LivenessRemindCodeLeftEyeClosed,
    LivenessRemindCodeRightEyeClosed,
    LivenessRemindCodeVerifyInitError,          //鉴权失败
//    LivenessRemindCodeVerifyDecryptError,
//    LivenessRemindCodeVerifyInfoFormatError,
//    LivenessRemindCodeVerifyExpired,
//    LivenessRemindCodeVerifyMissRequiredInfo,
//    LivenessRemindCodeVerifyInfoCheckError,
//    LivenessRemindCodeVerifyLocalFileError,
//    LivenessRemindCodeVerifyRemoteDataError,
    LivenessRemindCodeConditionMeet,
    LivenessRemindCodeFaceIdChanged,    // faceid 发生变化
    LivenessRemindCodeDataHitOne
//    LivenessRemindCodeDataHitLast,
};


///**
// * 人脸探测的返回状态
// */
typedef NS_ENUM(NSUInteger, DetectRemindCode) {
    DetectRemindCodeOK = 0, //成功
    DetectRemindCodeBeyondPreviewFrame,    //出框
    DetectRemindCodeNoFaceDetected, //没有检测到人脸
    DetectRemindCodeMuchIllumination,
    DetectRemindCodePoorIllumination,   //光照不足
    DetectRemindCodeImageBlured,    //图像模糊
    DetectRemindCodeTooFar,    //太远
    DetectRemindCodeTooClose,  //太近
    DetectRemindCodePitchOutofDownRange,    //头部偏低
    DetectRemindCodePitchOutofUpRange,  //头部偏高
    DetectRemindCodeYawOutofLeftRange,  //头部偏左
    DetectRemindCodeYawOutofRightRange, //头部偏右
    DetectRemindCodeOcclusionLeftEye,   //左眼有遮挡
    DetectRemindCodeOcclusionRightEye,  //右眼有遮挡
    DetectRemindCodeOcclusionNose, //鼻子有遮挡
    DetectRemindCodeOcclusionMouth,    //嘴巴有遮挡
    DetectRemindCodeOcclusionLeftContour,  //左脸颊有遮挡
    DetectRemindCodeOcclusionRightContour, //右脸颊有遮挡
    DetectRemindCodeOcclusionChinCoutour,  //下颚有遮挡
    DetectRemindCodeTimeout,   //超时
    DetectRemindCodeVerifyInitError,          //鉴权失败
//    DetectRemindCodeVerifyDecryptError,
//    DetectRemindCodeVerifyInfoFormatError,
//    DetectRemindCodeVerifyExpired,
//    DetectRemindCodeVerifyMissRequiredInfo,
//    DetectRemindCodeVerifyInfoCheckError,
//    DetectRemindCodeVerifyLocalFileError,
//    DetectRemindCodeVerifyRemoteDataError,
//    DetectRemindCodeDataHitLast
    DetectRemindCodeConditionMeet,
    DetectRemindCodeDataHitOne
};
//
//
///**
// * 人脸探测的跟踪状态
// */
typedef NS_ENUM(NSUInteger, TrackDetectRemindCode) {
    TrackDetectRemindCodeOK = 0, //成功
    TrackDetectRemindCodeImageBlured, //图像模糊
    TrackDetectRemindCodePoorIllumination, // 光照不足
    TrackDetectRemindCodeNoFaceDetected, //没有检测到人脸
    TrackDetectRemindCodeOcclusionLeftEye,   //左眼有遮挡
    TrackDetectRemindCodeOcclusionRightEye,  //右眼有遮挡
    TrackDetectRemindCodeOcclusionNose, //鼻子有遮挡
    TrackDetectRemindCodeOcclusionMouth,    //嘴巴有遮挡
    TrackDetectRemindCodeOcclusionLeftContour,  //左脸颊有遮挡
    TrackDetectRemindCodeOcclusionRightContour, //右脸颊有遮挡
    TrackDetectRemindCodeOcclusionChinCoutour,  //下颚有遮挡
    TrackDetectRemindCodeTooClose,  //太近
    TrackDetectRemindCodeTooFar,    //太远
    TrackDetectRemindCodeBeyondPreviewFrame   //出框
    
};


typedef NS_ENUM(NSUInteger, ColorRemindCode) {
    ColorRemindCodeOK = 0, //成功
    ColorRemindCodeBeyondPreviewFrame,    //出框
    ColorRemindCodeNoFaceDetected, //没有检测到人脸
    ColorRemindCodeMuchIllumination,
    ColorRemindCodePoorIllumination,   //光照不足
    ColorRemindCodeImageBlured,    //图像模糊
    ColorRemindCodeTooFar,    //太远
    ColorRemindCodeTooClose,  //太近
    ColorRemindCodePitchOutofDownRange,    //头部偏低
    ColorRemindCodePitchOutofUpRange,  //头部偏高
    ColorRemindCodeYawOutofLeftRange,  //头部偏左
    ColorRemindCodeYawOutofRightRange, //头部偏右
    ColorRemindCodeOcclusionLeftEye,   //左眼有遮挡
    ColorRemindCodeOcclusionRightEye,  //右眼有遮挡
    ColorRemindCodeOcclusionNose, //鼻子有遮挡
    ColorRemindCodeOcclusionMouth,    //嘴巴有遮挡
    ColorRemindCodeOcclusionLeftContour,  //左脸颊有遮挡
    ColorRemindCodeOcclusionRightContour, //右脸颊有遮挡
    ColorRemindCodeOcclusionChinCoutour,  //下颚有遮挡
    ColorRemindCodeTimeout,   //超时
    ColorRemindCodeVerifyInitError,          //鉴权失败
    ColorRemindCodeConditionMeet,
    ColorRemindCodeDataHitOne,
    ColorRemindCodeSuccess, //炫彩活体采集成功
    ColorRemindCodeColorMatchFailed, //炫彩活体采集失败
    ColorRemindCodeScoreFailed, //炫彩活体采集失败
    ColorRemindCodeBreak, //炫彩中途失败，由于当前颜色没有拿到质量满足的图片
    ColorRemindCodeComplete, //炫彩活体完成
    ColorRemindCodeChangeColor,
    ColorRemindCodeFaceIdChanged   // faceid 发生变化
};

/**
 * 证件类型
 */
typedef NSString *FaceIdCardType NS_STRING_ENUM;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceIdCardType const KFaceIdCardTypeDefault; // 默认 大陆身份证
FOUNDATION_EXPORT ATTR_VISIBILITY FaceIdCardType const KFaceIdCardTypeMTPIDCard; // 港澳居民来往内地通行证
FOUNDATION_EXPORT ATTR_VISIBILITY FaceIdCardType const KFaceIdCardTypeFPRIDCard; // 外国人永久居留身份证
FOUNDATION_EXPORT ATTR_VISIBILITY FaceIdCardType const KFaceIdCardTypePassport; // 定居国外的中国公民护照

/**
 * 活体控制
 */
typedef NSString *FaceLivenessControlType NS_STRING_ENUM;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceLivenessControlType const FaceLivenessControlTypeNone;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceLivenessControlType const FaceLivenessControlTypeLow;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceLivenessControlType const FaceLivenessControlTypeNormal;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceLivenessControlType const FaceLivenessControlTypeHeight;

/**
 * 合成图控制
 */
typedef NSString *FaceSpoofingControlType NS_STRING_ENUM;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceSpoofingControlType const FaceSpoofingControlTypeNone;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceSpoofingControlType const FaceSpoofingControlTypeLow;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceSpoofingControlType const FaceSpoofingControlTypeNormal;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceSpoofingControlType const FaceSpoofingControlTypeHeight;

/**
 * 质量控制
 */
typedef NSString *FaceQualityControlType NS_STRING_ENUM;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceQualityControlType const FaceQualityControlTypeNone;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceQualityControlType const FaceQualityControlTypeLow;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceQualityControlType const FaceQualityControlTypeNormal;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceQualityControlType const FaceQualityControlTypeHeight;

/**
 * 上传图片信息类型
 */
typedef NSString *FaceRegisterImageType NS_STRING_ENUM;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceRegisterImageType const FaceRegisterImageTypeBase64;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceRegisterImageType const FaceRegisterImageTypeURL;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceRegisterImageType const FaceRegisterImageTypeFaceToken;

/**
 * 人脸图片类型
 */
typedef NSString *FaceFaceType NS_STRING_ENUM;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceFaceType const FaceFaceTypeLive;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceFaceType const FaceFaceTypeIDCard;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceFaceType const FaceFaceTypeWaterMark;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceFaceType const FaceFaceTypeCert;
FOUNDATION_EXPORT ATTR_VISIBILITY FaceFaceType const FaceFaceTypeInfred;

/**
 * 人脸检测排序类型
 */
typedef NS_ENUM(NSInteger, FaceSortype) {
    FaceSortypeAreaFromBigToSmall = 0,
    FaceSortypeDistanceNearToFar = 1
};

/**
 * 人脸采集结果参与业务流程
 */
typedef NS_ENUM(NSInteger, BDFaceResultReportType) {
    BDFaceResultReportTypeVerifySec = 1, // 实名认证
    BDFaceResultReportTypeMatchSec = 2,  // 人脸对比
};

/**
 * 人脸校验流程
 */
typedef NS_ENUM(NSInteger, BDFaceFlowType) {
    BDFaceDetectionTypeDetection = 1,
    BDFaceDetectionTypeLiveness = 2,
    BDFaceDetectionTypeVideoRecording = 3,
    BDFaceDetectionTypeColorfulLiveness = 5,
};

/**
 * 返回图片类型
 */
typedef NS_ENUM(NSInteger, BDFaceOutputImageType) {
    BDFaceOutputImageTypeCrop = 1,
    BDFaceOutputImageTypeOrigin = 2
};

#import "FaceSDKManager.h"
#import "SSFaceDetectionManager.h"
