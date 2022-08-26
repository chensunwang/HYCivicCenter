//
//  HYDatePickerView.m
//  HelloFrame
//
//  Created by nuchina on 2021/11/29.
//

#import "HYDatePickerView.h"

@interface HYDatePickerView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIDatePicker *pickerView;
@property (nonatomic, copy) NSString *dateStr;

@end

@implementation HYDatePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //设置时间格式
        formatter.dateFormat = @"yyyy-MM-dd";
        self.dateStr = [formatter  stringFromDate:[NSDate date]];
        
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

- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:datePicker.date];
    self.dateStr = dateStr;
    
}

- (void)confirmClicked {
    
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(serviceDatePickerType:selectValue:)]) {
        [self.delegate serviceDatePickerType:self.type selectValue:self.dateStr];
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

- (UIDatePicker *)pickerView {
    
    if (!_pickerView) {
        _pickerView = [[UIDatePicker alloc]init];
        [_pickerView setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];
        _pickerView.datePickerMode = UIDatePickerModeDate;
        [_pickerView addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        if (@available(iOS 14.0, *)) {
            _pickerView.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }
    }
    return _pickerView;
    
}

@end
