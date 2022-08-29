//
//  ChooseIndusreyViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/9/22.
//

#import "ChooseIndusreyViewController.h"
#import "ChooseIndustryModel.h"
#import "IndustryLeftTableViewCell.h"
#import "IndustryRightTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface ChooseIndusreyViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, strong) NSMutableArray *subDatasArr;
@property (nonatomic, copy) NSString *chooseName;
@property (nonatomic, copy) NSString *chooseID;

@end

NSString *const leftCell = @"leftCell";
NSString *const rightCell = @"rightCell";
@implementation ChooseIndusreyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"所属行业";
    
    [self configUI];
    
    [self loadData];
    
}

- (void)loadData {
    
    [HttpRequest postPath:@"/phone/v1/card/initIndustryNew" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 行业列表== %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.datasArr = [ChooseIndustryModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.leftTableView reloadData];
            [self.rightTableView reloadData];
        }
    }];
    
}

- (void)configUI {
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitle:@"保存" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightbutton.titleLabel.font = RFONT(15);
    rightbutton.frame = CGRectMake(0 , 0, 60, 44);
    
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:rightbutton];

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    spaceItem.width = -15;
    self.navigationItem.rightBarButtonItems = @[spaceItem,rightItem];
    
    [self.leftTableView registerClass:[IndustryLeftTableViewCell class] forCellReuseIdentifier:leftCell];
    [self.rightTableView registerClass:[IndustryRightTableViewCell class] forCellReuseIdentifier:rightCell];
    [self.view addSubview:self.leftTableView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(135);
    }];
    
    [self.view addSubview:self.rightTableView];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.left.equalTo(self.leftTableView.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

#pragma tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.leftTableView) {
        return self.datasArr.count;
    }
    return self.subDatasArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        IndustryLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = self.datasArr[indexPath.row];
        
        return cell;
    }
    IndustryRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.subDatasArr[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    indexPath.section
//    NSInteger index = indexPath.section;
    if (tableView == self.leftTableView) {
        
        ChooseIndustryModel *model = self.datasArr[indexPath.row];
        self.subDatasArr = model.children;
        [self.rightTableView reloadData];
        
    }else {
        
        ChooseIndustryModel *chooseModel = self.subDatasArr[indexPath.row];
        self.chooseName = chooseModel.typeName;
        self.chooseID = chooseModel.typeId;
        
    }
    
}

// 保存
- (void)rightClicked {
    
    if (self.chooseName.length == 0) {
        NSLog(@" 请先选择行业 ");
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(chooseIndustryWithName:andIndustryID:)]) {
        [self.delegate chooseIndustryWithName:self.chooseName andIndustryID:self.chooseID];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UITableView *)leftTableView {
    
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.backgroundColor = [UIColor whiteColor];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 48;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.tableFooterView = [[UIView alloc] init];
        _leftTableView.showsVerticalScrollIndicator = NO;
    }
    return _leftTableView;
    
}

- (UITableView *)rightTableView {
    
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]init];
        _rightTableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 48;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.tableFooterView = [[UIView alloc]init];
        _rightTableView.showsVerticalScrollIndicator = NO;
    }
    return _rightTableView;
    
}

- (NSMutableArray *)datasArr {
    
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
    
}

- (NSMutableArray *)subDatasArr {
    
    if (!_subDatasArr) {
        _subDatasArr = [NSMutableArray array];
    }
    return _subDatasArr;
    
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
