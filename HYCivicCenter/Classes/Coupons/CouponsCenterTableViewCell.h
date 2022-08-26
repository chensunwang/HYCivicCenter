//
//  CouponsCenterTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/5.
//

#import <UIKit/UIKit.h>
#import "HYCouponModel.h"
@class CouponsCenterTableViewCell;

NS_ASSUME_NONNULL_BEGIN

@protocol HYCouponDelegate <NSObject>

- (void)receiveCouponWithCell:(CouponsCenterTableViewCell *)cell withModel:(HYCouponModel *)model;

@end

@interface CouponsCenterTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HYCouponDelegate>delegate;
@property (nonatomic, strong) HYCouponModel *couponModel;

@end

NS_ASSUME_NONNULL_END
