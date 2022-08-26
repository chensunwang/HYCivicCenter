//
//  HYOnLineBusinessMainViewController.h
//  HelloFrame
//
//  Created by nuchina on 2022/1/7.
//

#import <UIKit/UIKit.h>
#import "HYHotHandleAffairsModel.h"
#import "HYBusinessInfoModel.h"
#import "HYHotServiceModel.h"
#import "HYMyServiceModel.h"
#import "HYGuessBusinessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYOnLineBusinessMainViewController : UIViewController

@property (nonatomic, strong) HYHotServiceModel * serviceModel;
@property (nonatomic, strong) HYHotHandleAffairsModel * affairsModel;
@property (nonatomic, strong) HYBusinessInfoModel * infoModel;
@property (nonatomic, strong) HYMyServiceModel * myServiceModel;
@property (nonatomic, strong) HYGuessBusinessModel * businessModel;
@property (nonatomic, strong) UIColor *hyTitleColor;

@end

NS_ASSUME_NONNULL_END
