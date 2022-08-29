//
//  RechargeViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/27.
//

#import "RechargeViewController.h"
#import "RechargeCollectionViewCell.h"
#import "RechargeResultController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HYCivicCenterCommand.h"

@interface RechargeViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,RechargeDelegate>

@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UITextField *rechargeTF;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, copy) NSString *rechargeAmt;
@property (nonatomic, copy) NSString *orderNo;

@end

NSString *const rechargeCell = @"rechargeCell";
@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.title = @"我的余额";
    
    [self configUI];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rechargeNoti:) name:@"RechargeAmt" object:nil];
    
}

// 充值完成通知
- (void)rechargeNoti:(NSNotification *)noti {
    
    //查询充值结果
    NSString *queryUrl = [NSString stringWithFormat:@"/api/hcard/query/payOrder/%@",self.orderNo];
    [HttpRequest getPathBus:@"" params:@{@"uri":queryUrl} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
       
        NSLog(@" 查询充值结果 === %@ ",responseObject);
        if ([responseObject[@"success"] intValue] == 1) {
            
            NSString *urlString = [NSString stringWithFormat:@"/api/hcard/payOrder/%@",self.orderNo];
            [HttpRequest getPathBus:@"" params:@{@"uri":urlString} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
                NSLog(@" 分配金额== %@ ",responseObject);
                if ([responseObject[@"success"] intValue] == 1) {
                    
                    RechargeResultController *resultVC = [[RechargeResultController alloc]init];
                    resultVC.type = 1;
                    resultVC.delegate = self;
                    [self.navigationController pushViewController:resultVC animated:YES];
                    
                }else {
                    
                    RechargeResultController *resultVC = [[RechargeResultController alloc]init];
                    resultVC.type = 0;
                    resultVC.delegate = self;
                    [self.navigationController pushViewController:resultVC animated:YES];
                    
                }
            }];
            
        }
    }];
    
}

- (void)loadData {
    
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit",@"eventId": @"E0062",@"applicationId":@"H024"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ",responseObject);
    }];
    
    // 二维码账号信息查询  返回洪城一卡通账户信息
    [HttpRequest postPathBus:@"" params:@{@"uri":@"/api/hcard/query/account"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSLog(@" 账户查询== %@ ",responseObject);
        if ([responseObject[@"success"] intValue] == 1) {
            self.moneyLabel.text = [NSString stringWithFormat:@"%@元",responseObject[@"data"][@"cardBalance"]];
//            responseObject[@"data"][@"cardNo"] 卡号
        }
        
    }];
    
    
    // 查询充值订单结果
//    [HttpRequest getPathBus:@"/api/hcard/query/payOrder" params:@{@"orderNo":@"123124124"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
//
//        NSLog(@" 查询充值结果 == %@",responseObject);
//
//    }];
    
}

- (void)configUI {
    
    UIImageView *bgIV = [[UIImageView alloc]init];
    bgIV.image = [UIImage imageNamed:@"balanceBg"];
    [self.view addSubview:bgIV];
    
    UIView *balanceView = [[UIView alloc]init];
    balanceView.backgroundColor = [UIColor whiteColor];
    balanceView.layer.cornerRadius = 8;
    balanceView.clipsToBounds = YES;
    [self.view addSubview:balanceView];
    
    UILabel *balanceLabel = [[UILabel alloc]init];
    balanceLabel.textColor = UIColorFromRGB(0x666666);
    balanceLabel.font = RFONT(12);
    balanceLabel.text = @"当前余额（元）";
    [balanceView addSubview:balanceLabel];
    
    self.moneyLabel = [[UILabel alloc]init];
    self.moneyLabel.textColor = UIColorFromRGB(0x333333);
    self.moneyLabel.font = BFONT(24);
    self.moneyLabel.text = @"0元";
    [balanceView addSubview:self.moneyLabel];
    
    UIImageView *balanceIV = [[UIImageView alloc]init];
    balanceIV.image = [UIImage imageNamed:@"money"];
    [balanceView addSubview:balanceIV];
    
    UIView *rechargeView = [[UIView alloc]init];
    rechargeView.backgroundColor = [UIColor whiteColor];
    rechargeView.layer.cornerRadius = 8;
    rechargeView.clipsToBounds = YES;
    [self.view addSubview:rechargeView];
    
    UILabel *rechargeLabel = [[UILabel alloc]init];
    rechargeLabel.text = @"充值金额";
    rechargeLabel.font = RFONT(15);
    rechargeLabel.textColor = UIColorFromRGB(0x333333);
    [rechargeView addSubview:rechargeLabel];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 40)];
    leftView.backgroundColor = [UIColor whiteColor];
    self.rechargeTF = [[UITextField alloc]init];
    self.rechargeTF.layer.borderWidth = 0.5;
    self.rechargeTF.layer.borderColor = UIColorFromRGB(0xCFD8E6).CGColor;
    self.rechargeTF.layer.cornerRadius = 4;
    self.rechargeTF.clipsToBounds = YES;
    self.rechargeTF.placeholder = @"请输入充值金额";
    self.rechargeTF.keyboardType = UIKeyboardTypeNumberPad;
    self.rechargeTF.leftView = leftView;
    self.rechargeTF.leftViewMode = UITextFieldViewModeAlways;
    [rechargeView addSubview:self.rechargeTF];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[RechargeCollectionViewCell class] forCellWithReuseIdentifier:rechargeCell];
    
    UIButton *rechargeBtn = [[UIButton alloc]init];
    [rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    rechargeBtn.layer.cornerRadius = 8;
    rechargeBtn.clipsToBounds = YES;
    [rechargeBtn setBackgroundColor:UIColorFromRGB(0x157AFF)];
    [rechargeBtn addTarget:self action:@selector(rechargeClicked) forControlEvents:UIControlEventTouchUpInside];
    [rechargeView addSubview:rechargeBtn];
    
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.height.mas_equalTo(85);
    }];
    
    [balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight + 16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.mas_equalTo(100);
    }];
    
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(balanceView.mas_left).offset(25);
        make.top.equalTo(balanceView.mas_top).offset(25);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(balanceView.mas_left).offset(25);
        make.top.equalTo(balanceLabel.mas_bottom).offset(18);
    }];
    
    [balanceIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(balanceView.mas_centerY);
        make.right.equalTo(balanceView.mas_right).offset(-25);
        make.size.mas_equalTo(CGSizeMake(48, 53));
    }];
    
    [rechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.top.equalTo(balanceView.mas_bottom).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.mas_equalTo(340);
    }];
    
    [rechargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeView.mas_left).offset(16);
        make.top.equalTo(rechargeView.mas_top).offset(16);
    }];
    
    [self.rechargeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeView.mas_left).offset(16);
        make.top.equalTo(rechargeLabel.mas_bottom).offset(16);
        make.right.equalTo(rechargeView.mas_right).offset(-16);
        make.height.mas_equalTo(40);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeView.mas_left).offset(16);
        make.top.equalTo(self.rechargeTF.mas_bottom).offset(20);
        make.right.equalTo(rechargeView.mas_right).offset(-16);
        make.height.mas_equalTo(148);
    }];
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeView.mas_left).offset(32);
        make.right.equalTo(rechargeView.mas_right).offset(-32);
        make.bottom.equalTo(rechargeView.mas_bottom).offset(-32);
        make.height.mas_equalTo(46);
    }];
    
}

#pragma UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 5;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RechargeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:rechargeCell forIndexPath:indexPath];
    
    NSArray *namesArr = @[@"10元",@"20元",@"50元",@"100元",@"200元"];
    cell.nameLabel.text = namesArr[indexPath.row];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *amtArr = @[@"10",@"20",@"50",@"100",@"200"];
    self.rechargeAmt = amtArr[indexPath.row];
    
}

// 立即充值
- (void)rechargeClicked {
    
//    RechargeResultController *resultVC = [[RechargeResultController alloc]init];
//    [self.navigationController pushViewController:resultVC animated:YES];
    if (self.rechargeTF.text.length > 0) {
        self.rechargeAmt = self.rechargeTF.text;
    }
    if (self.rechargeAmt.length == 0) {
        NSLog(@" 请先输入充值金额或选择需要充值的金额 ");
        return;
    }
    
    // 创建充值订单  返回orderinfo调起支付宝
    [HttpRequest postPathBus:@"" params:@{@"uri":@"/api/hcard/create/payOrder",@"orderAmt":self.rechargeAmt,@"payType":@"01"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if ([responseObject[@"success"] intValue] == 1) {
            self.orderNo = responseObject[@"data"][@"orderNo"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AlipaySDK defaultService]payOrder:responseObject[@"data"][@"orderInfo"][@"ali_order_info"] fromScheme:@"nccb" callback:nil];
            });
        }
    }];
    
    
}

#pragma Recharge
- (void)rechargeReload {
    
    [self loadData];
    
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
    
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 16;
        _flowLayout.minimumLineSpacing = 16;
        CGFloat itemW = (SCREEN_WIDTH - 32 - 64)/ 3.0;
        CGFloat itemH = 50;
        _flowLayout.itemSize = CGSizeMake(itemW, itemH);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
    
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
