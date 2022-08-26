//
//  IndustryChooseCollectionViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/23.
//

#import "IndustryChooseCollectionViewCell.h"
@class IndustryChooseModel;

@implementation IndustryChooseModel



@end

@implementation IndustryChooseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = RFONT(15);
        self.nameLabel.backgroundColor = UIColorFromRGB(0xF5F5F5);
        self.nameLabel.layer.cornerRadius = 2;
        self.nameLabel.layer.borderWidth = 0.5;
        self.nameLabel.layer.borderColor = UIColorFromRGB(0xF5F5F5).CGColor;
        self.nameLabel.clipsToBounds = YES;
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

- (void)setModel:(IndustryChooseModel *)model {
    _model = model;
    
    self.nameLabel.text = model.dictLabel;
    
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.nameLabel.backgroundColor = UIColorFromRGB(0xE5F1FF);
//        self.nameLabel.layer.borderColor = UIColorFromRGB(0x157AFF).CGColor;
        self.nameLabel.textColor = UIColorFromRGB(0x157AFF);
    }else {
        self.nameLabel.backgroundColor = UIColorFromRGB(0xF5F5F5);
//        self.nameLabel.layer.borderColor = UIColorFromRGB(0xCFD8E6).CGColor;
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
    }
    
}

@end
