//
//  HYNavigationController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/12.
//

#import "HYNavigationController.h"
#import "HYCivicCenterCommand.h"

@interface HYNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation HYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    __weak typeof(self) wkself = self;
    self.delegate = wkself;
    
    UINavigationBar *appearance = [UINavigationBar appearance];
    if (@available(iOS 15, *)) {
        UINavigationBarAppearance *app = [UINavigationBarAppearance new];
        [app configureWithDefaultBackground];                                              /// 设置默认背景
        app.backgroundImage = nil;                                                         /// 导航条背景 : 一张图片
        app.backgroundColor = UIColorFromRGB(0x157AFF);                                    /// 导航条背景 : 纯颜色
        app.backgroundEffect = nil;                                                        /// 导航条背景 : 是否要一个 模糊效果
        app.shadowImage = nil;                                                             /// 导航条最下方的一条线 : 一张图片
        app.shadowColor = [UIColor clearColor];                                            /// 导航条最下方的一条线 : 纯颜色
        app.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]}; /// 导航条title的颜色 || 大小
        [appearance setScrollEdgeAppearance:app];
        [appearance setStandardAppearance:app];
    } else if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *barAppearance = UINavigationBarAppearance.new;
        barAppearance.backgroundColor = UIColorFromRGB(0x157AFF);
        appearance.standardAppearance = barAppearance;
        appearance.translucent = YES;
    } else {
        //设置导航栏的颜色
        [appearance setBarTintColor:UIColorFromRGB(0x157AFF)];
        appearance.translucent = YES;
    }
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

///MARK: override
//全部修改返回按钮,但是会失去右滑返回的手势
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:HyBundleImage(@"naviBack") style:UIBarButtonItemStyleDone target:self action:@selector(backClickedAction)];
    }
    //在push一个新的VC时，禁用滑动返回手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)backClickedAction {
    [self popViewControllerAnimated:YES];
}

///MARK: UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //完全展示出VC时，启用滑动返回手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    //解决根试图左滑页面卡死
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

///MARK: UIGestureRecognizerDelegate
//接受多手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationBar.subviews.firstObject.alpha = 1;
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

@end
