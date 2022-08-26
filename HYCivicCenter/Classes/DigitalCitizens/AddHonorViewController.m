//
//  AddHonorViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/18.
//

#import "AddHonorViewController.h"
#import "AddHonorCollectionViewCell.h"

@interface AddHonorViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextView *contentTV;
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *photosArr;
@property (nonatomic, strong) NSMutableArray *selectAssets;
@property (nonatomic, weak) UIButton *publishBtn;

@end

NSString *const honorPhotoCell = @"honorCell";
@implementation AddHonorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.title = @"新增荣誉";
    [self configUI];
    
}

- (void)configUI {
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 8;
    contentView.clipsToBounds = YES;
    [self.view addSubview:contentView];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.textColor = UIColorFromRGB(0x333333);
    tipLabel.font = RFONT(16);
    tipLabel.text = @"请上传纸质荣誉或证照名称和图片（必填）";
    [contentView addSubview:tipLabel];
    
    UILabel *redTipLabel = [[UILabel alloc]init];
    redTipLabel.textColor = [UIColor redColor];
    redTipLabel.font = RFONT(12);
    redTipLabel.text = @"*纸质荣誉或证照图片尽量完整、清晰";
    [contentView addSubview:redTipLabel];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = RFONT(16);
    nameLabel.textColor = UIColorFromRGB(0x333333);
    nameLabel.text = @"名称";
    [contentView addSubview:nameLabel];
    
    self.nameTF = [[UITextField alloc]init];
    self.nameTF.placeholder = @"荣誉或证照名称";
    [contentView addSubview:self.nameTF];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0x666666);
    [contentView addSubview:lineView];
    
    self.contentTV = [[UITextView alloc]init];
    self.contentTV.layer.cornerRadius = 15;
    self.contentTV.clipsToBounds = YES;
    self.contentTV.layer.borderWidth = 0.5;
    self.contentTV.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    [contentView addSubview:self.contentTV];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[AddHonorCollectionViewCell class] forCellWithReuseIdentifier:honorPhotoCell];
    [contentView addSubview:self.collectionView];
    
    UILabel *bottomTipLabel = [[UILabel alloc]init];
    bottomTipLabel.textColor = UIColorFromRGB(0x666666);
    bottomTipLabel.font = RFONT(12);
    bottomTipLabel.text = @"(*图片最多上传三张，每张不超过2M)";
    [contentView addSubview:bottomTipLabel];
    
    UIButton *publishBtn = [[UIButton alloc]init];
    [publishBtn setTitle:@"确定" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    publishBtn.titleLabel.font = RFONT(16);
    publishBtn.layer.cornerRadius = 8;
    publishBtn.clipsToBounds = YES;
    [publishBtn setBackgroundColor:UIColorFromRGB(0x157AFF)];
    [publishBtn addTarget:self action:@selector(publishClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:publishBtn];
    self.publishBtn = publishBtn;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(16, 16, 16, 16));
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight + 16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-16);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.top.equalTo(contentView.mas_top).offset(16);
    }];
    
    [redTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.top.equalTo(tipLabel.mas_bottom).offset(5);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.top.equalTo(redTipLabel.mas_bottom).offset(16);
    }];
    
    [self.nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.height.mas_equalTo(48);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.top.equalTo(self.nameTF.mas_bottom);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.top.equalTo(lineView.mas_bottom).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.height.mas_equalTo(220);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.top.equalTo(self.contentTV.mas_bottom).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.height.mas_equalTo(120);
    }];
    
    [bottomTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.top.equalTo(self.collectionView.mas_bottom).offset(5);
    }];
    
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.top.equalTo(bottomTipLabel.mas_bottom).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.height.mas_equalTo(40);
    }];
    
    
    
}

- (void)publishClicked {
    
    if (self.nameTF.text.length == 0) {
        [SVProgressHUD showWithStatus:@"请填写荣誉或证照名称"];
        [SVProgressHUD dismissWithDelay:0.5];
        return;
    }else if (self.contentTV.text.length == 0) {
        [SVProgressHUD showWithStatus:@"请填写描述"];
        [SVProgressHUD dismissWithDelay:0.5];
        return;
    }else if (self.photosArr.count == 0) {
        [SVProgressHUD showWithStatus:@"请添加照片"];
        [SVProgressHUD dismissWithDelay:0.5];
        return;
    }else if (self.contentTV.text.length > 200) {
        [SVProgressHUD showWithStatus:@"超过最大长度200"];
        [SVProgressHUD dismissWithDelay:0.5];
        return;
    }
    self.publishBtn.userInteractionEnabled = NO;
    [HttpRequest postPath:@"/phone/v1/file/uploadBatch" params:@{} formDataBlock:^(id  _Nullable formData) {
        
        for (NSInteger i = 0;i < self.photosArr.count;i++) {
            UIImage *image = self.photosArr[i];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@-%@.png", str,[NSString stringWithFormat:@"%ld",(long)i]];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"files" fileName:fileName mimeType:@"image/png"];
        }
    } resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 图片上传== %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            NSArray *array = responseObject[@"data"];
            NSLog(@"数组 == %@",array[0]);
            
            NSDictionary *params;
            if (array.count == 1) {
                params = @{ @"honorName":self.nameTF.text,
                            @"honorRemark":self.contentTV.text,
                            @"honorPhotoOne":array[0]};
            }else if (array.count == 2) {
                params = @{ @"honorName":self.nameTF.text,
                            @"honorRemark":self.contentTV.text,
                            @"honorPhotoOne":array[0],
                            @"honorPhotoTwo":array[1]};
            }else if (array.count == 3) {
                params = @{ @"honorName":self.nameTF.text,
                            @"honorRemark":self.contentTV.text,
                            @"honorPhotoOne":array[0],
                            @"honorPhotoTwo":array[1],
                            @"honorPhotoThree":array[2]};
            }
            
            [HttpRequest postHttpBody:@"/phone/v1/honor/add" params:params resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
                NSLog(@" 新增荣誉== %@ ",responseObject);
                if ([responseObject[@"code"] intValue] == 200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.delegate && [self.delegate respondsToSelector:@selector(addHonor)]) {
                        [self.delegate addHonor];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD showWithStatus:responseObject[@"msg"]];
                    [SVProgressHUD dismissWithDelay:0.5];
                });
                }
                
            }];
            
        }else {
            
            self.publishBtn.userInteractionEnabled = YES;
            [SVProgressHUD showWithStatus:@"上传失败"];
            [SVProgressHUD dismissWithDelay:0.5];
            
        }
    }];
    
}

#pragma collectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.photosArr.count == 0) {
        return 1;
    }else if (self.photosArr.count < 3) {
        return self.photosArr.count + 1;
    }else {
        return 3;
    }
//    return MAX(1, self.photosArr.count);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100, 100);
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AddHonorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:honorPhotoCell forIndexPath:indexPath];
    
    if (self.photosArr.count == indexPath.row) {
        cell.addIV.hidden = NO;
        cell.addLabel.hidden = NO;
        cell.delBtn.hidden = YES;
        cell.contentIV.image = [UIImage imageNamed:@" "];
    }else {
        cell.addIV.hidden = YES;
        cell.addLabel.hidden = YES;
        cell.delBtn.hidden = NO;
        cell.contentIV.image = self.photosArr[indexPath.row];
    }
    cell.delBtn.tag = indexPath.row;
    [cell.delBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.photosArr.count) { // 选择图片
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择上传类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            TZImagePickerController *imagePicker = [[TZImagePickerController alloc]initWithMaxImagesCount:3 delegate:self];
            imagePicker.selectedAssets = self.selectAssets;
            imagePicker.allowPickingOriginalPhoto = NO;
            imagePicker.allowPickingVideo = NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:libraryAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
    }else { // 预览
        
            
        
    }
    
}

- (void)deleteBtnClicked:(UIButton *)button {
    
    [self.photosArr removeObjectAtIndex:button.tag];
    [self.selectAssets removeObjectAtIndex:button.tag];
    
    [self.collectionView reloadData];
//    [self.collectionView performBatchUpdates:^{
//        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:button.tag inSection:0];
//        [self.collectionView deleteItemsAtIndexPaths:@[indexpath]];
//    } completion:^(BOOL finished) {
//        [self.collectionView reloadData];
//    }];
    
}

#pragma TZiamagepicker
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    XFLog(@" 选择了图片== %@ ",photos);
    // photos
    self.selectAssets = [NSMutableArray arrayWithArray:assets];
//    if (photos.count) {
//        for (__strong UIImage *image in photos) {
////            image = [image scaleToSize:image.size];
//            NSData *data = UIImageJPEGRepresentation(image, 0.8);
//            image = [UIImage imageWithData:data];
//            [self.photosArr addObject:image];
//        }
//    }
    self.photosArr = [NSMutableArray arrayWithArray:photos];
    [self.collectionView reloadData];
    
}

- (NSMutableArray *)photosArr {
    
    if (!_photosArr) {
        _photosArr = [NSMutableArray array];
    }
    return _photosArr;
    
}

- (NSMutableArray *)selectAssets {
    
    if (!_selectAssets) {
        _selectAssets = [NSMutableArray array];
    }
    return _selectAssets;
    
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
