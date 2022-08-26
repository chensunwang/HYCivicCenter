//
//  HYBaseInfoTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2022/1/12.
//

#import <UIKit/UIKit.h>
#import "HYFormInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYBaseInfoTableViewCellBlock)(NSString *text);

@interface HYBaseInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * rightLabel;
@property (nonatomic, strong) UITextField * rightTF;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, copy) HYBaseInfoTableViewCellBlock baseInfoTableViewCellBlock;

@end


typedef void(^HYRadioFormTableViewCellBlock)(NSString *text);

@interface HYRadioFormTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) HYFormInfoModel * infoModel;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, copy) HYRadioFormTableViewCellBlock radioFormTableViewCellBlock;

@end


typedef void(^HYBaseInfoTextFieldCellBlock)(NSString *text);

@interface HYBaseInfoTextFieldCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, copy) HYBaseInfoTextFieldCellBlock baseInfoTextFieldCellBlock;

@end

NS_ASSUME_NONNULL_END
