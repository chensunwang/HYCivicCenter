//
//  HYServiceProgressViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/13.
//
//  进度跟踪页面

#import "HYServiceProgressViewController.h"
#import "HYServiceProgressContentController.h"
#import "HYCivicCenterCommand.h"
#import "UIView+YXAdd.h"
#import "UILabel+XFExtension.h"

@interface HYServiceProgressViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *signView;
@property (nonatomic, strong) UIButton *currentTabBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HYServiceProgressViewController

- (void)loadView {
    [super loadView];
    
    for (NSInteger i = 0; i < self.titlesArr.count; i++) {
        HYServiceProgressContentController *contentVC = [[HYServiceProgressContentController alloc] init];
        contentVC.hyTitleColor = _hyTitleColor;
        contentVC.type = i;
        [self addChildViewController:contentVC];
    }
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, kTopNavHeight + 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -  49 - kTopNavHeight);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.titlesArr.count, 0);
    [self.view addSubview:_scrollView];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopNavHeight, [UIScreen mainScreen].bounds.size.width, 49)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    
    UIButton *firstBtn = nil;
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / self.titlesArr.count;
    for (NSInteger i = 0; i < self.titlesArr.count; i++) {
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:self.titlesArr[i] forState:UIControlStateNormal];
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
    [self.titleView addSubview:self.signView];
    
    [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(firstBtn.mas_centerX);
        make.bottom.equalTo(self.titleView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 3));
    }];

    [self titleClicked:firstBtn];
    [self setupContentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel = [UILabel xf_labelWithText:@"进度跟踪"];
    if (_hyTitleColor) {
        self.titleLabel.textColor = _hyTitleColor;
    }
    self.navigationItem.titleView = _titleLabel;
    
    [self traitCollectionDidChange:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.signView.backgroundColor = UIColorFromRGB(0x157AFF);
}

#pragma Clicked
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

- (void)setupContentView {
    HYServiceProgressContentController *couponVC = self.childViewControllers[[self getTheCurrentIndex]];
    if (couponVC.isViewLoaded) {
        return;
    }
    UIView *view = couponVC.view;
    view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:view];
}

- (void)setupButton:(UIButton *)button {
    if (button.selected) {
        button.titleLabel.font = RFONT(15);
        [button setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    } else {
        button.titleLabel.font = RFONT(15);
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
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

- (NSArray *)titlesArr {
    if (!_titlesArr) {
        _titlesArr = @[@"个人服务", @"企业服务"];
    }
    return _titlesArr;
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
