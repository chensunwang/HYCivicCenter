//
//  HYDepartDetailViewController.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/5.
//
//  部门服务详情页

#import "HYDepartDetailViewController.h"
#import "HYAgentInfoModel.h"
#import "HYBusinessInfoModel.h"
#import "HYHotHandleAffairsModel.h"
#import "HYDepartDetailHotCell.h"
#import "HYDepartDetailBusinessCell.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"
#import "UILabel+XFExtension.h"

@interface HYDepartDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView * headerBgImgV;  // 头部背景
@property (nonatomic, strong) UIImageView * logoImgV;      // 部门logo
@property (nonatomic, strong) UILabel * nameLabel;         // 部门名称
@property (nonatomic, strong) UILabel * describeLabel;     // 部门描述
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * hotArr;
@property (nonatomic, strong) HYAgentInfoModel * infoModel;
@property (nonatomic, strong) NSMutableArray * personalArr;
@property (nonatomic, strong) NSMutableArray * companyArr;
@property (nonatomic, assign) NSInteger type;              // 0个人业务  1法人业务
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HYDepartDetailViewController

- (void)loadView {
    [super loadView];
    
    self.headerBgImgV = [[UIImageView alloc] init];
    [self.view addSubview:self.headerBgImgV];
    [self.headerBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopNavHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(110);
    }];
    self.headerBgImgV.image = HyBundleImage(@"icon_depart_bg");
    
    self.logoImgV = [[UIImageView alloc] init];
    [self.headerBgImgV addSubview:self.logoImgV];
    [self.logoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerBgImgV);
        make.left.mas_equalTo(16);
        make.width.height.mas_equalTo(60);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    [self.headerBgImgV addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImgV.mas_right).offset(15);
        make.top.equalTo(self.logoImgV).offset(7);
        make.height.mas_equalTo(17);
        make.right.equalTo(self.headerBgImgV).offset(-16);
    }];
    self.nameLabel.text = @"南昌市医疗保障局";
    self.nameLabel.font = MFONT(18);
    
    self.describeLabel = [[UILabel alloc] init];
    [self.headerBgImgV addSubview:self.describeLabel];
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.logoImgV).offset(-10);
        make.height.mas_equalTo(12);
    }];
    self.describeLabel.text = @"户政业务、交管业务、出入境业务等服务";
    self.describeLabel.font = MFONT(12);
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.headerBgImgV.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HYDepartDetailHotCell class] forCellReuseIdentifier:@"HYDepartDetailHotCell"];
    [self.tableView registerClass:[HYDepartDetailBusinessCell class] forCellReuseIdentifier:@"HYDepartDetailBusinessCell"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel = [UILabel xf_labelWithText:self.orgName];
    if (_hyTitleColor) {
        self.titleLabel.textColor = _hyTitleColor;
    }
    self.navigationItem.titleView = _titleLabel;

    [self loadData];
    
    [self traitCollectionDidChange:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.nameLabel.textColor = UIColor.whiteColor;
    self.describeLabel.textColor = UIColor.whiteColor;
}

- (void)loadData {
    [HttpRequest getPathZWBS:@"phone/item/event/getItemsByAgentCode" params:@{@"orgName": self.orgName} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 部门服务所有数据 == %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.hotArr = [HYHotHandleAffairsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"agentHotList"]];
            if (self.hotArr.count > 0) {
                HYHotHandleAffairsModel *model = [self.hotArr firstObject];
                if ([model.agentId isEqualToString:@"360101000201006000"]) { // 如果是南昌市公安局 添加一个“货车通行证”死数据
                    HYHotHandleAffairsModel *trucksModel = [[HYHotHandleAffairsModel alloc] init];
                    trucksModel.agentId = @"360101000201006000";
                    trucksModel.agentName = @"南昌市公安局";
                    trucksModel.hotName = @"货车通行证";
                    trucksModel.hotPic = @"https://nccsdn.yunshangnc.com/ncbd-policy/2022/8/5/1659670892041_pass-icon.png";
                    NSString *uuid = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUuid"];
                    trucksModel.jumpUrl = [NSString stringWithFormat:@"https://nc.tpms.jxangyi.cn/tpmswx-webapp/?openId=%@&comefrom=inc", uuid];
                    trucksModel.outLinkFlag = @"1";
                    [self.hotArr addObject:trucksModel];
                }
            }
            self.infoModel = [HYAgentInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"agentInfo"]];
            self.personalArr = [HYBusinessInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"person"]];
            self.companyArr = [HYBusinessInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"company"]];
            [self.tableView reloadData];
        } else {
            SLog(@"%@ ", responseObject[@"msg"]);
        }
    }];
}

- (void)setInfoModel:(HYAgentInfoModel *)infoModel {
    if (infoModel) {
        _infoModel = infoModel;
        [self.logoImgV sd_setImageWithURL:[NSURL URLWithString:_infoModel.orgPic]];
        self.nameLabel.text = _infoModel.orgName;
        self.describeLabel.text = _infoModel.remark;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _hotArr.count == 0 ? 1 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hotArr.count != 0 && indexPath.row == 0) {  // 热门办事
        HYDepartDetailHotCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HYDepartDetailHotCell" forIndexPath:indexPath];
        cell.viewController = self;
        cell.dataArray = self.hotArr;
        cell.hyTitleColor = _hyTitleColor;
        return cell;
    } else {
        HYDepartDetailBusinessCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HYDepartDetailBusinessCell" forIndexPath:indexPath];
        cell.viewController = self;
        cell.dataArray = _type == 0 ? _personalArr : _companyArr;
        cell.type = _type;
        cell.isEnterprise = _isEnterprise;
        cell.hyTitleColor = _hyTitleColor;
        cell.departDetailBusinessCellBlock = ^(NSInteger type) {
            self.type = type;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_hotArr.count != 0 && indexPath.row == 0) {
        int mo = _hotArr.count%3 == 0 ? 0 : 1;
        return (_hotArr.count/3 + mo)*100 + 50;
    } else {
        // 根据数组计算整个页面的高度 返回上个页面渲染cell 总高度 = 段头高度 + 表高度 + 段尾高度 + 头部高度 + 底部安全高度
        NSMutableArray * tempArr = _type == 0 ? _personalArr : _companyArr;
        CGFloat headerHeight = [self caculateHeightForSectionWithArray:tempArr];
        CGFloat rowHeight = [self caculateHeightForRowWithArray:tempArr];
        CGFloat footerHeight = tempArr.count * 16;
        CGFloat totalHeight = headerHeight + rowHeight + footerHeight + 46 + 20 + kSafeAreaBottomHeight;
        return totalHeight;
    }
}

// 计算段头高度
- (CGFloat)caculateHeightForSectionWithArray:(NSMutableArray *)array {
    CGFloat totalHeight = 0;
    for (HYBusinessInfoModel * model in array) {
        CGFloat height = [model.littleTitle heightForStringWithFont:MFONT(12) width:([UIScreen mainScreen].bounds.size.width - 54 - 32)];
        height += 64;
        totalHeight += height;
    }
    return totalHeight;
}

// 计算表格高度
- (CGFloat)caculateHeightForRowWithArray:(NSMutableArray *)array {
    CGFloat totalHeight = 0;
    for (HYBusinessInfoModel * model in array) {
        for (HYBusinessInfoModel * mo in model.agentTitleList) {
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paraStyle.alignment = NSTextAlignmentLeft;
            paraStyle.lineSpacing = 4; //设置行间距
            paraStyle.minimumLineHeight = 10;
            NSDictionary *attribtDic = @{NSFontAttributeName:MFONT(16), NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSParagraphStyleAttributeName:paraStyle};
            CGRect rect = [mo.name boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 72 - 32, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attribtDic
                                                context:nil];
            
            CGFloat height = rect.size.height + 20;
            totalHeight += height;
        }
    }
    return totalHeight;
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
