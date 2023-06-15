//
//  DigitalcitizenViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/4.
//
//  数字市民页面

#import "DigitalcitizenViewController.h"
#import "CertificateCollectionViewCell.h"
#import "ServiceCollectionViewCell.h"
#import "CertificateHomeCollectionReusableView.h"
#import "CouponsCenterViewController.h"
#import "CouponMainViewController.h"
#import "CertificateLibraryViewController.h"
#import "MyCouponsMainViewController.h"
#import "MyCertificateMainViewController.h"
#import "HonorWallViewController.h"
#import "RideRecordViewController.h"
#import "BusinessCardViewController.h"
#import "MyBusinessCardController.h"
#import "ReceiceCardViewController.h"

#import "CitizenCodeViewController.h"
#import "MetroCodeViewController.h"
#import "BusTransportViewController.h"
#import "FaceTipViewController.h"
#import "FaceRecViewController.h"
#import "HYCivicCenterCommand.h"
#import "UIView+YXAdd.h"
#import "UILabel+XFExtension.h"
#import "WechatOpenSDK/WXApi.h"

@interface DigitalcitizenViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FaceResultDelegate, FaceRecResultDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIView *signView;
@property (nonatomic, strong) UIButton *currentBtn;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

NSString *const certificateHomeHeader = @"homeHeader";
NSString *const certificateCell = @"certificateCell";
NSString *const serviceCell = @"serviceCell";

@implementation DigitalcitizenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *titleLabel = [UILabel xf_labelWithText:@"数字市民"];
    if (_hyTitleColor) {
        titleLabel.textColor = _hyTitleColor;
    }
    self.navigationItem.titleView = titleLabel;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        // Fallback on earlier versions
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    [self setupChildVC];
    
    [self setupTitleView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceResult:) name:@"certiFaceResult" object:nil];
    
    [WXApi registerApp:@"wx523265a0e1fc5f22" universalLink:@"https://citybrain.yunshangnc.com/"];

}

- (void)faceResult:(NSNotification *)noti {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 人脸识别成功保存
        NSDate *currentDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:@"saveDate"];
        
        NSString *idCard = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYIdCard"];
        NSString *nickname = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYName"];
        NSDictionary *faceDic = noti.object;
        [HttpRequest postPathGov:@"" params:@{@"uri": @"/apiFile/discernFace", @"app": @"ios", @"nickname": nickname, @"idCard": idCard, @"file": faceDic[@"image_string"], @"deviceId": faceDic[@"device_id"], @"skey": faceDic[@"skey"]} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            NSLog(@" 人脸识别== %@ ", responseObject);
            if ([responseObject[@"success"] intValue] == 1) {
                MyCertificateMainViewController *mainVC = [[MyCertificateMainViewController alloc] init];
                [self.navigationController pushViewController:mainVC animated:YES];
            }
        }];
    });
}

- (void)setupChildVC {
    CitizenCodeViewController *citizenVC = [[CitizenCodeViewController alloc] init];
    citizenVC.hyTitleColor = _hyTitleColor;
    [self addChildViewController:citizenVC];
    
    MetroCodeViewController *metroVC = [[MetroCodeViewController alloc] init];
    metroVC.hyTitleColor = _hyTitleColor;
    [self addChildViewController:metroVC];
    
    BusTransportViewController *busVC = [[BusTransportViewController alloc] init];
    busVC.hyTitleColor = _hyTitleColor;
    [self addChildViewController:busVC];
    
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 0);
}

- (void)setupTitleView {
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopNavHeight, [UIScreen mainScreen].bounds.size.width, 50)];
    self.titleView.backgroundColor = UIColorFromRGB(0x157AFF);
    [self.view addSubview:self.titleView];
    
    UIButton *firstBtn = nil;
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / 4;
    for (int i = 0; i < self.titleArr.count; i++) {
        NSString *title = self.titleArr[i];
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = RFONT(15);
        [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
//        [button setBackgroundColor:UIColorFromRGB(0xE6E6E6)];
//        button.layer.cornerRadius = 16;
//        button.clipsToBounds = YES;
        button.tag = 100 + i;
        if (i == 0) {
            firstBtn = button;
        }
        button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, 47);
        [button addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleView addSubview:button];
    }
    
    self.signView = [[UIView alloc] init];
    self.signView.backgroundColor = [UIColor whiteColor];
    self.signView.layer.cornerRadius = 1.5;
    self.signView.clipsToBounds = YES;
    [self.titleView addSubview:self.signView];
    
    self.signView.kWidth = 50;
    self.signView.kHeight = 3;
    self.signView.kTop = 45;
    self.signView.kCenterX = firstBtn.kCenterX;
    
    [self titleClicked:firstBtn];
    [self setupContentView];
}

- (void)loadData {
    [HttpRequest postPath:@"/phone/v2/getUserByToken" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 请求返回== %@ ", responseObject);
    }];
}

#pragma UIScrollView
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setupContentView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setupContentView];
    UIButton *button = [self.titleView viewWithTag:[self getTheCurrentIndex] + 100];
    [self titleClicked:button];
}

- (BOOL)isBetweenSaveDateToExpireDate {
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,建议大写    HH 使用 24 小时制；hh 12小时制
    [dateFormat setDateFormat:@"yyyy:mm:HH:mm:ss"];
    
    NSDate *saveDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"saveDate"];
    NSDate *expireDate = [NSDate dateWithTimeInterval:60*60 sinceDate:saveDate];
    if ([currentDate compare:saveDate]==NSOrderedDescending && [currentDate compare:expireDate]==NSOrderedAscending) {
        return YES;
    } else {
        return NO;
    }
}

- (void)titleClicked:(UIButton *)button {
    if (button.tag == 103) {
        BOOL isExpire = [self isBetweenSaveDateToExpireDate];
        if (isExpire) {
            MyCertificateMainViewController *mainVC = [[MyCertificateMainViewController alloc] init];
            [self.navigationController pushViewController:mainVC animated:YES];
        } else {
//            FaceTipViewController *faceTipVC = [[FaceTipViewController alloc] init];
//            faceTipVC.delegate = self;
//            [self.navigationController pushViewController:faceTipVC animated:YES];
            FaceRecViewController *vc = [[FaceRecViewController alloc] init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }
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

#pragma FaceResult
- (void)getFaceResultWithImageStr:(NSString *)imageStr deviceId:(NSString *)deviceid skey:(NSString *)skey {
    // 人脸识别成功保存
    NSDate *currentDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:@"saveDate"];
    
    NSString *idCard = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYIdCard"];
    NSString *nickname = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYName"];
    [HttpRequest postPathGov:@"" params:@{@"uri": @"/apiFile/discernFace", @"app": @"ios", @"nickname": nickname ? : @"", @"idCard": idCard ? : @"", @"file": imageStr, @"deviceId": deviceid, @"skey": skey} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 人脸识别== %@ ", responseObject);
        if ([responseObject[@"success"] intValue] == 1) {
            MyCertificateMainViewController *mainVC = [[MyCertificateMainViewController alloc] init];
            [self.navigationController pushViewController:mainVC animated:YES];
        }
    }];
}

#pragma mark - FaceRecResultDelegate

- (void)getFaceResult:(BOOL)result {
    if (result) {
        MyCertificateMainViewController *mainVC = [[MyCertificateMainViewController alloc] init];
        [self.navigationController pushViewController:mainVC animated:YES];
    }
}

- (void)setupButton:(UIButton *)button {
    if (button.selected) {
        button.titleLabel.font = RFONT(15);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        button.titleLabel.font = RFONT(15);
        [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    }
}

- (void)setupContentView {
    UIViewController *currentVC = self.childViewControllers[[self getTheCurrentIndex]];
    if (currentVC.isViewLoaded) {
        return;
    }
    UIView *view = currentVC.view;
    view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:view];
}

- (int)getTheCurrentIndex {
    return self.scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"市民码", @"地铁码", @"公交码", @"电子证照"];
    }
    return _titleArr;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, kTopNavHeight + 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -  50 - kTopNavHeight - kBottomTabBarHeight);
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

#pragma old
- (void)configUI {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 660);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[CertificateHomeCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:certificateHomeHeader];
    [self.collectionView registerClass:[CertificateCollectionViewCell class] forCellWithReuseIdentifier:certificateCell];
    [self.collectionView registerClass:[ServiceCollectionViewCell class] forCellWithReuseIdentifier:serviceCell];
}

#pragma UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//
//        CertificateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:certificateCell forIndexPath:indexPath];
//        return cell;
//
//    }else {
//
//        ServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:serviceCell forIndexPath:indexPath];
//        return cell;
//
//    }
    
    ServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:serviceCell forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CertificateHomeCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:certificateHomeHeader forIndexPath:indexPath];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CouponMainViewController *couponVC = [[CouponMainViewController alloc] init];
            [self.navigationController pushViewController:couponVC animated:YES];
        } else if (indexPath.row == 1) {
            CertificateLibraryViewController *certificateVC = [[CertificateLibraryViewController alloc] init];
            [self.navigationController pushViewController:certificateVC animated:YES];
        } else if (indexPath.row == 2) {
            MyCouponsMainViewController *mainVC = [[MyCouponsMainViewController alloc] init];
            [self.navigationController pushViewController:mainVC animated:YES];
        } else if (indexPath.row == 3) {
            MyCertificateMainViewController *mainVC = [[MyCertificateMainViewController alloc] init];
            [self.navigationController pushViewController:mainVC animated:YES];
        } else if (indexPath.row == 4) {
            HonorWallViewController *wallVC = [[HonorWallViewController alloc] init];
            [self.navigationController pushViewController:wallVC animated:YES];
        } else if (indexPath.row == 5) {
            MyBusinessCardController *rideVC = [[MyBusinessCardController alloc] init];
            [self.navigationController pushViewController:rideVC animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 32) / 2, 64);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    // 上下
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 16, 0, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
    
}

@end
