//
//  AppDelegate.h
//  iNC-iOS
//
//  Created by yz on 2022/7/7.
//

#import "YSNCViewController.h"
#import "HYCivicCenterCommand.h"

@interface YSNCViewController ()

@end

@implementation YSNCViewController

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"super dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:253/255.0 alpha:1.0];
    _navView = [[YSNCNavView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopNavHeight)];
    [_navView.backBtn addTarget:self action:@selector(actBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navView];
   

}
- (void)setTitle:(NSString *)title
{
    _navView.titleLabel.text = title;
}
-(void)actBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        _navView.backBtn.hidden = NO;
    }else {
        _navView.backBtn.hidden = YES;
    }
}
@end
