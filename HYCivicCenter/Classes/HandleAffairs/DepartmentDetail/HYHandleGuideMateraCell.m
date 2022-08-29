//
//  HYHandleGuideMateraCell.m
//  HelloFrame
//
//  Created by 谌孙望 on 2022/4/12.
//

#import "HYHandleGuideMateraCell.h"
#import "HYCivicCenterCommand.h"

@interface HYHandleGuideMateraCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HYHandleGuideMateraCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 16, 16));
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HYMateraCellTableViewCell class] forCellReuseIdentifier:@"HYMateraCellTableViewCell"];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColor.whiteColor;
    self.tableView.backgroundColor = UIColor.whiteColor;
}

- (void)setMaterials:(NSArray *)materials {
    if (materials) {
        _materials = materials;
        [self.tableView reloadData];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _materials.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYMateraCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYMateraCellTableViewCell" forIndexPath:indexPath];
    cell.model = _materials[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 16;
}

@end


@interface HYMateraCellTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;  // 材料名称
@property (nonatomic, strong) UILabel *mustLabel;  // 必填
@property (nonatomic, strong) UILabel *lackLabel;  // 支持容缺处理
@property (nonatomic, strong) UILabel *commitmentLabel;  // 支持承诺审批
@property (nonatomic, strong) UILabel *lackAndCommitLabel;  // 支持容缺处理和承诺审批

@end


@implementation HYMateraCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        [self traitCollectionDidChange:nil];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    self.nameLabel = [[UILabel alloc] init];
    self.mustLabel = [[UILabel alloc] init];
    self.lackLabel = [[UILabel alloc] init];
    self.commitmentLabel = [[UILabel alloc] init];
    self.lackAndCommitLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.mustLabel];
    [self.contentView addSubview:self.lackLabel];
    [self.contentView addSubview:self.commitmentLabel];
    [self.contentView addSubview:self.lackAndCommitLabel];
    
    self.nameLabel.font = MFONT(14);
    self.mustLabel.font = MFONT(14);
    self.lackLabel.font = MFONT(14);
    self.commitmentLabel.font = MFONT(14);
    self.lackAndCommitLabel.font = MFONT(14);
    
    self.commitmentLabel.text = [NSString stringWithFormat:@"支持承诺审批：否"];
    
}

- (void)setModel:(HYMaterialModel *)model {
    if (model) {
        _model = model;
        
        self.nameLabel.text = [NSString stringWithFormat:@"材料名称：%@", model.name];
        self.mustLabel.text = [NSString stringWithFormat:@"必填：%@", [model.must isEqualToString:@"1"] ? @"是" : @"否"];
        self.lackLabel.text = [NSString stringWithFormat:@"支持容缺处理：%@", [model.must isEqualToString:@"2"] ? @"是" : @"否"];
        self.lackAndCommitLabel.text = [NSString stringWithFormat:@"支持容缺处理和承诺审批：%@", [model.must isEqualToString:@"1"] ? @"否" : @"是"];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    [self.mustLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.right.height.equalTo(self.nameLabel);
    }];
    [self.lackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mustLabel.mas_bottom);
        make.left.right.height.equalTo(self.nameLabel);
    }];
    [self.commitmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lackLabel.mas_bottom);
        make.left.right.height.equalTo(self.nameLabel);
    }];
    [self.lackAndCommitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commitmentLabel.mas_bottom);
        make.left.right.height.equalTo(self.nameLabel);
    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.backgroundColor = UIColor.whiteColor;
    self.nameLabel.textColor = UIColorFromRGB(0x999999);
    self.mustLabel.textColor = UIColorFromRGB(0x999999);
    self.lackLabel.textColor = UIColorFromRGB(0x999999);
    self.commitmentLabel.textColor = UIColorFromRGB(0x999999);
    self.lackAndCommitLabel.textColor = UIColorFromRGB(0x999999);
}

@end
