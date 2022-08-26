//
//  BusinessCardTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessCardModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *duty;
@property (nonatomic, copy) NSString *headPhoto;
@property (nonatomic, copy) NSString *nameFirstSpell;
@property (nonatomic, copy) NSString *uuid;

@end

@interface BusinessCardTableViewCell : UITableViewCell

@property (nonatomic, strong) BusinessCardModel *model;

@end

NS_ASSUME_NONNULL_END
