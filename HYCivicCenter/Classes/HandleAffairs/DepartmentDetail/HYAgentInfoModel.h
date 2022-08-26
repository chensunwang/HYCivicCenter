//
//  HYAgentInfoModel.h
//  HelloFrame
//
//  Created by nuchina on 2022/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYAgentInfoModel : NSObject

@property (nonatomic, copy) NSString * createBy;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, assign) NSInteger delFlg;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * orderCode;
@property (nonatomic, copy) NSString * orgCode;
@property (nonatomic, copy) NSString * orgName;
@property (nonatomic, copy) NSString * orgPic;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * searchValue;
@property (nonatomic, copy) NSString * updateBy;
@property (nonatomic, copy) NSString * updateTime;

@end

NS_ASSUME_NONNULL_END
