//
//  IndustryChooseView.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/23.
//

#import "IndustryChooseView.h"
#import "IndustryChooseCollectionViewCell.h"
#import "HYCivicCenterCommand.h"
#import "UIView+YXAdd.h"

@interface IndustryChooseView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, copy) NSString *industry;
@property (nonatomic, copy) NSString *industryCode;


@end

NSString *const industryCell = @"industryCell";
@implementation IndustryChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backView = [[UIView alloc]init];
        self.backView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self.backView addGestureRecognizer:tap];
        self.backView.alpha = 0.5;
        [self addSubview:self.backView];
        
        self.contentView = [[UIView alloc]init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"选择行业";
        nameLabel.textColor = UIColorFromRGB(0x333333);
        nameLabel.font = RFONT(16);
        [self.contentView addSubview:nameLabel];
        
        [self.contentView addSubview:self.collectionView];
        [self.collectionView registerClass:[IndustryChooseCollectionViewCell class] forCellWithReuseIdentifier:industryCell];
        
        UIView *bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        
        UIButton *confirmBtn = [[UIButton alloc]init];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = RFONT(15);
        [confirmBtn setBackgroundColor:UIColorFromRGB(0x157AFF)];
        confirmBtn.layer.cornerRadius = 8;
        confirmBtn.clipsToBounds = YES;
        [confirmBtn addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:confirmBtn];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-kSafeAreaBottomHeight);
            make.height.mas_equalTo(70);
        }];
        
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 16, 10, 16));
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(bottomView.mas_top);
            make.height.mas_equalTo(400);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.top.equalTo(self.contentView.mas_top).offset(20);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.top.equalTo(nameLabel.mas_bottom).offset(20);
        }];
        
    }
    return self;
    
}

- (void)setIndustryArr:(NSArray *)industryArr {
    _industryArr = industryArr;
    
    [self.datasArr addObjectsFromArray:industryArr];
    [self.collectionView reloadData];
    
}

#pragma UIcollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datasArr.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IndustryChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:industryCell forIndexPath:indexPath];
    
    cell.model = self.datasArr[indexPath.row];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IndustryChooseModel *model = self.datasArr[indexPath.row];
    self.industry = model.dictLabel;
    self.industryCode = model.dictValue;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 16, 0, 16);
    
}

// 确定
- (void)confirmClicked {
    
    if ([self.delegate respondsToSelector:@selector(chooseIndustry:andIndustryCode:)]) {
        [self.delegate chooseIndustry:self.industry andIndustryCode:self.industryCode];
    }
    
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.collectionView.kTop = [UIScreen mainScreen].bounds.size.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
//        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
    
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 20;
        _flowLayout.minimumLineSpacing = 20;
        CGFloat itemW = ([UIScreen mainScreen].bounds.size.width - 32 - 40)/ 3.0;
        CGFloat itemH = 48;
        _flowLayout.itemSize = CGSizeMake(itemW, itemH);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
    
}

- (NSMutableArray *)datasArr {
    
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
    
}

@end
