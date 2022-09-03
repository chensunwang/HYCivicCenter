//
//  EditBusinessCardTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/19.
//

#import "EditBusinessCardTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface EditBusinessCardTableViewCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation EditBusinessCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x999999);
        self.nameLabel.font = RFONT(14);
        [self.contentView addSubview:self.nameLabel];
        
        self.rightLabel = [[UILabel alloc]init];
        self.rightLabel.textColor = UIColorFromRGB(0x333333);
        self.rightLabel.font = RFONT(15);
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.rightLabel];
        
        self.rightTF = [[UITextField alloc]init];
        self.rightTF.textAlignment = NSTextAlignmentRight;
        self.rightTF.textColor = UIColorFromRGB(0x333333);
        self.rightTF.font = RFONT(15);
        [self.contentView addSubview:self.rightTF];
        
        self.headerIV = [[UIImageView alloc]init];
        self.headerIV.layer.cornerRadius = 4;
        self.headerIV.clipsToBounds = YES;
        self.headerIV.layer.borderWidth = 0.5;
        self.headerIV.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
        [self.contentView addSubview:self.headerIV];
        
        self.holderIV = [[UIImageView alloc]init];
        self.holderIV.image = HyBundleImage(@"headHolder");
        [self.headerIV addSubview:self.holderIV];
        
        self.tipLabel = [[UILabel alloc]init];
        self.tipLabel.textColor = UIColorFromRGB(0x999999);
        self.tipLabel.font = RFONT(12);
        self.tipLabel.text = @"请上传头像";
        [self.contentView addSubview:self.tipLabel];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.contentView addSubview:self.lineView];
        
        self.rightLabel.hidden = YES;
        self.rightTF.hidden = YES;
        self.headerIV.hidden = YES;
        self.holderIV.hidden = YES;
        self.tipLabel.hidden = YES;
        
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.height.mas_equalTo(50);
        make.left.equalTo(self.nameLabel.mas_right).offset(20);
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.holderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerIV.mas_centerX);
        make.centerY.equalTo(self.headerIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerIV.mas_left).offset(-14.5);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation EditBusinessCardModel



@end
