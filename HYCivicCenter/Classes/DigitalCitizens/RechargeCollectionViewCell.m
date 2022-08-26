//
//  RechargeCollectionViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/27.
//

#import "RechargeCollectionViewCell.h"

@implementation RechargeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = RFONT(20);
        self.nameLabel.layer.cornerRadius = 4;
        self.nameLabel.clipsToBounds = YES;
        self.nameLabel.layer.borderColor = UIColorFromRGB(0xCFD8E6).CGColor;
        self.nameLabel.layer.borderWidth = 0.5;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

- (void)setName:(NSString *)name {
    _name = name;
    
//    self.nameLabel.text = name;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName: RFONT(20),NSForegroundColorAttributeName: UIColorFromRGB(0x333333)}];
    [string addAttributes:@{NSFontAttributeName: RFONT(12)} range:NSMakeRange(name.length-2, 1)];
    self.nameLabel.attributedText = string;
    
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.contentView.backgroundColor = UIColorFromRGB(0xE5F1FF);
        self.nameLabel.layer.borderColor = UIColorFromRGB(0x157AFF).CGColor;
        self.nameLabel.textColor = UIColorFromRGB(0x157AFF);
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.nameLabel.layer.borderColor = UIColorFromRGB(0xCFD8E6).CGColor;
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
    }
    
}

@end
