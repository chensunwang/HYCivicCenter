//
//  HYGovServiceViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/18.
//

#import "HYGovServiceViewController.h"
#import "HYGovServiceTableViewCell.h"
#import "HYServiceClassifyModel.h"
#import "HYServiceWebViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface HYGovServiceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;

@end

NSString *const HYGovServiceCell = @"govService";
@implementation HYGovServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"商业服务"];
    
    [self configUI];
    
    [self loadData];
    
}

- (void)loadData {
    
    [HttpRequest getPath:@"/phone/v2/service/getAvailableService" params:@{@"parentId":self.serviceID} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 政务服务== %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.datasArr = [HYServiceClassifyModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableView reloadData];
        }
    }];
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYGovServiceTableViewCell class] forCellReuseIdentifier:HYGovServiceCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(16, 16, 16, 16));
    }];
    
}

#pragma UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datasArr.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.datasArr[section] children].count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HYGovServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HYGovServiceCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *classifyArr = [self.datasArr[indexPath.section] children];
    cell.model = classifyArr[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 16;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 16)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return contentView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *classifyArr = [self.datasArr[indexPath.section] children];
    HYServiceClassifyModel *classifyModel = classifyArr[indexPath.row];
    [HttpRequest getPath:@"/phone/v2/service/buildServiceUrl" params:@{@"serviceName":classifyModel.serviceName} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 返回== %@ ",responseObject[@"data"]);
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
        _tableView.rowHeight = 50;
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
