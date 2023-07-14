//
//  HYPopularServicesCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYPopularServicesCellBlock)(NSInteger index);

@interface HYPopularServicesCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, copy) HYPopularServicesCellBlock popularQueriesCellBlock;

@end

NS_ASSUME_NONNULL_END
