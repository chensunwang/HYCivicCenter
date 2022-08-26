//
//  HYHotHandleAffairsModel.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYHotHandleAffairsModel : NSObject  // 热门办事模型

@property (nonatomic, copy) NSString *agentId;
@property (nonatomic, copy) NSString *agentName;
@property (nonatomic, copy) NSString *createBy;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *delFlg;
@property (nonatomic, copy) NSString *hotItemId;
@property (nonatomic, copy) NSString *hotName;
@property (nonatomic, copy) NSString *hotPic;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, copy) NSString *needFaceRecognition;
@property (nonatomic, copy) NSString *onlyEnterpriseFlag;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *outLinkFlag;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *searchValue;
@property (nonatomic, copy) NSString *serviceObject;
@property (nonatomic, copy) NSString *servicePersonFlag;
@property (nonatomic, copy) NSString *updateBy;
@property (nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
