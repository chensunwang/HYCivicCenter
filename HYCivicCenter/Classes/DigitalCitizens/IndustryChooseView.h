//
//  IndustryChooseView.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IndustryChooseDelegate <NSObject>

- (void)chooseIndustry:(NSString *)industry andIndustryCode:(NSString *)industryCode;

@end

@interface IndustryChooseView : UIView

@property (nonatomic, weak) id <IndustryChooseDelegate> delegate;
@property (nonatomic, strong) NSArray *industryArr;

@end

NS_ASSUME_NONNULL_END
