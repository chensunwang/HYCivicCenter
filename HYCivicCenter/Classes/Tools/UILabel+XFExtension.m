//
//  UILabel+XFExtension.m
//  HelloFrame
//
//  Created by nuchina on 2021/10/22.
//

#import "UILabel+XFExtension.h"
#import "HYCivicCenterCommand.h"

@implementation UILabel (XFExtension)

+ (instancetype)xf_labelWithFont:(UIFont *)font
                       textColor:(UIColor *)color
                   numberOfLines:(NSInteger)lines
                       alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.numberOfLines = lines;
    label.textAlignment = alignment;
    return label;
}

+(instancetype)xf_labelWithText:(NSString *)text {
    
    UILabel *label = [[UILabel alloc]init];
    label.font = BFONT(17);
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    return label;
    
}

- (NSString *)verticalText {
    
    return objc_getAssociatedObject(self, @selector(verticalText));
    
}

- (void)setVerticalText:(NSString *)verticalText {
    
    objc_setAssociatedObject(self, &verticalText, verticalText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableString *str = [[NSMutableString alloc]initWithString:verticalText];
    NSInteger count = str.length;
    for (int i = 1; i < count; i++) {
        [str insertString:@"\n" atIndex:i*2-1];
    }
    self.text = str;
    self.numberOfLines = 0;
    
}

@end
