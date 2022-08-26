/**
 *  SSDK v2.5.3.1，集成和使用方法，请参考《iOS安全SDK使用文档》
 *  文档更新地址：http://wiki.baidu.com/pages/viewpage.action?pageId=357373756
 */

#import <Foundation/Foundation.h>

/**
 *  getZInfoWithEvent方法需要 传入 的参数字典中的Key
 */
__attribute__((visibility("default")))
extern NSString * const kSSDKEventIdentifier; // eventID

__attribute__((visibility("default")))
extern NSString * const kSSDKAccountIdentifier; // accountID

__attribute__((visibility("default")))
extern NSString * const kSSDKCallerIdentifier; // callerID

/**
 *  getZInfoWithEvent方法 返回 的参数字典中的Key
 */
__attribute__((visibility("default")))
extern NSString * const kSSDKZToken; // ztoken

__attribute__((visibility("default")))
extern NSString * const kSSDKZNote; // znote

__attribute__((visibility("default")))
extern NSString * const kSSDKTdid; // tdid


__attribute__((visibility("default")))
@interface SSDKLib : NSObject


/**
 iOS安全SDK操作粘贴板队列，App统一管控粘贴板时设置
 请在[SSDKLib sharedInstance]后立即赋值
 */
@property dispatch_queue_t pasteboardQueue;

/**
 *  iOS安全SDK单一实例
 */
+ (id)sharedInstance;


/**
 * iOS安全SDK初始化接口，宿主App直接调用，私有化时无法使用
 @param deviceID          唯一设备标识
 @param appKey            申请的AppKey
 @param secretKey         申请的secretKey
 @param ZInfoReadyHandler  调用者提供的回调函数，调起时zid在服务端可查。可传空
 */
- (void)startSDKEngineWithDeviceID:(NSString *)deviceID
                            appKey:(NSString *)appKey
                         secretKey:(NSString *)secretKey
                 ZInfoReadyHandler:(void (^)(NSError *error))ZInfoReadyHandler;

/**
 * iOS安全SDK初始化接口，宿主App直接调用，私有化时使用
 @param deviceID          唯一设备标识
 @param hostName          域名，不带https://
 @param ZInfoReadyHandler  调用者提供的回调函数，调起时zid在服务端可查。可传空
 */
- (void)startSDKEngineWithDeviceID:(NSString *)deviceID
                          hostName:(NSString *)hostName
                 ZInfoReadyHandler:(void (^)(NSError *error))ZInfoReadyHandler;

/**
 * 特定事件（如支付、登录）发生时查询ztoken的接口
 
 @param eventInfo 包含eventID和accountID信息的字典:{ kSSDKEventIdentifier: (NSString*)eventID, kSSDKAccountIdentifier:(NSString*)accountID}
 @return: 包含ztoken信息的字典：@{ kSSDKZToken: ztoken }，ztoken为NSString类型
 */
- (NSDictionary *)getZInfoWithEvent:(NSDictionary *)eventInfo;


/**
 JS对特定事件（如支付、登录）发生时查询ztoken的接口,

 @param paramDict 传入的参数, json string
 @return 包含ztoken等信息的字典
 */
- (NSDictionary *)getZInfoWithBridgeEvent:(NSDictionary *)paramDict;




- (void)setBceClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret;

@end
