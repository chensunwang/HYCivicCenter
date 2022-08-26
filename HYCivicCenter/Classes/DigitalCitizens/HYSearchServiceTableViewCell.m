//
//  HYSearchServiceTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/22.
//

#import "HYSearchServiceTableViewCell.h"

@interface HYSearchServiceTableViewCell () <UITextFieldDelegate>

@end

@implementation HYSearchServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.mustLabel = [[UILabel alloc]init];
        self.mustLabel.text = @"*";
        self.mustLabel.hidden = YES;
        self.mustLabel.textColor = UIColorFromRGB(0xFF3B3B);
        [self.contentView addSubview:self.mustLabel];
        
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.font = RFONT(14);
        [self.contentView addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.textColor = UIColorFromRGB(0x333333);
        self.contentLabel.font = RFONT(14);
        self.contentLabel.hidden = YES;
        [self.contentView addSubview:self.contentLabel];
        
        self.contentTF = [[UITextField alloc]init];
        self.contentTF.hidden = YES;
        self.contentTF.delegate = self;
        self.contentTF.textColor = UIColorFromRGB(0x333333);
        self.contentTF.font = RFONT(14);
        [self.contentView addSubview:self.contentTF];
        
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.contentView addSubview:self.lineView];
        
//        self.nameLabel.text = @"名字";
//        self.contentLabel.text = @"内容";
        
    }
    return self;
    
}

- (void)setModel:(HYSearchServiceModel *)model {
    _model = model;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.labelName];
    self.contentLabel.text = model.labelValue;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (_saveData) {
        _saveData([textField.text stringByReplacingCharactersInRange:range withString:string]);
    }
    return YES;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.mustLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mustLabel.mas_right);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(110);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.contentTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 110, 5, 16));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
