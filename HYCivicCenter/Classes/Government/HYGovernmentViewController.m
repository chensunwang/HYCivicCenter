//
//  HYGovernmentViewController.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/14.
//
//  政务服务首页

#import "HYGovernmentViewController.h"
#import "HYGoveHeaderView.h"
#import "HYGovementItemCell.h"
#import "HYServiceContentTableViewCell.h"
#import "HYServiceProgressViewController.h"
#import "HYServiceProgressModel.h"
#import "HYHomeSearchViewController.h"
#import "HYProgressDetailViewController.h"
#import "HYCivicCenterCommand.h"

@interface HYGovernmentViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) HYGoveHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger type; // 0:部门 1:县区
@property (nonatomic, strong) NSMutableArray * deparmentServiceArr; // 市直服务数据
@property (nonatomic, strong) NSMutableArray * countyServiceArr; // 县区服务数据
@property (nonatomic, strong) NSArray * headerDataArray;  // 头部进度数据
@property (nonatomic, assign) BOOL isEnterprise;  // true 企业  false 个人
@property (nonatomic, copy) NSString *idCard;  // 身份证号 如果有则已实名认证 否则未实名认证

@end

@implementation HYGovernmentViewController

- (void)loadView {
    [super loadView];
    
    self.headerView = [[HYGoveHeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, 285 + kStatusBarHeight)];
    [self.headerView.backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.searchView.searchTF.delegate = self;
    [self.headerView.searchView.searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView.moreButton addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    __weak typeof(self) weakSelf = self;
    self.headerView.goveHeaderViewBlock = ^(NSInteger index) {
        [weakSelf jumpToProgressDetail:index];
    };
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.tableView registerClass:[HYGovementItemCell class] forCellReuseIdentifier:@"HYGovementItemCell"];
    
    if (@available(iOS 11.0, *)) { // 填充状态栏
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self traitCollectionDidChange:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.headerView.searchView.backgroundColor = UIColor.clearColor;
    self.tableView.backgroundColor = UIColorFromRGB(0xEBEFF5);
}

- (void)loadData {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        MainApi *api = [MainApi sharedInstance];
        [HttpRequest postHttpBodyZWBS:@"city/4AItems/event/getUserByToken" params:@{@"authorization": api.token} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@" 办事验证token== %@ ", responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                self.idCard = responseObject[@"data"][@"personInfo"][@"idCard"];
                NSString *enterprise = responseObject[@"data"][@"personInfo"][@"isEnterprise"];
                if ([enterprise isEqualToString:@"true"]) {
                    self.isEnterprise = YES;
                } else {
                    self.isEnterprise = NO;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } else {
                SLog(@"%@", responseObject[@"msg"]);
            }
        }];
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{  // 分页失效 num和size不管传多少 都是返回所有数据
        [HttpRequest getPathZWBS:@"phone/item/event/getBusinessList" params:@{@"type": @"0", @"pageNum": @"1", @"pageSize": @"2"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@" 进度跟踪== %@ ", responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                NSArray *datas = [HYServiceProgressModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                self.headerDataArray = datas;
                self.headerView.dataArr = datas;
                // 根据数据动态改变headerView的高度
                if (datas.count == 1) {
                    self.headerView.frame = CGRectMake(0, 0, 0, 237 + kStatusBarHeight);
                } else {
                    self.headerView.frame = CGRectMake(0, 0, 0, 285 + kStatusBarHeight);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }];
        dispatch_group_leave(group);
    });

    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HttpRequest getPathZWBS:@"phone/item/event/getCityAgentList" params:@{@"type": @"city"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@" 市直单位 == %@ ", responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                self.deparmentServiceArr = [HYDepartmentCountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } else {
                SLog(@"%@", responseObject[@"msg"]);
            }
        }];
        dispatch_group_leave(group);
    });

    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HttpRequest getPathZWBS:@"phone/item/event/getCityAgentList" params:@{@"type": @"country"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@" 县区单位 == %@ ", responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                self.countyServiceArr = [HYDepartmentCountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } else {
                SLog(@"%@", responseObject[@"msg"]);
            }
        }];
        dispatch_group_leave(group);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    // 判断是 push / present 还是 pop /dismiss
    if ([self isBeingPresented] || [self isMovingToParentViewController]) {
        // push / present
        MainApi *api = [MainApi sharedInstance];
        if (api.token.length > 0) {
            [self.tableView.mj_header beginRefreshing];
        }
    } else {
        // pop /dismiss to here
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (NSMutableArray *)deparmentServiceArr {
    if (!_deparmentServiceArr) {
        _deparmentServiceArr = [NSMutableArray array];
    }
    return _deparmentServiceArr;
}

- (NSMutableArray *)countyServiceArr {
    if (!_countyServiceArr) {
        _countyServiceArr = [NSMutableArray array];
    }
    return _countyServiceArr;
}

- (NSArray *)headerDataArray {
    if (!_headerDataArray) {
        _headerDataArray = [NSArray array];
    }
    return _headerDataArray;
}

// 返回
- (void)backBtnClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 搜索
- (void)searchBtnClick:(UIButton *)sender {
    if (_headerView.searchView.searchTF.text.length == 0 || [_headerView.searchView.searchTF.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"搜索内容不能为空或者空格"];
        return;
    }
    HYHomeSearchViewController *homeSearchVC = [[HYHomeSearchViewController alloc] init];
    homeSearchVC.searchStr = _headerView.searchView.searchTF.text;
    homeSearchVC.idCard = _idCard;
    homeSearchVC.isEnterprise = _isEnterprise;
    homeSearchVC.hyTitleColor = _hyTitleColor;
    [self.navigationController pushViewController:homeSearchVC animated:YES];
}

// 进入进度详情
- (void)jumpToProgressDetail:(NSInteger)index {
    HYServiceProgressModel *progressModel = self.headerDataArray[index];
    HYProgressDetailViewController *detailVC = [[HYProgressDetailViewController alloc] init];
    detailVC.titleStr = progressModel.applySubject;
    detailVC.hyTitleColor = _hyTitleColor;
    detailVC.businessID = progressModel.id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

// 进度跟踪 -- 查看更多
- (void)moreBtnClicked:(UIButton *)sender {
    HYServiceProgressViewController *progressVC = [[HYServiceProgressViewController alloc] init];
    progressVC.hyTitleColor = _hyTitleColor;
    [self.navigationController pushViewController:progressVC animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.headerView.searchView.searchTF resignFirstResponder];
    if (_headerView.searchView.searchTF.text.length == 0 || [_headerView.searchView.searchTF.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"搜索内容不能为空或者空格"];
        return YES;
    }
    // 跳转到搜索页面
    HYHomeSearchViewController *homeSearchVC = [[HYHomeSearchViewController alloc] init];
    homeSearchVC.searchStr = _headerView.searchView.searchTF.text;
    homeSearchVC.idCard = _idCard;
    homeSearchVC.isEnterprise = _isEnterprise;
    homeSearchVC.hyTitleColor = _hyTitleColor;
    [self.navigationController pushViewController:homeSearchVC animated:YES];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.headerView.searchView.searchTF resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYGovementItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYGovementItemCell" forIndexPath:indexPath];
    cell.deparmentServiceArr = _deparmentServiceArr;
    cell.countyServiceArr = _countyServiceArr;
    cell.viewController = self;
    cell.isEnterprise = _isEnterprise;
    cell.hyTitleColor = _hyTitleColor;
    cell.govementItemCellBlock = ^(NSInteger type) {
        self.type = type;
        [tableView reloadData];
    };
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 0) {
        NSInteger count = (_deparmentServiceArr.count/2 + _deparmentServiceArr.count%2);
        return 154 * count + 65;
    } else {
        NSInteger count = (_countyServiceArr.count/2 + _countyServiceArr.count%2);
        return 154 * count + 65;
    }
}
 
@end
