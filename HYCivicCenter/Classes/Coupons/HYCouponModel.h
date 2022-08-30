//
//  HYCouponModel.h
//  SZSMFramework
//
//  Created by nuchina on 2021/9/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYCouponModel : NSObject

@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, copy) NSString *businessName;
@property (nonatomic, copy) NSString *couponTypeName;
@property (nonatomic, copy) NSString *expiresTime;
@property (nonatomic, copy) NSString *issueCode;
@property (nonatomic, copy) NSString *moneyAmount;
@property (nonatomic, copy) NSString *status;

@end

NS_ASSUME_NONNULL_END
