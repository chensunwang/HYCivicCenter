//
//  BusRouteViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusRouteViewController : UIViewController

@property (nonatomic, copy) NSString *lineNo;
@property (nonatomic, copy) NSString *isUpDown;
@property (nonatomic, copy) NSString *stationName;

@end

NS_ASSUME_NONNULL_END
