//
//  MyCouponsViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/9.
//

#import "MyCouponsViewController.h"
#import "CouponsCenterTableViewCell.h"
#import "MyCouponDetailViewController.h"
#import "HYCouponModel.h"
#import "HYCivicCenterCommand.h"

@interface MyCouponsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) NSInteger currentPage;

@end

NSString *const couponCenterCell = @"couponCenter";
@implementation MyCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    [HttpRequest postPath:@"phone/v1/coupon/getMyReceiveCoupon" params:@{@"status":self.type,@"pageSize":@"20",@"pageNum":@(page)} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@"优惠券 == %@ == %@",responseObject,self.type);
        if ([responseObject[@"code"] intValue] == 200) {
            
            if (self.currentPage == 1) {
                [self.datasArr removeAllObjects];
            }
            //数据处理
            NSArray *datas = [HYCouponModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.datasArr addObjectsFromArray:datas];
            [self.tableView reloadData];
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CouponsCenterTableViewCell class] forCellReuseIdentifier:couponCenterCell];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

#pragma tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datasArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CouponsCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:couponCenterCell];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.couponModel = self.datasArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    MyCouponDetailViewController *detailVC = [[MyCouponDetailViewController alloc]init];
//    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 116;
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
