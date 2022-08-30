//
//  BusinessCardViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/16.
//

#import "BusinessCardViewController.h"
#import "BusinessCardTableViewCell.h"
#import "CardDetailViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface BusinessCardViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CardDeleteDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, strong) NSMutableArray *letterArr;
@property (nonatomic, strong) UIImageView *holderIV;
@property (nonatomic, strong) UILabel *holderLabel;

@end

NSString *const businessCardCell = @"cardCell";
@implementation BusinessCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"";
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"名片夹"];
    
    [self configSearchView];
    
    [self configUI];
    
//    [self loadData];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)loadDatawithName:(NSString *)name {
    
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit",@"eventId": @"E0061",@"applicationId":@"H019"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ",responseObject);
    }];
    
    [HttpRequest postPath:@"/phone/v2/card/myCollectCardList" params:@{@"name":name} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        XFLog(@" 名片夹== %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
//            self.datasArr = [BusinessCardModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            NSArray *arr = [BusinessCardModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            if (arr.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.holderIV.hidden = YES;
                    self.holderLabel.hidden = YES;
                });
            }else {
                self.holderIV.hidden = NO;
                self.holderLabel.hidden = YES;
            }
            self.datasArr = [self sortObjectsAccordingToInitialWithDatasArr:arr];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)loadData {
    
    [self loadDatawithName:@""];
    
}

- (NSMutableArray *)sortObjectsAccordingToInitialWithDatasArr:(NSArray *)array {
    
    UILocalizedIndexedCollation *collaction = [UILocalizedIndexedCollation currentCollation];
    
    // 27个 A~Z+ #
    NSInteger sectionTitlesCount = [[collaction sectionTitles] count];
    
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc]initWithCapacity:sectionTitlesCount];
    
    for (NSInteger index = 0; index < sectionTitlesCount; index ++) {
        NSMutableArray *sectionArr = [[NSMutableArray alloc]init];
        [newSectionsArray addObject:sectionArr];
        
        [self.letterArr addObject:[collaction sectionTitles][index]];
    }
    
    for (BusinessCardModel *cardModel in array) {
        NSInteger sectionNumber = [collaction sectionForObject:cardModel collationStringSelector:@selector(nameFirstSpell)];
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:cardModel];
    }
    
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collaction sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(nameFirstSpell)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    return newSectionsArray;
}

- (void)configSearchView {
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopNavHeight, [UIScreen mainScreen].bounds.size.width, 50)];
    contentView.backgroundColor = UIColorFromRGB(0x157AFF);
    [self.view addSubview:contentView];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 36, 32)];
    UIImageView *searchIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 16, 16)];
    searchIV.image = [UIImage imageNamed:BundleFile(@"search")];
    [leftView addSubview:searchIV];
    
    UITextField *searchTF = [[UITextField alloc]init];
    searchTF.backgroundColor = [UIColor whiteColor];
    searchTF.placeholder = @"请输入搜索内容";
    searchTF.leftView = leftView;
    searchTF.leftViewMode = UITextFieldViewModeAlways;
    searchTF.layer.cornerRadius = 16;
    searchTF.clipsToBounds = YES;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.delegate = self;
    [contentView addSubview:searchTF];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0xF5F5F5) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = RFONT(15);
    [cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-17);
        make.centerY.equalTo(contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(32, 24));
    }];
    
    [searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.right.equalTo(cancelBtn.mas_left).offset(-13);
        make.centerY.equalTo(contentView.mas_centerY);
        make.height.mas_equalTo(32);
    }];
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[BusinessCardTableViewCell class] forCellReuseIdentifier:businessCardCell];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(kSafeAreaBottomHeight);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight + 50);
    }];
    
    self.holderIV = [[UIImageView alloc]init];
    self.holderIV.image = [UIImage imageNamed:BundleFile(@"cardHolder")];
    [self.view addSubview:self.holderIV];
    
    self.holderLabel = [[UILabel alloc]init];
    self.holderLabel.text = @"您还没有添加好友";
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
    
}

#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datasArr.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.datasArr[section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BusinessCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:businessCardCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.datasArr[indexPath.section][indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([self.datasArr[section] count] > 0) {
        return 30;
    }
    return 0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.letterArr[section];
    
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.letterArr;
    
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor = UIColorFromRGB(0xF5F5F5);
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    header.textLabel.font = RFONT(18);
    header.textLabel.textColor = UIColorFromRGB(0x333333);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BusinessCardModel *model = self.datasArr[indexPath.section][indexPath.row];
    CardDetailViewController *cardVC = [[CardDetailViewController alloc]init];
    cardVC.cardID = model.uuid;
    cardVC.delegate = self;
    [self.navigationController pushViewController:cardVC animated:YES];
    
}

#pragma Textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self loadDatawithName:textField.text];
    return YES;
    
}

#pragma cardDeleteDelegate
- (void)cardReload {
    
    [self loadData];
    
}

- (void)cancelClicked {
    
    [self loadData];
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 96;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
    
}

- (NSMutableArray *)datasArr {
    
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
    
}

- (NSMutableArray *)letterArr {
    
    if (!_letterArr) {
        _letterArr = [NSMutableArray array];
    }
    return _letterArr;
    
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
