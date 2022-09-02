//
//  HYSpecialServiceContentController.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/14.
//
//  专项服务子页面

#import "HYSpecialServiceContentController.h"
#import "HYHotServiceTableViewCell.h"
#import "HYHandleAffairsWebVIewController.h"
#import "FaceTipViewController.h"
#import "HYOnLineBusinessMainViewController.h"
#import "HYCivicCenterCommand.h"

@interface HYSpecialServiceContentController () <UITableViewDelegate, UITableViewDataSource, FaceResultDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, copy) NSString * jumpUrl;  // 传给网页的url
@property (nonatomic, copy) NSString * code;  // 传给网页的code
@property (nonatomic, copy) NSString * titleStr;  // 传给网页的title

@end

NSString *const specialServiceCell = @"specialServiceCell";
@implementation HYSpecialServiceContentController

- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYHotServiceTableViewCell class] forCellReuseIdentifier:specialServiceCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    
    [self traitCollectionDidChange:nil];
}

- (void)loadData {
    [HttpRequest getPathZWBS:@"phone/item/event/getSpecialList" params:@{@"parentId": self.contentModel.id} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@"专项服务222== %@", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.datasArr = [HYHotServiceModel mj_objectArrayWithKeyValuesArray:responseObject[@"rows"]];
            [self.tableView reloadData];
        }
    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYHotServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:specialServiceCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.serviceModel = self.datasArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HYHotServiceModel *serviceModel = self.datasArr[indexPath.row];
//    if ([serviceModel.canHandle boolValue] == NO) {
//        [SVProgressHUD showErrorWithStatus:@"该事项无法操作"];
//        return;
//    }
    if ([serviceModel.needFaceRecognition intValue] == 1) {  // 跳转人脸识别
        self.code = serviceModel.link;
        self.titleStr = serviceModel.name;
        self.jumpUrl = serviceModel.jumpUrl;
        FaceTipViewController *faceTipVC = [[FaceTipViewController alloc] init];
        faceTipVC.delegate = self;
        [self.navigationController pushViewController:faceTipVC animated:YES];
    } else {
        if ([serviceModel.outLinkFlag intValue] == 1) {  // 外链
            HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
            webVC.code = serviceModel.link;
            webVC.titleStr = serviceModel.name;
            webVC.jumpUrl = serviceModel.jumpUrl;
            [self.navigationController pushViewController:webVC animated:YES];
        } else if (serviceModel.servicePersonFlag || self.isEnterprise) {  // 内链个人  内链企业且已企业认证
            HYOnLineBusinessMainViewController * mainVC = [[HYOnLineBusinessMainViewController alloc] init];
            mainVC.serviceModel = serviceModel;
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
