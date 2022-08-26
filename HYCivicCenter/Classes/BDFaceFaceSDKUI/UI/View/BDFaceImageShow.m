//
//  BDFaceImageShow.m
//  FaceSDKSample_IOS
//
//  Created by 孙明喆 on 2020/4/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceImageShow.h"

@implementation BDFaceImageShow

+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static BDFaceImageShow *manager;
    dispatch_once(&once, ^{
        manager = [[BDFaceImageShow alloc] init];
        manager.successImage = [[UIImage alloc] init];
    });
    return manager;
}

- (void)setSuccessImage:(UIImage *)image{
    _successImage = image;
}

- (void)setSilentliveScore:(float)score{
    _silentliveScore = score;
}
- (void)setColorliveScore:(float)score{
    _colorliveScore = score;
}
- (void)setColorMatchNum:(int)num{
    _colorMatchNum = num;
}
- (void)setAuraLiveColor:(NSString *)string{
    _auraLiveColorStr = string;
}

- (UIImage *)getSuccessImage{
    return self.successImage;
}

- (float)getSilentliveScore{
    return self.silentliveScore;
}

- (float)getColorliveScore{
    return self.colorliveScore;
}

- (int)getColorMatchNum{
    return self.colorMatchNum;
}

- (NSString *)getAuraLiveColor{
    return self.auraLiveColorStr;
}

- (void)reset{
    _successImage = nil;
    _silentliveScore = 0;
}


@end
