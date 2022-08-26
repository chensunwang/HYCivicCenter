//
//  HYSpecialServiceViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYSpecialServiceViewController : UIViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *headerArr;
@property (nonatomic, assign) BOOL isEnterprise; // true 企业  false 个人

@end

NS_ASSUME_NONNULL_END
