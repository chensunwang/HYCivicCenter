//
//  BDFaceAdjustParamsController.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParamsController.h"
#import "BDFaceAdjustParamsCell.h"
#import "BDFaceAdjustParamsItem.h"
#import "BDFaceAdjustParamsModel.h"
#import "BDFaceAdjustParams.h"
#import "UIColor+BDFaceColorUtils.h"
#import "BDFaceAdjustParamsConstants.h"
#import "BDFaceAdjustParamsFileManager.h"
#import "BDFaceAdjustParamsRootCell.h"
#import "BDFaceAlertController.h"
#import "BDFaceAdjustParamsTool.h"
#import "BDPopupController.h"
#import "BDUIConstant.h"
#import "UIView+YZApperance.h"

static NSString *const BDFaceAdjustParamsControllerTitle = @"%@参数配置";
static NSString *const BDFaceAdjustParamsRecoverText = @"恢复为%@参数配置";

static float const BDFaceAdjustParamsSaveButtonWidth = 80.0f;
static float const BDFaceAdjustParamsSaveButtonHeight = 40.0f;
static float const BDFaceAdjustParamsSaveButtonRightMargin = 0.0f;
static NSString *const BDFaceAdjustParamsSaveButtonText = @"保存";

static NSString *const BDFaceAdjustParamsAlertTitle = @"是否保存修改";
static NSString *const BDFaceAdjustParamsAlertContent = @"参数配置已修改，是否保存后离开";
static NSString *const BDFaceAdjustParamsAlertJustLeave = @"直接离开";
static NSString *const BDFaceAdjustParamsAlertSaveAndLeave = @"保存并离开";
static NSString *const BDFaceAdjustParamsAlertCancel = @"取消";
static NSString *const BDFaceAdjustParamsAlertSaveCustomConfig = @"保存自定义";

static NSString *const BDFaceAdjustParamsAlertRecoverToDefaultTip = @"参数配置已修改，是否恢复默认";
static NSString *const BDFaceAdjustParamsAlertRecoverToDefault = @"恢复默认";

static float const BBDFaceAjustConfigTableViewOriginY = 10.0f;
static float const BDFaceSelectConfigTableMargin = 20.0f;
static float const BDFaceSelectConfigTableViewHeight = 24.0f;
static NSString *const BDFaceAdjustParamsSection1Tip = @"数值越小越严格";
static NSString *const BDFaceAdjustParamsSection2Tip = @"姿态阀值（绝对值，单位：度）";
@interface BDFaceAdjustParamsController ()

@property(nonatomic, strong) BDFaceAdjustParams *configInital;
@property(nonatomic, strong) BDFaceAdjustParams *currentConfig;
@property(nonatomic, strong) NSMutableArray *allData;
@property(nonatomic, assign) BDFaceSelectType selectType;
@property(nonatomic, assign) BDFaceSelectType initialSelect;

@property(nonatomic, strong) UIButton *saveButton;

@property(nonatomic, copy) NSString *selectTypeString;
@property(nonatomic, copy) NSString *recoverText;

@property(nonatomic, assign) BOOL isSameConfig;

@property(nonatomic, weak) BDFaceAdjustParamsCell *recoverCell;
//弹窗
@property (nonatomic, strong) BDPopupController *popupController; //保存
@property (nonatomic, strong) BDPopupController *popupController1; //table
@property (nonatomic, strong) BDPopupController *popupController2; //back

@end

@implementation BDFaceAdjustParamsController

- (instancetype)initWithConfig:(BDFaceAdjustParams *)config {
    self = [super init];
    if (self) {
        self.configInital = [config copy];
        self.currentConfig = [config copy];
        self.selectType = [BDFaceAdjustParamsFileManager sharedInstance].selectType;
        self.initialSelect = self.selectType;
        self.selectTypeString = [BDFaceAdjustParamsModel getSelectTypeString:self.selectType];
        self.recoverText = [NSString stringWithFormat:BDFaceAdjustParamsRecoverText, self.selectTypeString];
        self.isSameConfig = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.allData = [BDFaceAdjustParamsModel loadItemsArray:self.currentConfig recorverText:self.recoverText selectType:self.selectType];
    [self loadTableWithCellClass:[BDFaceAdjustParamsCell class] reuseLabel:NSStringFromClass([BDFaceAdjustParamsCell class]) dataSourceArray:self.allData];
    
    CGRect tableRect = self.tableView.frame;
    tableRect.origin.x = BDFaceAdjustConfigTableMargin;
    tableRect.size.width = CGRectGetWidth(self.view.frame) - BDFaceAdjustConfigTableMargin * 2.0f;
    self.tableView.frame = tableRect;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.titleLabel.text = [NSString stringWithFormat:BDFaceAdjustParamsControllerTitle, self.selectTypeString];
    [self loadSaveButton];
}

- (void)loadSaveButton {
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.frame = CGRectMake(CGRectGetWidth(self.titleView.frame) - BDFaceAdjustParamsSaveButtonRightMargin - BDFaceAdjustParamsSaveButtonWidth, (CGRectGetHeight(self.titleView.frame) - BDFaceAdjustParamsSaveButtonHeight) / 2.0f, BDFaceAdjustParamsSaveButtonWidth, BDFaceAdjustParamsSaveButtonHeight);
    [self.titleView addSubview:self.saveButton];
    [self.saveButton setTitle:BDFaceAdjustParamsSaveButtonText forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    [self updateSaveButtonTextColor];
    [self.saveButton addTarget:self action:@selector(userClickSave) forControlEvents:UIControlEventTouchUpInside];
}

/// 用户点击保存按钮
- (void)userClickSave {
    if (self.isSameConfig) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.popupController showInView:self.view.window duration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut bounced:NO completion:nil];
    }
    
}

- (void)saveConfig {
    [BDFaceAdjustParamsFileManager sharedInstance].selectType = BDFaceSelectTypeCustom;
    [BDFaceAdjustParamsTool changeConfig:self.currentConfig];
    [[BDFaceAdjustParamsFileManager sharedInstance] saveToCustomConfigFile:self.currentConfig];
    [[NSNotificationCenter defaultCenter] postNotificationName:BDFaceAdjustParamsUserDidFinishSavedConfigNotification object:nil];
    [self dismissVc];
    [self dismissVc2];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BDFaceAdjustParamsCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([theCell isKindOfClass:[BDFaceAdjustParamsCell class]]) {
        BDFaceAdjustParamsItem *item = (BDFaceAdjustParamsItem *)theCell.data;
        if (item.contentType == BDFaceAdjustParamsContentTypeRecoverToNormal) {
            if (self.isSameConfig) {
                // do nothing
            } else {
                [self.popupController1 showInView:self.view.window duration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut bounced:NO completion:nil];
            }
        }
        
    }
}

/// 恢复为默认值
- (void)recoverToInital {
    self.selectType = self.initialSelect;
    BDFaceAdjustParams *config = [[BDFaceAdjustParamsFileManager sharedInstance] configBySelection:self.selectType];
    self.configInital = [config copy];
    self.currentConfig = [config copy];
    self.isSameConfig = YES;
    [self updateSaveButtonTextColor];
    [self.allData removeAllObjects];
    NSMutableArray *array = [BDFaceAdjustParamsModel loadItemsArray:self.currentConfig recorverText:self.recoverText selectType:self.selectType];
    [self.allData addObjectsFromArray:array];
    [self.tableView reloadData];
    dispatch_after(0.5, dispatch_get_main_queue(), ^{
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    });
    [self dismissVc1];
}

- (UITableViewStyle)customTableViewStyle {
    return UITableViewStyleGrouped;
}

/// 点击返回按钮
- (void)goBack {
    if (self.isSameConfig) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.popupController2 showInView:self.view.window duration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut bounced:NO completion:nil];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *des = nil;
    switch (section) {
        case 0:
        {
            CGRect rect = CGRectMake(BDFaceSelectConfigTableMargin, 0, CGRectGetWidth(self.view.frame) - BDFaceSelectConfigTableMargin * 2.0f, BDFaceSelectConfigTableViewHeight);
            UIView *view = [[UIView alloc] initWithFrame:rect];
            
            CGRect label1Rect = view.bounds;
            label1Rect.origin.y = BBDFaceAjustConfigTableViewOriginY;
            label1Rect.size.height = BDFaceSelectConfigTableViewHeight;
            UILabel *label1 = [[UILabel alloc] initWithFrame:label1Rect];
            [view addSubview:label1];
            
            label1.textColor = [UIColor face_colorWithRGBHex:0x91979E];
            label1.text = BDFaceAdjustParamsSection1Tip;
            label1.font = [UIFont systemFontOfSize:14.0f];
            des = view;
        }
            break;
        case 1:{
            CGRect rect = CGRectMake(BDFaceSelectConfigTableMargin, 0, CGRectGetWidth(self.view.frame) - BDFaceSelectConfigTableMargin * 2.0f, BDFaceSelectConfigTableViewHeight);
            UIView *view = [[UIView alloc] initWithFrame:rect];
            
            CGRect label1Rect = view.bounds;
            label1Rect.origin.y = BBDFaceAjustConfigTableViewOriginY;
            label1Rect.size.height = BDFaceSelectConfigTableViewHeight;
            UILabel *label1 = [[UILabel alloc] initWithFrame:label1Rect];
            [view addSubview:label1];
            
            label1.textColor = [UIColor face_colorWithRGBHex:0x91979E];
            label1.text = BDFaceAdjustParamsSection2Tip;
            label1.font = [UIFont systemFontOfSize:14.0f];
            des = view;
        }
            break;;
            
        default:
            break;
    }
    return des;
}

- (void)updateCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    BDFaceAdjustParamsCell *theCell = (BDFaceAdjustParamsCell *)cell;
    theCell.isSameConfig = self.isSameConfig;
    __weak typeof(self) this = self;
    if ([theCell isKindOfClass:[BDFaceAdjustParamsCell class]]) {
        theCell.didFinishAdjustParams = ^(BDFaceAdjustParamsItemType type, float value) {
            [this changCurrentValue:type value:value];
            [this compareValues];
        };
    }
}

- (void)updateSaveButtonTextColor {
    if (self.isSameConfig) {
        [self.saveButton setTitleColor:[UIColor colorAndAlphaWithHexString:BDFaceAdjustParamsRecoverUnactiveTextColorNew] forState:UIControlStateNormal];
    } else {
        [self.saveButton setTitleColor:[UIColor colorAndAlphaWithHexString:BDFaceAdjustParamsRecoverActiveTextColorNew] forState:UIControlStateNormal];
    }
}

- (void)compareValues {
    BOOL temp = self.isSameConfig;
    if (![self.currentConfig compareToParams:self.configInital]) {
        self.isSameConfig = NO;
    } else {
        self.isSameConfig = YES;
    }
    if (temp != self.isSameConfig) {
        NSDictionary *dic = @{BDFaceAdjustParamsControllerConfigIsSameKey : @(self.isSameConfig)};
        [[NSNotificationCenter defaultCenter] postNotificationName:BDFaceAdjustParamsControllerConfigDidChangeNotification object:dic];
        [self updateSaveButtonTextColor];
    }
}

- (void)changCurrentValue:(BDFaceAdjustParamsItemType)type value:(float) value {
    switch (type) {
            /// 光照
        case BDFaceAdjustParamsTypeMinLightIntensity:
        {
            self.currentConfig.minLightIntensity = value;
        }
            break;
        case BDFaceAdjustParamsTypeMaxLightIntensity:
        {
            self.currentConfig.maxLightIntensity = value;
        }
            break;
        case BDFaceAdjustParamsTypeAmbiguity:
        {
            self.currentConfig.ambiguity = value;
        }
            break;
            /// 遮挡
        case BDFaceAdjustParamsTypeLeftEyeOcclusion:
        {
            self.currentConfig.leftEyeOcclusion = value;
        }
            break;
        case BDFaceAdjustParamsTypeRightEyeOcclusion:
        {
            self.currentConfig.rightEyeOcclusion = value;
        }
            break;
        case BDFaceAdjustParamsTypeNoseOcclusion:
        {
            self.currentConfig.noseOcclusion = value;
        }
            break;
        case BDFaceAdjustParamsTypeMouthOcclusion:
        {
            self.currentConfig.mouthOcclusion = value;
        }
            break;
        case BDFaceAdjustParamsTypeLeftFaceOcclusion:
        {
            self.currentConfig.leftFaceOcclusion = value;
        }
            break;
        case BDFaceAdjustParamsTypeRightFaceOcclusion:
        {
            self.currentConfig.rightFaceOcclusion = value;
        }
            break;
        case BDFaceAdjustParamsTypeLowerJawOcclusion:
        {
            self.currentConfig.lowerJawOcclusion = value;
        }
            break;
            /// 姿势
        case BDFaceAdjustParamsTypeUpAndDownAngle:
        {
            self.currentConfig.upAndDownAngle = value;
        }
            break;
        case BDFaceAdjustParamsTypeLeftAndRightAngle:
        {
            self.currentConfig.leftAndRightAngle = value;
        }
            break;
        case BDFaceAdjustParamsTypeSpinAngle:
        {
            self.currentConfig.spinAngle = value;
        }
            break;
        default:
            break;
    }
}

- (BDPopupController *)popupController {
    if (!_popupController) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, KScaleY(200))];
        view.backgroundColor = [UIColor whiteColor];
        [view yz_setRoundedWithCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadious:12.0f];
        // 对应的label
        UILabel *labelFirst = [[UILabel alloc] init];
        labelFirst.frame = CGRectMake(KScaleX(0), KScaleY(33), ScreenWidth, 24);
        labelFirst.text = @"是否保存自定义配置";
        labelFirst.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        labelFirst.textColor = UIColorFromRGB(0x171D24);
        labelFirst.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labelFirst];

        UILabel *labelSecond = [[UILabel alloc] init];
        labelSecond.frame = CGRectMake(KScaleX(0), KScaleY(73), ScreenWidth, 22);
        labelSecond.text = @"参数配置已更改，是否保存自定义配置";
        labelSecond.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        labelSecond.textColor = UIColorFromRGB(0x91979E);
        labelSecond.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labelSecond];
        
        // 上下两个button
        UIButton *btnFirst = [[UIButton alloc] init];
        btnFirst.frame = CGRectMake(KScaleX(16), KScaleY(200)-KScaleY(16)-52-KBDXMoveHeight, KScaleX(164), 52);
        [btnFirst setBackgroundColor:UIColorFromRGB(0xD9DFE6)];
        btnFirst.layer.cornerRadius = 26;
        [btnFirst addTarget:self action:@selector(dismissVc) forControlEvents:UIControlEventTouchUpInside];
        [btnFirst setTitle:@"取消" forState:UIControlStateNormal];
        [btnFirst setTitleColor:UIColorFromRGB(0x171D24) forState:UIControlStateNormal];
        btnFirst.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [view addSubview:btnFirst];

        UIButton *btnSecond = [[UIButton alloc] init];
        btnSecond.frame = CGRectMake(ScreenWidth-KScaleX(16)-KScaleX(164), KScaleY(200)-KScaleY(16)-52-KBDXMoveHeight,  KScaleX(164), 52);
        [btnSecond setBackgroundColor:UIColorFromRGB(0x0080FF)];
        btnSecond.layer.cornerRadius = 26;
        [btnSecond addTarget:self action:@selector(saveConfig) forControlEvents:UIControlEventTouchUpInside];
        [btnSecond setTitle:@"保存自定义" forState:UIControlStateNormal];
        [btnSecond setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        btnSecond.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [view addSubview:btnSecond];
        
        _popupController = [[BDPopupController alloc] initWithView:view size:view.bounds.size];
        _popupController.layoutType = zhPopupLayoutTypeBottom;
        _popupController.presentationStyle = zhPopupSlideStyleFromBottom;
        _popupController.dismissOnMaskTouched = NO;
    }
    return _popupController;
}
- (BDPopupController *)popupController1 {
    if (!_popupController1) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, KScaleY(200))];
        view.backgroundColor = [UIColor whiteColor];
        [view yz_setRoundedWithCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadious:12.0f];
        // 对应的label
        UILabel *labelFirst = [[UILabel alloc] init];
        labelFirst.frame = CGRectMake(KScaleX(0), KScaleY(33), ScreenWidth, 24);
        labelFirst.text = @"是否恢复默认参数配置";
        labelFirst.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        labelFirst.textColor = UIColorFromRGB(0x171D24);
        labelFirst.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labelFirst];

        UILabel *labelSecond = [[UILabel alloc] init];
        labelSecond.frame = CGRectMake(KScaleX(0), KScaleY(73), ScreenWidth, 22);
        labelSecond.text = @"参数配置已更改，是否恢复默认";
        labelSecond.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        labelSecond.textColor = UIColorFromRGB(0x91979E);
        labelSecond.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labelSecond];
        
        // 上下两个button
        UIButton *btnFirst = [[UIButton alloc] init];
        btnFirst.frame = CGRectMake(KScaleX(16), KScaleY(200)-KScaleY(16)-52-KBDXMoveHeight, KScaleX(164), 52);
        [btnFirst setBackgroundColor:UIColorFromRGB(0xD9DFE6)];
        btnFirst.layer.cornerRadius = 26;
        [btnFirst addTarget:self action:@selector(dismissVc1) forControlEvents:UIControlEventTouchUpInside];
        [btnFirst setTitle:@"取消" forState:UIControlStateNormal];
        [btnFirst setTitleColor:UIColorFromRGB(0x171D24) forState:UIControlStateNormal];
        btnFirst.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [view addSubview:btnFirst];

        UIButton *btnSecond = [[UIButton alloc] init];
        btnSecond.frame = CGRectMake(ScreenWidth-KScaleX(16)-KScaleX(164), KScaleY(200)-KScaleY(16)-52-KBDXMoveHeight,  KScaleX(164), 52);
        [btnSecond setBackgroundColor:UIColorFromRGB(0x0080FF)];
        btnSecond.layer.cornerRadius = 26;
        [btnSecond addTarget:self action:@selector(recoverToInital) forControlEvents:UIControlEventTouchUpInside];
        [btnSecond setTitle:@"恢复默认" forState:UIControlStateNormal];
        [btnSecond setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        btnSecond.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [view addSubview:btnSecond];
        
        _popupController1 = [[BDPopupController alloc] initWithView:view size:view.bounds.size];
        _popupController1.layoutType = zhPopupLayoutTypeBottom;
        _popupController1.presentationStyle = zhPopupSlideStyleFromBottom;
        _popupController1.dismissOnMaskTouched = NO;
    }
    return _popupController1;
}
- (BDPopupController *)popupController2 {
    if (!_popupController2) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, KScaleY(200))];
        view.backgroundColor = [UIColor whiteColor];
        [view yz_setRoundedWithCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadious:12.0f];
        
        // 对应的label
        UILabel *labelFirst = [[UILabel alloc] init];
        labelFirst.frame = CGRectMake(KScaleX(0), KScaleY(33), ScreenWidth, 24);
        labelFirst.text = @"是否保存自定义配置";
        labelFirst.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        labelFirst.textColor = UIColorFromRGB(0x171D24);
        labelFirst.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labelFirst];

        UILabel *labelSecond = [[UILabel alloc] init];
        labelSecond.frame = CGRectMake(KScaleX(0), KScaleY(73), ScreenWidth, 22);
        labelSecond.text = @"参数配置已更改，是否保存自定义配置";
        labelSecond.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        labelSecond.textColor = UIColorFromRGB(0x91979E);
        labelSecond.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labelSecond];
        
        // 上下两个button
        UIButton *btnFirst = [[UIButton alloc] init];
        btnFirst.frame = CGRectMake(KScaleX(16), KScaleY(200)-KScaleY(16)-52-KBDXMoveHeight, KScaleX(164), 52);
        [btnFirst setBackgroundColor:UIColorFromRGB(0xD9DFE6)];
        btnFirst.layer.cornerRadius = 26;
        [btnFirst addTarget:self action:@selector(dismissAndPop) forControlEvents:UIControlEventTouchUpInside];
        [btnFirst setTitle:@"直接离开" forState:UIControlStateNormal];
        [btnFirst setTitleColor:UIColorFromRGB(0x171D24) forState:UIControlStateNormal];
        btnFirst.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [view addSubview:btnFirst];

        UIButton *btnSecond = [[UIButton alloc] init];
        btnSecond.frame = CGRectMake(ScreenWidth-KScaleX(16)-KScaleX(164), KScaleY(200)-KScaleY(16)-52-KBDXMoveHeight,  KScaleX(164), 52);
        [btnSecond setBackgroundColor:UIColorFromRGB(0x0080FF)];
        btnSecond.layer.cornerRadius = 26;
        [btnSecond addTarget:self action:@selector(saveConfig) forControlEvents:UIControlEventTouchUpInside];
        [btnSecond setTitle:@"保存自定义" forState:UIControlStateNormal];
        [btnSecond setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        btnSecond.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        [view addSubview:btnSecond];
        
        _popupController2 = [[BDPopupController alloc] initWithView:view size:view.bounds.size];
        _popupController2.layoutType = zhPopupLayoutTypeBottom;
        _popupController2.presentationStyle = zhPopupSlideStyleFromBottom;
        _popupController2.dismissOnMaskTouched = NO;
    }
    return _popupController2;
}
-(void)dismissVc{
    [self.popupController dismiss];
}
-(void)dismissVc1{
    [self.popupController1 dismiss];
}
-(void)dismissVc2{
    [self.popupController2 dismiss];
}
-(void)dismissAndPop{
    [self.popupController2 dismiss];
    [self.navigationController popViewControllerAnimated:YES];

}

@end
