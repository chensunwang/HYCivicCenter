//
//  HYOnLineBusinessMainViewController.m
//  HelloFrame
//
//  Created by nuchina on 2022/1/7.
//
//  办事详情页

#import "HYOnLineBusinessMainViewController.h"
#import "HYOnLineHandleViewController.h"
#import "HYCommonProblemViewController.h"
#import "HYHandleGuideViewController.h"
#import "HYItemTotalInfoModel.h"
#import "HYCivicCenterCommand.h"
#import "UIView+YXAdd.h"
#import "UILabel+XFExtension.h"

@interface HYOnLineBusinessMainViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) UIButton * firstBtn;
@property (nonatomic, strong) UIView * signView;
@property (nonatomic, strong) UIButton * currentBtn;
@property (nonatomic, strong) HYOnLineHandleViewController * onlineVC;  // 在线办理vc
@property (nonatomic, strong) HYHandleGuideViewController * guideVC;  // 办理指南vc
@property (nonatomic, strong) HYCommonProblemViewController * problemVC;  // 常见问题vc
@property (nonatomic, strong) UIButton * collectionBtn;
@property (nonatomic, strong) NSMutableArray * onLineDataArray;
@property (nonatomic, strong) NSMutableArray * guideDataArray;
@property (nonatomic, strong) NSMutableArray * problemDataArray;

@property (nonatomic, copy) NSString * titleString;
@property (nonatomic, copy) NSString * itemCode;
@property (nonatomic, copy) NSString * eventName;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HYOnLineBusinessMainViewController

- (void)loadView {
    [super loadView];
    
    self.onlineVC = [[HYOnLineHandleViewController alloc] init];
//    self.onlineVC.affairsModel = _affairsModel;
//    self.onlineVC.infoModel = _infoModel;
    self.onlineVC.hyTitleColor = _hyTitleColor;
    self.onlineVC.itemCode = _itemCode;
    [self addChildViewController:_onlineVC];
    
    self.guideVC = [[HYHandleGuideViewController alloc] init];
    self.guideVC.itemCode = _itemCode;
    [self addChildViewController:_guideVC];
    
    self.problemVC = [[HYCommonProblemViewController alloc] init];
    self.problemVC.itemCode = _itemCode;
    [self addChildViewController:_problemVC];
    
    self.titleView = [[UIView alloc] init];
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.height.mas_equalTo(47);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / 3.0;
    for (int i = 0; i < self.titleArr.count; i++) {
        NSString *title = self.titleArr[i];
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = MFONT(15);
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        button.tag = 100 + i;
        if (i == 0) {
            self.firstBtn = button;
        }
        button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, 46);
        [button addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleView addSubview:button];
    }
    
    self.signView = [[UIView alloc] init];
    [self.titleView addSubview:self.signView];
    [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.firstBtn.mas_centerX);
        make.bottom.equalTo(self.titleView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(60, 3));
    }];
    
    self.collectionBtn = [[UIButton alloc] init];
    [self.view addSubview:self.collectionBtn];
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-160);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectionBtn setTitle:@"取消收藏" forState:UIControlStateSelected];
    self.collectionBtn.titleLabel.font = RFONT(14);
    self.collectionBtn.titleLabel.numberOfLines = 0;
    self.collectionBtn.layer.cornerRadius = 25;
    self.collectionBtn.clipsToBounds = YES;
    [self.collectionBtn addTarget:self action:@selector(collectionClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel = [UILabel xf_labelWithText:_titleString];
    if (_hyTitleColor) {
        self.titleLabel.textColor = _hyTitleColor;
    }
    self.navigationItem.titleView = _titleLabel;
    
    [self titleClicked:self.firstBtn];
    [self setupContentView];
    [self loadData];
    [self traitCollectionDidChange:nil];
}

- (void)setServiceModel:(HYHotServiceModel *)serviceModel {
    if (serviceModel) {
        _serviceModel = serviceModel;
        self.titleString = serviceModel.name;
        self.itemCode = serviceModel.code;
        self.eventName = serviceModel.name;
    }
}

- (void)setAffairsModel:(HYHotHandleAffairsModel *)affairsModel {
    if (affairsModel) {
        _affairsModel = affairsModel;
        self.titleString = affairsModel.hotName;
        self.itemCode = affairsModel.hotItemId;
        self.eventName = affairsModel.hotName;
    }
}

- (void)setInfoModel:(HYBusinessInfoModel *)infoModel {
    if (infoModel) {
        _infoModel = infoModel;
        self.titleString = infoModel.name;
        self.itemCode = infoModel.code;
        self.eventName = infoModel.name;
    }
}

- (void)setMyServiceModel:(HYMyServiceModel *)myServiceModel {
    if (myServiceModel) {
        _myServiceModel = myServiceModel;
        self.titleString = myServiceModel.eventName;
        self.itemCode = myServiceModel.eventCode;
        self.eventName = myServiceModel.eventName;
    }
}

- (void)setBusinessModel:(HYGuessBusinessModel *)businessModel {
    if (businessModel) {
        _businessModel = businessModel;
        self.titleString = businessModel.name;
        self.itemCode = businessModel.code;
        self.eventName = businessModel.name;
    }
}

- (void)loadData234 {
    [HttpRequest getPathZWBS:@"phone/item/event/getItemInfoByItemCode" params:@{@"itemCode": _itemCode} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 办事指南 == %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            
        } else {
            SLog(@"%@", responseObject[@"msg"]);
        }
    }];
}

- (void)loadData { // 判断是否收藏   /city/4AItems/event/collect/checkCollect
    [HttpRequest postHttpBodyZWBS:@"city/4AItems/event/collect/checkCollect" params:@{@"eventCode": _itemCode, @"eventName":_eventName} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@"判断是否收藏== %@", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            if ([responseObject[@"data"] intValue] == 0) {  // 未收藏
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.collectionBtn.selected = NO;
                    [self.collectionBtn setBackgroundColor:UIColorFromRGB(0xFF8F1F)];
                });
            } else {  // 已收藏
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.collectionBtn.selected = YES;
                    [self.collectionBtn setBackgroundColor:UIColorFromRGB(0xE5F1FF)];
                });
            }
        }
    }];
}

- (void)requestCollection {  // 点击收藏  /city/4AItems/event/collect/collectItem
    [HttpRequest postHttpBodyZWBS:@"city/4AItems/event/collect/collectItem" params:@{@"eventCode": _itemCode, @"eventName": _eventName} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@"点击收藏== %@", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.collectionBtn.selected = YES;
                [self.collectionBtn setBackgroundColor:UIColorFromRGB(0xE5F1FF)];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            });
        }
    }];
}

- (void)requestCancelCollection {  // 取消收藏  /city/4AItems/event/collect/cancelCollect
    [HttpRequest postHttpBodyZWBS:@"city/4AItems/event/collect/cancelCollect" params:@{@"eventCode": _itemCode} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@"取消收藏== %@", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.collectionBtn.selected = NO;
                [self.collectionBtn setBackgroundColor:UIColorFromRGB(0xFF8F1F)];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            });
        }
    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.signView.backgroundColor = UIColorFromRGB(0x157AFF);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    if (_collectionBtn.isSelected) {
        [self.collectionBtn setBackgroundColor:UIColorFromRGB(0xE5F1FF)];
    } else {
        [self.collectionBtn setBackgroundColor:UIColorFromRGB(0xFF8F1F)];
    }
    [self.collectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.collectionBtn setTitleColor:UIColorFromRGB(0x126AFB) forState:UIControlStateSelected];
}

- (void)setupContentView {
    UIViewController *contentVC = self.childViewControllers[[self getTheCurrentIndex]];
    if (contentVC.isViewLoaded) {
        return;
    }
    UIView *view = contentVC.view;
    view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:view];
}

- (int)getTheCurrentIndex {
    return self.scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
}

#pragma UIScrollView
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setupContentView];
}

// 收藏/取消收藏
- (void)collectionClicked:(UIButton *)sender {
    if (!sender.selected) {
        [self requestCollection];
    } else {
        [self requestCancelCollection];
    }
}

- (void)titleClicked:(UIButton *)button {
    if (button == self.currentBtn) return;
    self.currentBtn.selected = NO;
    [self setupButton:self.currentBtn];
    button.selected = YES;
    self.currentBtn = button;
    [self setupButton:self.currentBtn];
    
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
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"在线办理", @"办理指南", @"常见问题"];
    }
    return _titleArr;
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
