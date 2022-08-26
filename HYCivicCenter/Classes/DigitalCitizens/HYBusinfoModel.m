//
//  HYBusinfoModel.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/2.
//

#import "HYBusinfoModel.h"

@implementation HYBusinfoModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"nextStation":[HYStationModel class],@"terminusStation":[HYStationModel class]};
    
}

@end

@implementation HYStationModel

@end
