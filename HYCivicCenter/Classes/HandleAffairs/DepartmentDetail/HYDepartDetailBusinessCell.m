//
//  HYDepartDetailBusinessCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/7.
//
//  个人业务/法人业务cell

#import "HYDepartDetailBusinessCell.h"
#import "HYDDBusinessCell.h"
#import "HYBusinessInfoModel.h"
#import "HYHandleAffairsWebVIewController.h"
#import "FaceTipViewController.h"
#import "HYEmptyView.h"
#import "HYOnLineBusinessMainViewController.h"
#import "HYCivicCenterCommand.h"

@interface HYDepartDetailBusinessCell ()<UITableViewDelegate, UITableViewDataSource, FaceResultDelegate>

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIButton * personalBtn;
@property (nonatomic, strong) UIButton * companyBtn;
@property (nonatomic, strong) UIView * lineview;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy) NSString * jumpUrl;  // 传给网页的url
@property (nonatomic, copy) NSString * code;  // 传给网页的code
@property (nonatomic, copy) NSString * titleStr;  // 传给网页的title
@property (nonatomic, strong) HYEmptyView *emptyView;

@end

@implementation HYDepartDetailBusinessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
        [self traitCollectionDidChange:nil];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    _bgView = [[UIView alloc] init];
    _headerView = [[UIView alloc] init];
    _personalBtn = [[UIButton alloc] init];
    _companyBtn = [[UIButton alloc] init];
    _lineview = [[UIView alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.contentView addSubview:_bgView];
    [self.bgView addSubview:_headerView];
    [self.headerView addSubview:_personalBtn];
    [self.headerView addSubview:_companyBtn];
    [self.headerView addSubview:_lineview];
    [self.contentView addSubview:_tableView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(46);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(40);
    }];
    
    [self.personalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.headerView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*0.5);
    }];
    [self.personalBtn setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
    [self.personalBtn setTitle:@"个人业务" forState:UIControlStateNormal];
    self.personalBtn.titleLabel.font = MFONT(12);
    [self.personalBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.companyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*0.5);
        make.top.right.equalTo(self.headerView);
        make.height.mas_equalTo(40);
    }];
    [self.companyBtn setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
    [self.companyBtn setTitle:@"法人业务" forState:UIControlStateNormal];
    self.companyBtn.titleLabel.font = MFONT(12);
    [self.companyBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.personalBtn);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(3);
        make.bottom.equalTo(self.headerView);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(15);
        make.left.mas_equalTo(16);
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self).offset(-kSafeAreaBottomHeight);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[HYDDBusinessCell class] forCellReuseIdentifier:@"HYDDBusinessCell"];
    
    self.emptyView = [[HYEmptyView alloc] init];
    [self.contentView addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset([UIScreen mainScreen].bounds.size.height/3);
        make.width.mas_equalTo(155);
        make.height.mas_equalTo(204);
    }];
    self.emptyView.hidden = YES;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColor.whiteColor;
    self.bgView.backgroundColor = UIColorFromRGB(0xEBEFF5);
    self.headerView.backgroundColor = UIColor.whiteColor;
    if (_type == 0) {
        [self.personalBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
        [self.companyBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    } else {
        [self.personalBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.companyBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    }
    self.lineview.backgroundColor = UIColorFromRGB(0x157AFF);
    self.tableView.backgroundColor = UIColor.whiteColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setType:(NSInteger)type {
    _type = type;
    [self.lineview removeFromSuperview];
    if (type == 0) {
        [self.personalBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
        [self.companyBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.headerView addSubview:_lineview];
        [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.personalBtn);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(3);
            make.bottom.equalTo(self.headerView);
        }];
    } else {
        [self.personalBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.companyBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
        [self.headerView addSubview:_lineview];
        [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.companyBtn);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(3);
            make.bottom.equalTo(self.headerView);
        }];
    }
    [self.tableView reloadData];
    
    if (_dataArray.count == 0) {
        self.tableView.hidden = YES;
        self.emptyView.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.emptyView.hidden = YES;
    }
}

- (void)btnClicked:(UIButton *)sender {
    CGFloat flag = 0;
    if ([sender.titleLabel.text isEqualToString:@"个人业务"]) {
        flag = 0;
        [self.lineview removeFromSuperview];
        [self.personalBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
        [self.companyBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.headerView addSubview:_lineview];
        [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.personalBtn);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(3);
            make.bottom.equalTo(self.headerView);
        }];
    } else {
        if (!_isEnterprise) { //
            // 提示企业认证
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"该事项只针对企业，请先进行企业实名认证" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:confirm];
            [self.viewController presentViewController:alert animated:YES completion:nil];
            return;
        }
        
        flag = 1;
        [self.lineview removeFromSuperview];
        [self.personalBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [self.companyBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
        [self.headerView addSubview:_lineview];
        [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.companyBtn);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(3);
            make.bottom.equalTo(self.headerView);
        }];
    }
    
    if (self.departDetailBusinessCellBlock != nil) {
        self.departDetailBusinessCellBlock(flag);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HYBusinessInfoModel *infoModel = _dataArray[section];
    return infoModel.agentTitleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYDDBusinessCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HYDDBusinessCell" forIndexPath:indexPath];
    HYBusinessInfoModel * infoModel = _dataArray[indexPath.section];
    cell.infoModel = infoModel.agentTitleList[indexPath.row];
    cell.viewController = self.viewController;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HYDDBHeaderForSection * view = [[HYDDBHeaderForSection alloc] init];
    HYBusinessInfoModel * infoModel = _dataArray[section];
    view.model = infoModel;
    view.viewController = self.viewController;
    view.hyTitleColor = _hyTitleColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYBusinessInfoModel * infoModel = _dataArray[indexPath.section];
    HYBusinessInfoModel * model = infoModel.agentTitleList[indexPath.row];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 4; //设置行间距
    paraStyle.minimumLineHeight = 10;
    NSDictionary *attribtDic = @{NSFontAttributeName:MFONT(16), NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSParagraphStyleAttributeName:paraStyle};
    CGRect rect = [model.name boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 72 - 32, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attribtDic
                                           context:nil];
    
    return rect.size.height + 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HYBusinessInfoModel * infoModel = _dataArray[section];
    // 计算出littleTitle字符串的高度
    CGFloat height = [infoModel.littleTitle heightForStringWithFont:MFONT(12) width:([UIScreen mainScreen].bounds.size.width - 54 - 32)];
    return 64 + height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 16;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HYBusinessInfoModel * infoModel = _dataArray[indexPath.section];
    HYBusinessInfoModel * model = infoModel.agentTitleList[indexPath.row];
    if (infoModel.needFaceRecognition.intValue == 1) { // 跳转人脸
        self.code = infoModel.link;
        self.titleStr = infoModel.name;
        self.jumpUrl = infoModel.jumpUrl;
        FaceTipViewController *faceTipVC = [[FaceTipViewController alloc]init];
        faceTipVC.delegate = self;
        [self.viewController.navigationController pushViewController:faceTipVC animated:YES];
    } else {  // 内链：跳本地在线办事页面  外链：跳网页在线办事页面
        if (infoModel.outLinkFlag.intValue == 0) {
            HYOnLineBusinessMainViewController * mainVC = [[HYOnLineBusinessMainViewController alloc] init];
            mainVC.infoModel = model;
            mainVC.hyTitleColor = _hyTitleColor;
            [self.viewController.navigationController pushViewController:mainVC animated:YES];
        } else {
            HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
            webVC.code = model.link;
            webVC.titleStr = model.name;
            webVC.jumpUrl = model.jumpUrl;
            [self.viewController.navigationController pushViewController:webVC animated:YES];
        }
    }
}

#pragma mark - FaceResult

- (void)getFaceResultWithImageStr:(NSString *)imageStr deviceId:(NSString *)deviceid skey:(NSString *)skey {
    [HttpRequest postPathZWBS:@"phone/item/event/api" params:@{@"uri": @"/apiFile/discernFace", @"app": @"ios", @"file": imageStr, @"deviceId": deviceid, @"skey": skey} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 人脸识别== %@ ", responseObject);
        if ([responseObject[@"success"] intValue] == 1) {
            HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
            webVC.code = self.code;
            webVC.titleStr = self.titleStr;
            webVC.jumpUrl = self.jumpUrl;
            [self.viewController.navigationController pushViewController:webVC animated:YES];
        }
    }];
}

@end
