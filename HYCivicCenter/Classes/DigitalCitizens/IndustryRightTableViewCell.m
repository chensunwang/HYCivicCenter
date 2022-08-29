//
//  IndustryRightTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/9/26.
//

#import "IndustryRightTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface IndustryRightTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *chooseIV;

@end

@implementation IndustryRightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = RFONT(12);
        [self.contentView addSubview:self.nameLabel];
        
        self.chooseIV = [[UIImageView alloc]init];
        self.chooseIV.image = [UIImage imageNamed:@"chooseIndu"];
        self.chooseIV.hidden = YES;
        [self.contentView addSubview:self.chooseIV];
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.chooseIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-23);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(13, 10));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(24);
        make.right.equalTo(self.chooseIV.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
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
        self.chooseIV.hidden = NO;
        self.nameLabel.textColor = UIColorFromRGB(0x157AFF);
    }else {
        self.chooseIV.hidden = YES;
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
    }
    
}

@end
