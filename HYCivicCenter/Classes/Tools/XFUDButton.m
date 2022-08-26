//
//  XFUDButton.m
//  FateCircle
//
//  Created by 王文利 on 2017/9/20.
//  Copyright © 2017年 王文利. All rights reserved.
//

#import "XFUDButton.h"

@implementation XFUDButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    CGSize imgSize = [self.imageView sizeThatFits:CGSizeZero];
//    CGSize labelSize = [self.titleLabel sizeThatFits:CGSizeZero];
//    CGFloat totalH = imgSize.height + labelSize.height + self.padding;
//    self.imageView.size = imgSize;
//    self.imageView.top = (self.frame.size.height - totalH) * 0.5;
//    self.imageView.centerX = self.frame.size.width * 0.5;
//    
//    self.titleLabel.size = labelSize;
//    self.titleLabel.top = self.imageView.bottom + self.padding;
//    self.titleLabel.centerX = self.frame.size.width * 0.5;
    
    CGFloat totalH = self.imageView.frame.size.height + self.titleLabel.frame.size.height + self.padding;
    CGFloat marginX = (self.frame.size.height - totalH) * 0.5;
    CGPoint center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2 + marginX;
    self.imageView.center = center;

     //text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + self.padding + marginX;
    newFrame.size.width = self.frame.size.width;

    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
}

@end
