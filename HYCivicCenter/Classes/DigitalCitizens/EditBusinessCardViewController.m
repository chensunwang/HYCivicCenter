//
//  EditBusinessCardViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/19.
//

#import "EditBusinessCardViewController.h"
#import "EditBusinessCardTableViewCell.h"
#import "IndustryChooseCollectionViewCell.h"
#import "ChooseIndusreyViewController.h"
#import "ChooseCityView.h"
#import "HYAesUtil.h"

@interface EditBusinessCardViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChooseIndustryDelegate, ChooseCityDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) EditBusinessCardModel *cardModel;
@property (nonatomic, strong) NSMutableArray *industryArr;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UITextField *wechatTF;
@property (nonatomic, strong) UITextField *emailTF;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UITextField *companyTF;
@property (nonatomic, strong) UITextField *jobTF;
@property (nonatomic, copy) NSString *email;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation EditBusinessCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"编辑名片";
    
    [self configBottomView];
    
    [self configUI];
    
    [self loadData];
    
}

- (void)loadData {
    
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit", @"eventId": @"E0061", @"applicationId": @"H018"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ", responseObject);
    }];
    
    [HttpRequest postPath:@"/phone/v2/card/myCardData" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if ([responseObject[@"code"] intValue] == 200) {
            self.cardModel = [EditBusinessCardModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.tableView reloadData];
        }
    }];
    
}

- (void)configUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
}

- (void)configBottomView {
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    UIButton *saveBtn = [[UIButton alloc]init];
    saveBtn.frame = CGRectMake(24, 24, SCREEN_WIDTH - 48, 46);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.titleLabel.font = RFONT(15);
    saveBtn.layer.cornerRadius = 23;
    saveBtn.clipsToBounds = YES;
    [saveBtn addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:saveBtn];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kSafeAreaBottomHeight);
        make.height.mas_equalTo(94);
    }];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.colors = @[(__bridge id)UIColorFromRGB(0x1991F1).CGColor,(__bridge id)UIColorFromRGB(0x0F5CFF).CGColor];
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.frame = saveBtn.bounds;
    gl.locations = @[@(0),@(1.0f)];
    [saveBtn.layer insertSublayer:gl atIndex:0];
    
}

#pragma tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 5;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *IdStr = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
    EditBusinessCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdStr];
    NSDictionary *attrs = @{NSForegroundColorAttributeName: UIColorFromRGB(0xCCCCCC), NSFontAttributeName: RFONT(15)};
    if (!cell) {
        cell = [[EditBusinessCardTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IdStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        NSArray *titlesArr = @[@"头像：", @"姓名："];
        cell.nameLabel.text = titlesArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.headerIV.hidden = NO;
            cell.holderIV.hidden = NO;
            cell.tipLabel.hidden = NO;
            self.headerIV = cell.headerIV;
            if (self.cardModel.headPhoto.length > 0) {
                cell.holderIV.hidden = YES;
                [cell.headerIV sd_setImageWithURL:[NSURL URLWithString:self.cardModel.headPhoto]];
            }
        } else {
            cell.rightLabel.hidden = NO;
            cell.rightLabel.text = self.cardModel.name;
        }
    } else if (indexPath.section == 1) {
        NSArray *titlsArr = @[@"手机", @"微信", @"邮箱", @"所在区域", @"地址"];
        cell.nameLabel.text = titlsArr[indexPath.row];
        
        if (indexPath.row == 0) {
            cell.rightLabel.hidden = NO;
            cell.rightLabel.text = self.cardModel.phone;
        } else if (indexPath.row == 1) {
            cell.rightTF.hidden = NO;
            cell.rightTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请填写微信号" attributes:attrs];
            cell.rightTF.text = self.cardModel.weChat;
            self.wechatTF = cell.rightTF;
        } else if (indexPath.row == 2) {
            cell.rightTF.hidden = NO;
            cell.rightTF.text = [HYAesUtil aesDecrypt:self.cardModel.emailEncrypt];
            cell.rightTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请填写邮箱地址" attributes:attrs];
            self.emailTF = cell.rightTF;
//            self.email = [HYAesUtil aesDecrypt:self.cardModel.emailEncrypt];
//            self.emailTF.delegate = self;
        } else if (indexPath.row == 3) {
            cell.rightTF.hidden = NO;
            cell.rightTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请选择所在省份城市 >" attributes:attrs];
            cell.rightTF.userInteractionEnabled = NO;
            cell.rightTF.text = self.cardModel.areaName;
        } else if (indexPath.row == 4) {
            cell.rightTF.hidden = NO;
            cell.rightTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请填写街道地址" attributes:attrs];
            cell.rightTF.text = self.cardModel.address;
            self.addressTF = cell.rightTF;
        }
    } else {
        NSArray *titlesArr = @[@"公司", @"职位", @"行业"];
        NSArray *holderArr = @[@"请填写公司名称", @"请填写您的职位", @""];
        cell.nameLabel.text = titlesArr[indexPath.row];
        cell.rightTF.hidden = NO;
        cell.rightTF.placeholder = holderArr[indexPath.row];
        if (indexPath.row == 0) {
            cell.rightTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请填写公司名称" attributes:attrs];
            cell.rightTF.text = self.cardModel.companyName;
            self.companyTF = cell.rightTF;
        } else if (indexPath.row == 1) {
            cell.rightTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请填写您的职位" attributes:attrs];
            cell.rightTF.text = self.cardModel.duty;
            self.jobTF = cell.rightTF;
        } else if (indexPath.row == 2) {
            cell.rightTF.placeholder = @"请选择所在的行业 >";
            cell.rightTF.userInteractionEnabled = NO;
            cell.rightTF.text = self.cardModel.industryName;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) { // 选择头像
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择上传方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                self.imagePicker = [[UIImagePickerController alloc]init];
                self.imagePicker.delegate = self;
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                self.imagePicker.allowsEditing = YES;
                [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
                
            }];
            UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                self.imagePicker = [[UIImagePickerController alloc]init];
                self.imagePicker.delegate = self;
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                self.imagePicker.allowsEditing = YES;
                [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
                
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
            [alertVC addAction:libraryAction];
            [alertVC addAction:takePhotoAction];
            [alertVC addAction:cancelAction];
            [self presentViewController:alertVC animated:YES completion:nil];
            
        }
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 3) { // 选择城市
            
            ChooseCityView *cityView = [[ChooseCityView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            cityView.delegate = self;
            if (@available(iOS 13.0,*)) {
                [[UIApplication sharedApplication].windows[0] addSubview:cityView];
            }else {
                [[UIApplication sharedApplication].keyWindow addSubview:cityView];
            }
            
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 2) { // 选择行业
            ChooseIndusreyViewController *industryVC = [[ChooseIndusreyViewController alloc]init];
            industryVC.delegate = self;
            [self.navigationController pushViewController:industryVC animated:YES];
//            [HttpRequest postPath:@"/phone/v1/card/initIndustryNew" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
//                SLog(@" 行业列表== %@ ",responseObject);
//                if ([responseObject[@"code"] intValue] == 200) {
//
////                    self.industryArr = [IndustryChooseModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
////                    IndustryChooseView *chooseView = [[IndustryChooseView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
////                    chooseView.industryArr = self.industryArr;
////                    chooseView.delegate = self;
////                    [[UIApplication sharedApplication].windows.firstObject addSubview:chooseView];
//                }
//            }];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 110;
    }
    return 55;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = UIColorFromRGB(0x333333);
    nameLabel.font = RFONT(15);
    NSArray *namesArr = @[@"个人信息",@"联系信息",@"公司信息"];
    nameLabel.text = namesArr[section];
    [headerView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(16);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 55;
    
}

#pragma UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    // 上传图片
    
    [HttpRequest postPath:@"/phone/v2/file/uploadBatch" params:nil formDataBlock:^(id  _Nullable formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"files" fileName:fileName mimeType:@"image/png"];
        
    } resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 图片上传 == %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.cardModel.headPhoto = responseObject[@"data"][0];
            [self.headerIV sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][0]]];
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma IndustryChooseDelegate
- (void)chooseIndustryWithName:(NSString *)industryName andIndustryID:(NSString *)industryID {
    
    self.cardModel.industryName = industryName;
    self.cardModel.industryId = industryID;
    [self.tableView reloadData];
    
}

#pragma ChooseCityDelegate
- (void)chooseCityWithName:(NSString *)city withCode:(NSString *)code {
    
    self.cardModel.areaName = city;
    self.cardModel.areaId = code;
    [self.tableView reloadData];
    
}

//#pragma UITextfieldDelegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//
//    if (textField == self.emailTF) {
//        textField.text = [HYAesUtil aesDecrypt:self.cardModel.emailEncrypt];
//    }
//    return YES;
//
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//
//    if (textField == self.emailTF) {
//        self.email = textField.text;
//        textField.text = self.cardModel.email;
//    }
//    return YES;
//
//}

// 保存
- (void)saveClicked {
    
    
    
    if (self.emailTF.text.length > 0 && [self validateEmail:self.emailTF.text] == NO) {
        [SVProgressHUD showWithStatus:@"请输入正确的邮箱"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    [HttpRequest postHttpBody:@"/phone/v2/card/editMyCard" params:@{@"uuid":self.cardModel.uuid,@"address":self.addressTF.text,@"companyName":self.companyTF.text,@"duty":self.jobTF.text,@"email":self.emailTF.text,@"headPhoto":self.cardModel.headPhoto,@"weChat":self.wechatTF.text,@"areaName":self.cardModel.areaName,@"areaId":self.cardModel.areaId,@"industryName":self.cardModel.industryName,@"industryId":self.cardModel.industryId} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 名片编辑== %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(editCardReload)]) {
                    [self.delegate editCardReload];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    
}

- (BOOL)validateEmail:(NSString *)email {
      NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
      NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
      return [emailTest evaluateWithObject:email];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 48;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
    
}

- (NSMutableArray *)industryArr {
    
    if (!_industryArr) {
        _industryArr = [NSMutableArray array];
    }
    return _industryArr;
    
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
