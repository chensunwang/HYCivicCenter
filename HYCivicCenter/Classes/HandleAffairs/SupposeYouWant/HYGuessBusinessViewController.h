//
//  HYGuessBusinessViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYGuessBusinessViewController : UIViewController

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, assign) BOOL isEnterprise;  // true 企业  false 个人

@end

NS_ASSUME_NONNULL_END
