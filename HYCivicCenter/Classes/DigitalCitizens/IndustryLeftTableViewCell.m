//
//  IndustryLeftTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/9/26.
//

#import "IndustryLeftTableViewCell.h"

@interface IndustryLeftTableViewCell ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation IndustryLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = UIColorFromRGB(0x157AFF);
        self.lineView.hidden = YES;
        [self.contentView addSubview:self.lineView];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = RFONT(12);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(3, 20));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-3);
        make.top.bottom.equalTo(self.contentView);
    }];
    
}

- (void)setModel:(ChooseIndustryModel *)model {
    _model = model;
    
    self.nameLabel.text = model.typeName;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (selected) {
        self.lineView.hidden = NO;
        self.nameLabel.textColor = UIColorFromRGB(0x157AFF);
    }else {
        self.lineView.hidden = YES;
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
    }
    
}

@end
