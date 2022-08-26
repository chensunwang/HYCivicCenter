//
//  RideRecordTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RideRecordModel : NSObject

@property (nonatomic, copy) NSString *cardNo; // 卡号
@property (nonatomic, copy) NSString *cardType; // 卡类型
@property (nonatomic, copy) NSString *orderDesc; // 公交-线路-车号-乘车时间
@property (nonatomic, copy) NSString *orderNo; // 订单号
@property (nonatomic, copy) NSString *payAmt; // 支付金额
@property (nonatomic, copy) NSString *payState; // 支付状态
@property (nonatomic, copy) NSString *txnTime; // 交易时间
@property (nonatomic, copy) NSString *txnAmt; // 交易金额

@end

@interface RideRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) RideRecordModel *model;

@end

NS_ASSUME_NONNULL_END
