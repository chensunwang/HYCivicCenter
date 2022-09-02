//
//  MainApi.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ResultBlock)(__nullable id responseObject,  NSError * _Nullable error);
typedef void (^formDataBlock)(__nullable id formData);
typedef void (^progressBlock)(NSProgress * __nullable progress);

#define HttpRequest [MainApi sharedInstance]

@interface MainApi : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isShow;

+ (MainApi *)sharedInstance;


/**
 *  发送get请求
 *
 *  @param path  请求的网址字符串
 *  @param params 请求的参数
 *  @param resultBlock    请求成功的回调
 */

- (void)getPath:(NSString *)path params:(NSDictionary * _Nullable )params resultBlock:(ResultBlock)resultBlock;

- (void)getPathGov:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock;

- (void)getPathBus:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock;

- (void)getPathZWBS:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock;
/**
 *  发送post请求
 *
 *  @param path  请求的网址字符串
 *  @param params 请求的参数
 *  @param resultBlock    请求成功的回调
 */

- (void)postPath:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock;

- (void)postPathGov:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock;

- (void)postPathBus:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock;

- (void)postPathZWBS:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock;

// httpbody "application/json"
- (void)postHttpBody:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock;

- (void)postHttpBodyGov:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock;

- (void)postHttpBodyBus:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock;

- (void)postLocolBodyZWBS:(NSString *)path params:(NSDictionary *)params resultBlock:(ResultBlock)resultBlock;

- (void)postHttpBodyZWBS:(NSString *)path params:(NSDictionary * _Nullable)params resultBlock:(ResultBlock)resultBlock;

// 埋点接口
- (void)postPathPointParams:(NSDictionary * _Nullable)params resuleBlock:(ResultBlock)resultBlock;

// post发送文件
- (void)postPath:(NSString *)path params:(NSDictionary * _Nullable)params formDataBlock:(formDataBlock)formDataBlock resultBlock:(ResultBlock)resultBlock;

- (void)postPathGov:(NSString *)path params:(NSDictionary * _Nullable)params formDataBlock:(formDataBlock)formDataBlock resultBlock:(ResultBlock)resultBlock;

- (void)postPathZWBS:(NSString *)path params:(NSDictionary * _Nullable)params formDataBlock:(formDataBlock)formDataBlock progress:(progressBlock)progress resultBlock:(ResultBlock)resultBlock;

- (void)logout;

@end

NS_ASSUME_NONNULL_END
