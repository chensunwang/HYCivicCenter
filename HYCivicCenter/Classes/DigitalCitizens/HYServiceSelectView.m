//
//  HYServiceSelectView.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/26.
//

#import "HYServiceSelectView.h"
#import "HYSearchServiceModel.h"

@interface HYServiceSelectView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, copy) NSString *selectedCode;
@property (nonatomic, copy) NSString *selectedValue;

@end

@implementation HYServiceSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        self.backView = [[UIView alloc]init];
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.alpha = 0.5;
        [self.backView addGestureRecognizer:tap];
        [self addSubview:self.backView];
        
        self.contentView = [[UIView alloc]init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        
        self.topView = [[UIView alloc]init];
        self.topView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self.contentView addSubview:self.topView];
        
        self.confirmBtn = [[UIButton alloc]init];
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
        self.confirmBtn.titleLabel.font = RFONT(16);
        [self.confirmBtn addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:self.confirmBtn];
        
        self.cancelBtn = [[UIButton alloc]init];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:UIColorFromRGB(0x157AFF) forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = RFONT(16);
        [self.cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:self.cancelBtn];
        
        [self.contentView addSubview:self.pickerView];
        
    }
    return self;
    
}

- (void)setDatasArr:(NSArray *)datasArr {
    _datasArr = datasArr;
    
    if (datasArr.count > 0) {
        HYServiceChildrenModel *childrenModel = datasArr[0];
        self.selectedValue = childrenModel.dictLabel;
        self.selectedCode = childrenModel.dictValue;
    }
    [self.pickerView reloadAllComponents];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(400);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.top.equalTo(self.topView.mas_top);
        make.size.mas_equalTo(CGSizeMake(80, 50));
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(10);
        make.top.equalTo(self.topView.mas_top);
        make.size.mas_equalTo(CGSizeMake(80, 50));
    }];
    
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(350);
    }];
    
}

- (void)confirmClicked {
    
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceSelectType:selectValue:selectCode:)]) {
        [self.delegate serviceSelectType:self.type selectValue:self.selectedValue selectCode:self.selectedCode];
    }
    
}

- (void)cancelClicked {
    
    [self dismiss];
    
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        self.contentView.kTop = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.datasArr.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    HYServiceChildrenModel *childrenModel = self.datasArr[row];
    return childrenModel.dictLabel;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 50;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        HYServiceChildrenModel *childrenModel = self.datasArr[row];
        self.selectedCode = childrenModel.dictValue;
        self.selectedValue = childrenModel.dictLabel;
    }
    
}

- (UIPickerView *)pickerView {
    
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.tintColor = [UIColor blackColor];
    }
    return _pickerView;
    
}

@end
