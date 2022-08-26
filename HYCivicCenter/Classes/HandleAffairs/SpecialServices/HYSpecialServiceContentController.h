//
//  HYSpecialServiceContentController.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/14.
//

#import <UIKit/UIKit.h>
#import "HYServiceContentTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYSpecialServiceContentController : UIViewController

@property (nonatomic, strong) HYServiceContentModel *contentModel;
@property (nonatomic, assign) BOOL isEnterprise; // true 企业  false 个人

@end

NS_ASSUME_NONNULL_END
