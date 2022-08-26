//
//  HYPopularQueriesCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//
//  热门查询cell

#import "HYPopularQueriesCell.h"
#import "HYPQCollectionViewCell.h"

@interface HYPopularQueriesCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HYPopularQueriesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    if (dataArray) {
        _dataArray = dataArray;
        [self.collectionView reloadData];
    }
}

- (void)setupUI {
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.bgView = [[UIView alloc] init];
    self.titleLab = [[UILabel alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLab];
    [self.bgView addSubview:self.collectionView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(18, 10, 10, 10));
    }];
    self.bgView.layer.cornerRadius = 10;
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.height.mas_equalTo(17);
    }];
    self.titleLab.text = @"热门服务";
    self.titleLab.font = MFONT(17);
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(self.titleLab.mas_bottom);
        make.right.bottom.equalTo(self.bgView).offset(-10);
    }];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[HYPQCollectionViewCell class] forCellWithReuseIdentifier:@"HYPQCollectionViewCell"];
    self.collectionView.scrollEnabled = NO;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColorFromRGB(0xEBEFF5);
    self.bgView.backgroundColor = UIColor.whiteColor;
    self.titleLab.textColor = UIColorFromRGB(0x1E2023);
    self.collectionView.backgroundColor = UIColor.whiteColor;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYPQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HYPQCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.popularQueriesCellBlock) {
        self.popularQueriesCellBlock(indexPath.item);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH * 0.25 - 28, 80);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

@end
