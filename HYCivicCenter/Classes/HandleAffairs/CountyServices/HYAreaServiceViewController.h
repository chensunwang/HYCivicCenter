//
//  HYAreaServiceViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYAreaServiceViewController : UIViewController

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *orgCode;
@property (nonatomic, assign) BOOL isEnterprise;
@property (nonatomic, strong) UIColor *hyTitleColor;

@end

NS_ASSUME_NONNULL_END
