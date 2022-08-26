//
//  HYSearchServiceModel.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/22.
//

#import "HYSearchServiceModel.h"

@implementation HYSearchServiceModel


+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"valueList":[HYServiceChildrenModel class]};
    
}

@end

@implementation HYServiceChildrenModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"children":[HYServiceChildrenModel class]};
    
}

@end

@implementation HYServiceAvalilableModel



@end
