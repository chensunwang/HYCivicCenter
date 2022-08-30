//
//  HYGuessYouCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/3.
//
//  猜你想办cell

#import "HYGuessYouCell.h"
#import "HYCivicCenterCommand.h"

@interface HYGuessYouCell ()

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UIButton * business1;
@property (nonatomic, strong) UIButton * business2;
@property (nonatomic, strong) UIButton * business3;

@end

@implementation HYGuessYouCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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

- (void)setupUI {
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(18, 10, 20, 10));
    }];
    self.bgView.layer.cornerRadius = 10;
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(17);
        make.height.mas_equalTo(16);
    }];
    self.titleLab.text = @"猜你想办";
    self.titleLab.font = MFONT(17);
    
    CGFloat bgWidth = ([UIScreen mainScreen].bounds.size.width - 20 - 30 - 26);
    self.business1 = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.business1];
    [self.business1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.equalTo(self.bgView).offset(-18);
        make.width.mas_equalTo(bgWidth/3);
        make.height.mas_equalTo(61);
    }];
    self.business1.tag = 1111;
    [self.business1 setImage:[UIImage imageNamed:@"guess01"] forState:UIControlStateNormal];
    [self.business1 addTarget:self action:@selector(businessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.business2 = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.business2];
    [self.business2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.bottom.width.height.equalTo(self.business1);
    }];
    self.business2.tag = 1112;
    [self.business2 setImage:[UIImage imageNamed:@"guess02"] forState:UIControlStateNormal];
    [self.business2 addTarget:self action:@selector(businessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.business3 = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.bgView addSubview:self.business3];
    [self.business3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-15);
        make.bottom.width.height.equalTo(self.business1);
    }];
    self.business3.tag = 1113;
    [self.business3 setImage:[UIImage imageNamed:@"guess03"] forState:UIControlStateNormal];
    [self.business3 addTarget:self action:@selector(businessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColorFromRGB(0xEBEFF5);
    self.bgView.backgroundColor = UIColor.whiteColor;
    self.titleLab.textColor = UIColorFromRGB(0x1E2023);
}

- (void)businessBtnClick:(UIButton *)sender {
    if (self.guessYouCellBlock) {
        self.guessYouCellBlock(sender.tag - 1111);
    }
}

@end
