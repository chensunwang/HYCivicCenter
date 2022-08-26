//
//  CardDetailTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/20.
//

#import <UIKit/UIKit.h>
#import "EditBusinessCardTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *callBtn;
@property (nonatomic, strong) UIButton *reproduceBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) EditBusinessCardModel *cardModel;

@end

NS_ASSUME_NONNULL_END
