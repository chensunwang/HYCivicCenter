//
//  DigitalTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DigitalTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subNameLabel;
@property (nonatomic, strong) UIView *lineView;

@end

NS_ASSUME_NONNULL_END
