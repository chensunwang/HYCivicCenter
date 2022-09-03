//
//  HYGovServiceTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/18.
//

#import "HYGovServiceTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface HYGovServiceTableViewCell ()

@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *rightIV;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation HYGovServiceTableViewCell

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
        self.nameLabel.font = RFONT(14);
        [self.contentView addSubview:self.nameLabel];
        
        self.rightIV = [[UIImageView alloc]init];
        self.rightIV.image = HyBundleImage(@"enterIndicate");
        [self.contentView addSubview:self.rightIV];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.contentView addSubview:self.lineView];
        
//        self.headerIV.backgroundColor = [UIColor yellowColor];
//        self.nameLabel.text = @"创业补贴申领";
//        self.rightIV.backgroundColor = [UIColor redColor];
        
    }
    return self;
    
}

- (void)setModel:(HYServiceClassifyModel *)model {
    _model = model;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:nil];
    self.nameLabel.text = model.serviceName;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(22);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(13);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.rightIV.mas_left).offset(-16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
