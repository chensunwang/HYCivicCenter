//
//  BDFaceColorfulViewController.h
//  FaceSDKSample_IOS
//
//  Created by 之哥 on 2020/12/29.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BDFaceColorfulVCDelegate <NSObject>

@optional

- (void)getFaceImg:(UIImage *)img;
- (void)checkFaceFailed;
- (void)completeWithImageString:(NSString *)imageString skey:(NSString *)skey deviceId:(NSString *)deviceId;

@end
@interface BDFaceColorfulViewController : BDFaceBaseViewController

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, weak) id <BDFaceColorfulVCDelegate> delegate;

- (void)livenesswithList:(NSArray *)livenessArray order:(BOOL)order numberOfLiveness:(NSInteger)numberOfLiveness;

@end

NS_ASSUME_NONNULL_END
