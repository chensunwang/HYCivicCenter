//
//  RideRecordTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/13.
//

#import "RideRecordTableViewCell.h"
#import "HYCivicCenterCommand.h"

@implementation RideRecordModel



@end

@interface RideRecordTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *payLabel;
@property (nonatomic, strong) UILabel *rideTimeLabel;
@property (nonatomic, strong) UILabel *payTimeLabel;

@end

@implementation RideRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 8;
        self.bgView.clipsToBounds = YES;
        [self.contentView addSubview:self.bgView];
        
        self.headerIV = [[UIImageView alloc]init];
        [self.bgView addSubview:self.headerIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = RFONT(17);
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        [self.bgView addSubview:self.nameLabel];
        
        self.payLabel = [[UILabel alloc]init];
        self.payLabel.backgroundColor = UIColorFromRGB(0xE5F1FF);
        self.payLabel.layer.cornerRadius = 2;
        self.payLabel.clipsToBounds = YES;
        self.payLabel.textColor = UIColorFromRGB(0x157AFF);
        self.payLabel.font = RFONT(11);
        self.payLabel.text = @"已支付";
        self.payLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.payLabel];
        
        self.rideTimeLabel = [[UILabel alloc]init];
        self.rideTimeLabel.font = RFONT(13);
        self.rideTimeLabel.textColor = UIColorFromRGB(0x666666);
        [self.bgView addSubview:self.rideTimeLabel];
        
        self.payTimeLabel = [[UILabel alloc]init];
        self.payTimeLabel.textColor = UIColorFromRGB(0x666666);
        self.payTimeLabel.font = RFONT(13);
        [self.bgView addSubview:self.payTimeLabel];
     
        self.headerIV.image = [UIImage imageNamed:BundleFile(@"ride")];
        self.nameLabel.text = @"公交";
        self.rideTimeLabel.text = @"乘车时间：2021-07-10 19:39:18 ~ 19:55:16";
        self.payTimeLabel.text = @"支付时间：2021-07-10 19:55:17";
        
    }
    return self;
    
}

- (void)setModel:(RideRecordModel *)model {
    _model = model;
    
    self.nameLabel.text = @"公交";
    self.rideTimeLabel.text = model.orderDesc;
    self.payTimeLabel.text = model.txnTime;
    if (model.payState.intValue == 1) { // 已支付 0未支付
        self.payLabel.backgroundColor = UIColorFromRGB(0xE5F1FF);
        self.payLabel.textColor = UIColorFromRGB(0x157AFF);
        self.payLabel.text = @"已支付";
    }else {
        self.payLabel.backgroundColor = UIColorFromRGB(0xFFF3E5);
        self.payLabel.textColor = UIColorFromRGB(0xFE8601);
        self.payLabel.text = @"未支付";
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 16, 8, 16));
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.top.equalTo(self.bgView.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(8.5);
        make.centerY.equalTo(self.headerIV.mas_centerY);
    }];
    
    [self.payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.top.equalTo(self.bgView.mas_top).offset(18);
        make.size.mas_equalTo(CGSizeMake(45, 18));
    }];
    
    [self.rideTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.top.equalTo(self.headerIV.mas_bottom).offset(13.5);
    }];
    
    [self.payTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-19);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
