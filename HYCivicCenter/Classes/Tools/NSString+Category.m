//
//  NSString+Category.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/8.
//

#import "NSString+Category.h"

@implementation NSString (Category)

- (CGFloat)heightForStringWithFont:(UIFont *)font width:(CGFloat)width {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = font;
    label.text = self;
    [label sizeToFit];
    
    return label.frame.size.height;
}

@end
