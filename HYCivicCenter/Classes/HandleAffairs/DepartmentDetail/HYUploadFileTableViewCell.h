//
//  HYUploadFileTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2022/1/13.
//

#import <UIKit/UIKit.h>
#import "HYItemTotalInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYUploadFileTableViewCellBlock)(NSArray * _Nullable models, BOOL isWindow);

@interface HYUploadFileTableViewCell : UITableViewCell

@property (nonatomic, strong) HYMaterialModel * model;
@property (nonatomic, strong) UIViewController * viewController;
@property (nonatomic, copy) HYUploadFileTableViewCellBlock uploadFileTableViewCellBlock;
@property (nonatomic, strong) NSMutableArray * models;

@end

NS_ASSUME_NONNULL_END
