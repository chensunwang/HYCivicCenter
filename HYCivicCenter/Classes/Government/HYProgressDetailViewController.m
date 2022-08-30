//
//  HYProgressDetailViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/22.
//
//  进度查询页面

#import "HYProgressDetailViewController.h"
#import "HYProgressDetailTableViewCell.h"
#import "HYServiceProgressModel.h"
#import "HYItemTotalInfoModel.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"
#import "UILabel+XFExtension.h"

@interface HYProgressDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYServiceProgressModel *model;
@property (nonatomic, strong) UILabel *titleLabel;

@end

NSString *const progressDetailCell = @"detailCell";
@implementation HYProgressDetailViewController

- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 55;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[HYProgressDetailTableViewCell class] forCellReuseIdentifier:progressDetailCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel = [UILabel xf_labelWithText:_titleStr];
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
    self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

- (HYServiceProgressModel *)model {
    if (!_model) {
        _model = [[HYServiceProgressModel alloc] init];
    }
    return _model;
}

- (void)loadData {
    [HttpRequest getPathZWBS:@"phone/item/event/getBusinessDetail" params:@{@"id": self.businessID} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@"进度详情== %@", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.model = [HYServiceProgressModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.tableView reloadData];
        }
    }];
}

#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYProgressDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:progressDetailCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.headerIV.hidden = NO;
        cell.titleLabel.hidden = NO;
        cell.titleLabel.text = @"基本信息";
        cell.nameLabel.hidden = YES;
    } else if (indexPath.row == 1) {
        cell.headerIV.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.nameLabel.hidden = NO;
        cell.nameLabel.text = _model.applySubject;
        cell.nameLabel.textColor = UIColorFromRGB(0x333333);
    } else if (indexPath.row == 2) {
        cell.headerIV.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.nameLabel.hidden = NO;
        cell.nameLabel.text = @"业务流水号";
        cell.nameLabel.textColor = UIColorFromRGB(0x999999);
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text = _model.id;
    } else if (indexPath.row == 3) {
        cell.headerIV.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.nameLabel.hidden = NO;
        cell.nameLabel.text = @"实施单位";
        cell.nameLabel.textColor = UIColorFromRGB(0x999999);
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text = _model.itemName;
    } else if (indexPath.row == 4) {
        cell.headerIV.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.nameLabel.hidden = NO;
        cell.nameLabel.text = @"处理状态";
        cell.nameLabel.textColor = UIColorFromRGB(0x999999);
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text = _model.stateName;
        if ([_model.stateColor isEqualToString:@"yellow"]) {
            cell.rightLabel.textColor = UIColorFromRGB(0xFE8601);
        } else if ([_model.stateColor isEqualToString:@"red"]) {
            cell.rightLabel.textColor = UIColorFromRGB(0xFD5C66);
        } else if ([_model.stateColor isEqualToString:@"blue"]) {
            cell.rightLabel.textColor = UIColorFromRGB(0x157AFF);
        }
    } else if (indexPath.row == 5) {
        cell.headerIV.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.nameLabel.hidden = NO;
        cell.nameLabel.text = @"申请时间";
        cell.nameLabel.textColor = UIColorFromRGB(0x999999);
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text = [_model.submitTime isEqualToString:@""] ? @"--" : _model.submitTime;
    } else if (indexPath.row == 6) {
        cell.headerIV.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.nameLabel.hidden = NO;
        cell.nameLabel.text = @"受理时间";
        cell.nameLabel.textColor = UIColorFromRGB(0x999999);
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text = @"--";
    } else if (indexPath.row == 7) {
        cell.headerIV.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.nameLabel.hidden = NO;
        cell.nameLabel.text = @"承诺时间";
        cell.nameLabel.textColor = UIColorFromRGB(0x999999);
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text = [_model.timeLimit isEqualToString:@""] ? @"--" : _model.timeLimit;
    } else if (indexPath.row == 8) {
        cell.headerIV.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.nameLabel.hidden = NO;
        cell.nameLabel.text = @"办结时间";
        cell.nameLabel.textColor = UIColorFromRGB(0x999999);
        cell.rightLabel.hidden = NO;
        cell.rightLabel.text = [_model.finishTime isEqualToString:@""] ? @"--" : _model.finishTime;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cornerRadius = 8.f;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;

    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = CGRectInset(cell.bounds, 16, 0);

    if (indexPath.row == 0) {
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));

    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
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

    // 以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    // 如果你 cell 已经取消选中状态的话,那以下方法是不需要的.
//    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
//    selectedBackgroundView.backgroundColor = UIColor.clearColor;
//    cell.selectedBackgroundView = selectedBackgroundView;

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
