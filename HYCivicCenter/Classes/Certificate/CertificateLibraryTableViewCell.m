//
//  CertificateLibraryTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/9.
//

#import "CertificateLibraryTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface CertificateLibraryTableViewCell ()

@property (nonatomic, strong) UIImageView *timeLineIV;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *mainIV;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *cardNameLabel;
@property (nonatomic, strong) UILabel *cardNumberLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *codeBtn;

@end

@implementation CertificateModel



@end

@implementation CertificateLibraryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.timeLineIV = [[UIImageView alloc]init];
        self.timeLineIV.image = HyBundleImage(@"timeline");
        [self.contentView addSubview:self.timeLineIV];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = UIColorFromRGB(0xDDDDDD);
        [self.contentView addSubview:self.lineView];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = UIColorFromRGB(0x666666);
        self.timeLabel.font = RFONT(13);
        [self.contentView addSubview:self.timeLabel];
        
        self.mainIV = [[UIImageView alloc]init];
        self.mainIV.layer.cornerRadius = 8;
        self.mainIV.clipsToBounds = YES;
        [self.contentView addSubview:self.mainIV];
        
        self.headerIV = [[UIImageView alloc]init];
        self.headerIV.layer.cornerRadius = 20.5;
        self.headerIV.clipsToBounds = YES;
        [self.mainIV addSubview:self.headerIV];
        
        self.cardNameLabel = [[UILabel alloc]init];
        self.cardNameLabel.textColor = UIColorFromRGB(0x333333);
        self.cardNameLabel.font = RFONT(18);
        [self.mainIV addSubview:self.cardNameLabel];
        
        self.cardNumberLabel = [[UILabel alloc]init];
        self.cardNumberLabel.textColor = UIColorFromRGB(0x666666);
        self.cardNumberLabel.font = RFONT(12);
        [self.mainIV addSubview:self.cardNumberLabel];
        
        self.bottomView = [[UIView alloc]init];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        self.bottomView.alpha = 0.2;
        [self.mainIV addSubview:self.bottomView];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = RFONT(12);
        self.nameLabel.textColor = UIColorFromRGB(0x666666);
        [self.bottomView addSubview:self.nameLabel];
        
        self.codeBtn = [[UIButton alloc]init];
        [self.codeBtn setImage:HyBundleImage(@"code2") forState:UIControlStateNormal];
        [self.bottomView addSubview:self.codeBtn];
        
        self.mainIV.backgroundColor = [UIColor redColor];
        self.headerIV.backgroundColor = [UIColor blueColor];
        self.nameLabel.text = @"??????????????????";
        
    }
    return self;
    
}

- (void)setModel:(CertificateModel *)model {
    _model = model;
    
    if ([model.license_item_code isEqualToString:@"107012901"]) { // ??????????????????
        self.mainIV.image = HyBundleImage(@"idcard5");
        self.headerIV.image = HyBundleImage(@"idcardHeader4");
    }else if ([model.license_item_code isEqualToString:@"107013001"]) { // ??????????????????
        self.mainIV.image = HyBundleImage(@"idcard5");
        self.headerIV.image = HyBundleImage(@"idcardHeader4");
    }else if ([model.license_item_code isEqualToString:@"100018901"]) { //?????????????????????
        self.mainIV.image = HyBundleImage(@"idcard1");
        self.headerIV.image = HyBundleImage(@"idcardHeader1");
    }else if ([model.license_item_code isEqualToString:@"100019001"]) {// ???????????????????????????
        self.mainIV.image = HyBundleImage(@"idcard4");
        self.headerIV.image = HyBundleImage(@"idcardHeader1");
    }else if ([model.license_item_code isEqualToString:@"100018801"]) { // ?????????
        self.mainIV.image = HyBundleImage(@"idcard2");
        self.headerIV.image = HyBundleImage(@"idcardHeader3");
    }else if ([model.license_item_code isEqualToString:@"100018601"]) { // ?????????
        self.mainIV.image = HyBundleImage(@"idcard15");
        self.headerIV.image = HyBundleImage(@"idcardHeader11");
    }else if ([model.license_item_code isEqualToString:@"100001001"]) { // ?????????
        self.mainIV.image = HyBundleImage(@"idcard3");
        self.headerIV.image = HyBundleImage(@"idcardHeader2");
    }else if ([model.license_item_code isEqualToString:@"100000401"]) { // ?????????
        self.mainIV.image = HyBundleImage(@"idcard3");
        self.headerIV.image = HyBundleImage(@"idcardHeader2");
    }else if ([model.license_item_code isEqualToString:@"100043701"]) { // ??????????????????
        self.mainIV.image = HyBundleImage(@"idcard13");
        self.headerIV.image = HyBundleImage(@"idcardHeader1");
    }else if ([model.license_item_code isEqualToString:@"105003101"]) {// ???????????????????????????
        self.mainIV.image = HyBundleImage(@"idcard8");
        self.headerIV.image = HyBundleImage(@"idcardHeader7");
    }else if ([model.license_item_code isEqualToString:@"106006501"]) { // ???????????????????????????
        self.mainIV.image = HyBundleImage(@"idcard10");
        self.headerIV.image = HyBundleImage(@"idcardHeader9");
    }else if ([model.license_item_code isEqualToString:@"110002301"]) { // ?????????????????????
        self.mainIV.image = HyBundleImage(@"idcard9");
        self.headerIV.image = HyBundleImage(@"idcardHeader8");
    }else if ([model.license_item_code isEqualToString:@"100007801"]) { // ???????????????????????????
        self.mainIV.image = HyBundleImage(@"idcard6");
        self.headerIV.image = HyBundleImage(@"idcardHeader5");
    }else if ([model.license_item_code isEqualToString:@"501006601"]) {// ???????????????????????????????????????
        self.mainIV.image = HyBundleImage(@"idcard11");
        self.headerIV.image = HyBundleImage(@"idcardHeader10");
    }else if ([model.license_item_code isEqualToString:@"110003901"]) { // ????????????????????????
        self.mainIV.image = HyBundleImage(@"idcard12");
        self.headerIV.image = HyBundleImage(@"idcardHeader1");
    }else if ([model.license_item_code isEqualToString:@"100001701"]) { // ?????????????????????
        self.mainIV.image = HyBundleImage(@"idcard7");
        self.headerIV.image = HyBundleImage(@"idcardHeader6");
    }else if ([model.license_item_code isEqualToString:@"110"]) { // ??????
        self.mainIV.image = HyBundleImage(@"idcard14");
        self.headerIV.image = HyBundleImage(@"netCerti");
    }
    if (model.issue_date) {
        self.timeLabel.text = [model.issue_date substringToIndex:10];
    }
    self.cardNameLabel.text = model.name;
//    self.cardNumberLabel.text = @"**********";
    if (model.id_code.length > 9) {
        self.cardNumberLabel.text = [self setNoSeeText:model.id_code first:6 last:3];
    }
    
    if ([model.license_item_code isEqualToString:@"110"]) {
        self.cardNumberLabel.text = model.id_code;
    }
    
    
}

- (NSString *)setNoSeeText:(NSString *)text first:(NSInteger)first last:(NSInteger)last {
    
    NSString *newText = @"";
    for (int i = 0; i < text.length; i++) {
        
        NSString *itemString = [text substringWithRange:NSMakeRange(i, 1)];
        if (i < first) {
            newText = [newText stringByAppendingString:itemString];
        }else if (i >= text.length - last) {
            newText = [newText stringByAppendingString:itemString];
        }else {
            newText = [newText stringByAppendingString:@"*"];
        }
    }
    
    return newText;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.timeLineIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(37);
        make.top.equalTo(self.contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLineIV.mas_right).offset(13);
        make.centerY.equalTo(self.timeLineIV.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLineIV.mas_bottom);
        make.centerX.equalTo(self.timeLineIV.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(1);
    }];
    
    CGFloat kscreenWith = [UIScreen mainScreen].bounds.size.width;
    [self.mainIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLineIV.mas_bottom).offset(17);
        make.left.equalTo(self.contentView.mas_left).offset(64);
        make.right.equalTo(self.contentView.mas_right).offset(-26);
        make.height.mas_equalTo((kscreenWith - 90) * 0.41);
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainIV.mas_left).offset(13);
        make.top.equalTo(self.mainIV.mas_top).offset(14);
        make.size.mas_equalTo(CGSizeMake(41, 41));
    }];
    
    [self.cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(12);
        make.top.equalTo(self.headerIV.mas_top).offset(4);
    }];
    
    [self.cardNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(12);
        make.bottom.equalTo(self.headerIV.mas_bottom);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.mainIV);
        make.height.mas_equalTo(33);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.centerY.equalTo(self.bottomView.mas_centerY);
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.right.equalTo(self.bottomView.mas_right).offset(-14);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
