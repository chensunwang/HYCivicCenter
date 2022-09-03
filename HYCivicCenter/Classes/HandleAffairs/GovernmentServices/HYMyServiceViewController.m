//
//  HYMyServiceViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/13.
//
//  我的服务页面

#import "HYMyServiceViewController.h"
#import "HYMyServiceTableViewCell.h"
#import "HYMyServiceModel.h"
#import "HYHandleAffairsWebVIewController.h"
#import "FaceTipViewController.h"
#import "HYOnLineBusinessMainViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"
#import "UILabel+XFExtension.h"

@interface HYMyServiceViewController () <UITableViewDelegate, UITableViewDataSource, FaceResultDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIImageView *holderIV;
@property (nonatomic, strong) UILabel *holderLabel;
@property (nonatomic, copy) NSString * jumpUrl;  // 传给网页的url
@property (nonatomic, copy) NSString * code;  // 传给网页的code
@property (nonatomic, copy) NSString * titleStr;  // 传给网页的title

@end

NSString *const myServiceCell = @"HYMyserviceCell";
@implementation HYMyServiceViewController

- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYMyServiceTableViewCell class] forCellReuseIdentifier:myServiceCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 49;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.holderIV = [[UIImageView alloc]init];
    self.holderIV.image = HyBundleImage(@"cardHolder");
    [self.view addSubview:self.holderIV];
    
    self.holderLabel = [[UILabel alloc]init];
    self.holderLabel.text = @"没有更多了";
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
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"我的服务"];
        
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;

    [self traitCollectionDidChange:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView.mj_header beginRefreshing];
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

- (void)loadDataWithPage:(NSInteger)page {
    [HttpRequest getPathZWBS:@"city/4AItems/event/collect/getMyCollectList" params:@{@"pageSize": @"20", @"pageNum": @(page)} resultBlock:^(id _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 我的服务 == %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            if (self.currentPage == 1) {
                [self.datasArr removeAllObjects];
            }
            NSArray *datas = [HYMyServiceModel mj_objectArrayWithKeyValuesArray:responseObject[@"rows"]];
            [self.datasArr addObjectsFromArray:datas];
            if (self.datasArr.count > 0) {
                self.holderLabel.hidden = YES;
                self.holderIV.hidden = YES;
            } else {
                self.holderLabel.hidden = NO;
                self.holderIV.hidden = NO;
            }
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
    HYMyServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myServiceCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.serviceModel = self.datasArr[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYMyServiceModel *model = self.datasArr[indexPath.row];
    UITableViewRowAction *handleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"办理" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        if ([model.canHandle boolValue] == NO) {
//            [SVProgressHUD showErrorWithStatus:@"该事项无法操作"];
//            return;
//        }
        if (model.needFaceRecognition.intValue == 1) {  // 跳转人脸识别
            self.code = model.eventCode;
            self.titleStr = model.eventName;
            self.jumpUrl = model.jumpUrl;
            FaceTipViewController *faceTipVC = [[FaceTipViewController alloc] init];
            faceTipVC.delegate = self;
            [self.navigationController pushViewController:faceTipVC animated:YES];
        } else {
            if ([model.outLinkFlag intValue] == 1) {  // 外链
                HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
                webVC.code = model.eventCode;
                webVC.titleStr = model.eventName;
                webVC.jumpUrl = model.jumpUrl;
                [self.navigationController pushViewController:webVC animated:YES];
            } else if ([model.servicePersonFlag intValue] == 1 || self.isEnterprise) {
                HYOnLineBusinessMainViewController * mainVC = [[HYOnLineBusinessMainViewController alloc] init];
                mainVC.myServiceModel = model;
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
    }];
    
    UITableViewRowAction *collectAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [HttpRequest postHttpBodyZWBS:@"city/4AItems/event/collect/cancelCollect" params:@{@"eventCode": model.eventCode} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@" 取消收藏 == %@ ",responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.datasArr removeObject:model];
                    [self.tableView reloadData];
                });
            } else {
                SLog(@"取消收藏失败:%@", responseObject[@"msg"]);
            }
        }];
    }];
    handleAction.backgroundColor = UIColorFromRGB(0x03CBA4);
    collectAction.backgroundColor = UIColorFromRGB(0xFB8807);
    
    return @[collectAction, handleAction];
}

- (NSMutableArray *)datasArr {
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
}

#pragma mark - FaceResultDelegate

- (void)getFaceResultWithImageStr:(NSString *)imageStr deviceId:(NSString *)deviceid skey:(NSString *)skey {
    SLog(@" skey == %@ ", skey);
    [HttpRequest postPathZWBS:@"phone/item/event/api" params:@{@"uri": @"/apiFile/discernFace", @"app": @"ios", @"file": imageStr, @"deviceId": deviceid, @"skey": skey} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 人脸识别== %@ ", responseObject);
        if ([responseObject[@"success"] intValue] == 1) {
            HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
            webVC.code = self.code;
            webVC.titleStr = self.titleStr;
            webVC.jumpUrl = self.jumpUrl;
            [self.navigationController pushViewController:webVC animated:YES];
        } else {
            SLog(@"%@", responseObject[@"message"]);
        }
    }];
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
