//
//  HYHandleGuideViewController.m
//  HelloFrame
//
//  Created by nuchina on 2022/1/7.
//
//  办理指南页面

#import "HYHandleGuideViewController.h"
#import "HYHandleGuideTableViewCell.h"
#import "HYHandleGuideMateraCell.h"
#import <objc/runtime.h>
#import "HYItemTotalInfoModel.h"
#import "HYCivicCenterCommand.h"

@interface HYHandleGuideViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableDictionary * openSectionDict; // 记录哪个组展开

@end

NSString *const handleGuideCell = @"guideCell";
@implementation HYHandleGuideViewController

- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYHandleGuideTableViewCell class] forCellReuseIdentifier:handleGuideCell];
    [self.tableView registerClass:[HYHandleGuideMateraCell class] forCellReuseIdentifier:@"HYHandleGuideMateraCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(16, 16, 16, 16));
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
        
    [self traitCollectionDidChange:nil];
}

- (void)loadData {
    [HttpRequest getPathZWBS:@"phone/item/event/getItemInfoByItemCode" params:@{@"itemCode": _itemCode} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 办事指南 == %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            NSDictionary *dataDict = responseObject[@"data"];
            [self processingDataWith:dataDict];
        }
    }];
}

- (void)processingDataWith:(NSDictionary *)dict {
    // 顺序为：基本信息 办理材料 受理条件 收费明细 办理流程 流程图 咨询途径 监督投诉
    NSMutableArray *baseInfo = [HYItemInfoModel mj_objectArrayWithKeyValuesArray:dict[@"itemInfo"]];
    NSMutableArray *material = [HYMaterialModel mj_objectArrayWithKeyValuesArray:dict[@"material"]];
    NSMutableArray *condition = [HYConditionModel mj_objectArrayWithKeyValuesArray:dict[@"condition"]];
    NSMutableArray *charge = [HYChargeModel mj_objectArrayWithKeyValuesArray:dict[@"charge"]];
    NSMutableArray *handlingProcess = [HYHandlingProcessModel mj_objectArrayWithKeyValuesArray:dict[@"handlingProcess"]];
    NSMutableArray *outMap = [HYOutMapModel mj_objectArrayWithKeyValuesArray:dict[@"outMap"]];
    NSMutableArray *consultArr = [HYConsultModel mj_objectArrayWithKeyValuesArray:dict[@"consult"]];
    
    if (baseInfo.count > 0) {
        [self.imageArray addObject:@"icon_base_info"];
        [self.titleArray addObject:@"基本信息"];
        HYItemInfoModel *mo = baseInfo.firstObject;
        NSArray *keys = @[@"事项名称", @"事项编码", @"实施单位编码", @"实施单位名称", @"承办单位编码", @"承办单位名称", @"事项类型", @"办件类型", @"事项区划名称", @"法定时限", @"承诺时限"];
        NSString *lawTime = [NSString stringWithFormat:@"%ld个%@", (long)mo.lawTime, mo.lawTimeUnitValue];  // 法定时限
        NSString *agreeTime = [NSString stringWithFormat:@"%ld个%@", (long)mo.agreeTime, mo.agreeTimeUnitValue];  // 承诺时限
        NSArray *values = @[mo.name, mo.code, mo.orgCode, mo.orgName, mo.agentCode, mo.agentName, mo.type, mo.assort, mo.regionName, lawTime,  (mo.agreeTime == 0 ? @"即办" : agreeTime)];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < keys.count; i ++) {
            HYGuideItemInfoModel *model = [[HYGuideItemInfoModel alloc] init];
            model.name = keys[i];
            model.value = values[i];
            [tempArr addObject: model];
        }
        [self.dataArray addObject:tempArr];
    }
    if (material.count > 0) {
        [self.imageArray addObject:@"icon_meterail"];
        [self.titleArray addObject:@"办理材料"];
        [self.dataArray addObject:material];
    }
    if (condition.count > 0) {
        [self.imageArray addObject:@"icon_condition"];
        [self.titleArray addObject:@"受理条件"];
        [self.dataArray addObject:condition];
    }
    if (charge.count > 0) {
        [self.imageArray addObject:@"icon_charge"];
        [self.titleArray addObject:@"收费明细"];
        [self.dataArray addObject:charge];
    }
    if (handlingProcess.count > 0) {
        [self.imageArray addObject:@"icon_process"];
        [self.titleArray addObject:@"办理流程"];
        [self.dataArray addObject:handlingProcess];
    }
    if (outMap.count > 0) {
        [self.imageArray addObject:@"icon_out_map"];
        [self.titleArray addObject:@"流程图"];
        [self.dataArray addObject:outMap];
    }
    if (consultArr.count > 0) {
        [self.imageArray addObject:@"icon_consult"];
        [self.titleArray addObject:@"咨询途径"];
        HYConsultModel *mo = consultArr.firstObject;
        NSArray *keys = @[@"部门", @"地址", @"电话"];
        NSArray *values = @[mo.windowName, mo.windowAddress, mo.phoneNumber];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < keys.count; i ++) {
            HYGuideItemInfoModel *model = [[HYGuideItemInfoModel alloc] init];
            model.name = keys[i];
            model.value = values[i];
            [tempArr addObject: model];
        }
        [self.dataArray addObject:tempArr];
    }
    if (consultArr.count > 1) {
        [self.imageArray addObject:@"icon_supervision"];
        [self.titleArray addObject:@"监督投诉"];
        HYConsultModel *mo = consultArr[1];
        NSArray *keys = @[@"部门", @"地址", @"电话"];
        NSArray *values = @[mo.windowName, mo.windowAddress, mo.phoneNumber];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i < keys.count; i ++) {
            HYGuideItemInfoModel *model = [[HYGuideItemInfoModel alloc] init];
            model.name = keys[i];
            model.value = values[i];
            [tempArr addObject: model];
        }
        [self.dataArray addObject:tempArr];
    }
//    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
//    });
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = UIColorFromRGB(0xEBEFF5);
    self.tableView.backgroundColor = UIColorFromRGB(0xEBEFF5);
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)openSectionDict {
    if (!_openSectionDict) {
        _openSectionDict = [NSMutableDictionary dictionary];
    }
    return _openSectionDict;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.openSectionDict valueForKey:[NSString stringWithFormat:@"%ld", (long)section]] integerValue] == 0) { // 根据记录的展开状态设置row的数量
        return 0;
    } else {
        if ([_titleArray[section] isEqualToString:@"基本信息"] || [_titleArray[section] isEqualToString:@"办理流程"]) {
            return 11;
        } else if ([_titleArray[section] isEqualToString:@"办理材料"] || [_titleArray[section] isEqualToString:@"收费明细"] || [_titleArray[section] isEqualToString:@"流程图"]) {
            return 1;
        } else if ([_titleArray[section] isEqualToString:@"咨询途径"] || [_titleArray[section] isEqualToString:@"监督投诉"]) {
            return 3;
        } else if ([_titleArray[section] isEqualToString:@"受理条件"]) {
            return 2;
        }
        return [_dataArray[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYHandleGuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:handleGuideCell];
    if ([_titleArray[indexPath.section] isEqualToString:@"基本信息"] || [_titleArray[indexPath.section] isEqualToString:@"咨询途径"] || [_titleArray[indexPath.section] isEqualToString:@"监督投诉"]) {
        cell.infoModel = _dataArray[indexPath.section][indexPath.row];
    }
    if ([_titleArray[indexPath.section] isEqualToString:@"收费明细"]) {
        cell.chargeModel = _dataArray[indexPath.section][indexPath.row];
    }
    if ([_titleArray[indexPath.section] isEqualToString:@"办理流程"]) {
        cell.processModel = _dataArray[indexPath.section][indexPath.row];
    }
    if ([_titleArray[indexPath.section] isEqualToString:@"受理条件"]) {
        cell.conditionModel = _dataArray[indexPath.section][indexPath.row];
    }
    if ([_titleArray[indexPath.section] isEqualToString:@"办理材料"]) {
        HYHandleGuideMateraCell * materaCell = [tableView dequeueReusableCellWithIdentifier:@"HYHandleGuideMateraCell" forIndexPath:indexPath];
        materaCell.materials = _dataArray[indexPath.section];
        return materaCell;
    }
    if ([_titleArray[indexPath.section] isEqualToString:@"流程图"]) {
        cell.outMapModel = _dataArray[indexPath.section][indexPath.row];
    }
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 55)];
    view.tag = 110 + section;
    view.backgroundColor = UIColor.whiteColor;
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(16, 18, 20, 20)];
    logo.image = [UIImage imageNamed:BundleFile(_imageArray[section])];
    [view addSubview:logo];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 21, view.bounds.size.width - 75, 15)];
    label.text = self.titleArray[section];
    label.font = MFONT(15);
    label.textColor = UIColorFromRGB(0x333333);
    [view addSubview:label];
    
    if ([[self.openSectionDict valueForKey:[NSString stringWithFormat:@"%ld", (long)section]] integerValue] == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.bounds.size.width - 28, 25, 12, 7)];
        imageView.image = [UIImage imageNamed:BundleFile(@"ico_listdown")]; // 三角形小图片
        [view addSubview:imageView];
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.bounds.size.width - 28, 25, 12, 7)];
        imageView.image = [UIImage imageNamed:BundleFile(@"ico_listup")];
        [view addSubview:imageView];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 54, view.bounds.size.width, 1)];
    line.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [view addSubview:line];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collegeTaped:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = UIColorFromRGB(0xEBEFF5);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;  // 预估高度 比heightForRowAtIndexPath先展示 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_titleArray[indexPath.section] isEqualToString:@"基本信息"] || [_titleArray[indexPath.section] isEqualToString:@"咨询途径"] || [_titleArray[indexPath.section] isEqualToString:@"监督投诉"]) {
        HYGuideItemInfoModel *model = _dataArray[indexPath.section][indexPath.row];
        CGFloat height = [model.value heightForStringWithFont:MFONT(14) width:([UIScreen mainScreen].bounds.size.width - 170)];
        return height + 30;
    }
    if ([_titleArray[indexPath.section] isEqualToString:@"收费明细"]) {
        HYChargeModel *model = _dataArray[indexPath.section][indexPath.row];
        CGFloat height = [model.standard heightForStringWithFont:MFONT(14) width:([UIScreen mainScreen].bounds.size.width - 170)];
        return height + 30;
    }
    if ([_titleArray[indexPath.section] isEqualToString:@"办理流程"]) {
        HYHandlingProcessModel *model = _dataArray[indexPath.section][indexPath.row];
        CGFloat height = [model.content heightForStringWithFont:MFONT(14) width:([UIScreen mainScreen].bounds.size.width - 170)];
        return height + 30;
    }
    if ([_titleArray[indexPath.section] isEqualToString:@"受理条件"]) {
        HYConditionModel *model = _dataArray[indexPath.section][indexPath.row];
        NSString *string = [model.name stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        CGFloat height = [string heightForStringWithFont:MFONT(14) width:([UIScreen mainScreen].bounds.size.width - 64)];
        return height + 36;
    }
    if ([_titleArray[indexPath.section] isEqualToString:@"办理材料"]) {
        NSMutableArray *models = _dataArray[indexPath.section];
        return 16 + 116 * models.count;
    }
    if ([_titleArray[indexPath.section] isEqualToString:@"流程图"]) {
        HYOutMapModel *model = _dataArray[indexPath.section][indexPath.row];
        if (![model.webUrl isEqualToString:@""]) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.webUrl]]];
            CGFloat imgHeight = image.size.height * ([UIScreen mainScreen].bounds.size.width - 32) / image.size.width;  // 手动计算image高度
            SLog(@"流程图的高度:%f", imgHeight);
            imgHeight = imgHeight >= 0 ? imgHeight : 0;  // 防止计算出负数高度 导致闪退
            return imgHeight + 32;
        }
        return 32;
    }
    return 58;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 16;
}

#pragma mark - sectionHeader clicked
- (void)collegeTaped:(UITapGestureRecognizer *)sender {
    NSString *key = [NSString stringWithFormat:@"%ld", sender.view.tag - 110];
    // 给展开标识赋值
    if ([[self.openSectionDict objectForKey:key] integerValue] == 0) {
        [self.openSectionDict setObject:@"1" forKey:key];
    } else {
        [self.openSectionDict setObject:@"0" forKey:key];
    }
    NSUInteger index = sender.view.tag;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:index - 110];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
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
