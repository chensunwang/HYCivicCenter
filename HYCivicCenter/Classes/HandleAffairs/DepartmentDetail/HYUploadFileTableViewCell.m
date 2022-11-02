//
//  HYUploadFileTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2022/1/13.
//

#import "HYUploadFileTableViewCell.h"
#import "HYUploadImageCollectionViewCell.h"
#import "HYCivicCenterCommand.h"

@interface HYUploadFileTableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIButton * windowSubmitBtn;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) HYUploadedMaterailModel *uploadModel;

@end

NSString *uploadImageCell = @"imagecella";
@implementation HYUploadFileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = MFONT(14);
        self.nameLabel.numberOfLines = 0;
        [self.contentView addSubview:self.nameLabel];
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.flowLayout.minimumInteritemSpacing = 10;
        self.flowLayout.minimumLineSpacing = 10;
        self.flowLayout.itemSize = CGSizeMake(68, 68);
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:[HYUploadImageCollectionViewCell class] forCellWithReuseIdentifier:uploadImageCell];
        [self.contentView addSubview:self.collectionView];
        
        self.windowSubmitBtn = [[UIButton alloc] init];
        [self.contentView addSubview:self.windowSubmitBtn];
        self.windowSubmitBtn.layer.cornerRadius = 15;
        [self.windowSubmitBtn setTitle:@"窗口提交" forState:UIControlStateNormal];
        self.windowSubmitBtn.titleLabel.font = MFONT(12);
        [self.windowSubmitBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.lineView = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self traitCollectionDidChange:nil];
    }
    return self;
}

- (HYUploadedMaterailModel *)uploadModel {
    if (!_uploadModel) {
        _uploadModel = [[HYUploadedMaterailModel alloc] init];
    }
    return _uploadModel;
}

- (void)setModel:(HYMaterialModel *)model {
    if (model) {
        _model = model;
        if ([model.must isEqualToString:@"1"]) { // 必填项 添加*号
            NSString *htmlStr = [NSString stringWithFormat:@"<span style='color:red'>*</span>%@", model.name];
            NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            self.nameLabel.attributedText = attStr;
        } else {
            self.nameLabel.text = model.name;
        }
        self.nameLabel.font = MFONT(14);
        
        [self.dataArray removeAllObjects];
        
        self.uploadModel.docId = model.docId;
        self.uploadModel.documentId = model.materialId;
        self.uploadModel.documentName = model.name;
        self.uploadModel.fileName = model.fileName;
        self.uploadModel.url = model.autoUploadUrl;
        
        if (![model.autoUploadUrl isEqualToString:@""]) {
            [self.dataArray addObject:_uploadModel];
        }
        [self.collectionView reloadData];
    }
}

- (void)setModels:(NSMutableArray *)models {
    if (models) {
        _models = models;
//        [self.dataArray removeAllObjects];
//        [self.dataArray addObjectsFromArray:models];
        [self.collectionView reloadData];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(16);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 64 - 90);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    [self.windowSubmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.size.mas_equalTo(CGSizeMake(70, 30));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self);
    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = [UIColor whiteColor];
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.windowSubmitBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    [self.windowSubmitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.windowSubmitBtn setBackgroundColor:UIColorFromRGB(0xE5F1FF)];
    self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

- (void)btnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.windowSubmitBtn setBackgroundColor:UIColorFromRGB(0x157AFF)];
    } else {
        [self.windowSubmitBtn setBackgroundColor:UIColorFromRGB(0xE5F1FF)];
    }
    if (self.uploadFileTableViewCellBlock) {
        self.uploadFileTableViewCellBlock(nil, sender.selected);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYUploadImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:uploadImageCell forIndexPath:indexPath];
    if ((_dataArray.count == 0) || (indexPath.item == _dataArray.count)) {
        cell.deleteBtn.hidden = YES;
        cell.addBtn.hidden = NO;
        [cell.headerIV sd_setImageWithURL:[NSURL URLWithString:@""]];
    } else {
        cell.deleteBtn.hidden = NO;
        cell.addBtn.hidden = YES;
        HYUploadedMaterailModel *model = self.dataArray[indexPath.item];
        [cell.headerIV sd_setImageWithURL:[NSURL URLWithString:model.url]];
    }
    
    __weak typeof(self) weakSelf = self;
    cell.uploadImageCollectionViewCellBlock = ^(NSString * _Nonnull type) {
        if ([type isEqualToString:@"add"]) {  // 点击添加按钮
            [weakSelf showImagePicker];
        } else {  // 点击删除按钮
            [weakSelf.dataArray removeObjectAtIndex:indexPath.item];
            [weakSelf.collectionView reloadData];
            if (weakSelf.uploadFileTableViewCellBlock != nil) {
                weakSelf.uploadFileTableViewCellBlock(weakSelf.dataArray, nil);
            }
        }
    };
    return cell;
}

- (void)showImagePicker {
    if (@available(iOS 14, *)) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
        switch (status) {
            case PHAuthorizationStatusLimited:
                SLog(@"用户授权指定照片");
                break;
            case PHAuthorizationStatusDenied:
                SLog(@"用户禁止授权照片权限");
                [SVProgressHUD showErrorWithStatus:@"无法访问照片权限"];
                return;
            case PHAuthorizationStatusAuthorized:
                SLog(@"用户授权所有照片");
                break;
            case PHAuthorizationStatusNotDetermined:
                SLog(@"用户尚未选择");
                break;
            default:
                break;
        }
    } else {
        
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {  // 照片
        UIImage* editedImage =(UIImage *)[info objectForKey:UIImagePickerControllerEditedImage]; //取出编辑过的照片
        UIImage* originalImage =(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];//取出原生照片
        UIImage* imageToSave = nil;
        if(editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        __weak typeof(self) weakSelf = self;
        [HttpRequest postPathZWBS:@"phone/item/event/uploadDocFile" params:nil formDataBlock:^(id  _Nullable formData) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(imageToSave, 0.8) name:@"file" fileName:fileName mimeType:@"image/png"];
            
        } progress:^(NSProgress * _Nullable progress) {
            
        } resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            SLog(@" 图片上传 == %@ ",responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                HYUploadedMaterailModel *model = [HYUploadedMaterailModel mj_objectWithKeyValues:responseObject[@"data"]];
                [weakSelf.dataArray addObject:model];
                [weakSelf.collectionView reloadData];
                if (weakSelf.uploadFileTableViewCellBlock != nil) {
                    weakSelf.uploadFileTableViewCellBlock(weakSelf.dataArray, nil);
                }
            } else {
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }
        }];
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
