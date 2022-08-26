//
//  BDUIConstant.h
//  FaceSDKSample_IOS
//
//  Created by 之哥 on 2021/3/16.
//  Copyright © 2021 Baidu. All rights reserved.
//

#ifndef BDUIConstant_h
#define BDUIConstant_h


//MARK: 屏幕宽度与高度
#define ScreenRect [UIScreen mainScreen].bounds
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//MARK: 窗口
#define KWindow [UIApplication sharedApplication].keyWindow

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//设备相关
#define KIS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height == 480) ? YES : NO)
#define KIS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)
#define KIS_IPhone6 (667 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define KIS_IPhone6plus (736 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)

#define KIS_IPhoneX (812 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define IS_IPhoneX (812 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
// 判断是否是iPhone X 系列手机
#define IS_IPhoneXSeries ({\
BOOL is_IphoneXseries = NO;\
if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {\
    is_IphoneXseries = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0; \
}\
is_IphoneXseries; \
})\


//判断iPHoneXr
#define KIS_IPhone_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define KIS_IPhone_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define KIS_IPhone_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

// 获取安全区域
#define VIEWSAFEAREAINSETS(view) ({UIEdgeInsets i; if([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

#define KBDNaviHeight (IS_IPhoneXSeries ? 88.0f : 64.0f)
#define KBDXMoveHeight ((IS_IPhoneXSeries ? 34.f : 0.f))
#define KBDXStatusHeight ((IS_IPhoneXSeries ? 44.f : 20.f)) // iphoneX状态栏高度由20变为44
#define KBDIPhoneXBottomVirtualHomeHeight 34.0f // iPhoneX底部的虚拟Home键高度34

#define KBDCustomNavgationBarItemOffset  (KIS_IPhone6plus?15.f:7.f)
#define KBDCustomNavgationBarRightItemOffset  (KIS_IPhone6plus?15.f:11.f)


//MARK: 视图处理

//设置 view 圆角和边框
#define KBD_ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//由角度转换弧度 由弧度转换角度
#define KBD_DegreesToRadian(x) (M_PI * (x) / 180.0)
#define KBD_RadianToDegrees(radian) (radian*180.0)/(M_PI)


/**iPhone6s为标准，乘以宽的比例*/
#define KScaleX(value) ((value)/375.0f * ScreenWidth)
/**iPhone6s为标准，乘以高的比例*/
#define KScaleY(value) ((value)/667.0f * ScreenHeight)

//十六进制颜色转换
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define KColorFromRGB(rgbValue)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define KColorFromRGBAlpha(rgbValue,a)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]


#define KRGBColor(r,g,b)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define KRGBAColor(r,g,b,a)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#endif /* BDUIConstant_h */
