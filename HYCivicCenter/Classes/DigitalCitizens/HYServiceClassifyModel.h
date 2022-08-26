//
//  HYServiceClassifyModel.h
//  HelloFrame
//
//  Created by nuchina on 2021/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYServiceClassifyModel : NSObject

@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *parentName;
@property (nonatomic, copy) NSString *buttonName;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *backgroundUrl;

@end


NS_ASSUME_NONNULL_END
