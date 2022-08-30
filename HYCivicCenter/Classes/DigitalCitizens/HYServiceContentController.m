//
//  HYServiceContentController.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/18.
//

#import "HYServiceContentController.h"
#import "HYGovServiceTableViewCell.h"
#import "HYServiceWebViewController.h"
#import "HYCivicCenterCommand.h"

@interface HYServiceContentController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray *datasArr;

@end

NSString *const HYServiceCell = @"serviceCell";
@implementation HYServiceContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self configUI];
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYGovServiceTableViewCell class] forCellReuseIdentifier:HYServiceCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

- (void)setDatasArr:(NSArray *)datasArr {
    _datasArr = datasArr;
    
    [self.tableView reloadData];
    
}

#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datasArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HYGovServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HYServiceCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HYServiceClassifyModel *classifyModel = self.datasArr[indexPath.row];
    cell.model = classifyModel;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HYServiceClassifyModel *classifyModel = self.datasArr[indexPath.row];
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

//- (NSMutableArray *)datasArr {
//
//    if (!_datasArr) {
//        _datasArr = [NSMutableArray array];
//    }
//    return _datasArr;
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
