//
//  HYCommonProblemTableViewCell.m
//  HelloFrame
//
//  Created by nuchina on 2022/1/10.
//

#import "HYCommonProblemTableViewCell.h"

@interface HYCommonProblemTableViewCell ()

@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UIImageView *qustionIV;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UIImageView *answerIV;
@property (nonatomic, strong) UILabel *answerLabel;

@end

@implementation HYCommonProblemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        [self setupUI];
        
        [self traitCollectionDidChange:nil];
    }
    return self;
    
}

- (void)setupUI {
    self.containView = [[UIView alloc] init];
    self.containView.layer.cornerRadius = 5;
    self.containView.clipsToBounds = YES;
    [self.contentView addSubview:self.containView];
    
    self.qustionIV = [[UIImageView alloc] init];
    self.qustionIV.image = [UIImage imageNamed:@"icon_question"];
    [self.containView addSubview:self.qustionIV];
    
    self.questionLabel = [[UILabel alloc] init];
    self.questionLabel.font = MFONT(14);
    
    self.questionLabel.numberOfLines = 0;
    [self.containView addSubview:self.questionLabel];
    
    self.answerIV = [[UIImageView alloc] init];
    self.answerIV.image = [UIImage imageNamed:@"icon_answer"];
    [self.containView addSubview:self.answerIV];
    
    self.answerLabel = [[UILabel alloc] init];
    self.answerLabel.font = MFONT(15);
    self.answerLabel.numberOfLines = 0;
    [self.containView addSubview:self.answerLabel];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.containView.backgroundColor = [UIColor whiteColor];
    self.questionLabel.textColor = UIColorFromRGB(0x666666);
    self.answerLabel.textColor = UIColorFromRGB(0x333333);
}

- (void)setProblemModel:(HYQuestionModel *)problemModel {
    _problemModel = problemModel;
    
    self.questionLabel.text = problemModel.question;
    self.answerLabel.text = problemModel.answer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 16, 8, 16));
    }];
    
    [self.qustionIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(16);
        make.top.equalTo(self.containView.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.qustionIV.mas_right).offset(10);
        make.top.equalTo(self.containView.mas_top).offset(16);
        make.right.equalTo(self.containView.mas_right).offset(-16);
    }];
    
    [self.answerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containView.mas_left).offset(16);
        make.top.equalTo(self.questionLabel.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.answerIV.mas_right).offset(10);
        make.top.equalTo(self.answerIV.mas_top);
        make.right.equalTo(self.containView.mas_right).offset(-16);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
