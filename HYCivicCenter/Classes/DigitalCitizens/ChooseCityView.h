//
//  ChooseCityView.h
//  HelloFrame
//
//  Created by nuchina on 2021/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ChooseCityDelegate <NSObject>

- (void)chooseCityWithName:(NSString *)city withCode:(NSString *)code;

@end

@interface ChooseCityView : UIView

@property (nonatomic, weak) id <ChooseCityDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
