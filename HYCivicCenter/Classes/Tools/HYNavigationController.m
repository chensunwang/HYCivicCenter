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
    if (@available(iOS 13.0, *)) {
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
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"naviBack"] style:UIBarButtonItemStyleDone target:self action:@selector(backClickedAction)];
    }
    //在push一个新的VC时，禁用滑动返回手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

-(void)backClickedAction {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
