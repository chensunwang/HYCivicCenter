//
//  HYLegalAidGuideViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/17.
//
//  法律援助指南页面

#import "HYLegalAidGuideViewController.h"
#import "HYLegalAidTableViewCell.h"
#import <objc/runtime.h>
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

char * const buttonKey = "buttonKey";

@interface HYLegalAidGuideViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;

@end

NSString *const legalAidCell = @"legalCell";

@implementation HYLegalAidGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    UILabel *titleLabel = [UILabel xf_labelWithText:@"江西省法律援助指南"];
    if (_hyTitleColor) {
        titleLabel.textColor = _hyTitleColor;
    }
    self.navigationItem.titleView = titleLabel;
    
    [self configUI];
    
    [self initDatas];
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYLegalAidTableViewCell class] forCellReuseIdentifier:legalAidCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
    
}

#pragma UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datasArr.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ExpandModel *model = self.datasArr[section];
    // 展开
    if ([@(model.type).stringValue isEqualToString:@"1"]) {
        return model.datasArr.count;
    }else { // 闭合
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HYLegalAidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:legalAidCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ExpandModel *sectionModel = self.datasArr[indexPath.section];
    ExpandModel *model = sectionModel.datasArr[indexPath.row];
    cell.expandModel = model;
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [button setTag:section + 100];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 60)];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width - 32, 0.5)];
    line1.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [button addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, button.frame.size.height - 0.5, [UIScreen mainScreen].bounds.size.width - 32, 0.5)];
    line2.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [button addSubview:line2];
    
    ExpandModel *model = self.datasArr[section];
    if ([@(model.type).stringValue isEqualToString:@"1"]) {
        UIImageView *_imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, (44-6)/2, 10, 6)];
        _imgView.image = HyBundleImage(@"ico_listdown");
        [button addSubview:_imgView];
        CGAffineTransform currentTransform = _imgView.transform;
        CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, M_PI);
        _imgView.transform = newTransform;
        objc_setAssociatedObject(button, buttonKey, _imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else if ([@(model.type).stringValue isEqualToString:@"0"]) {
        UIImageView *_imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-30, (44-6)/2, 10, 6)];
        _imgView.image = HyBundleImage(@"ico_listup");
        [button addSubview:_imgView];
        objc_setAssociatedObject(button, buttonKey, _imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(16, (44-20)/2, [UIScreen mainScreen].bounds.size.width - 32, 20)];
    [tlabel setBackgroundColor:[UIColor clearColor]];
    [tlabel setFont:[UIFont systemFontOfSize:14]];
    [tlabel setTextColor:UIColorFromRGB(0x333333)];
    [tlabel setText:model.name];
    [button addSubview:tlabel];
    
    return button;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExpandModel *sectionModel = self.datasArr[indexPath.section];
    ExpandModel *model = sectionModel.datasArr[indexPath.row];
    
    CGRect rect = [model.name boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 32, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:RFONT(14)}
                                         context:nil];
    return rect.size.height + 12;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (void)buttonPress:(UIButton *)sender//headButton点击
{
    ExpandModel *model = self.datasArr[sender.tag - 100];
    UIImageView *imageView = objc_getAssociatedObject(sender, buttonKey);
    
    //判断状态值
    if ([@(model.type).stringValue isEqualToString:@"1"]) {
        //修改
//        [stateArray replaceObjectAtIndex:sender.tag - 1 withObject:@"0"];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
            CGAffineTransform currentTransform = imageView.transform;
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, M_PI/2);
            imageView.transform = newTransform;
        } completion:nil];
        model.type = 0;
    }else{
//        [stateArray replaceObjectAtIndex:sender.tag - 1 withObject:@"1"];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            CGAffineTransform currentTransform = imageView.transform;
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, -M_PI/2);
            imageView.transform = newTransform;
        } completion:nil];
        model.type = 1;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag-100] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (NSMutableArray *)datasArr {
    
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.rowHeight = 49;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
    
}

- (void)initDatas {
    
    ExpandModel *model11 = [[ExpandModel alloc]init];
    model11.name = @"法律援助是国家建立的保障经济困难公民和特殊案件当事人获得必要的法律咨询、代理、刑事辩护等无偿法律服务,维护当事人合法权益、维护法律正确实施、维护社会公平正义的一项重要法律制度。";
    model11.type = 0;
    
    ExpandModel *model1 = [[ExpandModel alloc]init];
    model1.name = @"法律援助概念";
    model1.type = 1;
    model1.datasArr = @[model11];
    [self.datasArr addObject:model1];
    
    ExpandModel *model21 = [[ExpandModel alloc]init];
    model21.name = @"1、法律咨询、代拟法律文书;";
    model21.type = 0;
    
    ExpandModel *model22 = [[ExpandModel alloc]init];
    model22.name = @"2、刑事辩护和刑事代理；";
    model22.type = 0;
    
    ExpandModel *model23 = [[ExpandModel alloc]init];
    model23.name = @"3、民事诉讼代理、行政诉讼代理；";
    model23.type = 0;
    
    ExpandModel *model24 = [[ExpandModel alloc]init];
    model24.name = @"4、仲裁代理、调解代理以及其他非诉讼法律事务代理;";
    model24.type = 0;
    
    ExpandModel *model25 = [[ExpandModel alloc]init];
    model25.name = @"5、公证援助、司法鉴定援助;";
    model25.type = 0;
    
    ExpandModel *model26 = [[ExpandModel alloc]init];
    model26.name = @"6、法律、行政法规规定的其他形式。";
    model26.type = 0;
    
    ExpandModel *model2 = [[ExpandModel alloc]init];
    model2.name = @"法律援助形式";
    model2.type = 0;
    model2.datasArr = @[model21,model22,model23,model24,model25,model26];
    [self.datasArr addObject:model2];
    
    ExpandModel *model31 = [[ExpandModel alloc]init];
    model31.name = @"1、经济困难公民或特殊案件当事人；";
    model31.type = 0;
    
    ExpandModel *model32 = [[ExpandModel alloc]init];
    model32.name = @"2、事项属于法律援助范围；";
    model32.type = 0;
    
    ExpandModel *model33 = [[ExpandModel alloc]init];
    model33.name = @"3、有合理的请求及事实依据。";
    model33.type = 0;
    
    ExpandModel *model3 = [[ExpandModel alloc]init];
    model3.name = @"法律援助条件";
    model3.type = 0;
    model3.datasArr = @[model31,model32,model33];
    [self.datasArr addObject:model3];
    
    ExpandModel *model41 = [[ExpandModel alloc]init];
    model41.name = @"一、公民就下列民事、行政事项，因经济困难可以申请法律援助：";// 深色
    model41.type = 1;
    
    ExpandModel *model42 = [[ExpandModel alloc]init];
    model42.name = @"1、依法请求国家赔偿的；";
    model42.type = 0;
    
    ExpandModel *model43 = [[ExpandModel alloc]init];
    model43.name = @"2、请求给予社会保险待遇或者最低生活保障待遇的；";
    model43.type = 0;
    
    ExpandModel *model44 = [[ExpandModel alloc]init];
    model44.name = @"3、请求发给抚恤金、救济金的；";
    model44.type = 0;
    
    ExpandModel *model45 = [[ExpandModel alloc]init];
    model45.name = @"4、请求给付赡养费、抚养费、扶养费的；";
    model45.type = 0;
    
    ExpandModel *model46 = [[ExpandModel alloc]init];
    model46.name = @"5、请求支付劳动报酬的；";
    model46.type = 0;
    
    ExpandModel *model47 = [[ExpandModel alloc]init];
    model47.name = @"6、主张因见义勇为行为产生的民事权益的；";
    model47.type = 0;
    
    ExpandModel *model48 = [[ExpandModel alloc]init];
    model48.name = @"7、请求工伤、交通、食品安全、环境污染、产品质量事故以及医疗损害赔偿的；";
    model48.type = 0;
    
    ExpandModel *model49 = [[ExpandModel alloc]init];
    model49.name = @"8、遭受家庭暴力、虐待、遗弃，维护合法权益的；";
    model49.type = 0;
    
    ExpandModel *model410 = [[ExpandModel alloc]init];
    model410.name = @"9、农民因购买种子、化肥、农药、饲料等质量低劣产品导致经济损失的。";
    model410.type = 0;
    
    ExpandModel *model411 = [[ExpandModel alloc]init];
    model411.name = @"二、刑事诉讼中有下列情形之一，犯罪嫌疑人、被告人没有委托辩护人的，本人及其近亲属可以向法律援助机构申请法律援助：";// 深色
    model411.type = 1;
    
    ExpandModel *model412 = [[ExpandModel alloc]init];
    model412.name = @"1、经济困难的；";
    model412.type = 0;
    
    ExpandModel *model413 = [[ExpandModel alloc]init];
    model413.name = @"2、有证据证明犯罪嫌疑人、被告人属于一级或者二级智力残疾的；";
    model413.type = 0;
    
    ExpandModel *model414 = [[ExpandModel alloc]init];
    model414.name = @"3、共同犯罪案件中，其他犯罪嫌疑人、被告人已委托辩护人的；";
    model414.type = 0;
    
    ExpandModel *model415 = [[ExpandModel alloc]init];
    model415.name = @"4、人民检察院抗诉的；";
    model415.type = 0;
    
    ExpandModel *model416 = [[ExpandModel alloc]init];
    model416.name = @"5、案件具有重大社会影响的。";
    model416.type = 0;
    
    ExpandModel *model417 = [[ExpandModel alloc]init];
    model417.name = @"三、刑事诉讼中有下列情形之一，人民法院、人民检察院和公安机关应当通知法律援助机构指派律师为其提供法律援助：";// 深色
    model417.type = 1;
    
    
    ExpandModel *model418 = [[ExpandModel alloc]init];
    model418.name = @"1、犯罪嫌疑人、被告人是盲、聋、哑人，尚未完全丧失辨认或者控制自己行为能力的精神病人，没有委托辩护人的；";
    model418.type = 0;
    
    ExpandModel *model419 = [[ExpandModel alloc]init];
    model419.name = @"2、犯罪嫌疑人、被告人可能被判处无期徒刑、死刑，没有委托辩护人的；";
    model419.type = 0;
    
    
    ExpandModel *model420 = [[ExpandModel alloc]init];
    model420.name = @"3、犯罪嫌疑人、被告人是未成年人，没有委托辩护人的；";
    model420.type = 0;
    
    ExpandModel *model421 = [[ExpandModel alloc]init];
    model421.name = @"四、强制医疗案件的被申请人或者被告人没有委托诉讼代理人的，人民法院应当通知法律援助机构指派律师为其提供法律援助。"; // 深色
    model421.type = 1;
    
    ExpandModel *model4 = [[ExpandModel alloc]init];
    model4.name = @"法律援助事项";
    model4.type = 0;
    model4.datasArr = @[model41,model42,model43,model44,model45,model46,model47,model48,model49,model410,model411,model412,model413,model414,model415,model416,model417,model418,model419,model420,model421];
    [self.datasArr addObject:model4];
    
    ExpandModel *model51 = [[ExpandModel alloc]init];
    model51.name = @"家庭人均收入不足当地城乡居民最低生活保障标准的2倍。公民经济困难的证明，以县级以上人民政府民政部门颁发的有关救济凭证或者申请人户籍所在地、经常居住地乡镇(街道)或村(居)委会出具的书面证明为据。";
    model51.type = 0;
    
    ExpandModel *model5 = [[ExpandModel alloc]init];
    model5.name = @"经济困难标准";
    model5.type = 0;
    model5.datasArr = @[model51];
    [self.datasArr addObject:model5];
    
    ExpandModel *model61 = [[ExpandModel alloc]init];
    model61.name = @"1、属于农村五保供养对象的；";
    model61.type = 0;
    
    ExpandModel *model62 = [[ExpandModel alloc]init];
    model62.name = @"2、领取城乡居民最低生活保障金或者其他经县级以上人民政府民政主管部门认定为困难家庭的；";
    model62.type = 0;
    
    ExpandModel *model63 = [[ExpandModel alloc]init];
    model63.name = @"3、重度残疾的；";
    model63.type = 0;
    
    ExpandModel *model64 = [[ExpandModel alloc]init];
    model64.name = @"4、由政府或者慈善机构出资供养的；";
    model64.type = 0;
    
    ExpandModel *model65 = [[ExpandModel alloc]init];
    model65.name = @"5、依靠政府或者单位给付抚恤金生活的；";
    model65.type = 0;
    
    ExpandModel *model66 = [[ExpandModel alloc]init];
    model66.name = @"6、进城务工人员请求支付劳动报酬或者工伤赔偿金的；";
    model66.type = 0;
    
    ExpandModel *model67 = [[ExpandModel alloc]init];
    model67.name = @"7、主张因见义勇为行为产生民事权益的；";
    model67.type = 0;
    
    ExpandModel *model68 = [[ExpandModel alloc]init];
    model68.name = @"8、因意外事件、重大疾病、自然灾害或者其他特殊原因，导致生活出现暂时困难，正在接受政府临时救济的。";
    model68.type = 0;
    
    ExpandModel *model6 = [[ExpandModel alloc]init];
    model6.name = @"免于经济审查情形";
    model6.type = 0;
    model6.datasArr = @[model61,model62,model63,model64,model65,model66,model67,model68];
    [self.datasArr addObject:model6];
    
    ExpandModel *model71 = [[ExpandModel alloc]init];
    model71.name = @"您可以直接到法律援助机构服务窗口或司法行政部门公共法律服务中心服务窗口申请。";
    model71.type = 0;
    
    ExpandModel *model72 = [[ExpandModel alloc]init];
    model72.name = @"您也可以到法律援助机构在乡镇（街道）司法所法律援助工作站或乡镇(街道)公共法律服务工作站办理，那里的工作人员会具体指导、帮助您申请。";
    model72.type = 0;
    
    ExpandModel *model73 = [[ExpandModel alloc]init];
    model73.name = @"您还可以通过拨打电话12348，申请法律援助和咨询。";
    model73.type = 0;
    
    ExpandModel *model7 = [[ExpandModel alloc]init];
    model7.name = @"去哪申请法律援助";
    model7.type = 0;
    model7.datasArr = @[model71,model72,model73];
    [self.datasArr addObject:model7];
    
    ExpandModel *model81 = [[ExpandModel alloc]init];
    model81.name = @"1、身份证或者其他有效的身份证明，代理申请人还应当提交有代理权的证明；";
    model81.type = 0;
    
    ExpandModel *model82 = [[ExpandModel alloc]init];
    model82.name = @"2、民政部门颁发的有关救济凭证或乡镇(街道)、村(居)委会出具的经济困难证明；";
    model82.type = 0;
    
    ExpandModel *model83 = [[ExpandModel alloc]init];
    model83.name = @"3、与所申请法律援助事项有关的案件材料；";
    model83.type = 0;
    
    ExpandModel *model84 = [[ExpandModel alloc]init];
    model84.name = @"4、法律援助机构认为需要提供的其他材料。";
    model84.type = 0;
    
    ExpandModel *model8 = [[ExpandModel alloc]init];
    model8.name = @"申请法律援助需要提供的材料";
    model8.type = 0;
    model8.datasArr = @[model81,model82,model83,model84];
    [self.datasArr addObject:model8];
    
    ExpandModel *model91 = [[ExpandModel alloc]init];
    model91.name = @"如果您要举报投诉法律援助机构或法律援助人员的违法违纪行为，欢迎拨打0791-87709119。";
    model91.type = 0;
    
    ExpandModel *model9 = [[ExpandModel alloc]init];
    model9.name = @"法律援助投诉电话";
    model9.type = 0;
    model9.datasArr = @[model91];
    [self.datasArr addObject:model9];
    
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
