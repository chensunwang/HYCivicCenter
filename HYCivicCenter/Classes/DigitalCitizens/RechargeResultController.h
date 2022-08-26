//
//  RechargeResultController.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RechargeDelegate <NSObject>

- (void)rechargeReload;

@end
@interface RechargeResultController : UIViewController

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, weak) id<RechargeDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
