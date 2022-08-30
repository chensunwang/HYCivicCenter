//
//  HYGuessBusinessTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/16.
//

#import "HYGuessBusinessTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface HYGuessBusinessTableViewCell ()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIImageView * indicateIV;
@property (nonatomic, strong) UIView * lineView;

@end

@implementation HYGuessBusinessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = RFONT(14);
        [self.contentView addSubview:self.nameLabel];
        
        self.indicateIV = [[UIImageView alloc] init];
        self.indicateIV.image = [UIImage imageNamed:@"serviceIndicate"];
        [self.contentView addSubview:self.indicateIV];
        
        self.lineView = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

- (void)setGuessModel:(HYGuessBusinessModel *)guessModel {
    if (guessModel) {
        _guessModel = guessModel;
        self.nameLabel.text = guessModel.name;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.centerY.equalTo(self);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 32 - 44);
    }];
    
    [self.indicateIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
