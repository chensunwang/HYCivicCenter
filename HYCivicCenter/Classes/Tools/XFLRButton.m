//
//  XFLRButton.m
//  HelloFrame
//
//  Created by nuchina on 2021/9/6.
//

#import "XFLRButton.h"

@implementation XFLRButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat totalW = self.imageView.frame.size.width + self.titleLabel.frame.size.width + self.padding;
    CGFloat marginY = (self.frame.size.width - totalW) * 0.5;
    
    CGRect newFrame = [self titleLabel].frame;
    CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(0, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:self.titleLabel.font}
                                                     context:nil];
    newFrame.size.width = rect.size.width;
    newFrame.origin.x = marginY;
    newFrame.origin.y = (self.frame.size.height - rect.size.height) * 0.5;
    self.titleLabel.frame = newFrame;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
 
    CGPoint center;
    center.x = marginY + newFrame.size.width + self.padding + self.imageView.frame.size.width * 0.5;
    center.y = self.frame.size.height * 0.5;
    self.imageView.center = center;
    
}

@end
