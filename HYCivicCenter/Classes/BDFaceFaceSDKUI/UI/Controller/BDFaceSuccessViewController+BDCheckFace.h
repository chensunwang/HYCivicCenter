//
//  BDFaceSuccessViewController+BDCheckFace.h
//  FaceSDKSample_IOS
//

#import "BDFaceSuccessViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDFaceSuccessViewController (BDCheckFace)

/*
 私有化部署,检测人脸的接口
 * 参数：imageIdetifier 图片唯一标识
 * 参数：imageString 人脸数据
 * 参数：deviceId 设备id
 * 参数：skey skey
 * 参数：checkLive 是否是活体检测，YES,是活体检测，NO,是人脸对比
 */
- (void)checkFaceWithImageId:(NSString *)imageIdetifier
                 imageString:(NSString *)imageString
                    deviceId:(NSString *)deviceId
                        sKey:(NSString *)skey
                   checkLive:(BOOL)checkLive;

@end

NS_ASSUME_NONNULL_END
