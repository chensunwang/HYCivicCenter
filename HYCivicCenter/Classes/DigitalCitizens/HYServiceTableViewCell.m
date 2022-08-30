//
//  HYServiceTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/24.
//

#import "HYServiceTableViewCell.h"
#import "HYServiceCollectionViewCell.h"
#import "MyBusinessCardController.h"
#import "HonorWallViewController.h"
#import "HYGovServiceViewController.h"
#import "HYBusinessServiceViewController.h"
#import "HYSocialServiceViewController.h"
#import "HYObtainCertiViewController.h"
#import "HYSearchServiceViewController.h"
#import "HYCivicCenterCommand.h"

@interface HYServiceTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

NSString *serviceCollectionCell = @"serviceCell";
@implementation HYServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        self.containView = [[UIView alloc]init];
        self.containView.backgroundColor = [UIColor whiteColor];
        self.containView.layer.cornerRadius = 8;
        self.containView.clipsToBounds = YES;
        [self.contentView addSubview:self.containView];
        
        [self.containView addSubview:self.collectionView];
        [self.collectionView registerClass:[HYServiceCollectionViewCell class] forCellWithReuseIdentifier:serviceCollectionCell];
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

//- (void)setIndexpath:(NSIndexPath *)indexpath {
//    _indexpath = indexpath;
//
//
//
//}

- (void)setDatasArr:(NSArray *)datasArr {
    _datasArr = datasArr;
    
    [self.collectionView reloadData];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datasArr.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HYServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:serviceCollectionCell forIndexPath:indexPath];
    
    cell.classifyModel = self.datasArr[indexPath.row];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 32) / 2.0;
    return CGSizeMake(width, 80);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.indexpath.section == 0) { // 个人名片 荣誉墙
        
        if (indexPath.row == 0) {
            
            MyBusinessCardController *businessVC = [[MyBusinessCardController alloc]init];
            [[self viewController].navigationController pushViewController:businessVC animated:YES];
            
        }else if (indexPath.row == 1) {
            
            HonorWallViewController *honorVC = [[HonorWallViewController alloc]init];
            [[self viewController].navigationController pushViewController:honorVC animated:YES];
            
        }
        
    }else if (self.indexpath.section == 1) {
        
        HYServiceClassifyModel *classifyModel = self.datasArr[indexPath.row];
        MainApi *api = [MainApi sharedInstance];
        
        if (api.isFirst == NO) {
            
            HYSearchServiceViewController *govSerViceVC = [[HYSearchServiceViewController alloc]init];
            govSerViceVC.serviceID = classifyModel.id;
            govSerViceVC.serviceName = classifyModel.serviceName;
            [[self viewController].navigationController pushViewController:govSerViceVC animated:YES];
            
        }else {
            
            if (indexPath.row == 0) {
                
                HYGovServiceViewController *businessVC = [[HYGovServiceViewController alloc]init];
                businessVC.serviceID = classifyModel.id;
                businessVC.serviceName = classifyModel.serviceName;
                [[self viewController].navigationController pushViewController:businessVC animated:YES];
                
            }else if (indexPath.row == 1) {
                
                HYBusinessServiceViewController *govServiceVC = [[HYBusinessServiceViewController alloc]init];
                govServiceVC.serviceID = classifyModel.id;
                govServiceVC.serviceName = classifyModel.serviceName;
                [[self viewController].navigationController pushViewController:govServiceVC animated:YES];
                
            }else if (indexPath.row == 2) {
                
                HYBusinessServiceViewController *socialVC = [[HYBusinessServiceViewController alloc]init];
                socialVC.serviceID = classifyModel.id;
                socialVC.serviceName = classifyModel.serviceName;
                [[self viewController].navigationController pushViewController:socialVC animated:YES];
                
            }else if (indexPath.row == 3) {
                
                HYObtainCertiViewController *obtainVC = [[HYObtainCertiViewController alloc]init];
                obtainVC.serviceID = classifyModel.id;
                obtainVC.serviceName = classifyModel.serviceName;
                [[self viewController].navigationController pushViewController:obtainVC animated:YES];
                
            }
            
        }
        
    }
    
}

- (UIViewController *)viewController {

    for (UIView* next = [self superview]; next; next = next.superview) {

        UIResponder *nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }

    return nil;

}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
    
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
    
}

@end
