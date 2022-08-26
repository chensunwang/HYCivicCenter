//
//  CardDetailViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CardDeleteDelegate <NSObject>

- (void)cardReload;

@end

@interface CardDetailViewController : UIViewController

@property (nonatomic, copy) NSString *cardID;
@property (nonatomic, weak) id<CardDeleteDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
