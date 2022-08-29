//
//  HYMyServiceTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/13.
//

#import "HYMyServiceTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface HYMyServiceTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation HYMyServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = RFONT(14);
        [self.contentView addSubview:self.nameLabel];
     
        self.lineView = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView];
        
        [self traitCollectionDidChange:nil];
    }
    return self;
    
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

- (void)setServiceModel:(HYMyServiceModel *)serviceModel {
    _serviceModel = serviceModel;
    
    self.nameLabel.text = serviceModel.eventName;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(32);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.right.equalTo(self).offset(-32);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
