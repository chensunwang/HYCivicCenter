//
//  FaceTipViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FaceResultDelegate <NSObject>

- (void)getFaceResultWithImageStr:(NSString *)imageStr deviceId:(NSString *)deviceid skey:(NSString *)skey;

@end

@interface FaceTipViewController : UIViewController

@property (nonatomic, weak) id<FaceResultDelegate>delegate;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
