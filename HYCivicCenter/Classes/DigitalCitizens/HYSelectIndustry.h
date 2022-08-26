//
//  HYSelectIndustry.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HYSelectIndustryDelegate <NSObject>

- (void)serviceSelectValue:(NSString *)selectValue selectCode:(NSString *)selectCode;

@end

@interface HYSelectIndustry : UIView

@property (nonatomic, strong) NSArray *datasArr;
@property (nonatomic, weak) id <HYSelectIndustryDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
