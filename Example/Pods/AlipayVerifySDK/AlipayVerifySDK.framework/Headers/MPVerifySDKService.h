//
//  MPVerifySDKService.h
//  AlipayVerifySDK
//
//  Created by 叶鸣宇 on 2022/8/15.
//  Copyright © 2022 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AliyunIdentityManager/AliyunIdentityManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPVerifySDKService : NSObject

// 初始化服务，在 App 启动后尽可能早的地方，如隐私权限弹框同意后第一时间等
+ (void)initSDKService;

+ (MPVerifySDKService *)sharedInstance;

/***
 * 启动服务
 * @param certifyId 流水ID
 * @param currentCtr 人脸页面载体 controller, currentCtr 必须基于navigation controller
 * @param params 扩展参数
 * @param callback 结果回调
 */
- (void)verifyWith:(NSString *)certifyId
        currentCtr:(UIViewController *)currentCtr
        extParams:(NSDictionary *)params
        onCompletion:(ZIMCallback)callback;
@end

NS_ASSUME_NONNULL_END
