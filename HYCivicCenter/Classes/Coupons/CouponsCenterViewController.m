//
//  CouponsCenterViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/5.
//

#import "CouponsCenterViewController.h"
#import "CouponsCenterTableViewCell.h"
#import "MyCouponDetailViewController.h"
#import "HYCouponModel.h"

@interface CouponsCenterViewController ()<UITableViewDelegate,UITableViewDataSource,HYCouponDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) NSInteger currentPage;

@end

NSString *const couponCell = @"couponCell";
@implementation CouponsCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self configUI];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CouponsCenterTableViewCell class] forCellReuseIdentifier:couponCell];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
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
    
    [HttpRequest postPath:@"phone/v1/coupon/getCouponListByType" params:@{@"couponType":self.couponType,@"pageSize":@"20",@"pageNum":@(page)} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@" 当前page == %ld ",(long)page);
        if ([responseObject[@"code"] intValue] == 200) {
            if (self.currentPage == 1) {
                [self.datasArr removeAllObjects];
            }
            NSArray *datas = [HYCouponModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.datasArr addObjectsFromArray:datas];
            [self.tableView reloadData];
            
        }
        
//        NSLog(@" 当前优惠券  == %@ === %@",responseObject,self.couponType);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datasArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CouponsCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:couponCell];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.couponModel = self.datasArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    MyCouponDetailViewController *detailVC = [[MyCouponDetailViewController alloc]init];
//    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma HYcouponDelegate
- (void)receiveCouponWithCell:(CouponsCenterTableViewCell *)cell withModel:(HYCouponModel *)model {
    
    [HttpRequest postPath:@"phone/v1/coupon/receiveCoupon" params:@{@"issueCode":model.issueCode} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 领取== %@ ",responseObject);
        [SVProgressHUD showWithStatus:@"正在领取"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           // 需要延迟执行的代码
            
            [HttpRequest postPath:@"phone/v1/coupon/checkReceiveCoupon" params:@{@"issueCode":model.issueCode} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
                
                NSLog(@" 领取结果== %@ ",responseObject);
                if ([responseObject[@"code"] intValue] == 200) {
                    [self.datasArr removeObject:model];
                    [self.tableView reloadData];
                    [SVProgressHUD showWithStatus:@"领取成功"];
                }
                [SVProgressHUD dismissWithDelay:0.5];
                
            }];
            
        });
        
    }];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
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
