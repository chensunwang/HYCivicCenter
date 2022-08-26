//
//  HYGoveHeaderView.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/14.
//
//  政务服务首页头部

#import "HYGoveHeaderView.h"
#import "HYServiceProgressModel.h"

@interface HYGoveHeaderView ()

@property (nonatomic, strong) UIImageView * headerImgV;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * scheduleView;
@property (nonatomic, strong) UIImageView * trackImgV;
@property (nonatomic, strong) UILabel * trackLabel;
@property (nonatomic, strong) UIView * firstView;
@property (nonatomic, strong) UILabel * firstTitleLab;
@property (nonatomic, strong) UILabel * firstResultLab;
@property (nonatomic, strong) UIView * secondView;
@property (nonatomic, strong) UILabel * secondTitleLab;
@property (nonatomic, strong) UILabel * secondResultLab;
@property (nonatomic, strong) UIImageView * emptyImageView;
@property (nonatomic, strong) UILabel * emptyLabel;
 
@end

@implementation HYGoveHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
    }
    return self;
}

- (void)setupUI {
    self.headerImgV = [[UIImageView alloc] init];
    self.backBtn = [[UIButton alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.searchView = [[HYSearchView alloc] init];
    self.scheduleView = [[UIView alloc] init];
    self.trackImgV = [[UIImageView alloc] init];
    self.trackLabel = [[UILabel alloc] init];
    self.moreButton = [[UIButton alloc] init];
    self.firstView = [[UIView alloc] init];
    self.firstTitleLab = [[UILabel alloc] init];
    self.firstResultLab = [[UILabel alloc] init];
    self.secondView = [[UIView alloc] init];
    self.secondTitleLab = [[UILabel alloc] init];
    self.secondResultLab = [[UILabel alloc] init];
    self.emptyImageView = [[UIImageView alloc] init];
    self.emptyLabel = [[UILabel alloc] init];
    
    [self addSubview:_headerImgV];
    [self.headerImgV addSubview:_backBtn];
    [self.headerImgV addSubview:_titleLabel];
    [self.headerImgV addSubview:_searchView];
    [self addSubview:_scheduleView];
    [self.scheduleView addSubview:_trackImgV];
    [self.scheduleView addSubview:_trackLabel];
    [self.scheduleView addSubview:_moreButton];
    [self.scheduleView addSubview:_firstView];
    [self.firstView addSubview:_firstTitleLab];
    [self.firstView addSubview:_firstResultLab];
    [self.scheduleView addSubview:_secondView];
    [self.secondView addSubview:_secondTitleLab];
    [self.secondView addSubview:_secondResultLab];
    [self.scheduleView addSubview:_emptyImageView];
    [self.scheduleView addSubview:_emptyLabel];
    
    [self.headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(174 + kTopNavHeight);
    }];
    self.headerImgV.image = [UIImage imageNamed:@"icon_gove_home"];
    self.headerImgV.userInteractionEnabled = YES;
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(kStatusBarHeight + 13);
        make.width.height.mas_equalTo(18);
    }];
    [self.backBtn setImage:[UIImage imageNamed:@"naviBack"] forState:UIControlStateNormal];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(17);
        make.top.mas_equalTo(kStatusBarHeight + 14);
        make.width.mas_equalTo(SCREEN_WIDTH - 50);
    }];
    self.titleLabel.text = @"政务服务";
    self.titleLabel.font = MFONT(18);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(23);
        make.left.right.equalTo(self.headerImgV);
        make.height.mas_equalTo(32);
    }];
    
    [self.scheduleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(25);
        make.left.mas_equalTo(16);
        make.right.equalTo(self.headerImgV).offset(-16);
        make.bottom.equalTo(self).offset(-10);
    }];
    // 添加阴影
    self.scheduleView.layer.shadowColor = UIColorFromRGB(0x0E55B3).CGColor;//shadowColor阴影颜色
    self.scheduleView.layer.shadowOffset = CGSizeMake(4, 4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.scheduleView.layer.shadowOpacity = 0.4;//阴影透明度，默认0
    self.scheduleView.layer.shadowRadius = 4;//阴影半径，默认3
    
    [self.trackImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.width.height.mas_equalTo(18);
    }];
    self.trackImgV.image = [UIImage imageNamed:@"icon_gove_percent"];
    
    [self.trackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.trackImgV.mas_right).offset(6);
        make.centerY.equalTo(self.trackImgV);
        make.height.mas_equalTo(15);
    }];
    self.trackLabel.text = @"进度跟踪";
    self.trackLabel.font = MFONT(15);
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.trackImgV);
        make.right.equalTo(self.scheduleView).offset(-17);
    }];
    self.moreButton.titleLabel.font = MFONT(12);
    [self.moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:@"icon_gov_more"] forState:UIControlStateNormal];
    [self.moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -17, 0, 17)];
    [self.moreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 45, 0, -45)];
    
    [self.firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.equalTo(self.trackImgV.mas_bottom).offset(18);
        make.right.equalTo(self.scheduleView).offset(-16);
        make.height.mas_equalTo(40);
    }];
    self.firstView.layer.cornerRadius = 4;
    self.firstView.hidden = YES;
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstViewClicked:)];
    [self.firstView addGestureRecognizer:firstTap];
    
    [self.firstTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.centerY.equalTo(self.firstView);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(SCREEN_WIDTH - 90 - 100);
    }];
    self.firstTitleLab.font = MFONT(12);
    self.firstTitleLab.text = @"暂无更多数据";
    
    [self.firstResultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.firstView);
        make.right.equalTo(self.firstView).offset(-13);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(90);
    }];
    self.firstResultLab.textAlignment = NSTextAlignmentRight;
    self.firstResultLab.font = MFONT(12);
    self.firstResultLab.text = @"";
    
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.bottom.equalTo(self.scheduleView).offset(-16);
        make.right.height.equalTo(self.firstView);
    }];
    self.secondView.layer.cornerRadius = 4;
    self.secondView.hidden = YES;
    UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondViewClicked:)];
    [self.secondView addGestureRecognizer:secondTap];
    
    [self.secondTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.centerY.equalTo(self.secondView);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(SCREEN_WIDTH - 90 - 100);
    }];
    self.secondTitleLab.font = MFONT(12);
    self.secondTitleLab.text = @"暂无更多数据";
    
    [self.secondResultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.secondView);
        make.right.equalTo(self.secondView).offset(-13);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(90);
    }];
    self.secondResultLab.textAlignment = NSTextAlignmentRight;
    self.secondResultLab.font = MFONT(12);
    self.secondResultLab.text = @"";
    
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scheduleView);
        make.centerY.equalTo(self.scheduleView).offset(5);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(60);
    }];
    self.emptyImageView.image = [UIImage imageNamed:@"cardHolder"];
    
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scheduleView);
        make.bottom.equalTo(self.secondView);
    }];
    self.emptyLabel.text = @"暂无已办理事项";
    self.emptyLabel.font = MFONT(12);
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColor.whiteColor;
    self.titleLabel.textColor = UIColor.whiteColor;
    self.trackLabel.textColor = UIColorFromRGB(0x333333);
    self.scheduleView.backgroundColor = UIColor.whiteColor;
    [self.moreButton setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
    self.firstView.backgroundColor = UIColorFromRGB(0xF5F7FA);
    self.firstTitleLab.textColor = UIColorFromRGB(0x333333);
    self.secondView.backgroundColor = UIColorFromRGB(0xF5F7FA);
    self.secondTitleLab.textColor = UIColorFromRGB(0x333333);
    self.emptyLabel.textColor = UIColorFromRGB(0x999999);
}

- (void)setDataArr:(NSArray *)dataArr {
    if (dataArr) {
        _dataArr = dataArr;
        
        if (dataArr.count == 0) {
            self.firstView.hidden = YES;
            self.secondView.hidden = YES;
            self.emptyImageView.hidden = NO;
            self.emptyLabel.hidden = NO;
        }

        if (dataArr.count > 0) {
            self.firstView.hidden = NO;
            self.secondView.hidden = YES;
            self.emptyImageView.hidden = YES;
            self.emptyLabel.hidden = YES;

            HYServiceProgressModel *model1 = [dataArr firstObject];
            self.firstTitleLab.text = model1.itemName;
            self.firstResultLab.text = model1.stateName;
            if ([model1.stateColor isEqualToString:@"yellow"]) {
                self.firstResultLab.textColor = UIColorFromRGB(0xFE8601);
            } else if ([model1.stateColor isEqualToString:@"red"]) {
                self.firstResultLab.textColor = UIColorFromRGB(0xFD5C66);
            } else if ([model1.stateColor isEqualToString:@"blue"]) {
                self.firstResultLab.textColor = UIColorFromRGB(0x157AFF);
            }
        }

        if (dataArr.count > 1) {
            self.secondView.hidden = NO;

            HYServiceProgressModel *model2 = dataArr[1];
            self.secondTitleLab.text = model2.itemName;
            self.secondResultLab.text = model2.stateName;
            if ([model2.stateColor isEqualToString:@"yellow"]) {
                self.secondResultLab.textColor = UIColorFromRGB(0xFE8601);
            } else if ([model2.stateColor isEqualToString:@"red"]) {
                self.secondResultLab.textColor = UIColorFromRGB(0xFD5C66);
            } else if ([model2.stateColor isEqualToString:@"blue"]) {
                self.secondResultLab.textColor = UIColorFromRGB(0x157AFF);
            }
        }
    }
}

- (void)firstViewClicked:(UITapGestureRecognizer *)tap {
    if (self.goveHeaderViewBlock) {
        self.goveHeaderViewBlock(0);
    }
}

- (void)secondViewClicked:(UITapGestureRecognizer *)tap {
    if (self.goveHeaderViewBlock) {
        self.goveHeaderViewBlock(1);
    }
}

@end
