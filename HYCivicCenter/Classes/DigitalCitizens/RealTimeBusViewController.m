//
//  RealTimeBusViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/10/25.
//

#import "RealTimeBusViewController.h"
#import "RealTimeBusTableViewCell.h"
#import "HYBusinfoModel.h"
#import "SearchStationViewController.h"
#import "BusRouteViewController.h"
#import "HYCivicCenterCommand.h"

@interface RealTimeBusViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) NSInteger currentPage;

@end

NSString *const realtimeBusCell = @"realtimecell";
@implementation RealTimeBusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.keyword;
    
    [self configUI];
    
//    [self loadData];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    
}

- (void)loadNewData {
    
    self.currentPage = 1;
    [self loadDataWithPage:self.currentPage];
    
}

- (void)loadMoreData {
    
    self.currentPage ++;
    [self loadDataWithPage:self.currentPage];
    
}

- (void)loadDataWithPage:(NSInteger)page {
    
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit",@"eventId": @"E0064",@"applicationId":@"H027"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ",responseObject);
    }];
    
    [HttpRequest getPath:@"/phone/v2/bus/getNearestBusLine" params:@{@"stationName":self.keyword,@"pageNum":@(page),@"pageSize":@"20"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 搜索线路或站点 == %@ ",responseObject);
        
        if ([responseObject[@"code"] intValue] == 200) {
            if (self.currentPage == 1) {
                [self.datasArr removeAllObjects];
            }
            NSArray *arr = [responseObject[@"data"] allKeys];
            for (NSInteger i = 0; i < arr.count; i++) {
                NSMutableArray *busInfoArr = [HYBusinfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][arr[i]]];
                [self.datasArr addObject:busInfoArr];
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

- (void)configUI {
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitle:@"搜索" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightbutton.titleLabel.font = RFONT(15);
    rightbutton.frame = CGRectMake(0 , 0, 60, 44);

    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:rightbutton];

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    spaceItem.width = -15;
    self.navigationItem.rightBarButtonItems = @[spaceItem,rightItem];
    
    [self.tableView registerClass:[RealTimeBusTableViewCell class] forCellReuseIdentifier:realtimeBusCell];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

#pragma TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datasArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RealTimeBusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:realtimeBusCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.datasArr[indexPath.row] count] > 0) {
        cell.busInfoModel = [self.datasArr[indexPath.row] firstObject];
        
        if ([self.datasArr[indexPath.row] count] > 1) {
            HYBusinfoModel *model = self.datasArr[indexPath.row][1];
            cell.nextTime = model.arriveNowStationNeedMinute;
        }else {
            cell.nextTime = @"暂无车辆";
        }
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HYBusinfoModel *busInfoModel = [self.datasArr[indexPath.row] firstObject];
    BusRouteViewController *routeVC = [[BusRouteViewController alloc]init];
    routeVC.isUpDown = busInfoModel.isUpDown?:@"1";
    routeVC.lineNo = busInfoModel.lineNo;
    routeVC.stationName = self.keyword?:@"";
    [self.navigationController pushViewController:routeVC animated:YES];
    
}

// 搜索
- (void)rightClicked {
    
    SearchStationViewController *searchVC = [[SearchStationViewController alloc]init];
    searchVC.keyword = self.keyword;
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 76;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
    
}

- (NSMutableArray *)datasArr {
    
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
    
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
