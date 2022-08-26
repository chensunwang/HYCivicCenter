//
//  HYUploadImageCollectionViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2022/1/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYUploadImageCollectionViewCellBlock)(NSString *type);

@interface HYUploadImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * headerIV;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) UIButton * addBtn;
@property (nonatomic, copy) HYUploadImageCollectionViewCellBlock uploadImageCollectionViewCellBlock;

@end

NS_ASSUME_NONNULL_END
