//
//  HYAreaServiceTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/14.
//

#import "HYAreaServiceTableViewCell.h"

@interface HYAreaServiceTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subNameLabel;
@property (nonatomic, strong) UIImageView *indicateIV;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation HYAreaServiceModel


@end

@implementation HYAreaServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = RFONT(14);
        [self.contentView addSubview:self.nameLabel];
        
        self.subNameLabel = [[UILabel alloc]init];
        self.subNameLabel.textColor = UIColorFromRGB(0x999999);
        self.subNameLabel.font = RFONT(12);
        [self.contentView addSubview:self.subNameLabel];
        
        self.indicateIV = [[UIImageView alloc]init];
        self.indicateIV.image = [UIImage imageNamed:@"serviceIndicate"];
        [self.contentView addSubview:self.indicateIV];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.contentView addSubview:self.lineView];
        
        self.nameLabel.text = @"南昌市公安局红谷滩分局";
        self.subNameLabel.text = @"港澳通行证、台湾通行证、港澳台居民居住证等业务";
        
    }
    return self;
    
}

- (void)setAreaModel:(HYAreaServiceModel *)areaModel {
    if (areaModel) {
        _areaModel = areaModel;
        self.nameLabel.text = areaModel.title;
        self.subNameLabel.text = areaModel.subTitle;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(32);
        make.top.equalTo(self.contentView.mas_top).offset(17);
    }];
    
    [self.indicateIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-35);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    
    [self.subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(32);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-18);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(32);
        make.right.equalTo(self.contentView.mas_right).offset(-32);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
