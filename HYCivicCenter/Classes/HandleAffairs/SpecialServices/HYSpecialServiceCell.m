//
//  HYSpecialServiceCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//
//  专项服务cell

#import "HYSpecialServiceCell.h"
#import "HYSSTableViewCell.h"
#import "HYSpecialServiceViewController.h"
#import "HYServiceContentTableViewCell.h"
#import "HYAreaServiceViewController.h"
#import "HYDepartDetailViewController.h"
#import "HYRealNameAlertView.h"
#import "HYCivicCenterCommand.h"

@interface HYSpecialServiceCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIButton * specialBtn;  // 专项服务
@property (nonatomic, strong) UIButton * departmentBtn;  // 部门服务
@property (nonatomic, strong) UIButton * countyBtn;  // 县区服务
@property (nonatomic, strong) UIView * lineView;  // 指示条
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, assign) NSInteger type; // 0:专项服务 1:部门服务 2:县区服务

@end

@implementation HYSpecialServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.type = 0;
        [self setupUI];
        [self traitCollectionDidChange:nil];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSpecialArray:(NSMutableArray *)specialArray {
    if (specialArray) {
        _specialArray = specialArray;
        [self.tableView reloadData];
    }
}

- (void)setDepartmentArray:(NSMutableArray *)departmentArray {
    if (departmentArray) {
        _departmentArray = departmentArray;
        [self.tableView reloadData];
    }
}

- (void)setCountyArray:(NSMutableArray *)countyArray {
    if (countyArray) {
        _countyArray = countyArray;
        [self.tableView reloadData];
    }
}

- (void)setupUI {
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(18, 10, 10, 10));
    }];
    self.bgView.layer.cornerRadius = 10;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
        make.height.mas_equalTo(51);
    }];
    
    self.specialBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.topView addSubview:self.specialBtn];
    [self.specialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(28);
        make.top.height.mas_equalTo(17);
    }];
    [self.specialBtn setTitle:@"专项服务" forState:UIControlStateNormal];
    self.specialBtn.titleLabel.font = MFONT(17);
    [self.specialBtn addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.departmentBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.topView addSubview:self.departmentBtn];
    [self.departmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.top.height.mas_equalTo(17);
    }];
    [self.departmentBtn setTitle:@"部门服务" forState:UIControlStateNormal];
    self.departmentBtn.titleLabel.font = MFONT(17);
    [self.departmentBtn addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.countyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.topView addSubview:self.countyBtn];
    [self.countyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView).offset(-28);
        make.top.height.mas_equalTo(17);
    }];
    [self.countyBtn setTitle:@"县区服务" forState:UIControlStateNormal];
    self.countyBtn.titleLabel.font = MFONT(17);
    [self.countyBtn addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.topView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.specialBtn);
        make.top.equalTo(self.specialBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(25);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView).offset(-10);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HYSSTableViewCell class] forCellReuseIdentifier:@"HYSSTableViewCell"];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColorFromRGB(0xEBEFF5);
    self.bgView.backgroundColor = UIColor.whiteColor;
    [self.specialBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    [self.departmentBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [self.countyBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    
    self.lineView.backgroundColor = UIColorFromRGB(0x157AFF);
}

- (void)switchBtnClicked:(UIButton *)sender {
    NSArray * subViews = [self.topView subviews];
    for (UIView * view in subViews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        }
    }
    [sender setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    
    if ([sender.titleLabel.text isEqualToString:@"专项服务"]) {
        self.type = 0;
    } else if ([sender.titleLabel.text isEqualToString:@"部门服务"]) {
        self.type = 1;
    } else {
        self.type = 2;
    }
    if (self.specialServiceCellBlock) {
        self.specialServiceCellBlock(_type);
    }
    [self.lineView removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        [self.topView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(sender);
            make.top.equalTo(sender.mas_bottom).offset(10);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(25);
        }];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _type == 0 ? _specialArray.count : (_type == 1 ? _departmentArray.count : _countyArray.count);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYSSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYSSTableViewCell" forIndexPath:indexPath];
    if (_type == 0) {
        cell.specialModel = self.specialArray[indexPath.row];
    } else if (_type == 1) {
        cell.departmentModel = self.departmentArray[indexPath.row];
    } else {
        cell.departmentModel = self.countyArray[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 0) { // 专项服务
        if (!_idCard || [_idCard isEqualToString:@""]) { // 需要实名认证
            [self showAlertForReanNameAuth];
        } else {
            HYSpecialServiceViewController *specialVC = [[HYSpecialServiceViewController alloc] init];
            specialVC.index = indexPath.row;
            specialVC.headerArr = self.specialArray;
            specialVC.isEnterprise = _isEnterprise;
            [self.viewController.navigationController pushViewController:specialVC animated:YES];
        }
    } else if (_type == 1) {  // 部门服务
        if (!_idCard || [_idCard isEqualToString:@""]) { // 需要实名认证
            [self showAlertForReanNameAuth];
        } else {
            HYDepartmentCountryModel *departmentModel = self.departmentArray[indexPath.row];
            HYDepartDetailViewController * businessVC = [[HYDepartDetailViewController alloc] init];
            businessVC.orgName = departmentModel.title;
            businessVC.isEnterprise = _isEnterprise;
            [self.viewController.navigationController pushViewController:businessVC animated:YES];
        }
    } else {  // 县区服务
        if (!_idCard || [_idCard isEqualToString:@""]) { // 需要实名认证
            [self showAlertForReanNameAuth];
        } else {
            HYDepartmentCountryModel *departmentModel = self.countyArray[indexPath.row];
            HYAreaServiceViewController *areaVC = [[HYAreaServiceViewController alloc] init];
            areaVC.titleString = departmentModel.title;
            areaVC.orgCode = departmentModel.orgCode;
            areaVC.isEnterprise = _isEnterprise;
            [self.viewController.navigationController pushViewController:areaVC animated:YES];
        }
    }
}

- (void)showAlertForReanNameAuth {
    HYRealNameAlertView *alertV = [[HYRealNameAlertView alloc] init];
    alertV.alertResult = ^(NSInteger index) {
        if (index == 2) {
            [self jumpRealNameAuthVC];
        }
    };
    [alertV showAlertView];
}

- (void)jumpRealNameAuthVC {  // 实名认证
    
    // 类名
    NSString *class =[NSString stringWithFormat:@"%@", @"RealNameListVC"];
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    
    // 从一个字串返回一个类
    Class newClass = objc_getClass(className);
    if (!newClass)
    {
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象
    UIViewController *instance = [[newClass alloc] init];
    instance.hidesBottomBarWhenPushed = true;
    [self.viewController.navigationController pushViewController:instance animated:true];
    
}

@end
