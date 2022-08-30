//
//  CouponMainViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/6.
//

#import "CouponMainViewController.h"
#import "CouponsCenterViewController.h"
#import "UIView+YXAdd.h"
#import "MyCouponsMainViewController.h"
#import "CouponClassifyModel.h"
#import "HYCivicCenterCommand.h"
#import "UIView+YXAdd.h"

@interface CouponMainViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *titlesArr;
@property (nonatomic,strong) UIView *signView;
@property (nonatomic,strong) UIButton *currentTabBtn;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIScrollView *titleScrollView;

@end

@implementation CouponMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"领券中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
}

- (void)loadData {
    ///phone/v1/coupon/getCouponType
    [HttpRequest postPath:@"/phone/v1/coupon/getCouponType" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
       
        SLog(@" 领券分类== %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.titlesArr = [CouponClassifyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self configUI];
        }
        
    }];
    
    
}

- (void)configUI {
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitle:@"我的券" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightbutton.titleLabel.font = RFONT(15);
    rightbutton.frame = CGRectMake(0 , 0, 60, 44);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    spaceItem.width = -15;
    self.navigationItem.rightBarButtonItems = @[spaceItem,rightItem];
    
    [self setupChildsVC];
    
    [self setupTitleSV];
    
}

- (void)setupChildsVC {
    
    for (NSInteger i = 0; i < self.titlesArr.count; i++) {
        CouponClassifyModel *model = self.titlesArr[i];
        CouponsCenterViewController *couponVC = [[CouponsCenterViewController alloc]init];
        couponVC.couponType = model.dictValue;
        [self addChildViewController:couponVC];
        
    }
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.titlesArr.count, 0);
    
}

- (void)setupTitleSV {
    
    UIButton *firstBtn = nil;
    CGFloat btnX = 8;
    for (int i = 0; i < self.titlesArr.count; i++) {
        CouponClassifyModel *classifyModel = self.titlesArr[i];
        NSString *title = classifyModel.dictLabel;
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateSelected];
        button.titleLabel.font = RFONT(14);
        button.tag = 100 + i;
        if (i == 0) {
            firstBtn = button;
        }
        //计算宽
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: RFONT(16)}];
        CGFloat width = titleSize.width+32;
        button.frame = CGRectMake(btnX, 0, width, 46);
        [button addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScrollView addSubview:button];
        btnX += button.frame.size.width;
    }
    
    self.titleScrollView.contentSize = CGSizeMake(btnX, 0);
    
    self.signView = [[UIView alloc]init];
    self.signView.backgroundColor = UIColorFromRGB(0x157AFF);
    self.signView.layer.cornerRadius = 1.5;
    self.signView.clipsToBounds = YES;
    [self.titleScrollView addSubview:self.signView];
    
    CouponClassifyModel *classifyModel = self.titlesArr[0];
    CGSize titleSize = [classifyModel.dictLabel sizeWithAttributes:@{NSFontAttributeName: RFONT(16)}];
    CGFloat width = titleSize.width;
    self.signView.kHeight = 3;
    self.signView.kWidth = width;
    self.signView.kTop = 46;
    self.signView.kCenterX = firstBtn.kCenterX;
//    [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(firstBtn.mas_bottom);
//        make.centerX.equalTo(firstBtn.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(width, 3));
//    }];
    
    [self titleClicked:firstBtn];
    [self setupContentView];
    
}

- (void)setupContentView {
    
    CouponsCenterViewController *couponVC = self.childViewControllers[[self getTheCurrentIndex]];
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
    UIButton *button = [self.titleScrollView viewWithTag:[self getTheCurrentIndex] + 100];
    [self titleClicked:button];
    
}

- (int)getTheCurrentIndex {
    return self.scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
}

// 我的券
- (void)rightClicked {
    
    MyCouponsMainViewController *mainVC = [[MyCouponsMainViewController alloc]init];
    [self.navigationController pushViewController:mainVC animated:YES];
    
}

- (void)titleClicked:(UIButton *)button {
    
    if (button == self.currentTabBtn) return;
    self.currentTabBtn.selected = NO;
    [self setupButton:self.currentTabBtn];
    button.selected = YES;
    self.currentTabBtn = button;
    [self setupButton:self.currentTabBtn];
    
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: RFONT(16)}];
    CGFloat width = titleSize.width;
    [UIView animateWithDuration:0.25 animations:^{
        self.signView.kWidth = width;
        self.signView.kCenterX = button.kCenterX;
    }];
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = [UIScreen mainScreen].bounds.size.width * (button.tag - 100);
    [self.scrollView setContentOffset:offset animated:YES];
    
    
}

- (void)setupButton:(UIButton *)button {
    if (button.selected) {
        button.titleLabel.font = RFONT(16);
        [button setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    } else {
        button.titleLabel.font = RFONT(14);
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    }
}

//- (NSArray *)titlesArr {
//
//    if (!_titlesArr) {
//        _titlesArr = @[@"精选",@"购物优惠券",@"生活优惠券",@"旅游优惠券"];
//    }
//    return _titlesArr;
//
//}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, kTopNavHeight+49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -  49 - kTopNavHeight);
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

- (UIScrollView *)titleScrollView {
    
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] init];
        _titleScrollView.frame = CGRectMake(0, kTopNavHeight,[UIScreen mainScreen].bounds.size.width,49);
        _titleScrollView.backgroundColor = [UIColor whiteColor];
        _titleScrollView.showsVerticalScrollIndicator = NO;
        _titleScrollView.showsHorizontalScrollIndicator = NO;
        _titleScrollView.pagingEnabled = YES;
        _titleScrollView.scrollsToTop = NO;
        _titleScrollView.bounces = YES;
        _titleScrollView.delegate = self;
        [self.view addSubview:_titleScrollView];
    }
    return _titleScrollView;
    
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
