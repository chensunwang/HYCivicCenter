//
//  ChooseCityTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProvinceModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSMutableArray *city;

@end

@interface CityModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSMutableArray *area;

@end

@interface AreaModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;

@end

@interface ChooseCityTableViewCell : UITableViewCell

@property (nonatomic, strong) ProvinceModel *provinceModel;
@property (nonatomic, strong) CityModel *cityModel;
@property (nonatomic, strong) AreaModel *areaModel;

@end

NS_ASSUME_NONNULL_END
