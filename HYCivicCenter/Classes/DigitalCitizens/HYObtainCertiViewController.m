//
//  HYObtainCertiViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/19.
//

#import "HYObtainCertiViewController.h"
#import "HYObtainCertiTableViewCell.h"
#import "HYGovServiceTableViewCell.h"
#import "HYServiceWebViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface HYObtainCertiViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;

@end

static NSString *obtainCell = @"obtainCell";
static NSString *serviceCell = @"ServiceCell";
@implementation HYObtainCertiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"考证服务"];
    
    [self configUI];
    
    [self loadData];
    
}

- (void)loadData {
    
    [HttpRequest getPath:@"/phone/v2/service/getAvailableService" params:@{@"parentId":self.serviceID} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 考证服务== %@ ",responseObject);
        self.datasArr = [HYServiceClassifyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.tableView reloadData];
        
    }];
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYGovServiceTableViewCell class] forCellReuseIdentifier:serviceCell];
    [self.tableView registerClass:[HYObtainCertiTableViewCell class] forCellReuseIdentifier:obtainCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(16, 16, 16, 16));
    }];
    
}

#pragma UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datasArr.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    HYServiceClassifyModel *classifyModel = self.datasArr[section];
    return classifyModel.children.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HYServiceClassifyModel *classifyModel = self.datasArr[indexPath.section];
    if ([classifyModel.remark isEqualToString:@"nurse"] || [classifyModel.remark isEqualToString:@"doctor"] || [classifyModel.remark isEqualToString:@"securityStaff"]) {// nurse  doctor  securityStaff
        // driver teacher
        
        HYObtainCertiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:obtainCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.classifyModel = classifyModel.children[indexPath.row];
        
        return cell;
        
    }else {
        
        HYGovServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = classifyModel.children[indexPath.row];
        
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HYServiceClassifyModel *classifyModel = self.datasArr[indexPath.section];
    if ([classifyModel.remark isEqualToString:@"nurse"] || [classifyModel.remark isEqualToString:@"doctor"] || [classifyModel.remark isEqualToString:@"securityStaff"]) {
        return 156;
    }
    return 50;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HYServiceClassifyModel *classifyModel = self.datasArr[section];
    if ([classifyModel.remark isEqualToString:@"nurse"] || [classifyModel.remark isEqualToString:@"doctor"] || [classifyModel.remark isEqualToString:@"securityStaff"] || [classifyModel.remark isEqualToString:@"teacher"]) {
        return nil;
    }

    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 32, 50)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"驾驶证服务";
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = BFONT(17);
    [contentView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(22);
        make.centerY.equalTo(contentView.mas_centerY);
    }];
    
    return contentView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    HYServiceClassifyModel *classifyModel = self.datasArr[section];
    if ([classifyModel.remark isEqualToString:@"driver"]) {
        return 50;
    }
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *sectionArr = [self.datasArr[indexPath.section] children];
    HYServiceClassifyModel *classifyModel = sectionArr[indexPath.row];
    [HttpRequest getPath:@"/phone/v2/service/buildServiceUrl" params:@{@"serviceName":classifyModel.serviceName} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
//        SLog(@" 返回== %@ ",responseObject[@"data"]);
        if ([responseObject[@"code"] intValue] == 200) {
            
            HYServiceWebViewController *webVC = [[HYServiceWebViewController alloc]init];
            webVC.serviceUrl = responseObject[@"data"];
            [self.navigationController pushViewController:webVC animated:YES];
            
        }
    }];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
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
