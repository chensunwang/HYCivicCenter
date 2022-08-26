//
//  HYPopularQueriesCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYPopularQueriesCellBlock)(NSInteger index);

@interface HYPopularQueriesCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, copy) HYPopularQueriesCellBlock popularQueriesCellBlock;

@end

NS_ASSUME_NONNULL_END
