//
//  HonorWallTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/12.
//

#import "HonorWallTableViewCell.h"
#import "HYCivicCenterCommand.h"

@class HonorWallModel;

@interface HonorWallTableViewCell ()

@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *describLabel;
@property (nonatomic, strong) UIImageView *photoIV;

@end

@implementation HonorWallModel



@end

@implementation HonorWallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentV = [[UIView alloc]init];
        self.contentV.backgroundColor = [UIColor whiteColor];
        self.contentV.layer.cornerRadius = 8;
        self.contentV.clipsToBounds = YES;
        [self.contentView addSubview:self.contentV];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = RFONT(16);
        [self.contentV addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textColor = UIColorFromRGB(0x999999);
        self.timeLabel.font = RFONT(12);
        [self.contentV addSubview:self.timeLabel];
        
        self.deleteBtn = [[UIButton alloc]init];
        [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentV addSubview:self.deleteBtn];
        
        self.describLabel = [[UILabel alloc]init];
        self.describLabel.font = RFONT(12);
        self.describLabel.textColor = UIColorFromRGB(0x666666);
        self.describLabel.numberOfLines = 0;
        [self.contentV addSubview:self.describLabel];
        
        self.photoIV = [[UIImageView alloc]init];
        self.photoIV.layer.cornerRadius = 8;
        self.photoIV.clipsToBounds = YES;
        self.photoIV.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentV addSubview:self.photoIV];
        
//        self.nameLabel.text = @"第13届红点设计大奖";
//        self.timeLabel.text = @"上传时间：2021-07-20 14:51:32";
//        self.describLabel.text = @"红点设计大奖，是由德国设计协会创立，已有超过60年的历史，通过对产品设计，传达设计以及设计概念的竞赛，每年吸引了超过60个国家，1万件作品投稿参赛，得奖的作品可以获得在德国埃森的红点博物馆展出作品以...";
//        self.photoIV.backgroundColor = [UIColor yellowColor];
        
    }
    return  self;
    
}

- (void)setModel:(HonorWallModel *)model {
    _model = model;
    
    self.nameLabel.text = model.honorName;
    self.timeLabel.text = [NSString stringWithFormat:@"上传时间：%@",model.createTime];
    self.describLabel.text = model.honorRemark;
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:model.honorPhotoOne]];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 16, 8, 16));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentV.mas_left).offset(15.5);
        make.top.equalTo(self.contentV.mas_top).offset(20);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentV.mas_left).offset(15.5);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15.5);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentV.mas_right).offset(-16);
        make.top.equalTo(self.contentV.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.photoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentV.mas_left).offset(16);
        make.right.equalTo(self.contentV.mas_right).offset(-16);
        make.bottom.equalTo(self.contentV.mas_bottom).offset(-16);
        make.height.mas_equalTo(([UIScreen mainScreen].bounds.size.width - 64) * 0.58);
    }];
    
    [self.describLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentV.mas_left).offset(16);
        make.right.equalTo(self.contentV.mas_right).offset(-16);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(18);
    }];
    
}

- (void)deleteClicked {
    
    if ([self.delegate respondsToSelector:@selector(honorCell:didDeleteWithModel:)]) {
        [self.delegate honorCell:self didDeleteWithModel:self.model];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
