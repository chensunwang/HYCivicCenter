//
//  HYDatePickerView.h
//  HelloFrame
//
//  Created by nuchina on 2021/11/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HYDatePickerDelegate <NSObject>

- (void)serviceDatePickerType:(NSInteger)type selectValue:(NSString *)dateStr;

@end

@interface HYDatePickerView : UIView

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, weak) id <HYDatePickerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
