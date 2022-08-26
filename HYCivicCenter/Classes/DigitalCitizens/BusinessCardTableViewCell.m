//
//  BusinessCardTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/16.
//

#import "BusinessCardTableViewCell.h"
@class BusinessCardModel;

@interface BusinessCardTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subNameLabel;


@end

@implementation BusinessCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 8;
        self.bgView.clipsToBounds = YES;
        [self.contentView addSubview:self.bgView];
        
        self.headerIV = [[UIImageView alloc]init];
        self.headerIV.layer.cornerRadius = 24;
        self.headerIV.clipsToBounds = YES;
        [self.bgView addSubview:self.headerIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = RFONT(15);
        [self.bgView addSubview:self.nameLabel];
        
        self.subNameLabel = [[UILabel alloc]init];
        self.subNameLabel.textColor = UIColorFromRGB(0x999999);
        self.subNameLabel.font = RFONT(12);
        [self.bgView addSubview:self.subNameLabel];
        
        self.headerIV.backgroundColor = [UIColor orangeColor];
        self.nameLabel.text = @"刘德华";
        self.subNameLabel.text = @"总经理";
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 16, 8, 16));
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(16);
        make.top.equalTo(self.bgView.mas_top).offset(22);
    }];
    
    [self.subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(16);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-21);
    }];
    
    
}

- (void)setModel:(BusinessCardModel *)model {
    _model = model;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.headPhoto]];
    self.nameLabel.text = model.name;
    self.subNameLabel.text = model.duty;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation BusinessCardModel



@end
