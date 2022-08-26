//
//  IndustryChooseCollectionViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IndustryChooseModel : NSObject

@property (nonatomic, copy) NSString *dictCode;
@property (nonatomic, copy) NSString *dictLabel;
@property (nonatomic, copy) NSString *dictValue;

@end

@interface IndustryChooseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) IndustryChooseModel *model;

@end

NS_ASSUME_NONNULL_END
