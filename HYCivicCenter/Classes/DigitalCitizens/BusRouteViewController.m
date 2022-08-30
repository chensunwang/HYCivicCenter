//
//  BusRouteViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/10/25.
//

#import "BusRouteViewController.h"
#import "BusRouteCollectionViewCell.h"
#import "BusRouteBusCollectionViewCell.h"
#import "CommintStationView.h"
#import "XFUDButton.h"
#import "HYSearchStationModel.h"
#import "HYBusinfoModel.h"
#import "HYCivicCenterCommand.h"

@interface BusRouteViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *datasArr; // 站点数组
@property (nonatomic, strong) NSMutableArray *busInfoArr;  // 正在运营的公交
@property (nonatomic, strong) NSMutableArray *willArriveBusArr; // 将要到达的公交
@property (nonatomic, strong) UIView *busInfoView;
@property (nonatomic, strong) UIView *commingBusView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *busHolderLabel;
@property (nonatomic, strong) UILabel *directionLabel;
@property (nonatomic, strong) UILabel *endStationLabel;
@property (nonatomic, strong) UIImageView *startIV;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UIImageView *endIV;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, assign) NSInteger currentDirection;

@end

NSString *const busRouteCell = @"routeCell";
NSString *const busRouteBusCell = @"routeBusCell";
@implementation BusRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"公交线路";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self configUI];
    
    [self loadDataWithUpOrDown:self.isUpDown];
    
    [self pointData];
    
}

- (void)pointData {
    
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit",@"eventId": @"E0064",@"applicationId":@"H026"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ",responseObject);
    }];
    
}

- (void)loadDataWithUpOrDown:(NSString *)upordown {
    
    self.currentDirection = upordown.intValue;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HttpRequest getPath:@"/phone/v2/bus/getBusLine" params:@{@"lineNo":self.lineNo,@"upOrDown":@(self.currentDirection)} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@" 公交站点== %@ ",responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                self.datasArr = [HYSearchStationModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                if (self.datasArr.count > 1) {
                    HYSearchStationModel *firstStaionModel = [self.datasArr firstObject];
                    HYSearchStationModel *lastStationModel = [self.datasArr lastObject];
                    self.directionLabel.text = [NSString stringWithFormat:@"方向：%@",firstStaionModel.stationName];
                    self.endStationLabel.text = lastStationModel.stationName;
                    self.title = firstStaionModel.lineName;
                }
                
                [self.datasArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    HYSearchStationModel *stationModel = obj;
                    if ([stationModel.stationName isEqualToString:self.stationName]) {
                        stationModel.currentBus = @"1";
                    }
                }];
                dispatch_group_leave(group);
            }
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [HttpRequest getPath:@"/phone/v2/bus/getBusRunList" params:@{@"lineNo":self.lineNo,@"upOrDown":@(self.currentDirection),@"stationName":self.stationName?:@""} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@"当前线路运行的车辆 == %@",responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                self.busInfoArr = [HYBusinfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"allBus"]];
                self.willArriveBusArr = [HYBusinfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"willArriveBus"]];
                if (responseObject[@"data"][@"busLineDetail"] && [responseObject[@"data"][@"busLineDetail"] allKeys].count != 0) {
                    self.startIV.hidden = NO;
                    self.startTimeLabel.text = responseObject[@"data"][@"busLineDetail"][@"firstBusTime"];
                    self.endIV.hidden = NO;
                    self.endTimeLabel.text = responseObject[@"data"][@"busLineDetail"][@"lastBusTime"];
                }
//                NSInteger  (((a)>(b))?(b):(a))
                NSInteger count = self.willArriveBusArr.count > 3 ? 3 : self.willArriveBusArr.count;
                
                CGFloat buttonWidth = ([UIScreen mainScreen].bounds.size.width - 32) / count;
                for (NSInteger i = 0; i < count; i++) {
                    HYBusinfoModel *busModel = self.willArriveBusArr[i];
                    CommintStationView *stationView = [[CommintStationView alloc]init];
                    stationView.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, 100);
                    
                    NSString *stationNum = @"最近一辆";
                    if (i == 1) {
                        stationNum = @"第二辆车";
                    }else if (i == 2) {
                        stationNum = @"第三辆车";
                    }
                    
                    NSString *distance = @"";
                    if (busModel.distanceMeter.intValue > 0 && busModel.distanceMeter.intValue < 1000) {
                        distance = [NSString stringWithFormat:@"%@m",busModel.distanceMeter];
                    }else {
                        distance = [NSString stringWithFormat:@"%.fkm",busModel.distanceMeter.intValue / 1000.0];
                    }
                    [stationView setTimeString:busModel.arriveNowStationNeedMinute speed:[NSString stringWithFormat:@"%@站/%@",busModel.arriveNowStationNumber,distance] stationNum:stationNum];
                    [self.commingBusView addSubview:stationView];
                    
                }
                dispatch_group_leave(group);
            }
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@" 刷新UI ");
        [self.datasArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HYSearchStationModel *stationModel = obj;
            
            [self.busInfoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  
                HYBusinfoModel *busInfoModel = obj;
                if ([stationModel.labelNo isEqualToString:@(abs(busInfoModel.stationNo.intValue)).stringValue]) {
                    stationModel.stationHaveCar = @"1";
                }
                
                
            }];
            
            
        }];
        [self.collectionView reloadData];
    });
    
}

- (void)configUI {
    
    [self configBusInfoView];
    [self configCommingStationView];
    [self configBottomView];

    [self.collectionView registerClass:[BusRouteBusCollectionViewCell class] forCellWithReuseIdentifier:busRouteBusCell];
    [self.collectionView registerClass:[BusRouteCollectionViewCell class] forCellWithReuseIdentifier:busRouteCell];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commingBusView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
}

- (void)configBusInfoView {
    
    self.busInfoView = [[UIView alloc]init];
    [self.view addSubview:self.busInfoView];
    
    self.directionLabel = [[UILabel alloc]init];
    self.directionLabel.textColor = UIColorFromRGB(0x212121);
    self.directionLabel.font = RFONT(15);
    [self.busInfoView addSubview:self.directionLabel];
    
    UIImageView *turnToIV = [[UIImageView alloc]init];
    turnToIV.image = [UIImage imageNamed:@"turnTo"];
    [self.busInfoView addSubview:turnToIV];
    
    self.endStationLabel = [[UILabel alloc]init];
    self.endStationLabel.textColor = UIColorFromRGB(0x212121);
    self.endStationLabel.font = RFONT(15);
    [self.busInfoView addSubview:self.endStationLabel];
    
    self.startIV = [[UIImageView alloc]init];
    self.startIV.image = [UIImage imageNamed:@"busStart"];
    self.startIV.hidden = YES;
    [self.busInfoView addSubview:self.startIV];
    
    self.startTimeLabel = [[UILabel alloc]init];
    self.startTimeLabel.textColor = UIColorFromRGB(0x999999);
    self.startTimeLabel.font = RFONT(12);
    [self.busInfoView addSubview:self.startTimeLabel];
    
    self.endIV = [[UIImageView alloc]init];
    self.endIV.image = [UIImage imageNamed:@"busEnd"];
    self.endIV.hidden = YES;
    [self.busInfoView addSubview:self.endIV];
    
    self.endTimeLabel = [[UILabel alloc]init];
    self.endTimeLabel.textColor = UIColorFromRGB(0x999999);
    self.endTimeLabel.font = RFONT(12);
    [self.busInfoView addSubview:self.endTimeLabel];
    
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.textColor = UIColorFromRGB(0x999999);
    self.priceLabel.font = RFONT(12);
    [self.busInfoView addSubview:self.priceLabel];
    
    [self.busInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.height.mas_equalTo(80);
    }];
    
    [self.directionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.busInfoView.mas_left).offset(19);
        make.top.equalTo(self.busInfoView.mas_top).offset(20);
    }];
    
    [turnToIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.directionLabel.mas_right).offset(5);
        make.centerY.equalTo(self.directionLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 5));
    }];
    
    [self.endStationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(turnToIV.mas_right).offset(5);
        make.centerY.equalTo(turnToIV.mas_centerY);
    }];
    
    [self.startIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.busInfoView.mas_left).offset(18);
        make.bottom.equalTo(self.busInfoView.mas_bottom).offset(-22);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startIV.mas_right).offset(5);
        make.centerY.equalTo(self.startIV.mas_centerY);
    }];
    
    [self.endIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startTimeLabel.mas_right).offset(15);
        make.centerY.equalTo(self.startTimeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endIV.mas_right).offset(5);
        make.centerY.equalTo(self.endIV.mas_centerY);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endTimeLabel.mas_right).offset(16);
        make.centerY.equalTo(self.endTimeLabel.mas_centerY);
    }];

    self.directionLabel.text = [NSString stringWithFormat:@"方向：老福山北"];
    self.endStationLabel.text = @"俊彦路北口";
//    self.startTimeLabel.text = @"06:10";
//    self.endTimeLabel.text = @"22:10";
//    self.priceLabel.text = @"票价2元";
    
}

- (void)configBottomView {
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.layer.cornerRadius = 6;
    self.bottomView.clipsToBounds = YES;
    [self.view addSubview:self.bottomView];
    
    XFUDButton *turnBtn = [[XFUDButton alloc]init];
    turnBtn.padding = 8;
    [turnBtn setImage:[UIImage imageNamed:@"turnRound"] forState:UIControlStateNormal];
    [turnBtn setTitle:@"转向" forState:UIControlStateNormal];
    [turnBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    turnBtn.titleLabel.font = RFONT(12);
    [turnBtn addTarget:self action:@selector(turnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:turnBtn];
    
    XFUDButton *refreshBtn = [[XFUDButton alloc]init];
    refreshBtn.padding = 8;
    [refreshBtn setImage:[UIImage imageNamed:@"busRefresh"] forState:UIControlStateNormal];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = RFONT(12);
    [refreshBtn addTarget:self action:@selector(refreshClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:refreshBtn];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-59);
        make.height.mas_equalTo(66);
    }];
    
    CGFloat buttonWidth = ([UIScreen mainScreen].bounds.size.width - 32)/2.0;
    [turnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bottomView);
        make.width.mas_equalTo(buttonWidth);
    }];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.bottomView);
        make.width.mas_equalTo(buttonWidth);
    }];
    
}

- (void)configCommingStationView {
    
    self.commingBusView = [[UIView alloc]init];
    self.commingBusView.layer.cornerRadius = 6;
    self.commingBusView.clipsToBounds = YES;
    self.commingBusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.commingBusView];
    
    self.busHolderLabel = [[UILabel alloc]init];
    self.busHolderLabel.text = @"暂无实时公交数据";
    self.busHolderLabel.textColor = UIColorFromRGB(0x666666);
    self.busHolderLabel.font = RFONT(20);
    [self.commingBusView addSubview:self.busHolderLabel];
    
    [self.commingBusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.top.equalTo(self.busInfoView.mas_bottom);
        make.height.mas_equalTo(100);
    }];
    
    [self.busHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.commingBusView.mas_centerX);
        make.centerY.equalTo(self.commingBusView.mas_centerY);
    }];
    
}

#pragma CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datasArr.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BusRouteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:busRouteCell forIndexPath:indexPath];
    
    cell.stationModel = self.datasArr[indexPath.row];
////    [cell setStationString:self.datasArr[indexPath.row] withCurrentStation:indexPath.row totalStation:self.datasArr.count];
    [cell currentIndex:indexPath.row totalStation:self.datasArr.count withBusInfoArr:self.busInfoArr];
    
//    HYSearchStationModel *stationModel = self.datasArr[indexPath.row];
//    [cell setStationString:stationModel.stationName withStationNum:stationModel.labelNo withCurrentStation:indexPath.row totalStation:self.datasArr.count withBusInfoArr:self.busInfoArr];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.datasArr.count -1) {
        return CGSizeMake(18, 300);
    }
    return CGSizeMake(61, 300);
    
}

#pragma Clicked
- (void)turnClicked {
    
        NSLog(@"转向== %ld",(long)self.currentDirection);
    if (self.currentDirection == 1) {
        [self loadDataWithUpOrDown:@"0"];
        self.currentDirection = 0;
    }else if (self.currentDirection == 0) {
        [self loadDataWithUpOrDown:@"1"];
        self.currentDirection = 1;
    }
    
}

- (void)refreshClicked {
    
        NSLog(@"刷新== %ld",(long)self.currentDirection);
    [self loadDataWithUpOrDown:@(self.currentDirection).stringValue];
    
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
    
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
    
}

- (NSMutableArray *)datasArr {
    
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
//        NSArray *arr = @[@"第一站",@"第二站",@"三站",@"来个比较长的站名常常常常常",@"第五站",@"六站",@"气站",@"霸占",@"就占",@"施展"];
//        [_datasArr addObjectsFromArray:arr];
    }
    return _datasArr;
    
}

- (NSMutableArray *)busInfoArr {
    
    if (!_busInfoArr) {
        _busInfoArr = [NSMutableArray array];
    }
    return _busInfoArr;
    
}

- (NSMutableArray *)willArriveBusArr {
    
    if (!_willArriveBusArr) {
        _willArriveBusArr = [NSMutableArray array];
    }
    return _willArriveBusArr;
    
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
