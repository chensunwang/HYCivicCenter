//
//  AppDelegate.h
//  iNC-iOS
//
//  Created by yz on 2022/7/7.
//

#import <UIKit/UIKit.h>
#import "YSNCNavView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YSNCViewController : UIViewController
@property (nonatomic, strong) YSNCNavView *navView;
-(void)actBack;
@end

NS_ASSUME_NONNULL_END
