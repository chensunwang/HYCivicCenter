//
//  MyCertificateMainViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/10.
//
//  电子证照页面
/*
#import "MyCertificateMainViewController.h"
#import "CertificateLibraryViewController.h"
#import "HYCivicCenterCommand.h"
#import "UIView+YXAdd.h"
#import "UILabel+XFExtension.h"

@interface MyCertificateMainViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *signView;
@property (nonatomic, strong) UIButton *currentTabBtn;

@end

@implementation MyCertificateMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"电子证照"];
    
    [self configUI];
    
}

- (void)configUI {
    
    [self setupChildsVC];
    [self setupTitilsView];
    
}

- (void)setupChildsVC {
    
    for (NSInteger i = 0; i < self.titlesArr.count; i++) {
        CertificateLibraryViewController *libraryVC = [[CertificateLibraryViewController alloc]init];
        libraryVC.type = i;
        [self addChildViewController:libraryVC];
        
    }
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.titlesArr.count, 0);
    
}

- (void)setupTitilsView {
    
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopNavHeight, [UIScreen mainScreen].bounds.size.width, 49)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    
    UIButton *firstBtn = nil;
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / 2;
    for (int i = 0; i < self.titlesArr.count; i++) {
        NSString *title = self.titlesArr[i];
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = RFONT(14);
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        button.tag = 100 + i;
        if (i == 0) {
            firstBtn = button;
        }
        button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, 46);
        [button addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleView addSubview:button];
    }
    
    self.signView = [[UIView alloc] init];
    self.signView.backgroundColor = UIColorFromRGB(0x157AFF);
    [self.titleView addSubview:self.signView];
    
    [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(firstBtn.mas_centerX);
        make.bottom.equalTo(self.titleView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 3));
    }];
    
    [self titleClicked:firstBtn];
    [self setupContentView];
    
}

- (void)setupContentView {
    
    CertificateLibraryViewController *couponVC = self.childViewControllers[[self getTheCurrentIndex]];
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

- (void)titleClicked:(UIButton *)button {
    
    if (button == self.currentTabBtn) return;
    self.currentTabBtn.selected = NO;
    [self setupButton:self.currentTabBtn];
    button.selected = YES;
    self.currentTabBtn = button;
    [self setupButton:self.currentTabBtn];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.signView.kCenterX = button.kCenterX;
    }];
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = [UIScreen mainScreen].bounds.size.width * (button.tag - 100);
    [self.scrollView setContentOffset:offset animated:YES];
    
    
}

- (void)setupButton:(UIButton *)button {
    if (button.selected) {
        button.titleLabel.font = RFONT(14);
        [button setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    } else {
        button.titleLabel.font = RFONT(14);
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }
}


//- (void)rightClicked {
//
//    NSLog(@"证件");
//
//}

- (NSArray *)titlesArr {
    
    if (!_titlesArr) {
        _titlesArr = @[@"个人证照",@"企业证照"];
    }
    return _titlesArr;
    
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, kTopNavHeight + 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -  49 - kTopNavHeight);
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

@end
*/
