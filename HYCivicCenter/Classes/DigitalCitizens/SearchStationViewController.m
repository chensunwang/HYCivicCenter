//
//  SearchStationViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/10/25.
//

#import "SearchStationViewController.h"
#import "SearchStationTableViewCell.h"
#import "HYSearchStationModel.h"
#import "BusRouteViewController.h"
#import "MoreStationViewController.h"
#import "MoreRouteViewController.h"
#import "RealTimeBusViewController.h"
#import "HYCivicCenterCommand.h"

@interface SearchStationViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) NSMutableArray *linesArr;
@property (nonatomic, strong) NSMutableArray *stationsArr;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIImageView *holderIV;
@property (nonatomic, strong) UIImageView *noResultIV;
@property (nonatomic, strong) UILabel *noresultLabel;

@end

NSString *const searchStationCell = @"searchStationCell";
@implementation SearchStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"搜索";
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self configSearchView];
    
    [self configUI];

    [self pointData];
    
}

- (void)pointData {
    
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit", @"eventId": @"E0064", @"applicationId": @"H025"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ",responseObject);
    }];
    
}

- (void)loadDataWithKeyword:(NSString *)keyword {
    
    [HttpRequest getPath:@"/phone/v2/bus/searchBus" params:@{@"keyword": keyword, @"pageNum": @"1", @"pageSize": @"3"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 搜索线路或站点 == %@ ",responseObject);
        
        if ([responseObject[@"code"] intValue] == 200) {
            self.holderIV.hidden = YES;
            self.linesArr = [HYSearchLineModel mj_objectArrayWithKeyValuesArray: responseObject[@"data"][@"line"][@"records"]];
            self.stationsArr = [HYSearchStationModel mj_objectArrayWithKeyValuesArray: responseObject[@"data"][@"stationList"][@"records"]];
            if (self.linesArr.count == 0 && self.stationsArr.count == 0) {
                self.noResultIV.hidden = NO;
                self.noresultLabel.hidden = NO;
            }else {
                self.noResultIV.hidden = YES;
                self.noresultLabel.hidden = YES;
            }
            
            [self.tableView reloadData];
        }
        
    }];
    
}

- (void)configUI {
    
    [self.tableView registerClass:[SearchStationTableViewCell class] forCellReuseIdentifier:searchStationCell];
    [self.view addSubview:self.tableView];
    
    self.holderIV = [[UIImageView alloc]init];
    self.holderIV.image = [UIImage imageNamed:@"searchBusHolder"];
    [self.view addSubview:self.holderIV];
    
    self.noResultIV = [[UIImageView alloc]init];
    self.noResultIV.image = [UIImage imageNamed:@"searchNoResult"];
    self.noResultIV.hidden = YES;
    [self.view addSubview:self.noResultIV];
    
    self.noresultLabel = [[UILabel alloc]init];
    self.noresultLabel.textColor = UIColorFromRGB(0x999999);
    self.noresultLabel.font = RFONT(12);
    self.noresultLabel.text = @"没有搜索结果";
    self.noresultLabel.hidden = YES;
    [self.view addSubview:self.noresultLabel];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.searchView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
    
    [self.holderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.588);
    }];
    
    [self.noResultIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.searchView.mas_bottom).offset(75);
        make.size.mas_equalTo(CGSizeMake(272, 245));
    }];
    
    [self.noresultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.noResultIV.mas_bottom).offset(20);
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
    searchTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"查路线、站点" attributes:attrs];
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

- (void)searchClicked {
    
    [self.view resignFirstResponder];
    [self loadDataWithKeyword:self.searchTF.text];
    
}

#pragma UITextfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self loadDataWithKeyword:textField.text];
    return YES;
    
}

#pragma TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.linesArr.count;
    }
    return self.stationsArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchStationCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.lineModel = self.linesArr[indexPath.row];
    }else {
        cell.stationModel = self.stationsArr[indexPath.row];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        BusRouteViewController *routeVC = [[BusRouteViewController alloc]init];
        HYSearchLineModel *lineModel = self.linesArr[indexPath.row];
        routeVC.lineNo = lineModel.lineNo;
        routeVC.isUpDown = lineModel.isUpDown?:@"1";
//        routeVC.stationName = self.keyword;
        [self.navigationController pushViewController:routeVC animated:YES];
        
    }else if (indexPath.section == 1) {
        
        HYSearchStationModel *stationModel = self.stationsArr[indexPath.row];
        RealTimeBusViewController *realtimeVC = [[RealTimeBusViewController alloc]init];
        realtimeVC.keyword = stationModel.stationName;
        [self.navigationController pushViewController:realtimeVC animated:YES];
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width - 32, 50)];
    titleView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = UIColorFromRGB(0x666666);
    titleLabel.font = RFONT(15);
    [titleView addSubview:titleLabel];

    if (section == 0 && self.linesArr.count > 0) {
        titleLabel.text = @"线路";
    }else if(section == 1 && self.stationsArr.count > 0){
        titleLabel.text = @"站点";
    }
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).offset(16);
        make.centerY.equalTo(titleView.mas_centerY);
    }];
    
    return titleView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 59)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UIButton *moreBtn = [[UIButton alloc]init];
    [moreBtn setBackgroundColor:[UIColor whiteColor]];
    moreBtn.tag = 100 + section;
    [moreBtn addTarget:self action:@selector(moreClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:moreBtn];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = UIColorFromRGB(0x666666);
    nameLabel.font = RFONT(14);
    if (section == 0) {
        nameLabel.text = @"查看更多路线";
        moreBtn.hidden = self.linesArr.count == 0;
    }else {
        nameLabel.text = @"查看更多站点";
        moreBtn.hidden = self.stationsArr.count == 0;
    }
    [moreBtn addSubview:nameLabel];
    
    UIImageView *moreIV = [[UIImageView alloc]init];
    moreIV.image = [UIImage imageNamed:@"moreIndicator"];
    [moreBtn addSubview:moreIV];
    
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moreBtn.mas_left).offset(17);
        make.centerY.equalTo(moreBtn.mas_centerY);
    }];
    
    [moreIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(moreBtn.mas_right).offset(-13);
        make.centerY.equalTo(moreBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    return contentView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0 && self.linesArr.count == 0) {
        return 0.01;
    }else if (section == 1 && self.stationsArr.count == 0) {
        return 0.01;
    }
    return 50;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0 && self.linesArr.count == 0) {
        return 0.01;
    }else if (section == 1 && self.stationsArr.count == 1) {
        return 0.01;
    }
    return 50;
    
}

#pragma Clicked
- (void)moreClicked:(UIButton *)button {
    
    if (button.tag == 100) {
        
        MoreRouteViewController *routeVC = [[MoreRouteViewController alloc]init];
        routeVC.keyword = self.searchTF.text;
        [self.navigationController pushViewController:routeVC animated:YES];
        
    }else if (button.tag == 101) {
        
        MoreStationViewController *stationVC = [[MoreStationViewController alloc]init];
        stationVC.keyword = self.searchTF.text;
        [self.navigationController pushViewController:stationVC animated:YES];
        
    }
    
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

- (NSMutableArray *)linesArr {
    
    if (!_linesArr) {
        _linesArr = [NSMutableArray array];
    }
    return _linesArr;
    
}

- (NSMutableArray *)stationsArr {
    
    if (!_stationsArr) {
        _stationsArr = [NSMutableArray array];
    }
    return _stationsArr;
    
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
