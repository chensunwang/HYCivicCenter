//
//  HYMyServiceModel.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYMyServiceModel : NSObject

@property (nonatomic, copy) NSString *createBy;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *delFlg;
@property (nonatomic, copy) NSString *eventCode;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, copy) NSString *needFaceRecognition;
@property (nonatomic, copy) NSString *onlyEnterpriseFlag;
@property (nonatomic, copy) NSString *outLinkFlag;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *searchValue;
@property (nonatomic, copy) NSString *serviceObject;
@property (nonatomic, copy) NSString *servicePersonFlag;
@property (nonatomic, copy) NSString *updateBy;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
