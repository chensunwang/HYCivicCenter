//
//  HYSpecialServiceViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/14.
//
//  专项服务页面

#import "HYSpecialServiceViewController.h"
#import "HYSpecialServiceContentController.h"
#import "XFUDButton.h"
#import "XFSpecialButton.h"
#import "HYServiceContentTableViewCell.h"
#import "UIButton+WebCache.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"
#import "UILabel+XFExtension.h"

@interface HYSpecialServiceViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) XFSpecialButton *currentTabBtn;

@end

@implementation HYSpecialServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"专项服务"];
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

- (void)setHeaderArr:(NSArray *)headerArr {
    _headerArr = headerArr;
    
    [self configUI];
}

- (void)configUI {
    [self setupChildVC];
    
    [self setupTitlesView];
}

- (void)setupChildVC {
    for (NSInteger i = 0; i < self.headerArr.count; i++) {
        HYServiceContentModel *serviceModel = self.headerArr[i];
        HYSpecialServiceContentController *contentVC = [[HYSpecialServiceContentController alloc] init];
        contentVC.contentModel = serviceModel;
        contentVC.isEnterprise = _isEnterprise;
        [self addChildViewController:contentVC];
    }
    self.scrollView.contentSize = CGSizeMake(self.headerArr.count * [UIScreen mainScreen].bounds.size.width, 0);
}

- (void)setupTitlesView {
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopNavHeight, [UIScreen mainScreen].bounds.size.width, 90)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    
    XFSpecialButton *firstBtn = nil;
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / self.headerArr.count;
    
    for (NSInteger i = 0; i < self.headerArr.count; i++) {
        HYServiceContentModel *contentModel = self.headerArr[i];
        XFSpecialButton *button = [[XFSpecialButton alloc] init];
        [button.headerIV sd_setImageWithURL:[NSURL URLWithString:contentModel.logoUrl]];
        button.nameLabel.text = contentModel.specialName;
        button.nameLabel.textColor = UIColorFromRGB(0x212121);
        button.tag = 100 + i;
        if (i == self.index) {
            firstBtn = button;
        }
        button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, 90);
        [button addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleView addSubview:button];
    }
    
    [self titleClicked:firstBtn];
    [self setupContentView];
}

#pragma Clicked
- (void)titleClicked:(XFSpecialButton *)button {
    if (button == self.currentTabBtn) return;
    self.currentTabBtn = button;
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = [UIScreen mainScreen].bounds.size.width * (button.tag - 100);
    [self.scrollView setContentOffset:offset animated:YES];
}

- (void)setupContentView {
    HYSpecialServiceContentController *couponVC = self.childViewControllers[[self getTheCurrentIndex]];
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

- (int)getTheCurrentIndex {
    return self.scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
}

- (NSArray *)titlesArr {
    if (!_titlesArr) {
        _titlesArr = @[@"社保服务", @"公积金服务", @"住房服务", @"行政审批服务"];
    }
    return _titlesArr;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, kTopNavHeight + 90, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -  90 - kTopNavHeight);
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
