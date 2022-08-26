//
//  ReceiceCardViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GetQRCodeDelegate <NSObject>

- (void)getBusQrcode;

@end

@interface ReceiceCardViewController : UIViewController

@property (nonatomic, weak) id <GetQRCodeDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
