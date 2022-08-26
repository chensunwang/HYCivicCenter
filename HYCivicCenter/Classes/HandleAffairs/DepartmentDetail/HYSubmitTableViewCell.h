//
//  HYSubmitTableViewCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYSubmitTableViewCellBlock)(void);

@interface HYSubmitTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, copy) HYSubmitTableViewCellBlock submitTableViewCellBlock;

@end

NS_ASSUME_NONNULL_END
