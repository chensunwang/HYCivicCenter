//
//  AppDelegate.h
//  iNC-iOS
//
//  Created by yz on 2022/7/7.
//

#import "YSNCNavigationController.h"

@interface YSNCNavigationController ()

@end

@implementation YSNCNavigationController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.navigationBar.hidden = YES;
    }
    
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {
        self.navigationBar.hidden = YES;
    }
    
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        //第二级则隐藏底部Tab
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
