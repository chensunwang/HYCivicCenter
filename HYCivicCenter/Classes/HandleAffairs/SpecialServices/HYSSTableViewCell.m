//
//  HYSSTableViewCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//
//  专项服务表格cell

#import "HYSSTableViewCell.h"

@interface HYSSTableViewCell ()

@property (nonatomic, strong) UIImageView * imgV;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * subTitleLab;
@property (nonatomic, strong) UIView * lineView;

@end

@implementation HYSSTableViewCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSpecialModel:(HYServiceContentModel *)specialModel {
    if (specialModel) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:specialModel.logoUrl]];
        self.titleLab.text = specialModel.specialName;
        self.subTitleLab.text = specialModel.littleName;
    }
}

- (void)setDepartmentModel:(HYDepartmentCountryModel *)departmentModel {
    if (departmentModel) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:departmentModel.icon]];
        self.titleLab.text = departmentModel.title;
        self.subTitleLab.text = departmentModel.subTitle;
    }
}

- (void)setupUI {
    self.imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.imgV];
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(22);
        make.width.height.mas_equalTo(33);
    }];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgV.mas_right).offset(12);
        make.top.equalTo(self.imgV);
        make.height.mas_equalTo(13);
        make.right.equalTo(self).offset(-22);
    }];
    self.titleLab.text = @"社保服务";
    self.titleLab.font = MFONT(13);
    
    self.subTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.subTitleLab];
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.bottom.equalTo(self.imgV).offset(-2);
        make.height.mas_equalTo(11);
        make.right.equalTo(self).offset(-22);
    }];
    self.subTitleLab.text = @"养老保险待遇核定、社保卡挂失、社保缴费申请";
    self.subTitleLab.font = MFONT(11);
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.right.equalTo(self).offset(-22);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColor.whiteColor;
    self.titleLab.textColor = UIColorFromRGB(0x333333);
    self.subTitleLab.textColor = UIColorFromRGB(0x999999);
    self.lineView.backgroundColor = UIColorFromRGB(0xE6E6E6);
}

@end
