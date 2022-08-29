//
//  HYProgressDetailTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/22.
//

#import "HYProgressDetailTableViewCell.h"
#import "HYCivicCenterCommand.h"

@implementation HYProgressDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    return self;
    
}

- (void)setupUI {
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    
    self.headerIV = [[UIImageView alloc] init];
    self.headerIV.image = [UIImage imageNamed:@"icon_base_info"];
    self.headerIV.hidden = YES;
    [self.bgView addSubview:self.headerIV];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = MFONT(15);
    self.titleLabel.hidden = YES;
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    [self.bgView addSubview:self.titleLabel];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = MFONT(14);
    self.nameLabel.hidden = YES;
    self.nameLabel.textColor = UIColorFromRGB(0x999999);
    [self.bgView addSubview:self.nameLabel];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.font = MFONT(14);
    self.rightLabel.hidden = YES;
    self.rightLabel.textColor = UIColorFromRGB(0x666666);
    [self.bgView addSubview:self.rightLabel];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self.bgView addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(32);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(32);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-32);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(32);
        make.right.equalTo(self.contentView.mas_right).offset(-32);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
