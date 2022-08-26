//
//  EditBusinessCardViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EditDelegate <NSObject>

- (void)editCardReload;

@end

@interface EditBusinessCardViewController : UIViewController

@property (nonatomic, weak) id <EditDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
