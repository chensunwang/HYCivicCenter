//
//  HYSpecialServiceCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYSpecialServiceCellBlock)(NSInteger index);

@interface HYSpecialServiceCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray * specialArray;
@property (nonatomic, strong) NSMutableArray * departmentArray;
@property (nonatomic, strong) NSMutableArray * countyArray;
@property (nonatomic, strong) UIViewController * viewController;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, assign) BOOL isEnterprise; // true 企业  false 个人

@property (nonatomic, copy) HYSpecialServiceCellBlock specialServiceCellBlock;

@end

NS_ASSUME_NONNULL_END
