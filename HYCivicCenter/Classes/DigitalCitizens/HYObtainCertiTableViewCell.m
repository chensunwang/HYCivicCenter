//
//  HYObtainCertiTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/19.
//

#import "HYObtainCertiTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface HYObtainCertiTableViewCell ()

@property (nonatomic, strong) UIImageView *bgIV;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *subNameLabel;

@end

@implementation HYObtainCertiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.bgIV = [[UIImageView alloc]init];
        self.bgIV.userInteractionEnabled = YES;
        self.bgIV.layer.cornerRadius = 8;
        self.bgIV.clipsToBounds = YES;
        [self.contentView addSubview:self.bgIV];
        
        self.headerIV = [[UIImageView alloc]init];
        self.headerIV.layer.cornerRadius = 24;
        self.headerIV.clipsToBounds = YES;
        [self.bgIV addSubview:self.headerIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.font = RFONT(18);
        [self.bgIV addSubview:self.nameLabel];
        
        self.subNameLabel = [[UILabel alloc]init];
        self.subNameLabel.font = RFONT(12);
        self.subNameLabel.textColor = [UIColor whiteColor];
        self.subNameLabel.layer.cornerRadius = 10;
        self.subNameLabel.clipsToBounds = YES;
        self.subNameLabel.layer.borderWidth = 1;
        self.subNameLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.subNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgIV addSubview:self.subNameLabel];
        
//        self.bgIV.backgroundColor = [UIColor systemPinkColor];
//        self.headerIV.backgroundColor = [UIColor yellowColor];
//        self.nameLabel.text = @"护士职业证书";
        
    }
    return self;
    
}

- (void)setClassifyModel:(HYServiceClassifyModel *)classifyModel {
    _classifyModel = classifyModel;
    
    [self.bgIV sd_setImageWithURL:[NSURL URLWithString:classifyModel.backgroundUrl] placeholderImage:nil];
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:classifyModel.iconUrl] placeholderImage:nil];
    self.nameLabel.text = classifyModel.titleName;
    self.subNameLabel.text = classifyModel.buttonName;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 16, 8, 16));
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgIV.mas_left).offset(16);
        make.top.equalTo(self.bgIV.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(15);
        make.centerY.equalTo(self.headerIV.mas_centerY);
    }];
    
    [self.subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
