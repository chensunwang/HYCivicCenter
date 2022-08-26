//
//  HYHomeSearchViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYHomeSearchViewController : UIViewController

@property (nonatomic, copy) NSString * searchStr;
@property (nonatomic, copy) NSString *idCard;  // 身份证号 如果有则已实名认证 否则未实名认证
@property (nonatomic, strong) UIColor *hyTitleColor;
@property (nonatomic, assign) BOOL isEnterprise;

@end

NS_ASSUME_NONNULL_END
