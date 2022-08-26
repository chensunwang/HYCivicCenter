//
//  HYGoveHeaderView.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/14.
//

#import <UIKit/UIKit.h>
#import "HYSearchView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HYGoveHeaderViewBlock)(NSInteger index);

@interface HYGoveHeaderView : UIView

@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) HYSearchView * searchView;
@property (nonatomic, strong) UIButton * moreButton;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy) HYGoveHeaderViewBlock goveHeaderViewBlock;

@end

NS_ASSUME_NONNULL_END
