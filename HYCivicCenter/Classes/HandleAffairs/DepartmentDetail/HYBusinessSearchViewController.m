//
//  HYBusinessSearchViewController.m
//  HelloFrame
//
//  Created by nuchina on 2022/1/6.
//

#import "HYBusinessSearchViewController.h"
#import "HYSearchView.h"
#import "HYGuessBusinessTableViewCell.h"
#import "FaceTipViewController.h"
#import "HYHandleAffairsWebVIewController.h"
#import "HYOnLineBusinessMainViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"
#import "UILabel+XFExtension.h"

@interface HYBusinessSearchViewController () <UITableViewDelegate, UITableViewDataSource, FaceResultDelegate, UITextFieldDelegate>

@property (nonatomic, strong) HYSearchView * searchView;
@property (nonatomic, copy) NSString * jumpUrl;  // 传给网页的url
@property (nonatomic, copy) NSString * code;  // 传给网页的code
@property (nonatomic, copy) NSString * titleStr;  // 传给网页的title
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * datasArr;
@property (nonatomic, strong) UILabel *titleLabel;

@end

NSString *const businessSearchCell = @"search";
@implementation HYBusinessSearchViewController

- (void)loadView {
    [super loadView];
    
    self.searchView = [[HYSearchView alloc] init];
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(kTopNavHeight);
        make.height.mas_equalTo(53);
    }];
    self.searchView.searchTF.delegate = self;
    [self.searchView.searchBtn addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.equalTo(self.view).offset(-16);
        make.top.equalTo(self.searchView.mas_bottom).offset(16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-16);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 49;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[HYGuessBusinessTableViewCell class] forCellReuseIdentifier:businessSearchCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.titleLabel = [UILabel xf_labelWithText:self.businessName];
    if (_hyTitleColor) {
        self.titleLabel.textColor = _hyTitleColor;
    }
    self.navigationItem.titleView = _titleLabel;
            
    [self loadDataWithKey:@""];
    
    [self traitCollectionDidChange:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.searchView.backgroundColor = UIColorFromRGB(0x157AFF);
    self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

- (void)loadDataWithKey:(NSString *)keyword {
    [HttpRequest getPathZWBS:@"phone/item/event/getItemsByOrgAndTitle" params:@{@"folderName": self.orgName, @"itemName": keyword, @"serviceObjType": @"1", @"titleName": self.businessName} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
        SLog(@" 部门搜索数据 == %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.datasArr = [HYGuessBusinessModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.tableView reloadData];
        }
    }];
}


#pragma UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYGuessBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:businessSearchCell];
    cell.guessModel = self.datasArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HYGuessBusinessModel *businessModel = self.datasArr[indexPath.row];
//    if ([businessModel.canHandle boolValue] == NO) {
//        [SVProgressHUD showErrorWithStatus:@"该事项无法操作"];
//        return;
//    }
    if (businessModel.needFaceRecognition.intValue == 1) { // 跳转人脸
        self.code = businessModel.link;
        self.titleStr = businessModel.name;
        self.jumpUrl = businessModel.jumpUrl;
        FaceTipViewController *faceTipVC = [[FaceTipViewController alloc]init];
        faceTipVC.delegate = self;
        [self.navigationController pushViewController:faceTipVC animated:YES];
    } else {  // 内链：跳本地在线办事页面  外链：跳网页在线办事页面
        if (businessModel.outLinkFlag.intValue == 0) {
            HYOnLineBusinessMainViewController * mainVC = [[HYOnLineBusinessMainViewController alloc] init];
            mainVC.businessModel = businessModel;
            mainVC.hyTitleColor = _hyTitleColor;
            [self.navigationController pushViewController:mainVC animated:YES];
        } else {
            HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
            webVC.code = businessModel.link;
            webVC.titleStr = businessModel.name;
            webVC.jumpUrl = businessModel.jumpUrl;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 32, 16)];
    contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    return contentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}

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

#pragma mark - FaceResult

- (void)getFaceResultWithImageStr:(NSString *)imageStr deviceId:(NSString *)deviceid skey:(NSString *)skey {
    [HttpRequest postPathZWBS:@"phone/item/event/api" params:@{@"uri": @"/apiFile/discernFace", @"app": @"ios", @"file": imageStr, @"deviceId": deviceid, @"skey": skey} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 人脸识别== %@ ", responseObject);
        if ([responseObject[@"success"] intValue] == 1) {
            HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
            webVC.code = self.code;
            webVC.titleStr = self.titleStr;
            webVC.jumpUrl = self.jumpUrl;
            [self.navigationController pushViewController:webVC animated:YES];
        }
    }];
}


- (void)searchClicked {
    [self loadDataWithKey:self.searchView.searchTF.text];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchView.searchTF resignFirstResponder];
    [self searchClicked];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchView.searchTF resignFirstResponder];
}

- (NSMutableArray *)datasArr {
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
}

@end
