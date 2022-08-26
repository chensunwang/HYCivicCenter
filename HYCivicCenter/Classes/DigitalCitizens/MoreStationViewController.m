//
//  MoreStationViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/9.
//

#import "MoreStationViewController.h"
#import "SearchStationTableViewCell.h"
#import "BusRouteViewController.h"
#import "RealTimeBusViewController.h"

@interface MoreStationViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchTF;

@end

NSString *const moreStationCell = @"stationCell";
@implementation MoreStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"站点";
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self configSearchView];
    
    [self configUI];
    
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
    
    [HttpRequest getPath:@"/phone/v2/bus/searchBus" params:@{@"keyword":self.searchTF.text.length >0?self.searchTF.text:self.keyword,@"pageNum":@(page),@"pageSize":@"20",@"type":@"station"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 搜索线路或站点 == %@ ",responseObject);
        
        if ([responseObject[@"code"] intValue] == 200) {
            if (self.currentPage == 1) {
                [self.datasArr removeAllObjects];
            }
            NSArray *datas = [HYSearchStationModel mj_objectArrayWithKeyValuesArray: responseObject[@"data"][@"stationList"][@"records"]];
            [self.datasArr addObjectsFromArray:datas];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

- (void)configUI {
    
    [self.tableView registerClass:[SearchStationTableViewCell class] forCellReuseIdentifier:moreStationCell];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.searchView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
    
}

- (void)configSearchView {
    
    self.searchView = [[UIView alloc]init];
    self.searchView.backgroundColor = UIColorFromRGB(0x157AFF);
    [self.view addSubview:self.searchView];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 36, 32)];
    UIImageView *searchIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 16, 16)];
    searchIV.image = [UIImage imageNamed:@"search"];
    [leftView addSubview:searchIV];
    
    UITextField *searchTF = [[UITextField alloc]init];
    searchTF.backgroundColor = [UIColor whiteColor];
//    searchTF.placeholder = @"查路线、站点";
    searchTF.textColor = UIColorFromRGB(0x333333);
    NSDictionary *attrs = @{NSForegroundColorAttributeName:UIColorFromRGB(0xCCCCCC),NSFontAttributeName:RFONT(15)};
    searchTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"查站点" attributes:attrs];
    searchTF.leftView = leftView;
    searchTF.leftViewMode = UITextFieldViewModeAlways;
    searchTF.layer.cornerRadius = 16;
    searchTF.clipsToBounds = YES;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.delegate = self;
    [self.searchView addSubview:searchTF];
    self.searchTF = searchTF;
    
    UIButton *searchBtn = [[UIButton alloc]init];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = RFONT(15);
    [searchBtn addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:searchBtn];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.height.mas_equalTo(53);
    }];
    
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(9, 16, 12, 60));
    }];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.searchView.mas_right).offset(-16);
        make.centerY.equalTo(searchTF.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(32, 24));
    }];
    
}

#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datasArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreStationCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.stationModel = self.datasArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    BusRouteViewController *routeVC = [[BusRouteViewController alloc]init];
//    HYSearchStationModel *stationModel = self.datasArr[indexPath.row];
//    routeVC.lineNo = stationModel.lineNo;
//    routeVC.stationName = stationModel.stationName;
//    routeVC.isUpDown = stationModel.isUpDown;
//    [self.navigationController pushViewController:routeVC animated:YES];
    RealTimeBusViewController *realtimeVC = [[RealTimeBusViewController alloc]init];
    HYSearchStationModel *stationModel = self.datasArr[indexPath.row];
    realtimeVC.keyword = stationModel.stationName;
    realtimeVC.navigationItem.rightBarButtonItems = nil;
    [self.navigationController pushViewController:realtimeVC animated:YES];
    
    
}

#pragma UITextfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self loadNewData];
    return YES;
    
}

#pragma Clicked
- (void)searchClicked {
    
    [self loadNewData];
    
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 59;
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
