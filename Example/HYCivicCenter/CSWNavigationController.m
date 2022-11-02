//
//  CSWNavigationController.m
//  Encapsulation
//
//  Created by 谌孙望 on 2019/9/26.
//  Copyright © 2019 chensunwang. All rights reserved.
//


#import "CSWNavigationController.h"

@interface CSWNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation CSWNavigationController

// 基类 导航控制器
+ (void)initialize {
    if (@available(iOS 15, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithDefaultBackground];                              /// 设置默认背景
        appearance.backgroundImage = nil;                                         /// 导航条背景 : 一张图片
        appearance.backgroundColor = UIColor.orangeColor;                         /// 导航条背景 : 纯颜色
        appearance.backgroundEffect = nil;                                        /// 导航条背景 : 是否要一个 模糊效果
        appearance.shadowImage = nil;                                             /// 导航条最下方的一条线 : 一张图片
        appearance.shadowColor = [UIColor clearColor];                            /// 导航条最下方的一条线 : 纯颜色
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]}; /// 导航条title的颜色 || 大小
        [[UINavigationBar appearance] setScrollEdgeAppearance:appearance];
        [[UINavigationBar appearance] setStandardAppearance:appearance];
    } else {
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    id target = self.interactivePopGestureRecognizer.delegate;
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    // 创建pan手势 作用范围是全屏
    UIPanGestureRecognizer *fullScreenGes = [[UIPanGestureRecognizer alloc] initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    // 过滤执行过渡动画时的手势处理
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // 解决右滑和UITableView左滑删除的冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return  self.childViewControllers.count == 1 ? NO : YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 不是根控制器
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 基类导航控制器的左栏目
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        // 让按钮内部的所有内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        // 让按钮的内容往左偏移10
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [button addTarget:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 80, 44);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    // 这句话要放在后面，让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
}

- (void)backToPre {
    [self popViewControllerAnimated:YES];
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    if (navigationBarHidden) {
        self.hidesBarsOnSwipe = YES;
    } else {
        self.hidesBarsOnSwipe = NO;
    }
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
