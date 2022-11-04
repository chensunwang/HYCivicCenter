//
//  FaceSSDKLib.h
//  FaceSSDKLib v1.1.0
//
//  Created by Gong,Jialiang on 2018/2/26.
//  Copyright © 2018年 Gong,Jialiang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, DeployModeType) {
    DeployModeTypeOffline, // 离线模式
    DeployModeTypeOnline // 在线模式
};

__attribute__((visibility("default")))
@interface FaceSSDKLib : NSObject

/**
 返回单例对象
 */
+ (instancetype)sharedInstance;


/**
 启动FaceSDK，需要传入已经申请好的appKey和secretKey

 @param appKey
 @param secretKey 
 */
- (void)startSDKWithAppKey:(NSString *)appKey secretKey:(NSString *)secretKey deployMode:(DeployModeType)deployModeType;

/**
 返回FaceSDK运行环境信息

 @return 包含FaceID和ztoken两个字段，{ @“0”: (NSString*)ztoken, @“1”:(NSString*)faceID}
 */
- (NSDictionary *)getFaceInfo;

/**
 加密模块初始化，初始化成功后才可进行文件加密

 @param keyBytes 加密Key指针
 @return 加密是否成功
 */
- (BOOL)encryptInitWithKeyBytes:(const char *)keyBytes;

/**
 加密文件

 @param originBytes 文件的数据指针
 @param length 数据长度
 @return 加密后的数据
 */
- (NSData*)encryptWithOriginBytes:(const char *)originBytes length:(NSUInteger)length;

/**
 图片变换加密

 @param originImage 原始图片
 @return 加密后的二进制图片
 */
- (NSData *)safeTransformImage:(UIImage *)originImage;

/**
 保存face licenseid，用于后续加密操作

 @param faceLicenseId
 
 */
- (void)setFaceLicenseId:(NSString *)faceLicenseId;

/**
 设置百度云id，用来获取access token

 @param clientId clientid
 @param clientSecret secretid
 
 */
- (void)setBCEClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret;

@end
