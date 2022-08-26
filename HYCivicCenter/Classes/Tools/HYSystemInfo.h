//
//  HYSystemInfo.h
//  HelloFrame
//
//  Created by nuchina on 2021/11/4.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/utsname.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYSystemInfo : NSObject

//设备型号
+ (NSString*)deviceVersion;

//手机系统
+ (NSString *)phoneVersion;

//ip地址
+ (NSString *)getIpAddress;

@end

NS_ASSUME_NONNULL_END
