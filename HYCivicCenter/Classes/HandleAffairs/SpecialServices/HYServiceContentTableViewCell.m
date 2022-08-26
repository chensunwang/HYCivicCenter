//
//  HYServiceContentTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/27.
//

#import "HYServiceContentTableViewCell.h"

@interface HYServiceContentTableViewCell ()

@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subNameLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation HYServiceContentModel



@end

@implementation HYDepartmentCountryModel



@end

@implementation HYServiceContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.headerIV = [[UIImageView alloc]init];
        [self.contentView addSubview:self.headerIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = RFONT(13);
        [self.contentView addSubview:self.nameLabel];
        
        self.subNameLabel = [[UILabel alloc]init];
        self.subNameLabel.textColor = UIColorFromRGB(0x999999);
        self.subNameLabel.font = RFONT(11);
        [self.contentView addSubview:self.subNameLabel];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
    
}

- (void)setSpecialModel:(HYServiceContentModel *)specialModel {
    _specialModel = specialModel;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:specialModel.logoUrl]];
    self.nameLabel.text = specialModel.specialName;
    self.subNameLabel.text = specialModel.littleName;
    
}

- (void)setDepartmentModel:(HYDepartmentCountryModel *)departmentModel {
    _departmentModel = departmentModel;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:departmentModel.icon]];
    self.nameLabel.text = departmentModel.title;
    self.subNameLabel.text = departmentModel.subTitle;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
 
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(12);
        make.top.equalTo(self.headerIV.mas_top);
    }];
    
    [self.subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(12);
        make.bottom.equalTo(self.headerIV.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
