//
//  HYBaseInfoTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2022/1/12.
//

#import "HYBaseInfoTableViewCell.h"

@interface HYBaseInfoTableViewCell ()<UITextFieldDelegate>

@end

@implementation HYBaseInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = MFONT(14);
        [self.contentView addSubview:self.nameLabel];
        
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.font = MFONT(14);
        self.rightLabel.hidden = YES;
        [self.contentView addSubview:self.rightLabel];
        
        self.rightTF = [[UITextField alloc] init];
        self.rightTF.font = MFONT(14);
        self.rightTF.hidden = YES;
        self.rightTF.returnKeyType = UIReturnKeyDone;
        self.rightTF.delegate = self;
        [self.contentView addSubview:self.rightTF];
        
        self.lineView = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView];
        
        [self traitCollectionDidChange:nil];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.equalTo(self);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(110);
        make.centerY.equalTo(self);
    }];
    
    [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(110);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField.text.length > 0) {
        if (self.baseInfoTableViewCellBlock != nil) {
            self.baseInfoTableViewCellBlock(textField.text);
        }
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColor.whiteColor;
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    self.rightLabel.textColor = UIColorFromRGB(0x999999);
    self.rightTF.textColor = UIColorFromRGB(0x999999);
    self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



#import "XFLRButton.h"

@interface HYRadioFormTableViewCell ()

@property (nonatomic, strong) UIButton * currentBtn;

@end

@implementation HYRadioFormTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = MFONT(14);
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.numberOfLines = 0;
        [self.contentView addSubview:self.nameLabel];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.contentView addSubview:self.lineView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setInfoModel:(HYFormInfoModel *)infoModel {
    _infoModel = infoModel;
    self.nameLabel.text = infoModel.fieldName;
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i < infoModel.fieldValueList.count; i++) {
        HYFormInfoModel *fieldModel = infoModel.fieldValueList[i];
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"radio_unSel"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"radio_sel"] forState:UIControlStateSelected];
        [button setTitle:fieldModel.fieldKey forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font = MFONT(14);
        [button addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(16 + i * 100, 45, 100, 30);
        [self.contentView addSubview:button];
        
        if ([infoModel.fieldValue isEqualToString:@"1"] && [fieldModel.fieldKey isEqualToString:@"是"]) {
            button.selected = YES;
        }
        if ([infoModel.fieldValue isEqualToString:@"0"] && [fieldModel.fieldKey isEqualToString:@"否"]) {
            button.selected = YES;
        }
    }
    
}

- (void)titleClicked:(UIButton *)button {
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setSelected:NO];
        }
    }
    
    button.selected = YES;
    
    for (HYFormInfoModel *model in _infoModel.fieldValueList) {
        if ([model.fieldKey isEqualToString:button.titleLabel.text]) {
            if (self.radioFormTableViewCellBlock != nil) {
                self.radioFormTableViewCellBlock(model.fieldValue);
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(16);
        make.right.equalTo(self).offset(-16);
    }];
    
}

@end




@interface HYBaseInfoTextFieldCell ()<UITextFieldDelegate>

@end

@implementation HYBaseInfoTextFieldCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = MFONT(14);
        self.nameLabel.textColor = UIColorFromRGB(0x333333);
        self.nameLabel.numberOfLines = 0;
        [self.contentView addSubview:self.nameLabel];
        
        self.textField = [[UITextField alloc] init];
        self.textField.font = MFONT(14);
        self.textField.textColor = UIColorFromRGB(0x999999);
        self.textField.placeholder = @"请输入你要填写的资料";
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.delegate = self;
        [self.contentView addSubview:self.textField];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.contentView addSubview:self.lineView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.bottom.equalTo(self).offset(-16);
        make.height.mas_equalTo(14);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(16);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.bottom.equalTo(self.textField.mas_top).offset(-10);
    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField.text.length > 0) {
        if (self.baseInfoTextFieldCellBlock != nil) {
            self.baseInfoTextFieldCellBlock(textField.text);
        }
    }
}

@end
