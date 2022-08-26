//
//  HYDepartDetailViewController.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYDepartDetailViewController : UIViewController

@property (nonatomic, copy) NSString * orgName;
@property (nonatomic, assign) BOOL isEnterprise; // true 企业  false 个人
@property (nonatomic, strong) UIColor *hyTitleColor;


@end

NS_ASSUME_NONNULL_END
