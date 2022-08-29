//
//  HYHandleGuideTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2022/1/8.
//

#import "HYHandleGuideTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface HYHandleGuideTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *containIV;
@property (nonatomic, strong) UIView *lineView;


@end

@implementation HYHandleGuideTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        
        [self traitCollectionDidChange:nil];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = MFONT(14);
    [self.contentView addSubview:self.nameLabel];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.font = MFONT(14);
    [self.contentView addSubview:self.rightLabel];
    self.rightLabel.numberOfLines = 0;
    self.rightLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = MFONT(14);
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    
    self.containIV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.containIV];
    
    self.lineView = [[UIView alloc] init];
    [self.contentView addSubview:self.lineView];
}

- (void)setInfoModel:(HYGuideItemInfoModel *)infoModel {
    _infoModel = infoModel;
    self.nameLabel.hidden = NO;
    self.rightLabel.hidden = NO;
    self.nameLabel.text = infoModel.name;
    self.rightLabel.text = infoModel.value;
    self.contentLabel.hidden = YES;
    self.containIV.hidden = YES;
}

- (void)setChargeModel:(HYChargeModel *)chargeModel {
    _chargeModel = chargeModel;
    self.nameLabel.hidden = NO;
    self.rightLabel.hidden = NO;
    self.nameLabel.text = chargeModel.name;
    self.rightLabel.text = chargeModel.standard;
    self.contentLabel.hidden = YES;
    self.containIV.hidden = YES;
}

- (void)setProcessModel:(HYHandlingProcessModel *)processModel {
    _processModel = processModel;
    self.nameLabel.hidden = NO;
    self.rightLabel.hidden = NO;
    self.nameLabel.text = processModel.name;
    self.rightLabel.text = processModel.content;
    self.contentLabel.hidden = YES;
    self.containIV.hidden = YES;
}

- (void)setConditionModel:(HYConditionModel *)conditionModel {
    _conditionModel = conditionModel;
    self.nameLabel.hidden = YES;
    self.rightLabel.hidden = YES;
    self.contentLabel.hidden = NO;
    self.contentLabel.text = [conditionModel.name stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    self.containIV.hidden = YES;
}

- (void)setOutMapModel:(HYOutMapModel *)outMapModel {
    _outMapModel = outMapModel;
    if (outMapModel.webUrl) {
        self.nameLabel.hidden = YES;
        self.rightLabel.hidden = YES;
        self.contentLabel.hidden = YES;
        self.containIV.hidden = NO;
        [self.containIV sd_setImageWithURL:[NSURL URLWithString:outMapModel.webUrl]];
    } else {
        self.nameLabel.hidden = YES;
        self.rightLabel.hidden = YES;
        self.contentLabel.hidden = NO;
        self.contentLabel.text = @"依据线下窗口办理";
        self.containIV.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.width.mas_equalTo(90);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(SCREEN_WIDTH - 106 - 32 - 32);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(16, 16, 16, 16));
    }];
    
    [self.containIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(16, 16, 16, 16));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColor.whiteColor;
    self.nameLabel.textColor = UIColorFromRGB(0x999999);
    self.rightLabel.textColor = UIColorFromRGB(0x333333);
    self.contentLabel.textColor = UIColorFromRGB(0x999999);
    self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
