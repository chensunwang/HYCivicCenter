//
//  HYLegalAidTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/17.
//

#import "HYLegalAidTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface HYLegalAidTableViewCell ()

//@property (nonatomic, strong) UIControl *topControl;
@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UIImageView *indicateIV;
//@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) UILabel *subNameLabel;
//@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation ExpandModel



@end

@implementation HYLegalAidTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
//        self.topControl = [[UIControl alloc]init];
//        [self.contentView addSubview:self.topControl];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = RFONT(14);
        self.nameLabel.numberOfLines = 0;
        [self.contentView addSubview:self.nameLabel];

//        self.indicateIV = [[UIImageView alloc]init];
//        [self.topControl addSubview:self.indicateIV];
        
//        self.lineView = [[UIView alloc]init];
//        self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
//        [self.contentView addSubview:self.lineView];
        
//        self.subNameLabel = [[UILabel alloc]init];
//        self.subNameLabel.textColor = UIColorFromRGB(0x999999);
//        self.subNameLabel.font = RFONT(14);
//        [self.contentView addSubview:self.subNameLabel];
//
//        self.bottomLineView = [[UIView alloc]init];
//        self.bottomLineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
//        [self.contentView addSubview:self.bottomLineView];
        
    }
    return self;
    
}

- (void)setExpandModel:(ExpandModel *)expandModel {
    _expandModel = expandModel;
    
    if ([@(expandModel.type).stringValue isEqualToString:@"1"]) {
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
    }else {
        self.nameLabel.textColor = UIColorFromRGB(0x999999);
    }
    self.nameLabel.text = expandModel.name;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [self.topControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self.contentView);
//        make.height.mas_equalTo(44);
//    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
//    [self.indicateIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.topControl.mas_right).offset(-16);
//        make.centerY.equalTo(self.topControl.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(12, 7));
//    }];
    
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.topControl.mas_left).offset(16);
//        make.right.equalTo(self.topControl.mas_right).offset(-16);
//        make.bottom.equalTo(self.topControl.mas_bottom);
//        make.height.mas_equalTo(0.5);
//    }];
//    
//    [self.subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(16);
//        make.top.equalTo(self.topControl.mas_bottom).offset(16);
//        make.right.equalTo(self.contentView.mas_right).offset(-16);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-16);
//    }];
//    
//    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(16);
//        make.right.equalTo(self.contentView.mas_right).offset(-16);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.height.mas_equalTo(0.5);
//    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
