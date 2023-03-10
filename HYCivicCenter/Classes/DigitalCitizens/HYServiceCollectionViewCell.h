//
//  HYServiceCollectionViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/11/23.
//

#import <UIKit/UIKit.h>
#import "HYServiceClassifyModel.h"
#import "HYHotServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYServiceCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) HYServiceClassifyModel *classifyModel;

@property (nonatomic, strong) HYHotServiceModel * model;

@end

NS_ASSUME_NONNULL_END
