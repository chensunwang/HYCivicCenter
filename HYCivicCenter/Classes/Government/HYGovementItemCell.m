//
//  HYGovementItemCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/21.
//

#import "HYGovementItemCell.h"
#import "HYGovItemCollectionViewCell.h"
#import "HYAreaServiceViewController.h"
#import "HYDepartDetailViewController.h"
#import "HYCivicCenterCommand.h"

@interface HYGovementItemCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HYGovementItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    self.headerView = [[UIView alloc] init];
    self.leftButton = [[UIButton alloc] init];
    self.rightButton = [[UIButton alloc] init];
    self.leftLineView = [[UIView alloc] init];
    self.rightLineView = [[UIView alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 32 - 8)*0.5, 146);
    flowLayout.minimumLineSpacing = 8;
    flowLayout.minimumInteritemSpacing = 8;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    [self.contentView addSubview:self.headerView];
    [self.headerView addSubview:_leftButton];
    [self.headerView addSubview:_rightButton];
    [self.headerView addSubview:_leftLineView];
    [self.headerView addSubview:_rightLineView];
    [self.contentView addSubview:_collectionView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(49);
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.headerView);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.5);
    }];
    self.leftButton.selected = YES;
    self.leftButton.titleLabel.font = MFONT(15);
    [self.leftButton setTitle:@"市直单位" forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self.leftButton);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(3);
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.headerView);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 0.5);
    }];
    self.rightButton.titleLabel.font = MFONT(15);
    [self.rightButton setTitle:@"区县单位" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self.rightButton);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(3);
    }];
    self.rightLineView.hidden = YES;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(49 + 16, 16, 0, 16));
    }];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerClass:[HYGovItemCollectionViewCell class] forCellWithReuseIdentifier:@"HYGovItemCollectionViewCell"];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColorFromRGB(0xEBEFF5);
    self.headerView.backgroundColor = UIColor.whiteColor;
    [self.leftButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [self.leftButton setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateSelected];
    self.leftLineView.backgroundColor = UIColorFromRGB(0x157AFF);
    [self.rightButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [self.rightButton setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateSelected];
    self.rightLineView.backgroundColor = UIColorFromRGB(0x157AFF);
    self.collectionView.backgroundColor = UIColorFromRGB(0xEBEFF5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)btnClicked:(UIButton *)sender {
    for (UIView *view in _headerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.selected = NO;
        }
    }
    sender.selected = YES;
    
    if ([sender.titleLabel.text isEqualToString:@"市直单位"]) {
        self.leftLineView.hidden = NO;
        self.rightLineView.hidden = YES;
        self.type = 0;
    } else {
        self.leftLineView.hidden = YES;
        self.rightLineView.hidden = NO;
        self.type = 1;
    }
    if (self.govementItemCellBlock) {
        self.govementItemCellBlock(_type);
    }
    [self.collectionView reloadData];
}

- (void)setDeparmentServiceArr:(NSMutableArray *)deparmentServiceArr {
    if (deparmentServiceArr) {
        _deparmentServiceArr = deparmentServiceArr;
        [self.collectionView reloadData];
    }
}

- (void)setCountyServiceArr:(NSMutableArray *)countyServiceArr {
    if (countyServiceArr) {
        _countyServiceArr = countyServiceArr;
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _type == 0 ? _deparmentServiceArr.count : _countyServiceArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYGovItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HYGovItemCollectionViewCell" forIndexPath:indexPath];
    if (_type == 0) {
        cell.departmentModel = _deparmentServiceArr[indexPath.row];
    } else {
        cell.departmentModel = _countyServiceArr[indexPath.row];
    }
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 0) {
        HYDepartmentCountryModel *model = _deparmentServiceArr[indexPath.item];
        HYDepartDetailViewController * businessVC = [[HYDepartDetailViewController alloc] init];
        businessVC.orgName = model.title;
        businessVC.isEnterprise = _isEnterprise;
        businessVC.hyTitleColor = _hyTitleColor;
        [self.viewController.navigationController pushViewController:businessVC animated:YES];
    } else {
        HYDepartmentCountryModel *model = _countyServiceArr[indexPath.item];
        HYAreaServiceViewController *areaVC = [[HYAreaServiceViewController alloc] init];
        areaVC.titleString = model.title;
        areaVC.orgCode = model.orgCode;
        areaVC.isEnterprise = _isEnterprise;
        areaVC.hyTitleColor = _hyTitleColor;
        [self.viewController.navigationController pushViewController:areaVC animated:YES];
    }
}


@end
