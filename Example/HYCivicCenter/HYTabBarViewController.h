//
//  HYTabBarViewController.h
//  HYCivicCenter_Example
//
//  Created by 谌孙望 on 2022/9/2.
//  Copyright © 2022 chensunwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYTabBarViewController : UITabBarController

@property (nonatomic, assign) NSUInteger selectedTabBarIndex;

+ (HYTabBarViewController *)shareInstance;

@end

NS_ASSUME_NONNULL_END
