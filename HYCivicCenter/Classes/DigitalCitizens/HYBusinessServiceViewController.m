//
//  HYBusinessServiceViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/18.
//

#import "HYBusinessServiceViewController.h"
#import "HYServiceContentController.h"
#import "HYServiceClassifyModel.h"
#import "HYCivicCenterCommand.h"
#import "UIView+YXAdd.h"
#import "UILabel+XFExtension.h"
#import "UILabel+XFExtension.h"

@interface HYBusinessServiceViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *titlesArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *signView;
@property (nonatomic, strong) UIButton *currentTabBtn;

@end

@implementation HYBusinessServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:self.serviceName];
    
//    [self configUI];
    
    [self loadData];
    
}

- (void)loadData {
    
    [HttpRequest getPath:@"/phone/v2/service/getAvailableService" params:@{@"parentId":self.serviceID} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 服务列表== %@ ",responseObject);
        // 没有titleView，单个列表
        self.titlesArr = [HYServiceClassifyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self configUI];
    }];
    
}

- (void)configUI {
    
    if (self.titlesArr.count == 0) {
        return;
    }
    [self setupChildVC];
    
    if (self.titlesArr.count > 1) {
        [self setupTitlesView];
        self.scrollView.frame = CGRectMake(0, kTopNavHeight + 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -  49 - kTopNavHeight);
    }else {
        self.scrollView.frame = CGRectMake(0, kTopNavHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - kTopNavHeight);
        [self setupContentView];
    }
    
}

- (void)setupChildVC {
    
    for (NSInteger i = 0; i < self.titlesArr.count; i++) {
        
        HYServiceClassifyModel *classifyModel = self.titlesArr[i];
        HYServiceContentController *contentVC = [[HYServiceContentController alloc]init];
        contentVC.datasArr = classifyModel.children;
        [self addChildViewController:contentVC];
        
    }
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.titlesArr.count, 0);
    
}

- (void)setupTitlesView {
    
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopNavHeight, [UIScreen mainScreen].bounds.size.width, 49)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    
    UIButton *firstBtn = nil;
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / self.titlesArr.count;
    for (int i = 0; i < self.titlesArr.count; i++) {
//        NSString *title = self.titlesArr[i];
        HYServiceClassifyModel *classifyModel = self.titlesArr[i];
        NSString *title = classifyModel.serviceName;
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
    
    self.signView = [[UIView alloc]init];
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
    
    HYServiceContentController *couponVC = self.childViewControllers[[self getTheCurrentIndex]];
    if (couponVC.isViewLoaded) {
        return;
    }
    UIView *view = couponVC.view;
    view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:view];
    
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

//- (NSArray *)titlesArr {
//
//    if (!_titlesArr) {
//        _titlesArr = @[@"毕业生服务",@"社会服务"];
//    }
//    return _titlesArr;
//
//}

- (NSMutableArray *)titlesArr {
    
    if (!_titlesArr) {
        _titlesArr = [NSMutableArray array];
    }
    return _titlesArr;
    
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
//        _scrollView.frame = CGRectMake(0, kTopNavHeight + 49, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -  49 - kTopNavHeight);
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
