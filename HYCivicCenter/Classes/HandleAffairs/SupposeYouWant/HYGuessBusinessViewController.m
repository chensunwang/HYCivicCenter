//
//  HYGuessBusinessViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/16.
//
//  猜你想办 业务列表页

#import "HYGuessBusinessViewController.h"
#import "HYGuessBusinessTableViewCell.h"
#import "HYGuessBusinessModel.h"
#import "HYHotServiceModel.h"
#import "FaceTipViewController.h"
#import "HYHandleAffairsWebVIewController.h"
#import "HYOnLineBusinessMainViewController.h"
#import "HYCivicCenterCommand.h"

@interface HYGuessBusinessViewController () <UITableViewDelegate, UITableViewDataSource, FaceResultDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, copy) NSString * jumpUrl;  // 传给网页的url
@property (nonatomic, copy) NSString * code;  // 传给网页的code
@property (nonatomic, copy) NSString * titleStr;  // 传给网页的title

@end

NSString *const guessBusinessCell = @"guessCell";
@implementation HYGuessBusinessViewController

- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYGuessBusinessTableViewCell class] forCellReuseIdentifier:guessBusinessCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kTopNavHeight, 16, kSafeAreaBottomHeight, 16));
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-kSafeAreaBottomHeight);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 49;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.navigationItem.titleView = [UILabel xf_labelWithText:self.titleName];
    
    [self loadData];
    
    [self traitCollectionDidChange:nil];
}

- (void)loadData {
    [HttpRequest getPathZWBS:@"phone/item/event/getGuessChildren" params:@{@"titleName": self.titleName ? : @""} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if ([responseObject[@"code"] intValue] == 200) {
            self.datasArr = [HYGuessBusinessModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableView reloadData];
        } else {
            SLog(@"%@", responseObject[@"msg"]);
        }
    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

#pragma UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYGuessBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:guessBusinessCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.guessModel = self.datasArr[indexPath.row];
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return contentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HYHotServiceModel *model = self.datasArr[indexPath.row];
    if (model.needFaceRecognition.intValue == 1) { // 跳转人脸识别
        self.code = model.link;
        self.titleStr = model.name;
        self.jumpUrl = model.jumpUrl;
        FaceTipViewController *faceTipVC = [[FaceTipViewController alloc] init];
        faceTipVC.delegate = self;
        [self.navigationController pushViewController:faceTipVC animated:YES];
    } else {
        if ([model.outLinkFlag intValue] == 1) {  // 外链
            HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
            webVC.code = model.link;
            webVC.titleStr = model.name;
            webVC.jumpUrl = model.jumpUrl;
            [self.navigationController pushViewController:webVC animated:YES];
        } else if ([model.servicePersonFlag intValue] == 1 || self.isEnterprise) { // 内链个人  内链企业且已企业认证
            HYOnLineBusinessMainViewController * mainVC = [[HYOnLineBusinessMainViewController alloc] init];
            mainVC.serviceModel = model;
            [self.navigationController pushViewController:mainVC animated:YES];
        } else {
            // 提示企业认证
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"该事项只针对企业，请先进行企业实名认证" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - FaceResultDelegate

- (void)getFaceResultWithImageStr:(NSString *)imageStr deviceId:(NSString *)deviceid skey:(NSString *)skey {
    SLog(@" skey == %@ ", skey);
    [HttpRequest postPathZWBS:@"phone/item/event/api" params:@{@"uri": @"/apiFile/discernFace", @"app": @"ios", @"file": imageStr, @"deviceId": deviceid, @"skey": skey} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 人脸识别== %@ ", responseObject);
        if ([responseObject[@"success"] intValue] == 1) {
            HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
            webVC.code = self.code;
            webVC.titleStr = self.titleStr;
            webVC.jumpUrl = self.jumpUrl;
            [self.navigationController pushViewController:webVC animated:YES];
        } else {
            SLog(@"%@", responseObject[@"message"]);
        }
    }];
}

- (NSMutableArray *)datasArr {
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
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
