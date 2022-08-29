//
//  CouponsCenterTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/5.
//

#import "CouponsCenterTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface CouponsCenterTableViewCell()

@property (nonatomic,strong) UIImageView *contentIV;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *useLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *receivedIV;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UIButton *useBtn;
@property (nonatomic,strong) UIButton *toUseBtn;

@end

@implementation CouponsCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        self.contentIV = [[UIImageView alloc]init];
        self.contentIV.userInteractionEnabled = YES;
        [self.contentView addSubview:self.contentIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = RFONT(15);
        self.nameLabel.textColor = UIColorFromRGB(333333);
        [self.contentIV addSubview:self.nameLabel];
        
        self.useLabel = [[UILabel alloc]init];
        self.useLabel.font = RFONT(12);
        self.useLabel.textColor = UIColorFromRGB(999999);
        [self.contentIV addSubview:self.useLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = RFONT(12);
        self.timeLabel.textColor = UIColorFromRGB(999999);
        [self.contentIV addSubview:self.timeLabel];
        
        self.receivedIV = [[UIImageView alloc]init];
        self.receivedIV.image = [UIImage imageNamed:@"received"];
        self.receivedIV.hidden = YES;
        [self.contentIV addSubview:self.receivedIV];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.textColor = UIColorFromRGB(0xFD5C66);
        [self.contentIV addSubview:self.priceLabel];

        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"￥10" attributes:@{NSFontAttributeName: RFONT(12),NSForegroundColorAttributeName: [UIColor colorWithRed:253/255.0 green:92/255.0 blue:102/255.0 alpha:1.0]}];

        [string addAttributes:@{NSFontAttributeName: RFONT(24)} range:NSMakeRange(1, 2)];
        self.priceLabel.attributedText = string;
        
        self.useBtn = [[UIButton alloc]init];
        [self.useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.useBtn.titleLabel.font = RFONT(10);
        self.useBtn.layer.cornerRadius = 11;
        self.useBtn.clipsToBounds = YES;
        self.useBtn.hidden = YES;
        [self.useBtn addTarget:self action:@selector(useClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentIV addSubview:self.useBtn];
        
        self.toUseBtn = [[UIButton alloc]init];
        [self.toUseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.toUseBtn.titleLabel.font = RFONT(10);
        self.toUseBtn.layer.cornerRadius = 11;
        self.toUseBtn.clipsToBounds = YES;
        self.toUseBtn.hidden = YES;
        [self.contentIV addSubview:self.toUseBtn];
        
        self.contentIV.image = [UIImage imageNamed:@"background"];
        self.nameLabel.text = @"打车出行代金券";
        self.useLabel.text = @"仅限滴滴打车可用";
        self.timeLabel.text = @"有效期至：2021-07-29 13:00:00";
        
        
    }
    return self;
    
}

- (void)setCouponModel:(HYCouponModel *)couponModel {
    _couponModel = couponModel;
    
    self.nameLabel.text = couponModel.couponName;
    if (couponModel.businessName.length > 0) {
        self.useLabel.text = [NSString stringWithFormat:@"仅限%@使用",couponModel.businessName];
    }else {
        self.useLabel.text = [NSString stringWithFormat:@"适用分类：%@",couponModel.couponTypeName];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"有效期至：%@",couponModel.expiresTime];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",couponModel.moneyAmount] attributes:@{NSFontAttributeName: RFONT(12),NSForegroundColorAttributeName: [UIColor colorWithRed:253/255.0 green:92/255.0 blue:102/255.0 alpha:1.0]}];

    [string addAttributes:@{NSFontAttributeName: RFONT(24)} range:NSMakeRange(1, couponModel.moneyAmount.length)];
    self.priceLabel.attributedText = string;
    
    if (couponModel.status.intValue == 1) {// 领券中心未领取
        self.useBtn.hidden = NO;
        self.toUseBtn.hidden = YES;
    }else if (couponModel.status.intValue == 2) { // 可使用
        self.useBtn.hidden = YES;
        self.toUseBtn.hidden = NO;
    }else {
        self.useBtn.hidden = YES;
        self.toUseBtn.hidden = YES;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.contentIV
    [self.contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 16, 8, 16));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentIV.mas_left).offset(16);
        make.top.equalTo(self.contentIV.mas_top).offset(19);
    }];
    
    [self.useLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentIV.mas_left).offset(16);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(12);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentIV.mas_left).offset(16);
        make.bottom.equalTo(self.contentIV.mas_bottom).offset(-17);
    }];
    
    [self.receivedIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentIV.mas_right).offset(-103);
        make.top.equalTo(self.contentIV.mas_top);
        make.size.mas_equalTo(CGSizeMake(53, 53));
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentIV.mas_right).offset(-30);
        make.top.equalTo(self.contentIV.mas_top).offset(25);
    }];
    
    [self.useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentIV.mas_right).offset(-16);
        make.bottom.equalTo(self.contentIV.mas_bottom).offset(-19);
        make.size.mas_equalTo(CGSizeMake(64, 22));
    }];
    
    [self.toUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentIV.mas_right).offset(-16);
        make.bottom.equalTo(self.contentIV.mas_bottom).offset(-19);
        make.size.mas_equalTo(CGSizeMake(64, 22));
    }];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.useBtn.bounds;
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)UIColorFromRGB(0x1991FF).CGColor,(__bridge id)UIColorFromRGB(0x0F5CFF).CGColor];
    gl.locations = @[@(0),@(1.0f)];
    [self.useBtn.layer insertSublayer:gl atIndex:0];
    [self.useBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    
    CAGradientLayer *touseGl = [CAGradientLayer layer];
    touseGl.frame = self.toUseBtn.bounds;
    touseGl.startPoint = CGPointMake(0, 0.5);
    touseGl.endPoint = CGPointMake(1, 0.5);
    touseGl.colors = @[(__bridge id)UIColorFromRGB(0x1991FF).CGColor,(__bridge id)UIColorFromRGB(0x0F5CFF).CGColor];
    touseGl.locations = @[@(0),@(1.0f)];
    [self.toUseBtn.layer insertSublayer:touseGl atIndex:0];
    [self.toUseBtn setTitle:@"去使用" forState:UIControlStateNormal];
    
}

- (void)useClicked {
    
    if ([self.delegate respondsToSelector:@selector(receiveCouponWithCell:withModel:)]) {
        [self.delegate receiveCouponWithCell:self withModel:self.couponModel];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
