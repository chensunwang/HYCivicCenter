//
//  HYBusinfoModel.h
//  HelloFrame
//
//  Created by nuchina on 2021/11/2.
//

#import <Foundation/Foundation.h>
@class HYStationModel;

NS_ASSUME_NONNULL_BEGIN

@interface HYBusinfoModel : NSObject

@property (nonatomic, copy) NSString *arriveNowStationNeedMinute;
@property (nonatomic, copy) NSString *arriveNowStationNumber;// 还有几站到达当前站点
@property (nonatomic, copy) NSString *busState;
@property (nonatomic, copy) NSString *currentBusMinute;
@property (nonatomic, copy) NSString *distanceMeter; // 距离当前站点xx米
@property (nonatomic, copy) NSString *isUpDown;
@property (nonatomic, copy) NSString *lineName;
@property (nonatomic, copy) NSString *lineNo;
@property (nonatomic, copy) NSString *motorcadeNo;
@property (nonatomic, strong) HYStationModel *nextStation;
@property (nonatomic, copy) NSString *runState;
@property (nonatomic, copy) NSString *stationNo;
@property (nonatomic, strong) HYStationModel *terminusStation;
@property (nonatomic, copy) NSString *velocity;
@property (nonatomic, copy) NSString *willRun;


@end

@interface HYStationModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *isUpDown;
@property (nonatomic, copy) NSString *labelNo;
@property (nonatomic, copy) NSString *lineNo;
@property (nonatomic, copy) NSString *stationId;
@property (nonatomic, copy) NSString *stationName;

@end

NS_ASSUME_NONNULL_END
