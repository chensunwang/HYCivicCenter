//
//  AddHonorViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AddHonorDelegate <NSObject>

- (void)addHonor;

@end

@interface AddHonorViewController : UIViewController

@property (nonatomic, weak) id <AddHonorDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
