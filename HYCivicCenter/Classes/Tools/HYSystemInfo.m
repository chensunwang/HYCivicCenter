//
//  HYSystemInfo.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/4.
//

#import "HYSystemInfo.h"

@implementation HYSystemInfo

//设备型号
+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //CLog(@"%@",deviceString);
    //获取最新的代码对比型号
    //https://www.innerfence.com/howto/apple-ios-devices-dates-versions-instruction-sets
    
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4s";
    if ([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6 ";
    if ([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA+GSM/LTE)";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM/LTE)";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA+GSM/LTE)";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM/LTE)";
    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])  return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])  return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])  return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"])  return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])  return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,6"] || [deviceString isEqualToString:@"iPhone11,4"])  return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone12,1"])  return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])  return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])  return @"iPhone 11 Pro Max";
    if ([deviceString isEqualToString:@"iPhone12,8"])  return @"iPhone SE (2nd generation)";
    if ([deviceString isEqualToString:@"iPhone13,1"])  return @"iPhone 12 mini";
    if ([deviceString isEqualToString:@"iPhone13,2"])  return @"iPhone 12";
    if ([deviceString isEqualToString:@"iPhone13,3"])  return @"iPhone 12 Pro";
    if ([deviceString isEqualToString:@"iPhone13,4"])  return @"iPhone 12 Pro Max";
    if ([deviceString isEqualToString:@"iPhone14,4"])  return @"iPhone 13 mini";
    if ([deviceString isEqualToString:@"iPhone14,5"])  return @"iPhone 13";
    if ([deviceString isEqualToString:@"iPhone14,2"])  return @"iPhone 13 Pro";
    if ([deviceString isEqualToString:@"iPhone14,3"])  return @"iPhone 13 Pro Max";
    
    
    if ([deviceString isEqualToString:@"iPod7,1"])    return @"iPod touch (6th generation)";
    if ([deviceString isEqualToString:@"iPod5,1"])    return @"iPod touch (5th generation)";
    if ([deviceString isEqualToString:@"iPod4,1"])    return @"iPod touch (4th generation)";
    if ([deviceString isEqualToString:@"iPod3,1"])    return @"iPod touch (3th generation)";
    if ([deviceString isEqualToString:@"iPod2,1"])    return @"iPod touch (2th generation)";
    if ([deviceString isEqualToString:@"iPod1,1"])    return @"iPod touch (1th generation)";
    if ([deviceString isEqualToString:@"iPad5,2"])    return @"iPad mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,1"])    return @"iPad mini 4 (Wi‑Fi)";
    if ([deviceString isEqualToString:@"iPad4,9"])    return @"iPad mini 3 (China)";
    if ([deviceString isEqualToString:@"iPad4,8"])    return @"iPad mini 3 (LTE)";
    if ([deviceString isEqualToString:@"iPad4,7"])    return @"iPad mini 3 (Wi‑Fi)";
    if ([deviceString isEqualToString:@"iPad4,6"])    return @"iPad mini with Retina display (China)";
    if ([deviceString isEqualToString:@"iPad4,5"])    return @"iPad mini with Retina display (LTE)";
    if ([deviceString isEqualToString:@"iPad4,4"])    return @"iPad mini with Retina display (Wi‑Fi)";
    if ([deviceString isEqualToString:@"iPad2,7"])    return @"iPad mini (GSM/LTE)";
    if ([deviceString isEqualToString:@"iPad2,6"])    return @"iPad mini (GSM/LTE)";
    if ([deviceString isEqualToString:@"iPad2,5"])    return @"iPad mini (Wi‑Fi)";
    if ([deviceString isEqualToString:@"iPad6,4"])    return @"9.7‑inch iPad Pro (LTE)";
    if ([deviceString isEqualToString:@"iPad6,3"])    return @"9.7‑inch iPad Pro (Wi‑Fi)";
    if ([deviceString isEqualToString:@"iPad6,8"])    return @"12.9‑inch iPad Pro (LTE)";
    if ([deviceString isEqualToString:@"iPad6,7"])    return @"12.9‑inch iPad Pro (Wi‑Fi)";
    if ([deviceString isEqualToString:@"iPad5,4"])    return @"iPad Air 2 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])    return @"iPad Air 2 (Wi‑Fi)";
    if ([deviceString isEqualToString:@"iPad4,3"])    return @"iPad Air (China)";
    if ([deviceString isEqualToString:@"iPad4,2"])    return @"iPad Air (LTE)";
    if ([deviceString isEqualToString:@"iPad4,1"])    return @"iPad Air (Wi‑Fi)";
    if ([deviceString isEqualToString:@"iPad3,6"])    return @"iPad (4th generation, CDMA/LTE)";
    if ([deviceString isEqualToString:@"iPad3,5"])    return @"iPad (4th generation, GSM/LTE)";
    if ([deviceString isEqualToString:@"iPad3,4"])    return @"iPad (4th generation, Wi‑Fi)";
    if ([deviceString isEqualToString:@"iPad3,3"])    return @"iPad (3rd generation, CDMA/LTE)";
    if ([deviceString isEqualToString:@"iPad3,2"])    return @"iPad (3rd generation, GSM/LTE)";
    if ([deviceString isEqualToString:@"iPad3,1"])    return @"iPad (3rd generation, Wi‑Fi)";
    if ([deviceString isEqualToString:@"iPad2,4"])    return @"iPad 2 (Wi‑Fi, A5R)";
    if ([deviceString isEqualToString:@"iPad2,3"])    return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,2"])    return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,1"])    return @"iPad 2 (Wi‑Fi)";
    if ([deviceString isEqualToString:@"iPad1,1"])    return @"iPad";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";

    return deviceString;
}

//手机系统
+ (NSString *)phoneVersion{
    return [[UIDevice currentDevice] systemVersion];
}

// 获取ip地址
+ (NSString *)getIpAddress {
    
    NSString *address = @"error";
    struct ifaddrs *ifaddress = NULL;
    struct ifaddrs *temp_address = NULL;
    int success = 0;
    success = getifaddrs(&ifaddress);
    if (success == 0) {
        temp_address = ifaddress;
        
        while (temp_address != NULL) {
            if (temp_address->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_address->ifa_name] isEqualToString:@"eno"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_address->ifa_addr)->sin_addr)];
                }
            }
            temp_address = temp_address->ifa_next;
        }
        
    }
    return address;
    
}

@end
