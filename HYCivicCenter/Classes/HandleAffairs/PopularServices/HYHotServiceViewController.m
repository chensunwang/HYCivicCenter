//
//  HYHotServiceViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/14.
//
//  热门服务 -- 更多页面

#import "HYHotServiceViewController.h"
#import "HYHotServiceTableViewCell.h"
#import "HYHotServiceModel.h"
#import "FaceRecViewController.h"
#import "HYHandleAffairsWebVIewController.h"
#import "HYOnLineBusinessMainViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface HYHotServiceViewController () <UITableViewDelegate, UITableViewDataSource, FaceRecResultDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString * jumpUrl;  // 传给网页的url
@property (nonatomic, copy) NSString * code;  // 传给网页的code
@property (nonatomic, copy) NSString * titleStr;  // 传给网页的title

@end

NSString *const hotServiceCell = @"hotCell";
@implementation HYHotServiceViewController

- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[HYHotServiceTableViewCell class] forCellReuseIdentifier:hotServiceCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    UILabel *titleLabel = [UILabel xf_labelWithText:@"热门服务"];
    if (_hyTitleColor) {
        titleLabel.textColor = _hyTitleColor;
    }
    self.navigationItem.titleView = titleLabel;
        
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
    [HttpRequest getPathZWBS:@"phone/item/event/getHotList" params:@{@"pageNum": @(page).stringValue, @"pageSize": @"20", @"isHot": @"1", @"type": @"1"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 热门服务分类== %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            if (self.currentPage == 1) {
                [self.datasArr removeAllObjects];
            }
            NSArray *datas = [HYHotServiceModel mj_objectArrayWithKeyValuesArray:responseObject[@"rows"]];
            [self.datasArr addObjectsFromArray:datas];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYHotServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotServiceCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.serviceModel = self.datasArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HYHotServiceModel *model = self.datasArr[indexPath.row];
    if (model.needFaceRecognition.intValue == 1) { // 跳转人脸识别
        self.code = model.link;
        self.titleStr = model.name;
        self.jumpUrl = model.jumpUrl;
        FaceRecViewController *vc = [[FaceRecViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if ([model.outLinkFlag intValue] == 1) {  // 外链
            HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
            webVC.code = model.link;
            webVC.titleStr = model.name;
            webVC.jumpUrl = model.jumpUrl;
            [self.navigationController pushViewController:webVC animated:YES];
        } else if ([model.servicePersonFlag intValue] == 1 || self.isEnterprise) {
            HYOnLineBusinessMainViewController * mainVC = [[HYOnLineBusinessMainViewController alloc] init];
            mainVC.serviceModel = model;
            mainVC.hyTitleColor = self.hyTitleColor;
            [self.navigationController pushViewController:mainVC animated:YES];
        } else {
            // 提示企业认证
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"该事项只针对企业，请先进行企业实名认证" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - FaceRecResultDelegate

- (void)getFaceResult:(BOOL)result {
    if (result) {
        HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
        webVC.code = self.code;
        webVC.titleStr = self.titleStr;
        webVC.jumpUrl = self.jumpUrl;
        [self.navigationController pushViewController:webVC animated:YES];
    }
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
