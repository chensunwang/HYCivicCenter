//
//  BDFaceSuccessViewController+BDCheckFace.m
//  FaceSDKSample_IOS
//

#import "BDFaceSuccessViewController+BDCheckFace.h"
#import "BDFaceToastView.h"

@implementation BDFaceSuccessViewController (BDCheckFace)

- (void)checkFaceWithImageId:(NSString *)imageIdetifier
                 imageString:(NSString *)imageString
                    deviceId:(NSString *)deviceId
                        sKey:(NSString *)skey
                   checkLive:(BOOL)checkLive
{
    NSString *requestUrl = nil;
#warning develper: 这个人脸私有化服务的 ip地址 10.138.47.99:8318 ，部署完私有化服务后，这个ip需要替换为私有话服务的 ip和端口号
    if (checkLive) {
        requestUrl = @"http://10.138.47.99:8318/face/biz-demo/face/liveness";
    } else {
        requestUrl = [NSString stringWithFormat:@"http://10.138.47.99:8318/face/biz-demo/match/plus"];
    }
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *bodyDic = [self wrapContentWithImageId:imageIdetifier imageString:imageString deviceId:deviceId sKey:skey];
    NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = requestBodyData;
    NSOperationQueue *queue = [NSOperationQueue new];
    
    __weak typeof(self) this = self;
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSString *tipMessage = @"接口发生错误";
        if (connectionError == nil) {
            @try {
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSNumber *number = resultDic[@"error_code"];
                if (number && number.intValue == 0) {
                    tipMessage = @"成功了";
                } else {
                    tipMessage = @"失败了";
                }
                tipMessage = [NSString stringWithFormat:@"%@; %@", tipMessage, [this dataToJsonString:resultDic]];
            } @catch (NSException *exception) {

            } @finally {

            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [BDFaceToastView showToast:this.view text:tipMessage];
        });
        
    }];
    
}

- (NSString*)dataToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSDictionary *)wrapContentWithImageId:(NSString *)imageIdetifier imageString:(NSString *)imageString deviceId:(NSString *)deviceId sKey:(NSString *)skey {
    // debug info
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{
        @"app" : @"ios",
        @"imageKey" : imageIdetifier ?: @"",
        @"device_id" : deviceId,
        @"s_key" : skey
    }];
    
    [dic setObject:imageString forKey:@"data"];
    return dic;
    
}

- (NSString *)sapi_stringByDecodingURLFormat:(NSString *)string {
    NSString *result = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}


@end
