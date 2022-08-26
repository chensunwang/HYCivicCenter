//
//  ChooseCityTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/9/26.
//

#import "ChooseCityTableViewCell.h"

@interface ChooseCityTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation ProvinceModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"city":[CityModel class]};
    
}

@end

@implementation CityModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"area":[AreaModel class]};
    
}

@end

@implementation AreaModel



@end

@implementation ChooseCityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = RFONT(15);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
    
}

- (void)setProvinceModel:(ProvinceModel *)provinceModel {
    _provinceModel = provinceModel;
    
    self.nameLabel.text = provinceModel.name;
    
}

- (void)setCityModel:(CityModel *)cityModel {
    _cityModel = cityModel;
    
    self.nameLabel.text = cityModel.name;
    
}

- (void)setAreaModel:(AreaModel *)areaModel {
    _areaModel = areaModel;
    
    self.nameLabel.text = areaModel.name;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
