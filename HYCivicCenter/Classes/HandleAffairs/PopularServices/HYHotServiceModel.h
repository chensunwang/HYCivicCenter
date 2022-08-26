//
//  HYHotServiceModel.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYHotServiceModel : NSObject  // 热门服务模型

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *createBy;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *delFlg;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) NSArray *infoList;
@property (nonatomic, copy) NSString *isHot;
@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *needFaceRecognition;
@property (nonatomic, copy) NSString *onlyEnterpriseFlag;
@property (nonatomic, copy) NSString *outLinkFlag;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *searchValue;
@property (nonatomic, copy) NSString *serviceObject;
@property (nonatomic, copy) NSString *servicePersonFlag;  // 判断是否是个人事项
@property (nonatomic, copy) NSString *specialId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updateBy;
@property (nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
