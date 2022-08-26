//
//  HYItemInfoModel.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/10.
//

#import "HYItemTotalInfoModel.h"

@implementation HYItemTotalInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"charge": [HYChargeModel class],
             @"condition": [HYConditionModel class],
             @"consult": [HYConsultModel class],
             @"handlingProcess": [HYHandlingProcessModel class],
             @"itemInfo": [HYItemInfoModel class],
             @"material": [HYMaterialModel class],
             @"outMap": [HYOutMapModel class],
             @"question": [HYQuestionModel class]};
}

@end


@implementation HYChargeModel


@end


@implementation HYConditionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"createTime": [HYConditionTimeModel class],
             @"lastTime": [HYConditionTimeModel class]};
}

@end


@implementation HYConditionTimeModel


@end


@implementation HYConsultModel


@end


@implementation HYHandlingProcessModel


@end


@implementation HYItemInfoModel


@end


@implementation HYMaterialModel


@end


@implementation HYOutMapModel


@end


@implementation HYQuestionModel


@end


@implementation HYGuideItemInfoModel


@end


@implementation HYUploadedMaterailModel


@end
