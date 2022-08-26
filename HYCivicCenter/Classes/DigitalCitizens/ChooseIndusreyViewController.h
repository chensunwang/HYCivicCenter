//
//  ChooseIndusreyViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ChooseIndustryDelegate <NSObject>

- (void)chooseIndustryWithName:(NSString *)industryName andIndustryID:(NSString *)industryID;

@end

@interface ChooseIndusreyViewController : UIViewController

@property (nonatomic, weak) id <ChooseIndustryDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
