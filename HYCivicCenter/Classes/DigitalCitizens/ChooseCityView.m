//
//  ChooseCityView.m
//  HelloFrame
//
//  Created by nuchina on 2021/9/26.
//

#import "ChooseCityView.h"
#import "ChooseCityTableViewCell.h"
#import "HYCivicCenterCommand.h"
#import "UIView+YXAdd.h"

@interface ChooseCityView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *provinceTableView;
@property (nonatomic, strong) UITableView *cityTableView;
@property (nonatomic, strong) UITableView *areaTableView;
@property (nonatomic, strong) NSMutableArray *provinceArr;
@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) NSMutableArray *areaArr;
@property (nonatomic, copy) NSString *chooseProvince;
@property (nonatomic, copy) NSString *chooseCity;
@property (nonatomic, copy) NSString *chooseName;
@property (nonatomic, copy) NSString *chooseCode;

@end

NSString *const provinceCell = @"province";
NSString *const citycell = @"cityCell";
NSString *const areaCell = @"areaCell";

@implementation ChooseCityView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backView = [[UIView alloc]init];
        self.backView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self.backView addGestureRecognizer:tap];
        self.backView.alpha = 0.5;
        [self addSubview:self.backView];
        
        self.contentView = [[UIView alloc]init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        self.topView = [[UIView alloc]init];
        self.topView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.topView];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = UIColorFromRGB(0x333333);
        nameLabel.font = RFONT(16);
        nameLabel.text = @"选择城市";
        [self.topView addSubview:nameLabel];
        
        UIButton *confirmBtn = [[UIButton alloc]init];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = RFONT(16);
        [confirmBtn addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:confirmBtn];
        
        [self.provinceTableView registerClass:[ChooseCityTableViewCell class] forCellReuseIdentifier:provinceCell];
        [self.cityTableView registerClass:[ChooseCityTableViewCell class] forCellReuseIdentifier:citycell];
        [self.areaTableView registerClass:[ChooseCityTableViewCell class] forCellReuseIdentifier:areaCell];
        [self.contentView addSubview:self.provinceTableView];
        [self.contentView addSubview:self.cityTableView];
        [self.contentView addSubview:self.areaTableView];
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.backView);
            make.height.mas_equalTo(400);
        }];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.mas_equalTo(50);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.topView.mas_centerX);
            make.top.equalTo(self.topView.mas_top);
            make.height.mas_equalTo(50);
        }];
        
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topView.mas_right).offset(-16);
            make.size.mas_equalTo(CGSizeMake(80, 50));
            make.centerY.equalTo(self.topView.mas_centerY);
        }];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 3.0;
        [self.provinceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.topView.mas_bottom);
            make.width.mas_equalTo(width);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        [self.cityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.provinceTableView.mas_right);
            make.top.equalTo(self.topView.mas_bottom);
            make.width.mas_equalTo(width);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        [self.areaTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cityTableView.mas_right);
            make.top.equalTo(self.topView.mas_bottom);
            make.width.mas_equalTo(width);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        NSDictionary *dic = [self readLocalFileWithName:@"city_code"];
        self.provinceArr = [ProvinceModel mj_objectArrayWithKeyValuesArray:dic];
        [self.provinceTableView reloadData];
        
    }
    return self;
    
}

// 读取本地JSON文件
- (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.contentView.kTop = [UIScreen mainScreen].bounds.size.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.provinceTableView) {
        return self.provinceArr.count;
    }else if (tableView == self.cityTableView) {
        return self.cityArr.count;
    }else {
        return self.areaArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.provinceTableView) {
        
        ChooseCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:provinceCell];
        
        cell.provinceModel = self.provinceArr[indexPath.row];
        
        return cell;
        
    }else if (tableView == self.cityTableView) {
        
        ChooseCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:citycell];
        
        cell.cityModel = self.cityArr[indexPath.row];
        
        return cell;
        
    }else {
        
        ChooseCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:areaCell];
        
        cell.areaModel = self.areaArr[indexPath.row];
        
        return cell;
        
    }
    
}

// 确定
- (void)confirmClicked {
    
    if (self.chooseName.length == 0) {
        NSLog(@"请先选择城市");
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(chooseCityWithName:withCode:)]) {
        [self.delegate chooseCityWithName:self.chooseName withCode:self.chooseCode];
    }
    [self dismiss];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.provinceTableView) {
        
        ProvinceModel *model = self.provinceArr[indexPath.row];
//        model.city
        self.cityArr = model.city;
        self.chooseProvince = model.name;
        [self.areaArr removeAllObjects];
        [self.cityTableView reloadData];
        [self.areaTableView reloadData];
        
    }else if (tableView == self.cityTableView) {
        
        CityModel *model = self.cityArr[indexPath.row];
        self.areaArr = model.area;
        self.chooseCity = model.name;
        [self.areaTableView reloadData];
        
    }else {
        
        AreaModel *model = self.areaArr[indexPath.row];
        self.chooseName = [NSString stringWithFormat:@"%@%@%@",self.chooseProvince,self.chooseCity,model.name];
        self.chooseCode = model.code;
        
    }
    
}

- (UITableView *)provinceTableView {
    
    if (!_provinceTableView) {
        _provinceTableView = [[UITableView alloc] init];
        _provinceTableView.backgroundColor = [UIColor whiteColor];
        _provinceTableView.delegate = self;
        _provinceTableView.dataSource = self;
        _provinceTableView.rowHeight = 48;
        _provinceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _provinceTableView.tableFooterView = [[UIView alloc] init];
        _provinceTableView.showsVerticalScrollIndicator = NO;
    }
    return _provinceTableView;
    
}

- (UITableView *)cityTableView {
    
    if (!_cityTableView) {
        _cityTableView = [[UITableView alloc] init];
        _cityTableView.backgroundColor = [UIColor whiteColor];
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;
        _cityTableView.rowHeight = 48;
        _cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cityTableView.tableFooterView = [[UIView alloc] init];
        _cityTableView.showsVerticalScrollIndicator = NO;
    }
    return _cityTableView;
    
}

- (UITableView *)areaTableView {
    
    if (!_areaTableView) {
        _areaTableView = [[UITableView alloc] init];
        _areaTableView.backgroundColor = [UIColor whiteColor];
        _areaTableView.delegate = self;
        _areaTableView.dataSource = self;
        _areaTableView.rowHeight = 48;
        _areaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _areaTableView.tableFooterView = [[UIView alloc] init];
        _areaTableView.showsVerticalScrollIndicator = NO;
    }
    return _areaTableView;
    
}

- (NSMutableArray *)provinceArr {
    
    if (!_provinceArr) {
        _provinceArr = [NSMutableArray array];
    }
    return _provinceArr;
    
}

- (NSMutableArray *)cityArr {
    
    if (!_cityArr) {
        _cityArr = [NSMutableArray array];
    }
    return _cityArr;
    
}

- (NSMutableArray *)areaArr {
    
    if (!_areaArr) {
        _areaArr = [NSMutableArray array];
    }
    return _areaArr;
    
}

@end
