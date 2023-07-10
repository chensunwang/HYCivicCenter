//
//  MainApi.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/23.
//

#import "MainApi.h"
#import "HYSystemInfo.h"
//#import "SSFaceSDK.h"
//#import "SSDKLib.h"
//#import "FaceParameterConfig.h"
//#import "FaceSSDKLib.h"
#import "WechatOpenSDK/WXApi.h"
#import "HYCivicCenterCommand.h"

@interface MainApi ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

static MainApi *request = nil;

@implementation MainApi

+ (MainApi *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[MainApi alloc] init];
    });
    return request;
}

- (instancetype)init {
    if (self == [super init]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"SoundMode"];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"LiveMode"];
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"ByOrder"];
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"checkAgreeBtn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
#warning develper: 下面的hostName sfp.mdbook.cn:8888 需要替换为私有化 安全服务的ip和端口号
//        [[SSDKLib sharedInstance] startSDKEngineWithDeviceID:nil hostName:@"nccsdn.yunshangnc.com/safe" ZInfoReadyHandler:^(NSError *error) {
//            NSLog(@"安全地址==%@", error);
//        }];
//
//        NSString* licensePath = [NSString stringWithFormat:@"%@.%@", FACE_LICENSE_NAME, FACE_LICENSE_SUFFIX ];
//        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath andRemoteAuthorize:true];
//        NSLog(@"canWork = %d", [[FaceSDKManager sharedInstance] canWork]);
//        NSLog(@"version = %@", [[FaceSDKManager sharedInstance] getVersion]);
//
//        [[FaceSSDKLib sharedInstance] setFaceLicenseId:@"pri_enc_key_01.face-ios"];

        [WXApi registerApp:@"wx523265a0e1fc5f22" universalLink:@"https://citybrain.yunshangnc.com/"];
        
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
        [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
//        AFHTTPResponseSerializer *responseSeri = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//        self.manager.responseSerializer = responseSeri;
    }
    return self;
}

- (void)getPath:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock {
    return [self dataTaskWithHTTPMethod:@"GET" URLString:path parameters:params  resultBlock:resultBlock];
}

- (void)getPathGov:(NSString *)path params:(NSDictionary *)params resultBlock:(ResultBlock)resultBlock {
    return [self govDataTaskWithHTTPMethod:@"GET" URLString:path parameters:params resultBlock:resultBlock];
}

- (void)getPathBus:(NSString *)path params:(NSDictionary *)params resultBlock:(ResultBlock)resultBlock {
    return [self busDataTaskWithHTTPMethod:@"GET" URLString:path parameters:params resultBlock:resultBlock];
}

- (void)getPathZWBS:(NSString *)path params:(NSDictionary *)params resultBlock:(ResultBlock)resultBlock {
    return [self zwbsDataTaskWithHTTPMethod:@"GET" URLString:path parameters:params resultBlock:resultBlock];
}

- (void)postPath:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock {
    return [self dataTaskWithHTTPMethod:@"POST" URLString:path parameters:params  resultBlock:resultBlock];
}

- (void)postPathGov:(NSString *)path params:(NSDictionary *)params resultBlock:(ResultBlock)resultBlock {
    return [self govDataTaskWithHTTPMethod:@"POST" URLString:path parameters:params resultBlock:resultBlock];
}

- (void)postPathBus:(NSString *)path params:(NSDictionary *)params resultBlock:(ResultBlock)resultBlock {
    return [self busDataTaskWithHTTPMethod:@"POST" URLString:path parameters:params resultBlock:resultBlock];
}

- (void)postPathZWBS:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock {
    return [self zwbsDataTaskWithHTTPMethod:@"POST" URLString:path parameters:params resultBlock:resultBlock];
}

- (void)postHttpBody:(NSString *)path params:(NSDictionary *)params resultBlock:(ResultBlock)resultBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BaseApi, path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    // qZS5Fs3c2puNHGoxBsRdGDaGYEI
    [request setValue:self.token ? : @"" forHTTPHeaderField:@"CityAuthorization"];
    
    if ([params allKeys].count != 0) {
        NSError *parseError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSData *body = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (resultBlock) {
                resultBlock(nil, error);
            }
        } else {
            if (resultBlock) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                resultBlock(dict, nil);
            }
        }
    }];
    [task resume];
    
}

- (void)postHttpBodyGov:(NSString *)path params:(NSDictionary *)params resultBlock:(ResultBlock)resultBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", ZWBaseApi, path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    // 51HRZgVE_TNirdyIEgbfQsf9z9k
    [request setValue:self.token ? : @"" forHTTPHeaderField:@"CityAuthorization"];
    
    if ([params allKeys].count != 0) {
        NSError *parseError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSData *body = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (resultBlock) {
                resultBlock(nil, error);
            }
        } else {
            if (resultBlock) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                resultBlock(dict, nil);
            }
        }
    }];
    [task resume];
    
}

- (void)postHttpBodyBus:(NSString *)path params:(NSDictionary *)params resultBlock:(ResultBlock)resultBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BusBaseApi, path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.token ? : @"" forHTTPHeaderField:@"CityAuthorization"];
    
    if ([params allKeys].count != 0) {
        NSError *parseError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSData *body = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (resultBlock) {
                resultBlock(nil, error);
            }
        } else {
            if (resultBlock) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                resultBlock(dict, nil);
            }
        }
    }];
    [task resume];
    
}

- (void)postLocolBodyZWBS:(NSString *)path params:(NSDictionary *)params resultBlock:(ResultBlock)resultBlock {
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.3.165:7777/%@", path]; // 192.168.3.165:7777/
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.token ? : @"" forHTTPHeaderField:@"authorization"];
    if ([params allKeys].count != 0) {
        NSError *parseError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSData *body = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (resultBlock) {
                resultBlock(nil, error);
            }
        } else {
            if (resultBlock) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                resultBlock(dict, nil);
            }
        }
    }];
    [task resume];
}

- (void)postHttpBodyZWBS:(NSString *)path params:(NSDictionary *)params resultBlock:(ResultBlock)resultBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", ZWBSBaseApi, path]; // 192.168.3.165:7777/
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.token ? : @"" forHTTPHeaderField:@"authorization"];
    if ([params allKeys].count != 0) {
        NSError *parseError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSData *body = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (resultBlock) {
                resultBlock(nil, error);
            }
        } else {
            if (resultBlock) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                resultBlock(dict, nil);
            }
        }
    }];
    [task resume];
    
}

- (void)postPathPointParams:(NSDictionary *)params resuleBlock:(ResultBlock)resultBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BaseApi, @"/phone/v2/mixPanel/save"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.token ? : @"" forHTTPHeaderField:@"CityAuthorization"];
    
    if ([params allKeys].count != 0) {
        NSError *parseError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionWithAppendDic:params] options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSData *body = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (resultBlock) {
                resultBlock(nil, error);
            }
        } else {
            if (resultBlock) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                resultBlock(dict, nil);
            }
        }
    }];
    [task resume];
    
}

- (NSDictionary *)dictionWithAppendDic:(NSDictionary *)appendDic {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@""]; // @"CurrentUuid"
    double currentTime = [[NSDate date]timeIntervalSince1970];
    NSString *strTime = [NSString stringWithFormat:@"%.0f",currentTime];
    NSDictionary *parameters = @{
        @"appKey": @"APP_ANDONE",
        @"applicationId": @"H017", // 应用ID
        @"applicationVersionNumber": [infoDictionary objectForKey:@"CFBundleShortVersionString"], // 当前版本号
//        @"buriedPointType": @"moduleVisit", // 埋点类型
        @"clientType": @"ios",
//        @"eventId": @"E0022", // 事件ID
        @"ipAddress": [HYSystemInfo getIpAddress],
//        @"jumpApplicationName": @"鹭鹭行",
        @"latitude": @"",
        @"longitude": @"",
        @"moduleId": @"M0003",  // 模块ID
        @"networkStatus": @"",
        @"operatingSystemVersion": [HYSystemInfo phoneVersion],  // 操作系统版本
        @"phoneModel": [HYSystemInfo deviceVersion],  // 手机型号
//        @"residenceTimeOfApplication": @"",  // 停留时间
//        @"screenResolution": @"", // 屏幕分辨率
//        @"telphone": @"",
        @"timestamp": strTime, // 时间戳
        @"useId": userID ? : @""  // 用户UUID
    };
    if (appendDic && appendDic.count > 0) {
        NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc]initWithDictionary:parameters];
        [parametersDic addEntriesFromDictionary:parameters];
        NSLog(@" 参数== %@ ", parametersDic);
        return (NSDictionary *)parametersDic;
    }
    return parameters;
    
}

// 发送文件
- (void)postPath:(NSString *)path params:(NSDictionary * _Nullable)params formDataBlock:(formDataBlock)formDataBlock resultBlock:(ResultBlock)resultBlock {
    return [self dataTaskWithHTTPMethod:@"POST" URLString:path paramters:params formDataBlock:formDataBlock resuleBlock:resultBlock];
}

- (void)postPathGov:(NSString *)path params:(NSDictionary * _Nullable)params formDataBlock:(formDataBlock)formDataBlock resultBlock:(ResultBlock)resultBlock {
    return [self govDataTaskWithHTTPMethod:@"POST" URLString:path paramters:params formDataBlock:formDataBlock resuleBlock:resultBlock];
}

- (void)postPathZWBS:(NSString *)path params:(NSDictionary * _Nullable)params formDataBlock:(formDataBlock)formDataBlock progress:(nonnull progressBlock)progress resultBlock:(nonnull ResultBlock)resultBlock {
    return [self zwbsDataTaskWithHTTPMethod:@"POST" URLString:path parameters:params forDataBlock:formDataBlock progress:progress resultBlock:resultBlock];
}


// 发送文件
- (void)dataTaskWithHTTPMethod:(NSString *)method URLString:(NSString *)URLString paramters:(id)parameters formDataBlock:(formDataBlock)formDataBlock resuleBlock:(ResultBlock)resultBlock {
    
    //  CityAuthorization
    [self.manager POST:[NSString stringWithFormat:@"%@%@", BaseApi, URLString] parameters:parameters headers:@{@"CityAuthorization": self.token ? : @""} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (formDataBlock) {
            formDataBlock(formData);
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"文件上传成功 == %@", responseObject);
            if (resultBlock) {
                resultBlock(responseObject,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"文件上传失败== %@", error);
            if (resultBlock) {
                resultBlock(nil, error);
            }
        }];
    
}

- (void)govDataTaskWithHTTPMethod:(NSString *)method URLString:(NSString *)URLString paramters:(id)parameters formDataBlock:(formDataBlock)formDataBlock resuleBlock:(ResultBlock)resultBlock {
    
    [self.manager POST:[NSString stringWithFormat:@"%@%@", ZWBaseApi, URLString] parameters:parameters headers:@{@"CityAuthorization": self.token ? : @""} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (formDataBlock) {
            formDataBlock(formData);
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"文件上传成功 == %@", responseObject);
            if (resultBlock) {
                resultBlock(responseObject, nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"文件上传失败== %@", error);
            if (resultBlock) {
                resultBlock(nil, error);
            }
        }];
    
}

- (void)zwbsDataTaskWithHTTPMethod:(NSString *)method
                         URLString:(NSString *)urlString
                        parameters:(id)parameters
                      forDataBlock:(formDataBlock)formDataBlock
                          progress:(progressBlock)progressBlock
                       resultBlock:(ResultBlock)resultBlock {
    
    [self.manager POST:[NSString stringWithFormat:@"%@%@", ZWBSBaseApi, urlString] parameters:parameters headers:@{@"authorization": self.token ? : @""} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (formDataBlock) {
                formDataBlock(formData);
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progressBlock) {
                progressBlock(uploadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"文件上传成功 == %@", responseObject);
            if (resultBlock) {
                resultBlock(responseObject, nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"文件上传失败== %@", error);
            if (resultBlock) {
                resultBlock(nil, error);
            }
        }];
}

- (void)dataTaskWithHTTPMethod:(NSString *)method
                     URLString:(NSString *)URLString
                    parameters:(id)parameters
                   resultBlock:(ResultBlock)resultBlock {
    
    if ([method isEqualToString:@"POST"]) {
        
        [self.manager POST:[NSString stringWithFormat:@"%@%@",BaseApi,URLString] parameters:parameters headers:@{
            @"CityAuthorization":self.token?:@""} progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@" POST成功== %@ ", responseObject);
                    if (resultBlock) {
                        resultBlock(responseObject, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@" POST失败== %@ ", error);
                    if (resultBlock) {
                        resultBlock(nil, error);
                    }
                    
                }];
        
    } else if ([method isEqualToString:@"GET"]) {
        // SAg4UntfgPzf_pFPi46yGPiGMrk
        [self.manager GET:[NSString stringWithFormat:@"%@%@", BaseApi, URLString] parameters:parameters headers:@{@"CityAuthorization": self.token ? : @""} progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@" GET成功== %@ ", responseObject);
                    if (resultBlock) {
                        resultBlock(responseObject, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@" GET失败== %@ ", error);
                    if (resultBlock) {
                        resultBlock(nil, error);
                    }
                }];
        
    }
    
}

- (void)govDataTaskWithHTTPMethod:(NSString *)method
                        URLString:(NSString *)URLString
                       parameters:(id)parameters
                      resultBlock:(ResultBlock)resultBlock {
    
    if ([method isEqualToString:@"POST"]) {
        
        [self.manager POST:[NSString stringWithFormat:@"%@%@", ZWBaseApi, URLString] parameters:parameters headers:@{
            @"CityAuthorization" : self.token ? : @""} progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@" POST成功== %@ ", responseObject);
                    if (resultBlock) {
                        resultBlock(responseObject, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@" POST失败== %@ ", error);
                    if (resultBlock) {
                        resultBlock(nil, error);
                    }
                    
                }];
        
    } else if ([method isEqualToString:@"GET"]) {
        
        [self.manager GET:[NSString stringWithFormat:@"%@%@", ZWBaseApi, URLString] parameters:parameters headers:@{@"CityAuthorization": self.token ? : @""} progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@" GET成功== %@ ", responseObject);
                    if (resultBlock) {
                        resultBlock(responseObject, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@" GET失败== %@ ", error);
                    if (resultBlock) {
                        resultBlock(nil, error);
                    }
                }];
        
    }
    
}

- (void)busDataTaskWithHTTPMethod:(NSString *)method
                       URLString:(NSString *)URLString
                      parameters:(id)parameters
                      resultBlock:(ResultBlock)resultBlock {
    
    if ([method isEqualToString:@"POST"]) {
        
        [self.manager POST:[NSString stringWithFormat:@"%@%@", BusBaseApi, URLString] parameters:parameters headers:@{
            @"CityAuthorization" : self.token ? : @""} progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@" POST成功== %@ ", responseObject);
                    if (resultBlock) {
                        resultBlock(responseObject, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@" POST失败== %@ ", error);
                    if (resultBlock) {
                        resultBlock(nil, error);
                    }
                    
                }];
        
    } else if ([method isEqualToString:@"GET"]) {
        // SAg4UntfgPzf_pFPi46yGPiGMrk
        [self.manager GET:[NSString stringWithFormat:@"%@%@", BusBaseApi, URLString] parameters:parameters headers:@{@"CityAuthorization": self.token ? : @""} progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@" GET成功== %@ ", responseObject);
                    if (resultBlock) {
                        resultBlock(responseObject, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@" GET失败== %@ ", error);
                    if (resultBlock) {
                        resultBlock(nil, error);
                    }
                }];
        
    }
    
}

- (void)zwbsDataTaskWithHTTPMethod:(NSString *)method
                        URLString:(NSString *)URLString
                       parameters:(id)parameters
                       resultBlock:(ResultBlock)resultBlock {
    
    if ([method isEqualToString:@"POST"]) {
        
        [self.manager POST:[NSString stringWithFormat:@"%@%@", ZWBSBaseApi, URLString] parameters:parameters headers:@{
            @"authorization" : self.token ? : @""} progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@" POST成功== %@ ", responseObject);
                    if (resultBlock) {
                        resultBlock(responseObject, nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@" POST失败== %@ ", error);
                    if (resultBlock) {
                        resultBlock(nil, error);
                    }
                    
                }];
        
    } else if ([method isEqualToString:@"GET"]) {
        // SAg4UntfgPzf_pFPi46yGPiGMrk
        [self.manager GET:[NSString stringWithFormat:@"%@%@", ZWBSBaseApi, URLString] parameters:parameters headers:@{@"authorization": self.token ? : @""} progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@" GET成功== %@ ", responseObject);
                    if (resultBlock) {
                        resultBlock(responseObject,nil);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@" GET失败== %@ ", error);
                    if (resultBlock) {
                        resultBlock(nil, error);
                    }
                }];
        
    }
    
}

- (void)logout {
    
    self.isFirst = NO;
    self.isShow = NO;
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate dateWithTimeIntervalSince1970:2*60*60] forKey:@"saveDate"];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"CTID"];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"imgStream"];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"imgwidth"];
    
}

@end
