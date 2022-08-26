//
//  HYGovernmentCell.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYGovernmentCell : UITableViewCell

@property (nonatomic, strong) UIViewController * viewController;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, assign) BOOL isEnterprise;  // true 企业  false 个人
@property (nonatomic, assign) BOOL isLogin;

@end

NS_ASSUME_NONNULL_END
