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
#import "HYCivicCenterCommand.h"
#import "UIView+YXAdd.h"

@interface DigitalcitizenViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FaceResultDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

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
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"数字市民"];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self configUI];
    
    [self loadData];
    
    [self setupChildVC];
    
    [self setupTitleView];

}

- (void)faceResult:(NSNotification *)noti {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 人脸识别成功保存
        NSDate *currentDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:@"saveDate"];
        
        NSString *idCard = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYIdCard"];
        NSString *nickname = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYName"];
        NSDictionary *faceDic = noti.object;
        [HttpRequest postPathGov:@"" params:@{@"uri":@"/apiFile/discernFace",@"app":@"ios",@"nickname":nickname,@"idCard":idCard,@"file":faceDic[@"image_string"],@"deviceId":faceDic[@"device_id"],@"skey":faceDic[@"skey"]} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@" 人脸识别== %@ ",responseObject);
            if ([responseObject[@"success"] intValue] == 1) {
                MyCertificateMainViewController *mainVC = [[MyCertificateMainViewController alloc]init];
                [self.navigationController pushViewController:mainVC animated:YES];
            }
        }];
//        [HttpRequest postHttpBodyGov:@"/apiFile/discernFace" params:@{@"app":@"ios",@"nickname":nickname,@"idCard":idCard,@"file":faceDic[@"image_string"],@"deviceId":faceDic[@"device_id"],@"skey":faceDic[@"skey"]} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
//            SLog(@" 人脸识别== %@ ",responseObject);
//            if ([responseObject[@"success"] intValue] == 1) {
//                MyCertificateMainViewController *mainVC = [[MyCertificateMainViewController alloc]init];
//                [self.navigationController pushViewController:mainVC animated:YES];
//            }
//
//        }];
        
//        MyCertificateMainViewController *mainVC = [[MyCertificateMainViewController alloc]init];
//        [self.navigationController pushViewController:mainVC animated:YES];
    });
    
}

- (void)setupChildVC {
    
    CitizenCodeViewController *citizenVC = [[CitizenCodeViewController alloc]init];
    [self addChildViewController:citizenVC];
    
    MetroCodeViewController *metroVC = [[MetroCodeViewController alloc]init];
    [self addChildViewController:metroVC];
    
    BusTransportViewController *busVC = [[BusTransportViewController alloc]init];
    [self addChildViewController:busVC];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    
}

- (void)setupTitleView {
    
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopNavHeight, SCREEN_WIDTH, 50)];
    self.titleView.backgroundColor = UIColorFromRGB(0x157AFF);
    [self.view addSubview:self.titleView];
    
    UIButton *firstBtn = nil;
    CGFloat buttonWidth = SCREEN_WIDTH / 4;
    for (int i = 0; i < self.titleArr.count; i++) {
        NSString *title = self.titleArr[i];
        UIButton *button = [[UIButton alloc]init];
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
    
    self.signView = [[UIView alloc]init];
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
        
        SLog(@" 请求返回== %@ ",responseObject);
        
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
    }else {
        return NO;
    }
    
     
}

- (void)titleClicked:(UIButton *)button {
    
    if (button.tag == 103) {
        
        BOOL isExpire = [self isBetweenSaveDateToExpireDate];
        if (isExpire) {
            MyCertificateMainViewController *mainVC = [[MyCertificateMainViewController alloc]init];
            [self.navigationController pushViewController:mainVC animated:YES];
        }else {
            FaceTipViewController *faceTipVC = [[FaceTipViewController alloc]init];
//            faceTipVC.type = 2;
            faceTipVC.delegate = self;
            [self.navigationController pushViewController:faceTipVC animated:YES];
        }
        
//        CertificateLibraryViewController *libraryVC = [[CertificateLibraryViewController alloc]init];
//        [self.navigationController pushViewController:libraryVC animated:YES];
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
    offset.x = SCREEN_WIDTH * (button.tag - 100);
    [self.scrollView setContentOffset:offset animated:YES];
    
}

#pragma FaceResult
- (void)getFaceResultWithImageStr:(NSString *)imageStr deviceId:(NSString *)deviceid skey:(NSString *)skey {
    
    // 人脸识别成功保存
    NSDate *currentDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:@"saveDate"];
    
    NSString *idCard = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYIdCard"];
    NSString *nickname = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYName"];
    [HttpRequest postPathGov:@"" params:@{@"uri":@"/apiFile/discernFace",@"app":@"ios",@"nickname":nickname,@"idCard":idCard,@"file":imageStr,@"deviceId":deviceid,@"skey":skey} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 人脸识别== %@ ",responseObject);
        if ([responseObject[@"success"] intValue] == 1) {
            MyCertificateMainViewController *mainVC = [[MyCertificateMainViewController alloc]init];
            [self.navigationController pushViewController:mainVC animated:YES];
        }
    }];
    
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
    return self.scrollView.contentOffset.x / SCREEN_WIDTH;
}

- (NSArray *)titleArr {
    
    if (!_titleArr) {
        _titleArr = @[@"市民码",@"地铁码",@"公交码",@"电子证照"];
    }
    return _titleArr;
    
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, kTopNavHeight + 50, SCREEN_WIDTH, SCREEN_HEIGHT -  50 - kTopNavHeight - kBottomTabBarHeight);
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
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 660);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
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
            
            CouponMainViewController *couponVC = [[CouponMainViewController alloc]init];
            [self.navigationController pushViewController:couponVC animated:YES];
            
        }else if (indexPath.row == 1) {
            
            CertificateLibraryViewController *certificateVC = [[CertificateLibraryViewController alloc]init];
            [self.navigationController pushViewController:certificateVC animated:YES];
            
        }else if (indexPath.row == 2) {
            
            MyCouponsMainViewController *mainVC = [[MyCouponsMainViewController alloc]init];
            [self.navigationController pushViewController:mainVC animated:YES];
            
        }else if (indexPath.row == 3) {
            
            MyCertificateMainViewController *mainVC = [[MyCertificateMainViewController alloc]init];
            [self.navigationController pushViewController:mainVC animated:YES];
            
        }else if (indexPath.row == 4) {
            
            HonorWallViewController *wallVC = [[HonorWallViewController alloc]init];
            [self.navigationController pushViewController:wallVC animated:YES];
            
        }else if (indexPath.row == 5) {
            
            MyBusinessCardController *rideVC = [[MyBusinessCardController alloc]init];
            [self.navigationController pushViewController:rideVC animated:YES];
            
        }
        
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 32 - 44*4) / 4, 80);
//    }
    return CGSizeMake((SCREEN_WIDTH - 32) / 2, 64);
    
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

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//
//    //设置导航栏背景图片为一个空的image，这样就透明了
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    //    如果不想让其他页面的导航栏变为透明 需要重置
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
