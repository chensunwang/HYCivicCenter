//
//  CardDetailViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/20.
//

#import "CardDetailViewController.h"
#import "CardDetailTableViewCell.h"
#import "EditBusinessCardTableViewCell.h"
#import <ContactsUI/ContactsUI.h>
#import "HYContactManager.h"
#import "HYAesUtil.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface CardDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *mailBoxLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) EditBusinessCardModel *cardModel;

@end

NSString *const cardDetailCell = @"cardDetail";
@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"名片详情"];
    
    [self configBottomView];
    
    [self configUI];
    
    [self loadData];
    
}

- (void)loadData {
    
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit",@"eventId": @"E0061",@"applicationId":@"H021"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ",responseObject);
    }];
    
    [HttpRequest postPath:@"/phone/v2/card/getCardByUuid" params:@{@"uuid":self.cardID?self.cardID:@""} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSLog(@" 名片详情 == %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.cardModel = [EditBusinessCardModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.companyLabel.text = self.cardModel.companyName;
            [self.headerIV sd_setImageWithURL:[NSURL URLWithString:self.cardModel.headPhoto]];
            self.nameLabel.text = self.cardModel.name;
            self.jobLabel.text = self.cardModel.duty;
            self.phoneLabel.text = self.cardModel.phone;
            self.mailBoxLabel.text = self.cardModel.email;
            [self.tableView reloadData];
        }
        
    }];
    
}

- (UIView *)headerView {
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    
    UIImageView *bgIV = [[UIImageView alloc]init];
    bgIV.image = HyBundleImage(@"businessBG");
    [self.topView addSubview:bgIV];
    
    UIImageView *contentIV = [[UIImageView alloc]init];
    contentIV.image = HyBundleImage(@"busiContent");
    contentIV.userInteractionEnabled = YES;
    [self.topView addSubview:contentIV];
    
    self.companyLabel = [[UILabel alloc]init];
    self.companyLabel.textColor = [UIColor whiteColor];
    self.companyLabel.font = RFONT(12);
    [contentIV addSubview:self.companyLabel];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = RFONT(18);
    [contentIV addSubview:self.nameLabel];
    
    self.jobLabel = [[UILabel alloc]init];
    self.jobLabel.textColor = [UIColor whiteColor];
    self.jobLabel.font = RFONT(12);
    [contentIV addSubview:self.jobLabel];
    
    self.headerIV = [[UIImageView alloc]init];
    self.headerIV.layer.cornerRadius = 8;
    self.headerIV.clipsToBounds = YES;
    [contentIV addSubview:self.headerIV];
    
    self.phoneLabel = [[UILabel alloc]init];
    self.phoneLabel.textColor = [UIColor whiteColor];
    self.phoneLabel.font = RFONT(12);
    [contentIV addSubview:self.phoneLabel];
    
    self.mailBoxLabel = [[UILabel alloc]init];
    self.mailBoxLabel.textColor = [UIColor whiteColor];
    self.mailBoxLabel.font = RFONT(12);
    [contentIV addSubview:self.mailBoxLabel];
    
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.topView);
        make.height.mas_equalTo(154);
    }];
    
    [contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(16);
        make.top.equalTo(self.topView.mas_top).offset(16);
        make.right.equalTo(self.topView.mas_right).offset(-16);
        make.height.mas_equalTo(200);
    }];
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentIV.mas_left).offset(32);
        make.top.equalTo(contentIV.mas_top).offset(24);
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentIV.mas_top).offset(21);
        make.right.equalTo(contentIV.mas_right).offset(-21);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.mailBoxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentIV.mas_left).offset(32);
        make.bottom.equalTo(contentIV.mas_bottom).offset(-23);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentIV.mas_left).offset(32);
        make.bottom.equalTo(self.mailBoxLabel.mas_top).offset(-11);
    }];
    
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentIV.mas_left).offset(32);
        make.bottom.equalTo(self.phoneLabel.mas_top).offset(-26);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentIV.mas_left).offset(32);
        make.bottom.equalTo(self.jobLabel.mas_top).offset(-12);
    }];
    
//    self.companyLabel.text = @"南昌****有限公司";
//    self.headerIV.backgroundColor = [UIColor redColor];
//    self.nameLabel.text = @"张三";
//    self.jobLabel.text = @"总经理";
//    self.phoneLabel.text = @"137219291203";
//    self.mailBoxLabel.text = @"andone@163.com";
    return self.topView;
    
}

- (UIView *)footerView {
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    footerView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return footerView;
    
}

- (void)configBottomView {
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    UIButton *saveBtn = [[UIButton alloc]init];
    [saveBtn setTitle:@"保存到通讯录" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:UIColorFromRGB(0x157AFF)];
    saveBtn.titleLabel.font = RFONT(15);
    saveBtn.layer.cornerRadius = 20;
    saveBtn.clipsToBounds = YES;
    [saveBtn addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:saveBtn];
    
    UIButton *deleteBtn = [[UIButton alloc]init];
    [deleteBtn setTitle:@"删除名片" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [deleteBtn setBackgroundColor:UIColorFromRGB(0xE6E6E6)];
    deleteBtn.titleLabel.font = RFONT(15);
    deleteBtn.layer.cornerRadius = 20;
    deleteBtn.clipsToBounds = YES;
    [deleteBtn addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:deleteBtn];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight);
        make.height.mas_equalTo(60);
    }];
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 60) / 2;
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(16);
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, 40));
    }];
    
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).offset(-16);
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(width, 40));
    }];
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[CardDetailTableViewCell class] forCellReuseIdentifier:cardDetailCell];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
}

#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    }
    return 3;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 76)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UIView *whiteView = [[UIView alloc]init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:whiteView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0x157AFF);
    [whiteView addSubview:lineView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = UIColorFromRGB(0x333333);
    nameLabel.font = RFONT(15);
    [whiteView addSubview:nameLabel];
    
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.top.equalTo(contentView.mas_top).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.height.mas_equalTo(60);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView.mas_left).offset(16);
        make.centerY.equalTo(whiteView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(4, 18));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(8.5);
        make.centerY.equalTo(whiteView.mas_centerY);
    }];
    
    NSArray *titlesArr = @[@"联系信息",@"公司信息"];
    nameLabel.text = titlesArr[section];
    
    return contentView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 76;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardDetailCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        NSArray *imagesArr = @[@"info1",@"info2",@"info3",@"info4"];
        NSArray *titlesArr = @[@"电话",@"微信",@"邮箱",@"地址"];
        cell.headerIV.image = HyBundleImage(imagesArr[indexPath.row]);
        cell.nameLabel.text = titlesArr[indexPath.row];
        
        NSArray *contentArr = @[self.cardModel.phone?:@"",self.cardModel.weChat?:@"",self.cardModel.email?:@"",self.cardModel.address?:@""];
        cell.contentLabel.text = contentArr[indexPath.row];
        
        if (indexPath.row == 0) {
            cell.callBtn.hidden = NO;
//            cell.encryptStr = self.cardModel.phoneEncrypt;
            cell.cardModel = self.cardModel;
        }else {
            if (indexPath.row == 2) {
                cell.cardModel = self.cardModel;
            }
            if (indexPath.row == 3) {
                cell.contentLabel.font = RFONT(12);
                cell.contentLabel.numberOfLines = 0;
            }
            cell.reproduceBtn.hidden = NO;
        }
        
    }else {
        
        NSArray *imagesArr = @[@"info5",@"info6",@"info7"];
        NSArray *titlesArr = @[@"公司",@"职位",@"行业"];
        NSArray *contentArr = @[self.cardModel.companyName?:@"",self.cardModel.duty?:@"",self.cardModel.industryName?:@""];
        cell.reproduceBtn.hidden = NO;
        cell.headerIV.image = HyBundleImage(imagesArr[indexPath.row]);
        cell.nameLabel.text = titlesArr[indexPath.row];
        cell.contentLabel.text = contentArr[indexPath.row];
        
    }
    
    
    return cell;
    
}

// 保存到通讯录
- (void)saveClicked {
    
    if (!self.cardModel) {
        return;
    }
    HYContactManager *manager = [[HYContactManager alloc]init];
    [manager getContactAuthorization:^(BOOL isAuthorization) {
        if (isAuthorization) {
            
            CNContactStore *store = [[CNContactStore alloc]init];
            if (@available(iOS 11.0, *)) {
                
                NSString *mobile = [HYAesUtil aesDecrypt:self.cardModel.phoneEncrypt];
                NSPredicate *predicate = [CNContact predicateForContactsMatchingPhoneNumber:[CNPhoneNumber phoneNumberWithStringValue:mobile]];
                NSArray *keysToFetch = @[CNContactPhoneNumbersKey,CNContactFamilyNameKey];
                NSArray *contactArr = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keysToFetch error:nil];
                if (contactArr.count == 0) {
                    
                    CNMutableContact *contact = [self initializeContact];
                    CNSaveRequest *saveRequest = [[CNSaveRequest alloc]init];
                    [saveRequest addContact:contact toContainerWithIdentifier:nil];
                    
                    bool isSave = [store executeSaveRequest:saveRequest error:nil];
                    if (isSave) {
                        NSLog(@" 保存成功 ");
                        [SVProgressHUD showWithStatus:@"保存成功"];
                        [SVProgressHUD dismissWithDelay:0.5];
                    }
                    
                    
                }else {
                    
                    [SVProgressHUD showWithStatus:@"号码已经存在"];
                    [SVProgressHUD dismissWithDelay:0.5];
                    
                }
                  
            }else {
                
                CNMutableContact *contact = [self initializeContact];
                CNSaveRequest *saveRequest = [[CNSaveRequest alloc]init];
                [saveRequest addContact:contact toContainerWithIdentifier:nil];
                
                BOOL isSave = [store executeSaveRequest:saveRequest error:nil];
                if (isSave) {
                    NSLog(@" ios 9.0 保存成功 ");
                    [SVProgressHUD showWithStatus:@"保存成功"];
                    [SVProgressHUD dismissWithDelay:0.5];
                }
                
            }
            
        }
    }];
    
}

// 删除名片
- (void)deleteClicked {
    
    if (self.cardModel) {
        
        [HttpRequest postPath:@"/phone/v2/card/cancelCollect" params:@{@"collectId":self.cardModel.collectId?:@""} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
           
            NSLog(@" 删除名片成功 ");
            if ([responseObject[@"code"] intValue] == 200) {
             
                if ([self.delegate respondsToSelector:@selector(cardReload)]) {
                    [self.delegate cardReload];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        }];
        
    }
    
}

- (CNMutableContact *)initializeContact API_AVAILABLE(ios(9.0)) {
    
    CNMutableContact *contact = [[CNMutableContact alloc]init];
    NSString *name = [HYAesUtil aesDecrypt:self.cardModel.nameEncrypt];
    contact.familyName = name;
    
    NSString *mobile = [HYAesUtil aesDecrypt:self.cardModel.phoneEncrypt];
    CNPhoneNumber *mobileNumber = [[CNPhoneNumber alloc]initWithStringValue:mobile];
    CNLabeledValue *mobilePhone = [[CNLabeledValue alloc]initWithLabel:CNLabelPhoneNumberMobile value:mobileNumber];
    
    contact.phoneNumbers = @[mobilePhone];
    return contact;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self headerView];
        _tableView.tableFooterView = [self footerView];
    }
    return _tableView;
    
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
