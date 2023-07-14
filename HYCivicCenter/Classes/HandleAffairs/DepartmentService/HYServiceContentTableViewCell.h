//
//  HYServiceContentTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYServiceContentModel : NSObject  // 专项服务模型

@property (nonatomic, copy) NSString *createBy;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *delFlg;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *littleName;
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *searchValue;
@property (nonatomic, copy) NSString *specialName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updateBy;
@property (nonatomic, copy) NSString *updateTime;

@end

@interface HYDepartmentCountryModel : NSObject  // 部门服务/县区服务模型

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *orgCode;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *title;


@end

@interface HYServiceContentTableViewCell : UITableViewCell

@property (nonatomic, strong) HYServiceContentModel *specialModel;
@property (nonatomic, strong) HYDepartmentCountryModel *departmentModel;

@end

NS_ASSUME_NONNULL_END
