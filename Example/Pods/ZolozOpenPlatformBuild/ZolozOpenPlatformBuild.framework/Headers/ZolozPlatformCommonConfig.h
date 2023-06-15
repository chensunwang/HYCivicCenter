//
//  ZolozPlatformCommonConfig.h
//  ZolozOpenPlatformBuild
//
//  Created by 叶鸣宇 on 2022/1/17.
//  Copyright © 2022 com.alipay.iphoneclient.zoloz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZolozPlatformCommonConfig : NSObject

@property (nonatomic, strong) NSString *zolozPlatform;

+ (instancetype)getInstance;

- (BOOL)isDIGITAL_TECH;

@end

NS_ASSUME_NONNULL_END
