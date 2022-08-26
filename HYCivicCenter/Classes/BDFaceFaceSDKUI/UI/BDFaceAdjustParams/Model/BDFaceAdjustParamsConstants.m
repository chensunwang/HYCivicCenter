//
//  BDFaceAdjustParamsConstants.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParamsConstants.h"

NSString *const BDFaceAjustParamsPageTitle = @"质量控制设置";
NSString *const BDFaceAjustParamsNormalPageTitle = @"正常参数配置";
NSString *const BDFaceAjustParamsLoosePageTitle = @"宽松参数配置";
NSString *const BDFaceAjustParamsStrictPageTitle = @"严格参数配置";


NSString *const minLightIntensityKey = @"minIllum";
NSString *const maxLightIntensityKey = @"maxIllum";
NSString *const ambiguityKey = @"blur";

NSString *const leftEyeOcclusionKey = @"leftEyeOcclusion";
NSString *const rightEyeOcclusionKey = @"rightEyeOcclusion";
NSString *const noseOcclusionKey = @"noseOcclusion";
NSString *const mouthOcclusionKey = @"mouseOcclusion";
NSString *const leftFaceOcclusionKey = @"leftContourOcclusion";
NSString *const rightFaceOcclusionKey = @"rightContourOcclusion";
NSString *const lowerJawOcclusionKey = @"chinOcclusion";

NSString *const upAndDownAngleKey = @"pitch";
NSString *const leftAndRightAngleKey = @"yaw";
NSString *const spinAngleKey = @"roll";


float const BDFaceAdjustConfigTableCornerRadius = 10.0f;
float const BDFaceAdjustConfigTableMargin = 20.0f;

float const BDFaceAdjustConfigContentTitleFontSize = 16.0f;
float const BDFaceAdjustConfigControllerTitleFontSize = 20.0f;

UInt32 const BDFaceAdjustConfigTipTextColor = 0x171D24;
UInt32 const BDFaceAdjustParamsSeperatorColor = 0xE0E0E0;
UInt32 const BDFaceAdjustParamsTableBackgroundColor = 0xF9F9F9;

NSString *const BDFaceAdjustParamsUserDidFinishSavedConfigNotification = @"BDFaceAdjustParamsUserDidFinishSavedConfigNotification";

NSString *const BDFaceAdjustParamsControllerConfigDidChangeNotification = @"BDFaceAdjustParamsControllerConfigDidChangeNotification";
NSString *const BDFaceAdjustParamsControllerConfigIsSameKey = @"BDFaceAdjustParamsControllerConfigDidChangeNotification";

UInt32 const BDFaceAdjustParamsRecoverActiveTextColor = 0x00BAF2;
UInt32 const BDFaceAdjustParamsRecoverUnactiveTextColor = 0xDCDDE0;

NSString *const BDFaceAdjustParamsRecoverActiveTextColorNew = @"0xFF0080FF";
NSString *const BDFaceAdjustParamsRecoverUnactiveTextColorNew = @"0x4D0080FF";

extern

@implementation BDFaceAdjustParamsConstants

@end
