//
//  HYOnLineHandleViewController.h
//  HelloFrame
//
//  Created by nuchina on 2022/1/7.
//

#import <UIKit/UIKit.h>
#import "HYHotHandleAffairsModel.h"
#import "HYBusinessInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYOnLineHandleViewController : UIViewController

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) UIColor *hyTitleColor;

@property (nonatomic, copy) NSString * itemCode;

@end

NS_ASSUME_NONNULL_END
