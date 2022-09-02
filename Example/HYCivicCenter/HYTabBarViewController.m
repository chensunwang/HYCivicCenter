//
//  HYTabBarViewController.m
//  HYCivicCenter_Example
//
//  Created by 谌孙望 on 2022/9/2.
//  Copyright © 2022 chensunwang. All rights reserved.
//

#import "HYTabBarViewController.h"
#import "DigitalcitizenViewController.h"
#import "HYNavigationController.h"
#import "HYGovernmentViewController.h"
#import "HYHandleAffairsViewController.h"
#import "MainApi.h"

@interface HYTabBarViewController ()<UIGestureRecognizerDelegate, UITabBarControllerDelegate>

@property (nonatomic, assign) NSUInteger previousIndex;

@end

@implementation HYTabBarViewController

+ (HYTabBarViewController *)shareInstance {
    static HYTabBarViewController *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

#pragma mark - 类的初始化方法，只有第一次使用类的时候会调用一次该方法
//+ (void)initialize {
//    //tabbar去掉顶部黑线
//    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    if (@available(iOS 10.0, *)) {
//        [[UITabBar appearance] setUnselectedItemTintColor:[UIColor colorWithRed:164.f/255.f green:164.f/255.f blue:164.f/255.f alpha:1.f]];
//        [[UITabBar appearance] setTintColor:[UIColor blackColor]];
//    } else {
//        // Fallback on earlier versions
//        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MainApi *mainApi = [MainApi sharedInstance];
    mainApi.token = @"s9P41NF3pK-yVpNc3DtZK3i5rIw";
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.delegate = self;
    [self setupChildViewController];
}

// 设置分栏的项目属性
- (void)setupChildViewController {
    // alloc init 的时候会进入对应vc的init viewdidload方法里面，也算是进入了新的界面
    DigitalcitizenViewController *homeVc = [[DigitalcitizenViewController alloc] init];
    [self setupChildViewController:homeVc title:@"首页" image:@"icon_task_n" selectedImage:@"icon_task_s"];
    
    HYHandleAffairsViewController *InstanceVc = [[HYHandleAffairsViewController alloc] init];
    [self setupChildViewController:InstanceVc title:@"办事" image:@"icon_money_n" selectedImage:@"icon_money_s"];
    
    HYGovernmentViewController *mineVc = [[HYGovernmentViewController alloc] init];
    [self setupChildViewController:mineVc title:@"政务" image:@"icon_me_n" selectedImage:@"icon_me_s"];
}

#pragma mark - 添加一个子控制器
- (void)setupChildViewController:(UIViewController *)viewController
                           title:(NSString *)title
                           image:(NSString *)image
                   selectedImage:(NSString *)selectedImage {
    
    viewController.navigationItem.title = title;  // 顶部标题
    viewController.tabBarItem.title = title;  // 底部标题
    
    
    // 正常状态
    [viewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    [self.tabBar setUnselectedItemTintColor:UIColor.grayColor];
    
    // 选中状态
    [viewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    viewController.tabBarItem.image = [UIImage imageNamed:image];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    HYNavigationController *nav = [[HYNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:nav];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
