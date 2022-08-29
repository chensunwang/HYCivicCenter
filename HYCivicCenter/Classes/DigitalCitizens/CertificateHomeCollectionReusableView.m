//
//  CertificateHomeCollectionReusableView.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/12.
//

#import "CertificateHomeCollectionReusableView.h"
#import "HYButton.h"
#import "BusTransportViewController.h"
#import "HYCivicCenterCommand.h"

@interface CertificateHomeCollectionReusableView ()

@property (nonatomic, strong) UIImageView *homeBG;

@end

@implementation CertificateHomeCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.homeBG = [[UIImageView alloc]init];
        self.homeBG.image = [UIImage imageNamed:@"homebg"];
        self.homeBG.userInteractionEnabled = YES;
        [self addSubview:self.homeBG];
        
        NSArray *imagesArr = @[@"citizen",@"transit",@"travel",@"payment"];
        NSArray *titlesArr = @[@"市民码",@"乘车",@"旅游",@"支付"];
        CGFloat padding = (SCREEN_WIDTH - 64 - 48 * 4) / 3;
        for (NSInteger i = 0; i < 4; i ++ ) {
            
            HYButton *button = [[HYButton alloc]init];
            button.nameLabel.text = titlesArr[i];
            button.headerIV.image = [UIImage imageNamed:imagesArr[i]];
            button.frame = CGRectMake(32 + (padding + 48) * i , 0, 48, 105);
            if (i>0) {
                button.bgView.alpha = 0.2;
            }
            button.tag = 999 + i;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.homeBG addSubview:button];
            
        }
        
        NSArray *imagesArr1 = @[@"card",@"coupon",@"honor",@"namecard"];
        NSArray *titlesArr1 = @[@"证件",@"优惠券",@"荣誉墙",@"名片夹"];
        for (NSInteger i = 0; i < 4; i++) {
            
            HYButton *button = [[HYButton alloc]init];
            button.nameLabel.text = titlesArr1[i];
            button.nameLabel.textColor = UIColorFromRGB(0x333333);
            button.headerIV.image = [UIImage imageNamed:imagesArr1[i]];
            button.frame = CGRectMake(32 + (padding +48) *i, self.frame.size.height - 105, 48, 105);
            button.tag = 888 + i;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
        }
        
        
    }
    return self;
    
}

- (void)buttonClicked:(UIButton *)button {
    
    NSInteger buttonTag = button.tag - 888;
    if (buttonTag == 0) {
        
        
        
    }else if (buttonTag == 1) {
        
        
        
    }else if (buttonTag == 2) {
        
        
        
    }else if (buttonTag == 3) {
        
        
        
    }
    
    NSInteger pageTag = button.tag - 999;
    if (pageTag == 0) {
        
    }else if (pageTag == 1) {
        
        BusTransportViewController *busVC = [[BusTransportViewController alloc]init];
        [[self topViewController].navigationController pushViewController:busVC animated:YES];
        
    }else if (pageTag == 2) {
        
    }else if (pageTag == 3) {
        
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.homeBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(253);
    }];
    
}

- (UIViewController *)topViewController {
    
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
    
}

@end
