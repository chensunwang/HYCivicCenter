//
//  BDFaceImageShow.h
//  FaceSDKSample_IOS
//
//  Created by 孙明喆 on 2020/4/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDFaceImageShow : NSObject

@property (nonatomic, readwrite) UIImage *successImage;

@property (nonatomic,assign) float silentliveScore;

@property (nonatomic,assign) float colorliveScore;

@property (nonatomic,assign) float colorMatchNum;

@property (nonatomic,copy) NSString * auraLiveColorStr;


+ (instancetype)sharedInstance;

- (void)setSuccessImage:(UIImage *)image;

- (void)setSilentliveScore:(float)score;

- (void)setColorliveScore:(float)score;

- (void)setColorMatchNum:(int)num;

- (void)setAuraLiveColor:(NSString *)string;

- (UIImage *)getSuccessImage;

- (float)getSilentliveScore;

- (float)getColorliveScore;

- (int)getColorMatchNum;

- (NSString *)getAuraLiveColor;

- (void) reset;

@end

NS_ASSUME_NONNULL_END
