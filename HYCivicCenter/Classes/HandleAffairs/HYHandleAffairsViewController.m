//
//  HYHandleAffairsViewController.m
//  HelloFrame
//
//  Created by chensunwang on 2022/3/2.
//
//  办事页面

#import "HYHandleAffairsViewController.h"
#import "HYSearchView.h"
#import "HYGovernmentCell.h"
#import "HYPopularQueriesCell.h"
#import "HYSpecialServiceCell.h"
#import "HYGuessYouCell.h"
#import "HYHotServiceModel.h"
#import "HYHandleAffairsWebVIewController.h"
#import "HYServiceContentTableViewCell.h"
#import "HYGuessBusinessViewController.h"
#import "HYHomeSearchViewController.h"
#import "HYOnLineBusinessMainViewController.h"

#import "HYHotServiceViewController.h"
#import "HYLegalAidGuideViewController.h"
#import "FaceTipViewController.h"
#import "HYRealNameAlertView.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"
#import "UILabel+XFExtension.h"

@interface HYHandleAffairsViewController ()<UITableViewDelegate, UITableViewDataSource, FaceResultDelegate, UITextFieldDelegate>

@property (nonatomic, strong) HYSearchView * searchView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * hotServiceArr;  // 热门服务数据
@property (nonatomic, strong) NSMutableArray * specialServiceArr;  // 专项服务数据
@property (nonatomic, strong) NSMutableArray * deparmentServiceArr; // 部门服务数据
@property (nonatomic, strong) NSMutableArray * countyServiceArr; // 县区服务数据
@property (nonatomic, copy) NSString * jumpUrl;  // 传给网页的url
@property (nonatomic, copy) NSString * code;  // 传给网页的code
@property (nonatomic, copy) NSString * titleStr;  // 传给网页的title
@property (nonatomic, assign) NSInteger type; // 0:专项 1:部门 2:县区
@property (nonatomic, copy) NSString *idCard;  // 身份证号 如果有则已实名认证 否则未实名认证
@property (nonatomic, assign) BOOL isEnterprise;  // true 企业  false 个人
@property (nonatomic, assign) BOOL isLogin;  // 是否已经登录

@end

@implementation HYHandleAffairsViewController

- (void)loadView {
    [super loadView];
    self.searchView = [[HYSearchView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(kTopNavHeight);
        make.height.mas_equalTo(53);
    }];
    self.searchView.searchTF.delegate = self;
    [self.searchView.searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kBottomTabBarHeight);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getUserByToken];
    }];
    [self.tableView registerClass:[HYGovernmentCell class] forCellReuseIdentifier:@"HYGovernmentCell"];
    [self.tableView registerClass:[HYPopularQueriesCell class] forCellReuseIdentifier:@"HYPopularQueriesCell"];
    [self.tableView registerClass:[HYSpecialServiceCell class] forCellReuseIdentifier:@"HYSpecialServiceCell"];
    [self.tableView registerClass:[HYGuessYouCell class] forCellReuseIdentifier:@"HYGuessYouCell"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    UILabel *titleLabel = [UILabel xf_labelWithText:@"办事"];
    if (_hyTitleColor) {
        titleLabel.textColor = _hyTitleColor;
    }
    self.navigationItem.titleView = titleLabel;
    
    [self traitCollectionDidChange:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
//    self.navigationController.navigationBar.hidden = YES;
    
//    // 判断是 push / present 还是 pop /dismiss
//    if ([self isBeingPresented] || [self isMovingToParentViewController]) {
//        // push / present
//    } else {
//        // pop /dismiss to here
//    }
    MainApi *api = [MainApi sharedInstance];
    if (api.token.length > 0) {
        self.isLogin = YES;
//        [self.tableView.mj_header beginRefreshing];
        [self getUserByToken];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.hidden = NO;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.searchView.backgroundColor = UIColorFromRGB(0x157AFF);
}

- (void)searchBtnClick:(UIButton *)sender {
    if (_searchView.searchTF.text.length == 0 || [_searchView.searchTF.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"搜索内容不能为空或者空格"];
        return;
    }
    HYHomeSearchViewController *homeSearchVC = [[HYHomeSearchViewController alloc] init];
    homeSearchVC.hyTitleColor = _hyTitleColor;
    homeSearchVC.searchStr = _searchView.searchTF.text;
    homeSearchVC.idCard = _idCard;
    homeSearchVC.isEnterprise = _isEnterprise;
    [self.navigationController pushViewController:homeSearchVC animated:YES];
}

- (NSMutableArray *)hotServiceArr {
    if (!_hotServiceArr) {
        _hotServiceArr = [NSMutableArray array];
    }
    return _hotServiceArr;
}

- (NSMutableArray *)specialServiceArr {
    if (!_specialServiceArr) {
        _specialServiceArr = [NSMutableArray array];
    }
    return _specialServiceArr;
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

- (void)getUserByToken {
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
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HttpRequest getPathZWBS:@"phone/item/event/getHotList" params:@{@"pageNum": @"1", @"pageSize": @"6"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@" 热门服务分类== %@ ",responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                self.hotServiceArr = [HYHotServiceModel mj_objectArrayWithKeyValuesArray:responseObject[@"rows"]];
                
                HYHotServiceModel *legalModel = [[HYHotServiceModel alloc] init];
                legalModel.name = @"法律援助指南";
                legalModel.logoUrl = @"legalAid";
                [self.hotServiceArr addObject:legalModel];
                
                HYHotServiceModel *moreModel = [[HYHotServiceModel alloc] init];
                moreModel.name = @"更多";
                moreModel.logoUrl = @"moreService";
                [self.hotServiceArr addObject:moreModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                });
            } else {
                SLog(@"%@", responseObject[@"msg"]);
            }
        }];
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HttpRequest getPathZWBS:@"phone/item/event/getSpecialTagList" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@" 专项服务1== %@ ", responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                self.specialServiceArr = [HYServiceContentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                });
            } else {
                SLog(@"%@", responseObject[@"msg"]);
            }
        }];
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HttpRequest getPathZWBS:@"phone/item/event/getCityAgentList" params:@{@"type": @"city"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@" 部门服务 == %@ ", responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                self.deparmentServiceArr = [HYDepartmentCountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
            SLog(@" 县区服务 == %@ ", responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                self.countyServiceArr = [HYDepartmentCountryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchView.searchTF resignFirstResponder];
    if (_searchView.searchTF.text.length == 0 || [_searchView.searchTF.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"搜索内容不能为空或者空格"];
        return YES;
    }
    // 跳转到搜索页面
    HYHomeSearchViewController *homeSearchVC = [[HYHomeSearchViewController alloc] init];
    homeSearchVC.searchStr = _searchView.searchTF.text;
    homeSearchVC.idCard = _idCard;
    homeSearchVC.isEnterprise = _isEnterprise;
    [self.navigationController pushViewController:homeSearchVC animated:YES];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchView.searchTF resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HYGovernmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYGovernmentCell"];
        cell.viewController = self;
        cell.hyTitleColor = _hyTitleColor;
        cell.idCard = _idCard;
        cell.isEnterprise = _isEnterprise;
        cell.isLogin = _isLogin;
        return cell;
    } else if (indexPath.row == 1) {
        HYPopularQueriesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYPopularQueriesCell"];
        cell.dataArray = self.hotServiceArr;
        __weak typeof(self) weakSelf = self;
        cell.popularQueriesCellBlock = ^(NSInteger index) {
            if (!weakSelf.isLogin) {
                return;
            }
            SLog(@"index:%ld", (long)index);
            [self popularQueriesJumpUrl:index];
        };
        return cell;
    } else if (indexPath.row == 2) {
        HYSpecialServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYSpecialServiceCell"];
        cell.viewController = self;
        cell.hyTitleColor = _hyTitleColor;
        cell.idCard = _idCard;
        cell.isEnterprise = _isEnterprise;
        cell.specialArray = self.specialServiceArr;
        cell.departmentArray = self.deparmentServiceArr;
        cell.countyArray = self.countyServiceArr;
        __weak typeof(self) weakSelf = self;
        cell.specialServiceCellBlock = ^(NSInteger index) {
            if (!weakSelf.isLogin) {
                return;
            }
            weakSelf.type = index;
            [tableView reloadData];
        };
        return cell;
    } else {
        HYGuessYouCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYGuessYouCell"];
        __weak typeof(self) weakSelf = self;
        cell.guessYouCellBlock = ^(NSInteger index) {
            if (!weakSelf.isLogin) {
                return;
            }
            if (!weakSelf.idCard || [weakSelf.idCard isEqualToString:@""]) {  // 需要实名认证
                [weakSelf showAlertForReanNameAuth];
            } else {
                HYHotServiceModel *model = weakSelf.hotServiceArr[index];
                if (model.outLinkFlag || model.servicePersonFlag || weakSelf.isEnterprise) { // 外链 内链个人  内链企业且已企业认证
                    HYGuessBusinessViewController *guessVC = [[HYGuessBusinessViewController alloc] init];
                    guessVC.isEnterprise = weakSelf.isEnterprise;
                    guessVC.hyTitleColor = weakSelf.hyTitleColor;
                    if (index == 0) {
                        guessVC.titleName = @"机动车业务";
                    } else if (index == 1) {
                        guessVC.titleName = @"驾驶证业务";
                    } else {
                        guessVC.titleName = @"医疗费用报销";
                    }
                    [weakSelf.navigationController pushViewController:guessVC animated:YES];
                } else {
                    // 提示企业认证
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"该事项只针对企业，请先进行企业实名认证" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:confirm];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
            }
        };
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 226;
    } else if (indexPath.row == 1) {
        return 253;
    } else if (indexPath.row == 2) {
        return 368;
//        if (_type == 0) {
//            return 88 + self.specialServiceArr.count * 70;
//        } else if (_type == 1) {
//            return 88 + self.deparmentServiceArr.count * 70;
//        } else {
//            return 88 + self.countyServiceArr.count * 70;
//        }
    } else {
        return 168;
    }
}

- (void)popularQueriesJumpUrl:(NSInteger)index {
    if (!_isLogin) {
        return;
    }
    HYHotServiceModel *model = self.hotServiceArr[index];
    if ([model.name isEqualToString:@"法律援助指南"]) {
        HYLegalAidGuideViewController *legalAidVC = [[HYLegalAidGuideViewController alloc] init];
        legalAidVC.hyTitleColor = self.hyTitleColor;
        [self.navigationController pushViewController:legalAidVC animated:YES];
    } else if ([model.name isEqualToString:@"更多"]) {
        if (!_idCard || [_idCard isEqualToString:@""]) { // 需要实名认证
            [self showAlertForReanNameAuth];
        } else {
            HYHotServiceViewController *hotServiceVC = [[HYHotServiceViewController alloc] init];
            hotServiceVC.isEnterprise = self.isEnterprise;
            hotServiceVC.hyTitleColor = self.hyTitleColor;
            [self.navigationController pushViewController:hotServiceVC animated:YES];
        }
    } else {
//        if ([model.canHandle boolValue] == NO) {
//            [SVProgressHUD showErrorWithStatus:@"该事项无法操作"];
//            return;
//        }
        // 判断逻辑如下：先判断是否实名认证 -- 再判断是否人脸识别 -- 再判断内外链（外链直接跳转，内链区分个人和企业 -- 个人直接跳转，企业判断是否企业认证）
        if (!_idCard || [_idCard isEqualToString:@""]) { // 需要实名认证
            [self showAlertForReanNameAuth];
        } else {
            if (model.needFaceRecognition.intValue == 1) { // 跳转人脸识别
                self.code = model.link;
                self.jumpUrl = model.jumpUrl;
                self.titleStr = model.name;
                FaceTipViewController *faceTipVC = [[FaceTipViewController alloc] init];
                faceTipVC.delegate = self;
                [self.navigationController pushViewController:faceTipVC animated:YES];
            } else {
                if ([model.outLinkFlag intValue] == 1) { // 外链
                    HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
                    webVC.code = model.link;
                    webVC.titleStr = model.name;
                    webVC.jumpUrl = model.jumpUrl;
                    [self.navigationController pushViewController:webVC animated:YES];
                } else if ([model.servicePersonFlag intValue] == 1 || self.isEnterprise) { // 内链个人  内链企业且已企业认证
                    HYOnLineBusinessMainViewController * mainVC = [[HYOnLineBusinessMainViewController alloc] init];
                    mainVC.serviceModel = model;
                    mainVC.hyTitleColor = self.hyTitleColor;
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


- (void)showAlertForReanNameAuth {
    HYRealNameAlertView *alertV = [[HYRealNameAlertView alloc] init];
    __weak typeof(self) weakSelf = self;
    alertV.alertResult = ^(NSInteger index) {
        if (index == 2) {
            [weakSelf jumpRealNameAuthVC];
        }
    };
    [alertV showAlertView];
}

- (void)jumpRealNameAuthVC {  // 实名认证
    
    // 类名
    NSString *class = [NSString stringWithFormat:@"%@", @"RealNameListVC"];
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

@end
