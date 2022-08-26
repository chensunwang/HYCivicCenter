//
//  HYSearchServiceTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/11/22.
//

#import <UIKit/UIKit.h>
#import "HYSearchServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYSearchServiceTableViewCell : UITableViewCell

@property (nonatomic, strong) HYSearchServiceModel *model;
@property (nonatomic, strong) UILabel *mustLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UITextField *contentTF;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) void (^saveData)(NSString *text);

@end

NS_ASSUME_NONNULL_END
