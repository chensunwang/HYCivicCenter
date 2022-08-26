//
//  HYDepartDetailHotCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/7.
//

#import "HYDepartDetailHotCell.h"
#import "HYDDCollectionViewCell.h"
#import "HYHandleAffairsWebVIewController.h"
#import "HYOnLineBusinessMainViewController.h"

@interface HYDepartDetailHotCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView * verticalView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation HYDepartDetailHotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    if (dataArray) {
        _dataArray = dataArray;
        [self.collectionView reloadData];
    }
}

- (void)setupUI {
    _verticalView = [[UIView alloc] init];
    _titleLabel = [[UILabel alloc] init];
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.contentView addSubview:_verticalView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_collectionView];
    
    [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalView.mas_right).offset(7);
        make.centerY.equalTo(self.verticalView);
        make.height.mas_equalTo(15);
    }];
    self.titleLabel.text = @"热门办事";
    self.titleLabel.font = MFONT(15);
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.bottom.equalTo(self).offset(-10);
    }];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HYDDCollectionViewCell class] forCellWithReuseIdentifier:@"HYDDCollectionViewCell"];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColor.whiteColor;
    self.verticalView.backgroundColor = UIColorFromRGB(0x157AFF);
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.collectionView.backgroundColor = UIColor.whiteColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYDDCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HYDDCollectionViewCell" forIndexPath:indexPath];
    cell.hotModel = self.dataArray[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 后台说这里返回的全是本地的页面 不需要判断外链的情况
    HYOnLineBusinessMainViewController * mainVC = [[HYOnLineBusinessMainViewController alloc] init];
    mainVC.affairsModel = self.dataArray[indexPath.item];
    mainVC.hyTitleColor = _hyTitleColor;
    [self.viewController.navigationController pushViewController:mainVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 134)/3, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

@end
