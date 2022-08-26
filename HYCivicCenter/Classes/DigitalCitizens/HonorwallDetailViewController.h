//
//  HonorwallDetailViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HonorDetailDeleteDelegate <NSObject>

- (void)deleteHonorDetail;

@end

@interface HonorwallDetailViewController : UIViewController

@property (nonatomic, copy) NSString *honorId;
@property (nonatomic, weak) id <HonorDetailDeleteDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
