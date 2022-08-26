//
//  HYSearchServiceModel.h
//  HelloFrame
//
//  Created by nuchina on 2021/11/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYSearchServiceModel : NSObject

@property (nonatomic, copy) NSString *editFlag;
@property (nonatomic, copy) NSString *labelName;
@property (nonatomic, copy) NSString *labelType;
@property (nonatomic, copy) NSString *labelValue;
@property (nonatomic, copy) NSString *requiredFlag;
@property (nonatomic, strong) NSArray *valueList;

@end

@interface HYServiceChildrenModel : NSObject

@property (nonatomic, strong) NSArray *children;
@property (nonatomic, copy) NSString *dictCode;
@property (nonatomic, copy) NSString *dictLabel;
@property (nonatomic, copy) NSString *dictValue;
@property (nonatomic, copy) NSString *parentCode;

@end

@interface HYServiceAvalilableModel : NSObject

@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *areaCode;
@property (nonatomic, copy) NSString *areaName; // 区域
@property (nonatomic, copy) NSString *nationalityCode;
@property (nonatomic, copy) NSString *nationalityName;
@property (nonatomic, copy) NSString *blindId;
@property (nonatomic, copy) NSString *blindName; // 是否盲人
@property (nonatomic, copy) NSString *disabilityId;
@property (nonatomic, copy) NSString *disabilityName; // 是否残疾
@property (nonatomic, copy) NSString *graduationDate; // 毕业
@property (nonatomic, copy) NSString *admissionDate; // 入学
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *industryId;
@property (nonatomic, copy) NSString *industryName; // 行业
@property (nonatomic, copy) NSString *major; // 专业
@property (nonatomic, copy) NSString *positionName; // 职位
@property (nonatomic, copy) NSString *occupationName; // 职业名称
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *retireId;
@property (nonatomic, copy) NSString *retireName; // 退休
@property (nonatomic, copy) NSString *schoolName;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *sex;


@end

NS_ASSUME_NONNULL_END
