//
//  HYFormInfoModel.h
//  HelloFrame
//
//  Created by nuchina on 2022/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYBaseInfoModel : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *sex;

@end

@interface HYFormInfoModel : NSObject

@property (nonatomic, copy) NSString *fieldId;
@property (nonatomic, copy) NSString *fieldName;
@property (nonatomic, copy) NSString *fieldKey;
@property (nonatomic, copy) NSString *fieldType;
@property (nonatomic, copy) NSString *fieldValue;
@property (nonatomic, copy) NSString *readOnly;
@property (nonatomic, copy) NSString *required;
@property (nonatomic, strong) NSArray *fieldValueList;

@end

NS_ASSUME_NONNULL_END
