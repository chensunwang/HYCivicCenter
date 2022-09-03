//
//  SearchStationTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/10/25.
//

#import "SearchStationTableViewCell.h"
#import "HYCivicCenterCommand.h"

@interface SearchStationTableViewCell ()

@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SearchStationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        self.containView = [[UIView alloc]init];
        self.containView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.containView];
        
        self.headerIV = [[UIImageView alloc]init];
        [self.containView addSubview:self.headerIV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = RFONT(17);
        self.nameLabel.textColor = UIColorFromRGB(0x212121);
        [self.containView addSubview:self.nameLabel];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = UIColorFromRGB(0xE6E6E6);
        [self.containView addSubview:self.lineView];
        
    }
    return self;
    
}

- (void)setLineModel:(HYSearchLineModel *)lineModel {
    _lineModel = lineModel;
    
    self.headerIV.image = HyBundleImage(@"busRoute");
    self.nameLabel.text = lineModel.lineName?:@"";
    
}

- (void)setStationModel:(HYSearchStationModel *)stationModel {
    _stationModel = stationModel;
    
    self.headerIV.image = HyBundleImage(@"station");
    self.nameLabel.text = stationModel.stationName;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(12);
        make.centerY.equalTo(self.containView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(10);
        make.centerY.equalTo(self.containView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(16);
        make.bottom.equalTo(self.containView.mas_bottom);
        make.right.equalTo(self.containView.mas_right).offset(-16);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
