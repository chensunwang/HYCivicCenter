//
//  HYCivicCenterCommand.h
//  HYCivicCenter
//
//  Created by 谌孙望 on 2022/8/29.
//

#ifndef HYCivicCenterCommand_h
#define HYCivicCenterCommand_h

#import "Masonry/Masonry.h"
#import "AFNetworking/AFNetworking.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SDWebImage/SDImageCache.h"
#import "SDWebImage/SDWebImageManager.h"
#import "MJRefresh/MJRefresh.h"
#import "MJExtension/MJExtension.h"
#import "TZImagePickerController/TZImageManager.h"
#import "TZImagePickerController/TZImagePickerController.h"
#import "MainApi.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "HYSystemInfo.h"
#import "NSString+Category.h"
#import "UIButton+Gradient.h"
#import "HYNavigationController.h"
#import "UIImage+Gradient.h"

// **********************************  测试环境  ***************************************
//#define BaseApi @"http://10.20.114.168:80"  //
//#define BusBaseApi @""  //
//#define ZWBaseApi @""  //
//#define ZWBSBaseApi @"http://192.168.1.151:15001/"  // 政务办事

// **********************************  正式环境  ***************************************
#define BaseApi @"https://nccsdn.yunshangnc.com/mixPanel/app/" //
#define BusBaseApi @"https://nccsdn.yunshangnc.com/mixPanel/app/phone/v1/api"  //
#define ZWBaseApi @"https://nccsdn.yunshangnc.com/mixPanel/app/phone/v1/api/"  //
#define ZWBSBaseApi @"https://nccsdn.yunshangnc.com/cityBrainItems-api/" // 政务办事


// *********************************  正式内网环境  **************************************
//#define BaseApi @"http://172.30.129.83:80"

#define XFLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#define SLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#define RFONT(size) [UIFont systemFontOfSize:size weight:UIFontWeightRegular]
#define BFONT(size) [UIFont systemFontOfSize:size weight:UIFontWeightBold]
#define MFONT(size) [UIFont systemFontOfSize:size weight:UIFontWeightMedium]
#define SFONT(size) [UIFont systemFontOfSize:size weight:UIFontWeightSemibold]
#define DMFONT(size) [UIFont fontWithName:@"DIN-Medium" size:size]

#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kIsBangsScreen ({\
    BOOL isBangsScreen = NO; \
    if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    isBangsScreen = window.safeAreaInsets.bottom > 0; \
    } \
    isBangsScreen; \
})

#define kStatusBarHeight    (kIsBangsScreen ? 44.f : 20.f)

#define kTopNavHeight    (kStatusBarHeight + 44.f)

#define kSafeAreaBottomHeight  (kIsBangsScreen ? 34.f : 0.f)

#define kBottomTabBarHeight    (kSafeAreaBottomHeight + 49.f)

#define ResourceBundle [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingPathComponent:@"/HYCivicCenter.bundle"]]
#define HyBundleImage(imageName) [UIImage imageNamed:imageName inBundle:ResourceBundle compatibleWithTraitCollection:nil]

#endif /* HYCivicCenterCommand_h */
