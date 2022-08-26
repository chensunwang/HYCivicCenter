//
//  HYLegalAidTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExpandModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray *datasArr;

@end

@interface HYLegalAidTableViewCell : UITableViewCell

@property (nonatomic, strong) ExpandModel *expandModel;

@end

NS_ASSUME_NONNULL_END
