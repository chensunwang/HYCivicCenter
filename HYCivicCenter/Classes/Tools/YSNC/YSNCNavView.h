//
//  AppDelegate.h
//  iNC-iOS
//
//  Created by yz on 2022/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YSNCNavView : UIView
//背景
@property (nonatomic, strong) UIView *headView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//副标题
@property (nonatomic, strong) UILabel *subTitleLabel;
//返回按钮
@property (nonatomic, strong) UIButton *backBtn;
//底部线条
@property (nonatomic, strong) UIView *lineView;
@end

NS_ASSUME_NONNULL_END
