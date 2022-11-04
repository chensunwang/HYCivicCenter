//
//  HYOnLineHandleViewController.m
//  HelloFrame
//
//  Created by nuchina on 2022/1/7.
//
//  在线办理页面

#import "HYOnLineHandleViewController.h"
#import "HYBaseInfoTableViewCell.h"
#import "HYUploadFileTableViewCell.h"
#import "HYSubmitTableViewCell.h"
#import "HYFormInfoModel.h"
#import "HYItemTotalInfoModel.h"
#import "HYOnLineHandleHeader.h"
#import "HYServiceProgressViewController.h"
#import "HYCivicCenterCommand.h"
#import "HYHandleAffairsWebVIewController.h"

@interface HYOnLineHandleViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) HYBaseInfoModel * baseInfoModel;

@property (nonatomic, strong) NSMutableDictionary * infoDict;  // 基本信息缓存数据
@property (nonatomic, strong) NSMutableArray * fieldListArray;  // radio选项缓存数据
@property (nonatomic, strong) NSMutableArray * fieldsArr;  // 表单数据
@property (nonatomic, strong) NSMutableArray * materailsArr;  // 材料数据

@property (nonatomic, strong) NSMutableDictionary * postDataDict;  // 需要提交的全部参数数据
@property (nonatomic, strong) NSMutableDictionary * infoParamsDict;  // 需要提交的基本信息参数
@property (nonatomic, strong) NSMutableArray * fieldListParamsArray;  // 需要提交的radio选项数据
@property (nonatomic, strong) NSMutableArray * materialParamsArray;  // 需要提交的材料数据
@property (nonatomic, assign) BOOL isAllFill;  // 判断所有资料是否全部填写完  填写完方可提交
@property (nonatomic, assign) NSInteger totalParamsNum;  // 总共有多少个参数

@property (nonatomic, strong) NSMutableDictionary * rowHeightDic;
@property (nonatomic, strong) NSMutableDictionary * uploadModels;   // 存储上传材料的动态数组
@property (nonatomic, strong) NSMutableDictionary * uploadWindowFlag;  // 存储是否窗口提交
@property (nonatomic, strong) NSMutableDictionary * recordAddedData;  // 记录已经添加的材料数据

@property (nonatomic, strong) HYItemInfoModel *baseInfo;

@end

@implementation HYOnLineHandleViewController

- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(16, 16, 0, 16));
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HYBaseInfoTableViewCell class] forCellReuseIdentifier:@"HYBaseInfoTableViewCell"];
    [self.tableView registerClass:[HYRadioFormTableViewCell class] forCellReuseIdentifier:@"HYRadioFormTableViewCell"];
    [self.tableView registerClass:[HYBaseInfoTextFieldCell class] forCellReuseIdentifier:@"HYBaseInfoTextFieldCell"];
    [self.tableView registerClass:[HYUploadFileTableViewCell class] forCellReuseIdentifier:@"HYUploadFileTableViewCell"];
    [self.tableView registerClass:[HYSubmitTableViewCell class] forCellReuseIdentifier:@"HYSubmitTableViewCell"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self traitCollectionDidChange:nil];
    [self loadData];
}

- (void)loadData {
    [HttpRequest getPathZWBS:@"phone/item/event/getFormZoneDetail" params:@{@"itemCode": _itemCode} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@"动态表单== %@", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            [self.postDataDict setValue:responseObject[@"data"][@"formId"] forKey:@"formId"];  // 表单id
            self.baseInfoModel = [HYBaseInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"baseInfo"]];
            self.fieldsArr = [HYFormInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"fieldList"]];
            [self.tableView reloadData];
        } else {
            SLog(@"%@", responseObject[@"msg"]);
        }
    }];
    
    [HttpRequest getPathZWBS:@"phone/item/event/getItemInfoByItemCode" params:@{@"itemCode": _itemCode} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 办事指南 == %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.materailsArr = [HYMaterialModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"material"]];
            self.baseInfo = [[HYItemInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"itemInfo"]] firstObject];
            if (!self.baseInfo.canHandle) {
                [self showUnableToOperate];  // 提示该事项无法操作
            } else {
                NSArray *onlineConduct = responseObject[@"data"][@"onlineConduct"];
                if (onlineConduct != nil && onlineConduct.count > 0) {
                    NSString *onlineAddress = onlineConduct.firstObject[@"ONLINE_ADDRESS"];
                    if (onlineAddress != nil && ![onlineAddress isEqualToString:@""]) {
                        NSString *uuid = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUuid"];
                        if ([onlineAddress containsString:@"https://nc.tpms.jxangyi.cn"] && uuid != nil) { // 货车通行证
                            HYHandleAffairsWebVIewController *webVC = [[HYHandleAffairsWebVIewController alloc] init];
                            webVC.code = @"";
                            webVC.titleStr = @"货车通行证";
                            webVC.jumpUrl = [NSString stringWithFormat:@"https://nc.tpms.jxangyi.cn/tpmswx-webapp/?openId=%@&comefrom=inc", uuid];
                            [self.navigationController pushViewController:webVC animated:YES];
                        } else {
                            [self showOutsideOpen:onlineAddress];  // 弹出该事项无法在app内办理
                        }
                    } else {
                        [self.tableView reloadData];
                    }
                } else {
                    [self.tableView reloadData];
                }
            }
        } else {
            SLog(@"%@", responseObject[@"msg"]);
        }
    }];
}

- (void)showUnableToOperate { // 提示该事项无法操作
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"该事项无法操作" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showOutsideOpen:(NSString *)url { // 弹出该事项无法在app内办理
    NSString *message = [NSString stringWithFormat:@"复制链接前往浏览器办理\n%@", url];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该事项无法在app内办理" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        board.string = url;
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);  // 3s
        // 主队列中执行
        dispatch_after(time, dispatch_get_main_queue(), ^{ // dispatch_after 这个函数是用来延时执行任务的
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    [alert addAction:confirm];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)submitData {
    [SVProgressHUD showWithStatus:@"正在提交"];
    [HttpRequest postHttpBodyZWBS:@"phone/item/event/applyOnline" params:@{@"postData": _postDataDict} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@"提交资料== %@", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            SLog(@"提交成功");
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            // 跳转到进度跟踪列表页
            dispatch_async(dispatch_get_main_queue(), ^{
                HYServiceProgressViewController *vc = [[HYServiceProgressViewController alloc] init];
                vc.hyTitleColor = self.hyTitleColor;
                [self.navigationController pushViewController:vc animated:YES];
            });
        } else {
            SLog(@"%@", responseObject[@"msg"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            });
        }
    }];
    
    // 本地测试路径
//    [HttpRequest postLocolBodyZWBS:@"phone/item/event/applyOnline" params:dic resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
//        SLog(@"提交资料== %@", responseObject);
//        if ([responseObject[@"code"] intValue] == 200) {
//            SLog(@"提交成功");
//        } else {
//            SLog(@"%@", responseObject[@"msg"]);
//        }
//    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    if (dataArray) {
        _dataArray = dataArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else if (section == 1) {
        return _fieldsArr.count;
    } else if (section == 2) {
        return _materailsArr.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HYBaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYBaseInfoTableViewCell"];
        
        NSArray *titlesArr = @[@"姓名", @"性别", @"证件号", @"联系电话", @"联系地址"];
        NSString *htmlStr = [NSString stringWithFormat:@"<span style='color:red'>*</span>%@", titlesArr[indexPath.row]];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        cell.nameLabel.attributedText = attStr;
        cell.nameLabel.font = MFONT(14);
        
        if (indexPath.row == 0) {
            cell.rightTF.hidden = YES;
            cell.rightLabel.hidden = NO;
            cell.rightLabel.text = self.baseInfoModel.nickname;
        } else if (indexPath.row == 1) {
            cell.rightTF.hidden = YES;
            cell.rightLabel.hidden = NO;
            cell.rightLabel.text = self.baseInfoModel.sex;
        } else if (indexPath.row == 2) {
            cell.rightTF.hidden = YES;
            cell.rightLabel.hidden = NO;
            cell.rightLabel.text = self.baseInfoModel.idCard;
        } else if (indexPath.row == 3) {
            cell.rightTF.hidden = YES;
            cell.rightLabel.hidden = NO;
            cell.rightLabel.text = self.baseInfoModel.phone;
        } else if (indexPath.row == 4) {
            cell.rightLabel.hidden = YES;
            cell.rightTF.hidden = NO;
            cell.rightTF.placeholder = @"请输入联系地址";
            cell.rightTF.text = [_infoDict valueForKey:@"linkAddress"] ? : self.baseInfoModel.address;
            
            __weak typeof(self) weakSelf = self;
            cell.baseInfoTableViewCellBlock = ^(NSString * _Nonnull text) {
                [weakSelf.infoDict setValue:text forKey:@"linkAddress"];
                // 添加数据到参数数组
                [weakSelf.infoParamsDict setValue:text forKey:@"linkAddress"];
                [weakSelf updateBottomCellViewSubmitButtonStatus];
            };
        }
        return cell;
    } else if (indexPath.section == 1) {
        HYFormInfoModel *formModel = self.fieldsArr[indexPath.row];
        NSString *cellID = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
        if ([formModel.fieldType isEqualToString:@"text"]) {  // date、radio、text
            if ([formModel.readOnly integerValue] == 1) {
                HYBaseInfoTableViewCell *cell = [[HYBaseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                cell.nameLabel.text = formModel.fieldName;
                cell.rightTF.hidden = NO;
                cell.rightTF.text = formModel.fieldValue;
                return cell;
            } else {
                HYBaseInfoTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYBaseInfoTextFieldCell" forIndexPath:indexPath];
                NSString *oldValue = nil;
                for (NSDictionary *dic in _fieldListArray) {
                    if ([dic valueForKey:formModel.fieldName]) {
                        oldValue = [dic valueForKey:formModel.fieldName];
                        break;
                    }
                }
                cell.nameLabel.text = formModel.fieldName;
                if (oldValue != nil) {
                    cell.textField.text = oldValue ? : formModel.fieldValue;
                } else {
                    cell.textField.placeholder = [NSString stringWithFormat:@"请输入%@", formModel.fieldName];
                }
                
                __block typeof(self) weakSelf = self;
                cell.baseInfoTextFieldCellBlock = ^(NSString * _Nonnull text) {
                    __block int index = -1;
                    for (int i = 0; i < weakSelf.fieldListArray.count; i ++) {
                        if ([weakSelf.fieldListArray[i] valueForKey:formModel.fieldName] != nil) {
                            NSDictionary *dict = [NSDictionary dictionaryWithObject:text forKey:formModel.fieldName];
                            [weakSelf.fieldListArray replaceObjectAtIndex:i withObject:dict];
                            // 添加数据到参数数组
                            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:formModel.fieldId forKey:@"fieldId"];
                            [dic setValue:text forKey:@"fieldValue"];
                            [weakSelf.fieldListParamsArray replaceObjectAtIndex:i withObject:dic];
                            index = i;
                            break;
                        }
                    }
                    if (index == -1) {
                        NSDictionary *dict = [NSDictionary dictionaryWithObject:text forKey:formModel.fieldName];
                        [weakSelf.fieldListArray addObject:dict];
                        // 添加数据到参数数组
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:formModel.fieldId forKey:@"fieldId"];
                        [dic setValue:text forKey:@"fieldValue"];
                        [weakSelf.fieldListParamsArray addObject:dic];
                    }
                };
                
                return cell;
            }
        } else if ([formModel.fieldType isEqualToString:@"radio"]) {
            HYRadioFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYRadioFormTableViewCell" forIndexPath:indexPath];
            NSString *oldValue = nil;
            for (NSDictionary *dic in _fieldListArray) {
                if ([dic valueForKey:formModel.fieldName]) {
                    oldValue = [dic valueForKey:formModel.fieldName];
                    break;
                }
            }
            if (oldValue != nil) {
                formModel.fieldValue = oldValue;
            }
            cell.infoModel = formModel;
            
            __block typeof(self) weakSelf = self;
            cell.radioFormTableViewCellBlock = ^(NSString * _Nonnull text) {
                __block int index = -1;
                for (int i = 0; i < weakSelf.fieldListArray.count; i ++) {
                    if ([weakSelf.fieldListArray[i] valueForKey:formModel.fieldName] != nil) {
                        NSDictionary *dict = [NSDictionary dictionaryWithObject:text forKey:formModel.fieldName];
                        [weakSelf.fieldListArray replaceObjectAtIndex:i withObject:dict];
                        // 添加数据到参数数组
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:formModel.fieldId forKey:@"fieldId"];
                        [dic setValue:text forKey:@"fieldValue"];
                        [weakSelf.fieldListParamsArray replaceObjectAtIndex:i withObject:dic];
                        index = i;
                        break;
                    }
                }
                if (index == -1) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:text forKey:formModel.fieldName];
                    [weakSelf.fieldListArray addObject:dict];
                    // 添加数据到参数数组
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:formModel.fieldId forKey:@"fieldId"];
                    [dic setValue:text forKey:@"fieldValue"];
                    [weakSelf.fieldListParamsArray addObject:dic];
                }
            };
            
            return cell;
        } else {
            return [UITableViewCell new];
        }
    } else if (indexPath.section == 2) {
        if (_materailsArr.count == 0) {
            return [[UITableViewCell alloc] init];
        }
        HYUploadFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYUploadFileTableViewCell"];
        cell.viewController = self;
        HYMaterialModel *mo = _materailsArr[indexPath.row];
        NSMutableArray *arr = [self.uploadModels valueForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        NSString *flag = [self.uploadWindowFlag valueForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        if (arr && arr.count > 0) {  // 如果有旧数据 则使用就数据 否则使用初始数据
//            cell.models = arr;
        } else {
            cell.model = mo;
        }
        if ([mo.must isEqualToString:@"1"]) {
            if (![mo.autoUploadUrl isEqualToString:@""] || arr.count > 0 || [flag isEqualToString:@"1"]) {
                [self.recordAddedData setValue:@"1" forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            } else {
                [self.recordAddedData setValue:@"0" forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            }
            [self updateBottomCellViewSubmitButtonStatus];
        }
        
        __weak typeof(self) weakSelf = self;
        cell.uploadFileTableViewCellBlock = ^(NSArray * _Nullable models, BOOL isWindow) {
            BOOL isFill = NO;
            if (models != nil) {
                [weakSelf.materialParamsArray removeAllObjects];
                for (HYUploadedMaterailModel *model in models) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setValue:model.docId forKey:@"docId"];
                    [dict setValue:model.documentId forKey:@"documentId"];
                    [dict setValue:model.documentName forKey:@"documentName"];
                    [dict setValue:model.fileName forKey:@"fileName"];
                    [dict setValue:model.url forKey:@"url"];
                    [weakSelf.materialParamsArray addObject:dict];
                }
                // 保存已添加的数据 防止tableView复用机制清空数据
                [weakSelf.uploadModels setValue:models forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
                isFill = models.count > 0 ? YES : NO;
            }
            // 保存已添加的数据 防止tableView复用机制清空数据
            [weakSelf.uploadWindowFlag setValue:isWindow ? @"1" : @"0" forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            
            [weakSelf.recordAddedData setValue:(isFill || isWindow) ? @"1" : @"0" forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            [weakSelf updateBottomCellViewSubmitButtonStatus];
            
            // 根据返回数组数量 动态计算cell高度 cell里面的collectionView每3个一行  注意：暂时不实现 如果放开 需要调整collectionView的滚动方向
//            NSInteger num = floor(models.count/3);  // 向下取整 floor（5.0/4）＝1;
//            CGFloat height = (num + 1) * 88;  // 行数 * 行高
//            [weakSelf.rowHeightDic setValue:[NSString stringWithFormat:@"%f", height] forKey:[NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row]];
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    } else {
        HYSubmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYSubmitTableViewCell" forIndexPath:indexPath];
        cell.submitBtn.enabled = _isAllFill;
        __weak typeof(self) weakSelf = self;
        cell.submitTableViewCellBlock = ^{
            // 点击提交按钮 先处理参数数据
            [weakSelf.postDataDict setValue:weakSelf.fieldListParamsArray forKey:@"fieldList"];
            [weakSelf.postDataDict setValue:weakSelf.infoParamsDict forKey:@"info"];
            [weakSelf.postDataDict setValue:weakSelf.itemCode forKey:@"itemCode"];
            [weakSelf.postDataDict setValue:weakSelf.baseInfo.id forKey:@"itemId"];
            [weakSelf.postDataDict setValue:weakSelf.baseInfo.name forKey:@"itemName"];
            [weakSelf.postDataDict setValue:weakSelf.materialParamsArray forKey:@"material"];
            [weakSelf.postDataDict setValue:weakSelf.baseInfo.orgCode forKey:@"orgCode"];
            [weakSelf.postDataDict setValue:weakSelf.baseInfo.orgName forKey:@"orgName"];
            [weakSelf.postDataDict setValue:weakSelf.baseInfo.serviceObject forKey:@"serviceObject"];  // 事项属性 判断是个人还是企业
            [weakSelf submitData];
        };
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 55;
    } else if (indexPath.section == 1) {
        HYFormInfoModel *formModel = self.fieldsArr[indexPath.row];
        CGFloat height = [formModel.fieldName heightForStringWithFont:MFONT(14) width:([UIScreen mainScreen].bounds.size.width - 64)];
        if ([formModel.fieldType isEqualToString:@"text"]) {
            if ([formModel.readOnly integerValue] == 1) {  //
                return height + 40;
            } else {
                return height + 70;
            }
        } else if ([formModel.fieldType isEqualToString:@"radio"]) {
            return height + 70;
        } else {
            return 80;
        }
    } else if (indexPath.section == 2) {
        if (_materailsArr.count == 0) {
            return 80;
        }
        HYMaterialModel *model = _materailsArr[indexPath.row];
        CGFloat height = [model.name heightForStringWithFont:MFONT(14) width:([UIScreen mainScreen].bounds.size.width - 64)];
//        CGFloat rowHeight = [[_rowHeightDic valueForKey:[NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row]] floatValue];
//        return 36 + height + (rowHeight != 0 ? rowHeight : 88);  // collectionViewCell行高 68 间距10
        return 124 + height;
    } else {
        return 80;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HYOnLineHandleHeader *view = [[HYOnLineHandleHeader alloc] init];
    if (section == 0) {
        view.nameLabel.text = @"基本信息";
    } else if (section == 1) {
        view.nameLabel.text = @"详细信息";
        view.hidden = _fieldsArr.count == 0 ? YES : NO;
    } else if (section == 2) {
        view.nameLabel.text = @"上传材料";
        view.hidden = _materailsArr.count == 0 ? YES : NO;
    } else {
        return [UIView new];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ((_fieldsArr.count == 0 && section == 1) || (_materailsArr.count == 0 && section == 2) || (section == 3)) {
        return 0.001;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ((_fieldsArr.count == 0 && section == 1) || (_materailsArr.count == 0 && section == 2) || (section == 3)) {
        return 0.001;
    }
    return 16;
}


#pragma mark - 判断参数是否完整

- (BOOL)judgeParameterComplete {
    NSString *address = [self.infoParamsDict valueForKey:@"linkAddress"];
    if (!address || [address isEqualToString:@""]) {
        return NO;
    }
    
    for (NSString *value in [_recordAddedData allValues]) {
        if ([value isEqualToString:@"0"]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)updateBottomCellViewSubmitButtonStatus {
    self.isAllFill = [self judgeParameterComplete];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 懒加载

- (NSMutableDictionary *)infoDict {
    if (!_infoDict) {
        _infoDict = [NSMutableDictionary dictionary];
    }
    return _infoDict;
}

- (NSMutableArray *)fieldListArray {
    if (!_fieldListArray) {
        _fieldListArray = [NSMutableArray array];
    }
    return _fieldListArray;
}

- (NSMutableArray *)fieldsArr {
    if (!_fieldsArr) {
        _fieldsArr = [NSMutableArray array];
    }
    return _fieldsArr;
}

- (NSMutableArray *)materailsArr {
    if (!_materailsArr) {
        _materailsArr = [NSMutableArray array];
    }
    return _materailsArr;
}

- (NSMutableDictionary *)postDataDict {
    if (!_postDataDict) {
        _postDataDict = [NSMutableDictionary dictionary];
        [_postDataDict setValue:@"01" forKey:@"applyFrom"];  // 业务来源 默认为网上申报(01)
    }
    return _postDataDict;
}

- (NSMutableDictionary *)infoParamsDict {
    if (!_infoParamsDict) {
        _infoParamsDict = [NSMutableDictionary dictionary];
    }
    return _infoParamsDict;
}

- (NSMutableArray *)fieldListParamsArray {
    if (!_fieldListParamsArray) {
        _fieldListParamsArray = [NSMutableArray array];
    }
    return _fieldListParamsArray;
}

- (NSMutableArray *)materialParamsArray {
    if (!_materialParamsArray) {
        _materialParamsArray = [NSMutableArray array];
    }
    return _materialParamsArray;
}

- (NSMutableDictionary *)rowHeightDic {
    if (!_rowHeightDic) {
        _rowHeightDic = [NSMutableDictionary dictionary];
    }
    return _rowHeightDic;
}

- (NSMutableDictionary *)uploadModels {
    if (!_uploadModels) {
        _uploadModels = [NSMutableDictionary dictionary];
    }
    return _uploadModels;
}

- (NSMutableDictionary *)uploadWindowFlag {
    if (!_uploadWindowFlag) {
        _uploadWindowFlag = [NSMutableDictionary dictionary];
    }
    return _uploadWindowFlag;
}
    
- (NSMutableDictionary *)recordAddedData {
    if (!_recordAddedData) {
        _recordAddedData = [NSMutableDictionary dictionary];
    }
    return _recordAddedData;
}

// 区头跟随表格一起滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y > 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
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
