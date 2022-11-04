#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DigitalcitizenViewController.h"
#import "FaceParameterConfig.h"
#import "FaceSDKManager.h"
#import "FaceSSDKLib.h"
#import "HYCivicCenterCommand.h"
#import "HYGovernmentViewController.h"
#import "HYHandleAffairsViewController.h"
#import "HYNavigationController.h"
#import "MainApi.h"
#import "SSDKLib.h"
#import "SSFaceDetectionManager.h"
#import "SSFaceSDK.h"
#import "YSNCNavigationController.h"
#import "YSNCNavView.h"
#import "YSNCViewController.h"

FOUNDATION_EXPORT double HYCivicCenterVersionNumber;
FOUNDATION_EXPORT const unsigned char HYCivicCenterVersionString[];

