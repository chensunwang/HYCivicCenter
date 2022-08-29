//
//  HYDDBusinessCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/7.
//
//  个人业务/法人业务中tableView的cell

#import "HYDDBusinessCell.h"
#import "HYBusinessSearchViewController.h"
#import "HYCivicCenterCommand.h"

@interface HYDDBusinessCell ()

@property (nonatomic, strong) UIView * pointView;
@property (nonatomic, strong) UILabel * nameLabel;
@end

@implementation HYDDBusinessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.pointView = [[UIView alloc] init];
        self.pointView.layer.cornerRadius = 3;
        self.pointView.clipsToBounds = YES;
        [self.contentView addSubview:self.pointView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.font = MFONT(16);
        [self.contentView addSubview:self.nameLabel];
        
        [self traitCollectionDidChange:nil];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(32);
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pointView.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-24);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColorFromRGB(0xF0F4FA);
    self.pointView.backgroundColor = UIColorFromRGB(0x666666);
    self.nameLabel.textColor = UIColorFromRGB(0x666666);
}

- (void)setInfoModel:(HYBusinessInfoModel *)infoModel {
    if (infoModel) {
        _infoModel = infoModel;
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = 4; //设置行间距
        paraStyle.minimumLineHeight = 10;
        NSDictionary *attribtDic = @{NSFontAttributeName:MFONT(16),
                                     NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                     NSParagraphStyleAttributeName:paraStyle};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:infoModel.name attributes:attribtDic];
        self.nameLabel.attributedText = attribtStr;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



// *************************************************************************** //

@interface HYDDBHeaderForSection ()

@property (nonatomic, strong) UIView * verticalView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * viewMoreBtn;
@property (nonatomic, strong) UILabel * descriptlabel;

@end

@implementation HYDDBHeaderForSection

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
    }
    return self;
}

- (void)setModel:(HYBusinessInfoModel *)model {
    if (model) {
        _model = model;
        self.titleLabel.text = model.titleName;
        
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = 4; //设置行间距
        paraStyle.minimumLineHeight = 7;
        NSDictionary *dic = @{NSFontAttributeName:MFONT(12), NSParagraphStyleAttributeName:paraStyle};
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:model.littleTitle attributes:dic];
        self.descriptlabel.attributedText = attributeStr;
    }
}

- (void)setupUI {
    _verticalView = [[UIView alloc] init];
    [self addSubview:_verticalView];
    [_verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(18);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(18);
    }];
    self.layer.cornerRadius = 2;
    
    _titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalView.mas_right).offset(8);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(15);
    }];
    _titleLabel.text = @"备案业务";
    _titleLabel.font = MFONT(15);
    
    _viewMoreBtn = [[UIButton alloc] init];
    [self addSubview:_viewMoreBtn];
    [_viewMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.top.mas_equalTo(22);
        make.height.mas_equalTo(12);
    }];
    [_viewMoreBtn setTitle:@"查看更多 >" forState:UIControlStateNormal];
    _viewMoreBtn.titleLabel.font = MFONT(12);
    [_viewMoreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _descriptlabel = [[UILabel alloc] init];
    [self addSubview:_descriptlabel];
    [_descriptlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(28);
        make.right.equalTo(self).offset(-26);
        make.bottom.equalTo(self).offset(-6);
    }];
    _descriptlabel.numberOfLines = 0;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColorFromRGB(0xF0F4FA);
    self.verticalView.backgroundColor = UIColorFromRGB(0x157AFF);
    self.titleLabel.textColor = UIColor.blackColor;
    [self.viewMoreBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    self.descriptlabel.textColor = UIColorFromRGB(0x999999);
}

- (void)moreBtnClicked:(UIButton *)sender {
    HYBusinessSearchViewController *searchVC = [[HYBusinessSearchViewController alloc] init];
    searchVC.orgName = _model.orgName;
    searchVC.businessName = _model.titleName;
    searchVC.hyTitleColor = _hyTitleColor;
    [self.viewController.navigationController pushViewController:searchVC animated:YES];
}

@end
