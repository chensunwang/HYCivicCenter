//
//  HYHotServiceTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/14.
//

#import "HYHotServiceTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface HYHotServiceTableViewCell ()

@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation HYHotServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        self.containView = [[UIView alloc]init];
        self.containView.backgroundColor = [UIColor whiteColor];
        self.containView.layer.cornerRadius = 16;
        self.containView.clipsToBounds = YES;
        [self.contentView addSubview:self.containView];
        
        self.headerIV = [[UIImageView alloc]init];
        [self.containView addSubview:self.headerIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = RFONT(15);
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        [self.containView addSubview:self.nameLabel];
        
//        self.headerIV.backgroundColor = [UIColor yellowColor];
//        self.nameLabel.text = @"南昌地铁时刻信息";
        
    }
    return self;
    
}

- (void)setServiceModel:(HYHotServiceModel *)serviceModel {
    _serviceModel = serviceModel;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:serviceModel.logoUrl]];
    self.nameLabel.text = serviceModel.name;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 16, 10, 16));
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(13);
        make.centerY.equalTo(self.containView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(11);
        make.centerY.equalTo(self.containView.mas_centerY);
    }];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
