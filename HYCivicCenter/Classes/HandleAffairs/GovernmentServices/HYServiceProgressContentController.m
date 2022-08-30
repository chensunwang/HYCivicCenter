//
//  HYServiceProgressContentController.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/14.
//

#import "HYServiceProgressContentController.h"
#import "HYServiceProgressTableViewCell.h"
#import "HYServiceProgressModel.h"
#import "HYProgressDetailViewController.h"
#import "HYCivicCenterCommand.h"

@interface HYServiceProgressContentController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIImageView *holderIV;
@property (nonatomic, strong) UILabel *holderLabel;

@end

NSString *const serviceProgressCell = @"progressCell";
@implementation HYServiceProgressContentController

- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYServiceProgressTableViewCell class] forCellReuseIdentifier:serviceProgressCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.holderIV = [[UIImageView alloc]init];
    self.holderIV.image = [UIImage imageNamed:BundleFile(@"cardHolder")];
    [self.view addSubview:self.holderIV];
    
    self.holderLabel = [[UILabel alloc]init];
    self.holderLabel.text = @"列表内容为空";
    self.holderLabel.font = RFONT(17);
    [self.view addSubview:self.holderLabel];
    
    [self.holderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight + 160);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(155, 139));
    }];
    
    [self.holderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.holderIV.mas_bottom).offset(29);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    
    [self traitCollectionDidChange:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.holderLabel.textColor = UIColorFromRGB(0x212121);
}

- (void)loadNewData {
    self.currentPage = 1;
    [self loadDataWithPage:self.currentPage];
}

- (void)loadMoreData {
    self.currentPage ++;
    [self loadDataWithPage:self.currentPage];
}

- (void)loadDataWithPage:(NSInteger)page {  // 分页失效 num和size不管传多少 都是返回所有数据
    [HttpRequest getPathZWBS:@"phone/item/event/getBusinessList" params:@{@"type": @(_type).stringValue, @"pageNum": @(page).stringValue, @"pageSize": @"20"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 进度跟踪== %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            if (self.currentPage == 1) {
                [self.datasArr removeAllObjects];
            }
            NSArray *datas = [HYServiceProgressModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.datasArr addObjectsFromArray:datas];
            if (self.datasArr.count > 0) {
                self.holderIV.hidden = YES;
                self.holderLabel.hidden = YES;
            } else {
                self.holderLabel.hidden = NO;
                self.holderIV.hidden = NO;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
}

#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYServiceProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceProgressCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.progressModel = self.datasArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 高度不固定，在model中计算高度
    return 136;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HYServiceProgressModel *progressModel = self.datasArr[indexPath.row];
    HYProgressDetailViewController *detailVC = [[HYProgressDetailViewController alloc] init];
    detailVC.titleStr = progressModel.applySubject;
    detailVC.businessID = progressModel.id;
    detailVC.hyTitleColor = _hyTitleColor;
    [self.navigationController pushViewController:detailVC animated:YES];
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
