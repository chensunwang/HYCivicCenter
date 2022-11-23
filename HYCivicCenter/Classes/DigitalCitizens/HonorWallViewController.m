//
//  HonorWallViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/12.
//

#import "HonorWallViewController.h"
#import "HonorWallTableViewCell.h"
#import "AddHonorViewController.h"
#import "HonorwallDetailViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface HonorWallViewController () <UITableViewDelegate,UITableViewDataSource,HonorDeleteDelegate,HonorDetailDeleteDelegate,AddHonorDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, strong) UIImageView *holderIV;
@property (nonatomic, strong) UILabel *holderLabel;

@end

NSString *const honorCell = @"honorCell";
@implementation HonorWallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"";
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"荣誉墙"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    [self buriedPoint];
    
}

- (void)buriedPoint {
    
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit",@"eventId": @"E0022",@"applicationId":@"H017"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ",responseObject);
    }];
    
}

- (void)loadData {
    
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUuid"];
    [HttpRequest postPath:@"/phone/v1/honor/myList" params:@{@"uuid": uuid ? : @""} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        XFLog(@" 荣誉墙列表== %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.datasArr = [HonorWallModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (self.datasArr.count > 0) {
                self.holderIV.hidden = YES;
                self.holderLabel.hidden = YES;
            }else {
                self.holderIV.hidden = NO;
                self.holderLabel.hidden = NO;
            }
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HonorWallTableViewCell class] forCellReuseIdentifier:honorCell];
    
    UIButton *addCardBtn = [[UIButton alloc]init];
//    [addCardBtn setBackgroundColor:[UIColor orangeColor]];
    [addCardBtn addTarget:self action:@selector(addHonorClicked) forControlEvents:UIControlEventTouchUpInside];
    addCardBtn.layer.cornerRadius = 30;
    addCardBtn.clipsToBounds = YES;
    [self.view addSubview:addCardBtn];
    
    UIImageView *addIV = [[UIImageView alloc]init];
    addIV.image = HyBundleImage(@"addCard");
    [addCardBtn addSubview:addIV];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"新增荣誉";
    nameLabel.font = RFONT(11);
    nameLabel.textColor = [UIColor whiteColor];
    [addCardBtn addSubview:nameLabel];
    
    self.holderIV = [[UIImageView alloc]init];
    self.holderIV.image = HyBundleImage(@"cardHolder");
    [self.view addSubview:self.holderIV];
    
    self.holderLabel = [[UILabel alloc]init];
    self.holderLabel.text = @"您还没有添加荣誉";
    self.holderLabel.textColor = UIColorFromRGB(0x212121);
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
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [addCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-[UIScreen mainScreen].bounds.size.height * 0.4);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [addIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(addCardBtn.mas_centerX);
        make.top.equalTo(addCardBtn.mas_top).offset(14);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addCardBtn.mas_bottom).offset(-14);
        make.centerX.equalTo(addCardBtn.mas_centerX);
    }];
    
    [addCardBtn layoutIfNeeded]; // 重点
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = addCardBtn.bounds;

    [addCardBtn.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0x1991FF).CGColor,(__bridge id)UIColorFromRGB(0x0F5CFF).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
}

#pragma tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datasArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HonorWallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:honorCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    cell.model = self.datasArr[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HonorWallModel *model = self.datasArr[indexPath.row];
    CGRect rect = [model.honorRemark boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 64, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:RFONT(12)}
                                         context:nil];
    return 136 + rect.size.height + ([UIScreen mainScreen].bounds.size.width - 64) * 0.58;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HonorWallModel *model = self.datasArr[indexPath.row];
    HonorwallDetailViewController *detailVC = [[HonorwallDetailViewController alloc]init];
    detailVC.honorId = model.id;
    detailVC.delegate = self;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

// 新增
- (void)addHonorClicked {
    
    AddHonorViewController *addHonorVC = [[AddHonorViewController alloc]init];
    addHonorVC.delegate = self;
    [self.navigationController pushViewController:addHonorVC animated:YES];
    
}

#pragma AddHonorDelegate
- (void)addHonor {
    
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit",@"eventId": @"E0022",@"applicationId":@"H016"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ",responseObject);
    }];
    
    [self loadData];
    
}

#pragma HonorDeleteDelegate
- (void)honorCell:(HonorWallTableViewCell *)cell didDeleteWithModel:(HonorWallModel *)model {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否删除当前荣誉" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [HttpRequest postPath:@"/phone/v1/honor/del" params:@{@"id":model.id} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            
            NSLog(@" 删除荣誉墙 == %@ ",responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                [self.datasArr removeObject:model];
                [self.tableView reloadData];
            }
            
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:confirmAction];
    [alertVC addAction:cancelAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)deleteHonorDetail {
    
    [self loadData];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
