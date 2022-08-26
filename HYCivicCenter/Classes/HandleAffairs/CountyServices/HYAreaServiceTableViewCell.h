//
//  HYAreaServiceTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYAreaServiceModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *orgCode;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *title;


@end

@interface HYAreaServiceTableViewCell : UITableViewCell

@property (nonatomic, strong) HYAreaServiceModel *areaModel;

@end

NS_ASSUME_NONNULL_END
