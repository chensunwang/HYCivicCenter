//
//  RideRecordViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/13.
//

#import "RideRecordViewController.h"
#import "RideRecordTableViewCell.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface RideRecordViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) NSInteger currentPage;

@end

NSString *const rideRecordCell = @"rideRecord";
@implementation RideRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"乘车记录"];
    
    [self configUI];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    
    [self pointData];
    
}

- (void)pointData {
    
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit",@"eventId": @"E0062",@"applicationId":@"H023"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ",responseObject);
    }];
    
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
    
    // 查询乘车记录
    [HttpRequest getPathBus:@"" params:@{@"uri":@"/api/hcard/query/record",@"pageSize":@"20",@"pageNum":@(page)} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 乘车记录== %@ ",responseObject);
        if ([responseObject[@"success"] intValue] == 1) {
            
            if (self.currentPage == 1) {
                [self.datasArr removeAllObjects];
            }
            NSArray *datas = [RideRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"records"]];
            [self.datasArr addObjectsFromArray:datas];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[RideRecordTableViewCell class] forCellReuseIdentifier:rideRecordCell];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

#pragma tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datasArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RideRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rideRecordCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.datasArr[indexPath.row];
    
    return cell;
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 126;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
