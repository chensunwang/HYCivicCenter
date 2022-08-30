//
//  HYSearchStationModel.h
//  HelloFrame
//
//  Created by nuchina on 2021/11/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYSearchStationModel : NSObject

@property (nonatomic, copy) NSString *isUpDown;
@property (nonatomic, copy) NSString *lineNo;
@property (nonatomic, copy) NSString *lineName;
@property (nonatomic, copy) NSString *stationName;
@property (nonatomic, copy) NSString *labelNo;
@property (nonatomic, copy) NSString *stationHaveCar;
@property (nonatomic, copy) NSString *currentBus;

@end

@interface HYSearchLineModel : NSObject

@property (nonatomic, copy) NSString *lineCode;
@property (nonatomic, copy) NSString *lineName;
@property (nonatomic, copy) NSString *lineNo;
@property (nonatomic, copy) NSString *labelNo;
@property (nonatomic, copy) NSString *isUpDown;

@end

NS_ASSUME_NONNULL_END
