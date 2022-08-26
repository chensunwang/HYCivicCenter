//
//  HYHomeSearchViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/17.
//

#import "HYHomeSearchViewController.h"
#import "HYSearchView.h"
#import "HYGuessBusinessTableViewCell.h"
#import "HYHandleAffairsWebVIewController.h"
#import "HYRealNameAlertView.h"
#import "HYEmptyView.h"
#import "FaceTipViewController.h"
#import "HYOnLineBusinessMainViewController.h"

@interface HYHomeSearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, FaceResultDelegate>

@property (nonatomic, strong) HYSearchView * searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) HYEmptyView *emptyView;  // 空数据占位图
@property (nonatomic, copy) NSString * jumpUrl;  // 传给网页的url
@property (nonatomic, copy) NSString * code;  // 传给网页的code
@property (nonatomic, copy) NSString * titleStr;  // 传给网页的title
@property (nonatomic, strong) UILabel *titleLabel;

@end

NSString *const searchCell = @"homeSearchCell";
@implementation HYHomeSearchViewController

- (void)loadView {
    [super loadView];
    
    self.searchView = [[HYSearchView alloc] initWithFrame:CGRectZero];
    self.searchView.searchTF.text = self.searchStr;
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(kTopNavHeight);
        make.height.mas_equalTo(50);
    }];
    self.searchView.searchTF.delegate = self;
    [self.searchView.searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYGuessBusinessTableViewCell class] forCellReuseIdentifier:searchCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.searchView.mas_bottom).offset(16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-16);
    }];
    self.tableView.layer.cornerRadius = 10;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 49;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    
    self.emptyView = [[HYEmptyView alloc] init];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(155);
        make.height.mas_equalTo(204);
    }];
    self.emptyView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel = [UILabel xf_labelWithText:@"查询结果"];
    if (_hyTitleColor) {
        self.titleLabel.textColor = _hyTitleColor;
    }
    self.navigationItem.titleView = _titleLabel;
    
    [self traitCollectionDidChange:nil];
    
    [self searchBtnClick:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.searchView.backgroundColor = UIColorFromRGB(0x157AFF);
    self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

- (NSMutableArray *)datasArr {
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
}

// 点击搜索
- (void)searchBtnClick:(UIButton *)sender {
    self.currentPage = 1;
    [self loadDataWithPage:self.currentPage keyword:self.searchView.searchTF.text];
}

- (void)loadMoreData {
    self.currentPage ++;
    [self loadDataWithPage:self.currentPage keyword:self.searchView.searchTF.text];
}

- (void)loadDataWithPage:(NSInteger)page keyword:(NSString *)keyword {
    [HttpRequest getPathZWBS:@"phone/item/event/searchItemName" params:@{@"keyword": keyword ? : @"", @"pageNum": @(page).stringValue, @"pageSize": @"20"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
        SLog(@" 全局搜索数据 == %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            if (self.currentPage == 1) {
                [self.datasArr removeAllObjects];
            }
            NSArray *tempArr = [HYGuessBusinessModel mj_objectArrayWithKeyValuesArray:responseObject[@"rows"]];
            if (tempArr.count == 0) {
                self.emptyView.hidden = NO;
                self.tableView.hidden = YES;
            } else {
                self.emptyView.hidden = YES;
                self.tableView.hidden = NO;
                [self.datasArr addObjectsFromArray:tempArr];
                [self.tableView reloadData];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchView.searchTF resignFirstResponder];
    [self searchBtnClick:nil];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchView.searchTF resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYGuessBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.guessModel = self.datasArr[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_idCard || [_idCard isEqualToString:@""]) { // 需要实名认证
        [self showAlertForReanNameAuth];
    } else {
        HYGuessBusinessModel *businessModel = self.datasArr[indexPath.row];
        if ([businessModel.needFaceRecognition intValue] == 1) { // 跳转人脸识别
            self.code  =businessModel.code;
            self.titleStr = businessModel.name;
            self.jumpUrl = businessModel.jumpUrl;
            FaceTipViewController *faceTipVC = [[FaceTipViewController alloc] init];
            faceTipVC.delegate = self;
            [self.navigationController pushViewController:faceTipVC animated:YES];
        } else {
            if ([businessModel.outLinkFlag intValue] == 1) { // 外链
                HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
                webVC.code = businessModel.link;
                webVC.titleStr = businessModel.name;
                webVC.jumpUrl = businessModel.jumpUrl;
                [self.navigationController pushViewController:webVC animated:YES];
            } else if ([businessModel.servicePersonFlag intValue] == 1 || self.isEnterprise) { // 内链个人  内链企业且已企业认证
                HYOnLineBusinessMainViewController * mainVC = [[HYOnLineBusinessMainViewController alloc] init];
                mainVC.businessModel = businessModel;
                [self.navigationController pushViewController:mainVC animated:YES];
            } else { // 内链
                // 提示企业认证
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"该事项只针对企业，请先进行企业实名认证" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:confirm];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}

#pragma mark - HYRealNameAuthDelegate

- (void)jumpRealNameAuthVC {  // 实名认证
    
    // 类名
    NSString *class =[NSString stringWithFormat:@"%@", @"RealNameListVC"];
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    
    // 从一个字串返回一个类
    Class newClass = objc_getClass(className);
    if (!newClass)
    {
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象
    UIViewController *instance = [[newClass alloc] init];
    instance.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:instance animated:true];
    
}

- (void)showAlertForReanNameAuth {
    HYRealNameAlertView *alertV = [[HYRealNameAlertView alloc] init];
    alertV.alertResult = ^(NSInteger index) {
        if (index == 2) {
            [self jumpRealNameAuthVC];
        }
    };
    [alertV showAlertView];
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
