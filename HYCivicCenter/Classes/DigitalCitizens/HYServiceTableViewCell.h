//
//  HYServiceTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYServiceTableViewCellBlock)(NSInteger index);

@interface HYServiceTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *myArr;
@property (nonatomic, strong) NSArray *datasArr;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) HYServiceTableViewCellBlock serviceTableViewCellBlock;

@end

NS_ASSUME_NONNULL_END
