//
//  HYSearchServiceViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/22.
//

#import "HYSearchServiceViewController.h"
#import "HYSearchServiceTableViewCell.h"
#import "HYSearchServiceModel.h"
#import "HYServiceSelectView.h"
#import "HYSelectIndustry.h"
#import "HYDatePickerView.h"
#import "HYGovServiceViewController.h"
#import "HYBusinessServiceViewController.h"
#import "HYObtainCertiViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"
#import "UILabel+XFExtension.h"

@interface HYSearchServiceViewController () <UITableViewDelegate, UITableViewDataSource, HYDatePickerDelegate, HYSelectServiceDelegate, HYSelectIndustryDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, strong) NSMutableArray *areaArr;
@property (nonatomic, strong) NSMutableArray *industryArr;
@property (nonatomic, strong) NSMutableArray *nationalityArr;
@property (nonatomic, strong) NSMutableArray *blindArr;
@property (nonatomic, strong) NSMutableArray *disableArr;
@property (nonatomic, strong) UITextField *positionTF;
@property (nonatomic, strong) UITextField *occupationTF;
@property (nonatomic, strong) HYServiceAvalilableModel *serviceModel;

@end

@implementation HYSearchServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"查询可享服务"];
    
    [self configUI];
    
    [self loadData];
    
}

- (void)loadData {
    
    [HttpRequest getPath:@"/phone/v2/service/getServiceUserInfo" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 查询可享服务 === %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.serviceModel = [HYServiceAvalilableModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.tableView reloadData];
        }
    }];
    
    [HttpRequest getPath:@"/phone/v2/service/getValueList" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
       
        SLog(@" 获取用户表单元素填写规则 == %@ ",responseObject);
        // 是否盲人
        // 是否残疾
        // 行业
        // 区域
        if ([responseObject[@"code"] intValue] == 200) {
            
            NSArray *areaArr = [HYServiceChildrenModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"area"]];
            self.areaArr = [NSMutableArray arrayWithArray:[areaArr[0] children]];
            
            NSArray *industryArr = [HYServiceChildrenModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"industry"]];
            self.industryArr = [NSMutableArray arrayWithArray:[industryArr[0] children]];
            
            NSArray *nationaArr = [HYServiceChildrenModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"nationality"]];
            self.nationalityArr = [NSMutableArray arrayWithArray:[nationaArr[0] children]];
            
            NSArray *blindArr = [HYServiceChildrenModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"whetherBlind"]];
            self.blindArr = [NSMutableArray arrayWithArray:[blindArr[0] children]];
            
            NSArray *disabilityArr = [HYServiceChildrenModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"whetherDisability"]];
            self.disableArr = [NSMutableArray arrayWithArray:[disabilityArr[0] children]];
            
        }
        
    }];
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    
}

- (UIView *)footerView {
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 32, 118)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UIButton *searchBtn = [[UIButton alloc]init];
    [searchBtn setTitle:@"查询可享服务" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = RFONT(15);
    searchBtn.layer.cornerRadius = 23;
    searchBtn.clipsToBounds = YES;
    [searchBtn addTarget:self action:@selector(searchAvalilabelService) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:searchBtn];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(8);
        make.right.equalTo(contentView.mas_right).offset(-8);
        make.centerY.equalTo(contentView.mas_centerY);
        make.height.mas_equalTo(46);
    }];
    
    [searchBtn layoutIfNeeded]; // 重点
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = searchBtn.bounds;
    
    [searchBtn.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0x1991FF).CGColor,(__bridge id)UIColorFromRGB(0x0F5CFF).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    return contentView;
    
}

#pragma UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 5;
    }else if (section == 1) {
        return self.serviceModel.schoolName.length > 0?4:0;
    }else if (section == 2) {
        return 3;
    }else {
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    HYSearchServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[HYSearchServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        
        NSArray *namesArr = @[@"姓名",@"性别",@"年龄",@"国籍",@"区域"];
        cell.nameLabel.text = namesArr[indexPath.row];
        cell.contentLabel.hidden = NO;
        if (indexPath.row == 0) {
            cell.mustLabel.hidden = NO;
            cell.contentLabel.text = self.serviceModel.nickName;
            cell.contentLabel.textColor = UIColorFromRGB(0x999999);
        }else if (indexPath.row == 1) {
            cell.mustLabel.hidden = NO;
            cell.contentLabel.text = self.serviceModel.sex;
            cell.contentLabel.textColor = UIColorFromRGB(0x999999);
        }else if (indexPath.row == 2) {
            cell.mustLabel.hidden = NO;
            cell.contentLabel.text = self.serviceModel.age;
            cell.contentLabel.textColor = UIColorFromRGB(0x999999);
        }else if (indexPath.row == 3) {
            cell.contentLabel.text = self.serviceModel.nationalityName;
        }else if (indexPath.row == 4) {
            cell.mustLabel.hidden = NO;
            cell.contentLabel.text = self.serviceModel.areaName;
        }
        
    }else if (indexPath.section == 1) {
        
        NSArray *namesArr = @[@"学校",@"专业",@"入学时间",@"毕业时间"];
        cell.nameLabel.text = namesArr[indexPath.row];
        cell.mustLabel.hidden = NO;
        cell.contentLabel.hidden = NO;
        if (indexPath.row == 0) {
//            cell.contentTF.hidden = NO;
//            cell.contentTF.placeholder = @"请填写学校";
//            cell.saveData = ^(NSString * _Nonnull text) {
//                self.serviceModel.schoolName = text;
//            };
//            cell.contentTF.text = self.serviceModel.schoolName;
            cell.contentLabel.textColor = UIColorFromRGB(0x999999);
            cell.contentLabel.text = self.serviceModel.schoolName;
        }else if (indexPath.row == 1) {
//            cell.contentTF.hidden = NO;
//            cell.contentTF.placeholder = @"请填写专业";
//            cell.saveData = ^(NSString * _Nonnull text) {
//                self.serviceModel.major = text;
//            };
//            cell.contentTF.text = self.serviceModel.major;
            cell.contentLabel.textColor = UIColorFromRGB(0x999999);
            cell.contentLabel.text = self.serviceModel.major;
        }else if (indexPath.row == 2) {
            cell.contentLabel.textColor = UIColorFromRGB(0x999999);
            cell.contentLabel.text = self.serviceModel.admissionDate;
        }else if (indexPath.row == 3) {
            cell.contentLabel.textColor = UIColorFromRGB(0x999999);
            cell.contentLabel.text = self.serviceModel.graduationDate;
        }
        
    }else if (indexPath.section == 2) {
        
        NSArray *namesArr = @[@"行业",@"职位",@"职业"];
        cell.nameLabel.text = namesArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.contentLabel.hidden = NO;
            cell.contentLabel.text = self.serviceModel.industryName;
        }else if (indexPath.row == 1) {
            cell.contentTF.hidden = NO;
            cell.contentTF.placeholder = @"请填写职位";
            cell.saveData = ^(NSString * _Nonnull text) {
                self.serviceModel.positionName = text;
            };
            cell.contentTF.text = self.serviceModel.positionName;
//            self.positionTF = cell.contentTF;
        }else if (indexPath.row == 2) {
            cell.contentTF.hidden = NO;
            cell.contentTF.placeholder = @"请填写职业";
            cell.saveData = ^(NSString * _Nonnull text) {
                self.serviceModel.occupationName = text;
            };
            cell.contentTF.text = self.serviceModel.occupationName;
//            self.occupationTF = cell.contentTF;
        }
        
    }else if (indexPath.section == 3) {
        
        NSArray *namesArr = @[@"残疾人士",@"盲人"];
        cell.nameLabel.text = namesArr[indexPath.row];
        cell.contentLabel.hidden = NO;
        if (indexPath.row == 0) {
            cell.contentLabel.text = self.serviceModel.disabilityName;
        }else if (indexPath.row == 1) {
            cell.contentLabel.text = self.serviceModel.blindName;
        }
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 32, 71)];
    headerView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 16, [UIScreen mainScreen].bounds.size.width - 32, 55)];
    contentView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:contentView];
    
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc]init];
    cornerRadiusLayer.frame = contentView.bounds;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    contentView.layer.mask = cornerRadiusLayer;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0x157AFF);
    [contentView addSubview:lineView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = UIColorFromRGB(0x333333);
    nameLabel.font = RFONT(15);
    [contentView addSubview:nameLabel];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [contentView addSubview:bottomLine];
    
    NSArray *titlesArr = @[@"基本信息",@"学历信息",@"工作信息",@"其他信息"];
    nameLabel.text = titlesArr[section];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.centerY.equalTo(contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(3, 12));
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right).offset(10);
        make.centerY.equalTo(contentView.mas_centerY);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1 && self.serviceModel.schoolName.length == 0) {
        return 0;
    }
    return 71;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) { // 基本信息
        
        if (indexPath.row == 3) { // 国籍
            
            HYServiceSelectView *selectView = [[HYServiceSelectView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            selectView.type = 100;
            selectView.delegate = self;
            selectView.datasArr = self.nationalityArr;
            if (@available(iOS 13.0,*)) {
                [[UIApplication sharedApplication].windows[0] addSubview:selectView];
            }else {
                [[UIApplication sharedApplication].keyWindow addSubview:selectView];
            }
            
        }else if (indexPath.row == 4) { // 区域
            
            HYServiceSelectView *selectView = [[HYServiceSelectView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            selectView.type = 101;
            selectView.delegate = self;
            selectView.datasArr = self.areaArr;
            if (@available(iOS 13.0,*)) {
                [[UIApplication sharedApplication].windows[0] addSubview:selectView];
            }else {
                [[UIApplication sharedApplication].keyWindow addSubview:selectView];
            }
            
        }
        
    }else if (indexPath.section == 1) { // 学历信息
        
//        if (indexPath.row == 2) { // 入学时间
//
//            HYDatePickerView *pickerView = [[HYDatePickerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//            pickerView.type = 201;
//            pickerView.delegate = self;
//            if (@available(iOS 13.0,*)) {
//                [[UIApplication sharedApplication].windows[0] addSubview:pickerView];
//            }else {
//                [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
//            }
//
//        }else if (indexPath.row == 3) { // 毕业时间
//
//            HYDatePickerView *pickerView = [[HYDatePickerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//            pickerView.type = 202;
//            pickerView.delegate = self;
//            if (@available(iOS 13.0,*)) {
//                [[UIApplication sharedApplication].windows[0] addSubview:pickerView];
//            }else {
//                [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
//            }
//
//        }
        
    }else if (indexPath.section == 2) { // 行业信息
        
        if (indexPath.row == 0) { // 选择行业
            
            HYSelectIndustry *industryView = [[HYSelectIndustry alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            industryView.delegate = self;
            industryView.datasArr = self.industryArr;
            if (@available(iOS 13.0,*)) {
                [[UIApplication sharedApplication].windows[0] addSubview:industryView];
            }else {
                [[UIApplication sharedApplication].keyWindow addSubview:industryView];
            }
            
        }
        
    }else if (indexPath.section == 3) { // 其他信息
        
        if (indexPath.row == 0) { // 是否残疾人士
            
            HYServiceSelectView *selectView = [[HYServiceSelectView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            selectView.type = 102;
            selectView.delegate = self;
            selectView.datasArr = self.disableArr;
            if (@available(iOS 13.0,*)) {
                [[UIApplication sharedApplication].windows[0] addSubview:selectView];
            }else {
                [[UIApplication sharedApplication].keyWindow addSubview:selectView];
            }
            
        }
//        else if (indexPath.row == 1) { // 是否盲人
//
//            HYServiceSelectView *selectView = [[HYServiceSelectView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//            selectView.type = 103;
//            selectView.delegate = self;
//            selectView.datasArr = self.blindArr;
//            if (@available(iOS 13.0,*)) {
//                [[UIApplication sharedApplication].windows[0] addSubview:selectView];
//            }else {
//                [[UIApplication sharedApplication].keyWindow addSubview:selectView];
//            }
//
//        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cornerRadius = 8.f;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        // 添加cell的rectangle信息到path中（不包括圆角）
        CGPathAddRect(pathRef, nil, bounds);
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    // cell的背景view
    cell.backgroundView = roundView;
    
}

#pragma HYService
// 日期选择
- (void)serviceDatePickerType:(NSInteger)type selectValue:(NSString *)dateStr {
    
    if (type == 201) { // 入学时间
        
        self.serviceModel.admissionDate = dateStr;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    }else if (type == 202) { // 毕业时间
            
        self.serviceModel.graduationDate = dateStr;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}

- (void)serviceSelectType:(NSInteger)type selectValue:(NSString *)value selectCode:(NSString *)code {
    
    NSLog(@" 选择== %ld == %@ == %@",(long)type,value,code);
    if (type == 100) { // 国籍
        
        self.serviceModel.nationalityName = value;
        self.serviceModel.nationalityCode = code;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    }else if (type == 101) { // 区域
        
        self.serviceModel.areaName = value;
        self.serviceModel.areaCode = code;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    }else if (type == 102) { // 是否残疾
        
        self.serviceModel.disabilityName = value;
        self.serviceModel.disabilityId = code;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:3];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    }
//    else if (type == 103) { // 是否盲人
//        
//        self.serviceModel.blindName = value;
//        self.serviceModel.blindId = code;
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:3];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//        
//    }
    
}

- (void)serviceSelectValue:(NSString *)selectValue selectCode:(NSString *)selectCode {
    
    self.serviceModel.industryName = selectValue;
    self.serviceModel.industryId = selectCode;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma Clicked
// 查询
- (void)searchAvalilabelService {
    
    if (self.serviceModel.areaName.length == 0) {
        [SVProgressHUD showWithStatus:@"请填写区域"];
        [SVProgressHUD dismissWithDelay:0.5];
        return;
    }
    
    [HttpRequest postHttpBody:@"/phone/v2/service/editServiceUserInfo" params:@{@"admissionDate":self.serviceModel.admissionDate,@"areaCode":self.serviceModel.areaCode,@"areaName":self.serviceModel.areaName,@"blindId":self.serviceModel.blindId,@"blindName":self.serviceModel.blindName,@"disabilityId":self.serviceModel.disabilityId,@"disabilityName":self.serviceModel.disabilityName,@"graduationDate":self.serviceModel.graduationDate,@"id":self.serviceModel.id,@"industryId":self.serviceModel.industryId,@"industryName":self.serviceModel.industryName,@"major":self.serviceModel.major,@"nationalityCode":self.serviceModel.nationalityCode,@"nationalityName":self.serviceModel.nationalityName,@"occupationName":self.serviceModel.occupationName,@"positionName":self.serviceModel.positionName,@"schoolName":self.serviceModel.schoolName,@"uuid":self.serviceModel.uuid
    } resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 保存可享服务 == %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            MainApi *api = [MainApi sharedInstance];
            api.isFirst = YES;
            
            if ([self.serviceName isEqualToString:@"商业服务"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    HYGovServiceViewController *govServiceVC = [[HYGovServiceViewController alloc]init];
                    govServiceVC.serviceID = self.serviceID?:@"";
                    govServiceVC.serviceName = self.serviceName?:@"";
                    [self.navigationController pushViewController:govServiceVC animated:YES];
                });
                
            }else if ([self.serviceName isEqualToString:@"政务服务"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    HYBusinessServiceViewController *businessVC = [[HYBusinessServiceViewController alloc]init];
                    businessVC.serviceID = self.serviceID?:@"";
                    businessVC.serviceName = self.serviceName?:@"";
                    [self.navigationController pushViewController:businessVC animated:YES];
                });
                
            }else if ([self.serviceName isEqualToString:@"社会服务"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    HYBusinessServiceViewController *businessVC = [[HYBusinessServiceViewController alloc]init];
                    businessVC.serviceID = self.serviceID?:@"";
                    businessVC.serviceName = self.serviceName?:@"";
                    [self.navigationController pushViewController:businessVC animated:YES];
                });
                
            }else if ([self.serviceName isEqualToString:@"考证服务"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    HYObtainCertiViewController *obtainVC = [[HYObtainCertiViewController alloc]init];
                    obtainVC.serviceID = self.serviceID?:@"";
                    obtainVC.serviceName = self.serviceName?:@"";
                    [self.navigationController pushViewController:obtainVC animated:YES];
                });
                
            }
            
        }else {
            
            [SVProgressHUD showWithStatus:responseObject[@"msg"]];
            [SVProgressHUD dismiss];
            
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
        _tableView.tableFooterView = [self footerView];
    }
    return _tableView;
    
}

- (NSMutableArray *)datasArr {
    
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
    
}

- (NSMutableArray *)areaArr {
    
    if (!_areaArr) {
        _areaArr = [NSMutableArray array];
    }
    return _areaArr;
    
}

- (NSMutableArray *)industryArr {
    
    if (!_industryArr) {
        _industryArr = [NSMutableArray array];
    }
    return _industryArr;
    
}

- (NSMutableArray *)nationalityArr {
    
    if (!_nationalityArr) {
        _nationalityArr = [NSMutableArray array];
    }
    return _nationalityArr;
    
}

- (NSMutableArray *)blindArr {
    
    if (!_blindArr) {
        _blindArr = [NSMutableArray array];
    }
    return _blindArr;
    
}

- (NSMutableArray *)disableArr {
    
    if (!_disableArr) {
        _disableArr = [NSMutableArray array];
    }
    return _disableArr;
    
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
