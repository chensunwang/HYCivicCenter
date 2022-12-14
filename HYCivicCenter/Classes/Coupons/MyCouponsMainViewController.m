//
//  MyCouponsMainViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/9.
//

#import "MyCouponsMainViewController.h"
#import "MyCouponsViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface MyCouponsMainViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *titlesArr;
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,strong) UIButton *currentTabBtn;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation MyCouponsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"我的优惠券"];
    
    [self configUI];
    
}

- (void)configUI {
    
//    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightbutton addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
//    [rightbutton setTitle:@"领券中心" forState:UIControlStateNormal];
//    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    rightbutton.titleLabel.font = RFONT(15);
//    rightbutton.frame = CGRectMake(0 , 0, 60, 44);
//
//    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:rightbutton];
//
//    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//
//    spaceItem.width = -15;
//    self.navigationItem.rightBarButtonItems = @[spaceItem,rightItem];
    
    [self setupChildsVC];
    
    [self setupTitleView];
    
}

- (void)setupChildsVC {
    
    for (NSInteger i = 0; i < self.titlesArr.count; i++) {
        
        MyCouponsViewController *couponVC = [[MyCouponsViewController alloc]init];
        couponVC.type = @(i + 2).stringValue;
        [self addChildViewController:couponVC];
        
    }
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.titlesArr.count, 0);
    
}

- (void)setupTitleView {
    
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopNavHeight, [UIScreen mainScreen].bounds.size.width, 60)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    
    UIButton *firstBtn = nil;
    CGFloat buttonWidth = ([UIScreen mainScreen].bounds.size.width - 64)/3;
    for (int i = 0; i < self.titlesArr.count; i++) {
        NSString *title = self.titlesArr[i];
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = RFONT(14);
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xE6E6E6)];
        button.layer.cornerRadius = 16;
        button.clipsToBounds = YES;
        button.tag = 100 + i;
        if (i == 0) {
            firstBtn = button;
        }
        button.frame = CGRectMake(16+(buttonWidth + 16) * i, 15, buttonWidth, 32);
        [button addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleView addSubview:button];
    }
    
    
    [self titleClicked:firstBtn];
    [self setupContentView];
    
}

- (void)setupContentView {
    
    MyCouponsViewController *couponVC = self.childViewControllers[[self getTheCurrentIndex]];
    if (couponVC.isViewLoaded) {
        return;
    }
    UIView *view = couponVC.view;
    view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:view];
    
}

#pragma ScrollView
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self setupContentView];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self setupContentView];
    UIButton *button = [self.titleView viewWithTag:[self getTheCurrentIndex] + 100];
    [self titleClicked:button];
    
}

- (int)getTheCurrentIndex {
    return self.scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
}

- (void)rightClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)titleClicked:(UIButton *)button {
    
    if (button == self.currentTabBtn) return;
    self.currentTabBtn.selected = NO;
    [self setupButton:self.currentTabBtn];
    button.selected = YES;
    self.currentTabBtn = button;
    [self setupButton:self.currentTabBtn];
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = [UIScreen mainScreen].bounds.size.width * (button.tag - 100);
    [self.scrollView setContentOffset:offset animated:YES];
    
    
}

- (void)setupButton:(UIButton *)button {
    if (button.selected) {
        button.titleLabel.font = RFONT(14);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0x157AFF)];
    } else {
        button.titleLabel.font = RFONT(14);
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xE6E6E6)];
    }
}

- (NSArray *)titlesArr {
    
    if (!_titlesArr) {
        _titlesArr = @[@"可使用",@"已使用",@"已失效"];
    }
    return _titlesArr;
    
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, kTopNavHeight+60, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -  60 - kTopNavHeight);
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
    
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
