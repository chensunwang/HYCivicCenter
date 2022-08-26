//
//  HYServiceSelectView.h
//  HelloFrame
//
//  Created by nuchina on 2021/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HYSelectServiceDelegate <NSObject>

- (void)serviceSelectType:(NSInteger)type selectValue:(NSString *)value selectCode:(NSString *)code;

@end

@interface HYServiceSelectView : UIView

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray *datasArr;
@property (nonatomic, weak) id <HYSelectServiceDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
