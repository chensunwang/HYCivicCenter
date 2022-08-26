//
//  CardDetailTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/20.
//

#import "CardDetailTableViewCell.h"
#import "HYAesUtil.h"

@implementation CardDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        self.whiteView = [[UIView alloc]init];
        self.whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.whiteView];
        
        self.headerIV = [[UIImageView alloc]init];
        [self.whiteView addSubview:self.headerIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x999999);
        self.nameLabel.font = RFONT(15);
        [self.whiteView addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.textColor = UIColorFromRGB(0x333333);
        self.contentLabel.font = RFONT(15);
        [self.whiteView addSubview:self.contentLabel];
        
        self.callBtn = [[UIButton alloc]init];
        [self.callBtn setBackgroundColor:[UIColorFromRGB(0x157AFF) colorWithAlphaComponent:0.1]];
        [self.callBtn setTitle:@"拨打" forState:UIControlStateNormal];
        [self.callBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
        self.callBtn.titleLabel.font = RFONT(12);
        self.callBtn.layer.cornerRadius = 2;
        self.callBtn.clipsToBounds = YES;
        [self.callBtn addTarget:self action:@selector(callClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteView addSubview:self.callBtn];
        
        self.reproduceBtn = [[UIButton alloc]init];
        [self.reproduceBtn setBackgroundColor:[UIColorFromRGB(0x157AFF) colorWithAlphaComponent:0.1]];
        [self.reproduceBtn setTitle:@"复制" forState:UIControlStateNormal];
        [self.reproduceBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
        self.reproduceBtn.titleLabel.font = RFONT(12);
        self.reproduceBtn.layer.cornerRadius = 2;
        self.reproduceBtn.clipsToBounds = YES;
        [self.reproduceBtn addTarget:self action:@selector(reproduceClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteView addSubview:self.reproduceBtn];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.whiteView addSubview:self.lineView];
        
        self.callBtn.hidden = YES;
        self.reproduceBtn.hidden = YES;
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView.mas_left).offset(16);
        make.centerY.equalTo(self.whiteView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(12);
        make.centerY.equalTo(self.whiteView.mas_centerY);
    }];
    
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.whiteView.mas_right).offset(-16);
        make.centerY.equalTo(self.whiteView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 22));
    }];
    
    [self.reproduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.whiteView.mas_right).offset(-16);
        make.centerY.equalTo(self.whiteView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 22));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteView.mas_left).offset(103);
        make.right.equalTo(self.whiteView.mas_right).offset(-83);
        make.centerY.equalTo(self.whiteView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.whiteView);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setCardModel:(EditBusinessCardModel *)cardModel {
    _cardModel = cardModel;
    
    
}

- (void)reproduceClicked:(UIButton *)button {
    
    NSString *string = [HYAesUtil aesDecrypt:self.cardModel.emailEncrypt];
    NSLog(@"解密邮箱== %@",string);
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
    
}

- (void)callClicked:(UIButton *)button {
    
    if (self.contentLabel.text == 0) {
        return;
    }
    
    NSString *phone = [HYAesUtil aesDecrypt:self.cardModel.phoneEncrypt];
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phone]] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phone]]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
