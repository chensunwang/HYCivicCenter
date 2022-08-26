//
//  HYGuessYouCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYGuessYouCellBlock)(NSInteger index);

@interface HYGuessYouCell : UITableViewCell

@property (nonatomic, copy) HYGuessYouCellBlock guessYouCellBlock;

@end

NS_ASSUME_NONNULL_END
