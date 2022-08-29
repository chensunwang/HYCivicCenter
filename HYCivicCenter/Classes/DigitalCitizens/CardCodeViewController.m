//
//  CardCodeViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/19.
//

#import "CardCodeViewController.h"
#import "HYCivicCenterCommand.h"

@interface CardCodeViewController ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) UIView *codeContentView;
@property (nonatomic, strong) UIImageView *codeIV;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation CardCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"名片码";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self configUI];
    
    [self loadData];
    
}

- (void)loadData {
    
    [HttpRequest postPath:@"/phone/v2/card/shardMyQrCode" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSLog(@" 我的名片码 == %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.codeIV.image = [self createQRCodeWithCodeStr:responseObject[@"data"]];
        }
        
    }];
    
}

- (void)configUI {
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    self.nameLabel.font = RFONT(24);
    [self.view addSubview:self.nameLabel];
    
    self.jobLabel = [[UILabel alloc]init];
    self.jobLabel.textColor = UIColorFromRGB(0x666666);
    self.jobLabel.font = RFONT(12);
    [self.view addSubview:self.jobLabel];
    
    self.codeContentView = [[UIView alloc]init];
    self.codeContentView.backgroundColor = [UIColor whiteColor];
    self.codeContentView.layer.cornerRadius = 8;
    self.codeContentView.clipsToBounds = YES;
    [self.view addSubview:self.codeContentView];
    
    self.codeIV = [[UIImageView alloc]init];
    [self.codeContentView addSubview:self.codeIV];
    
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.textColor = UIColorFromRGB(0x666666);
    self.tipLabel.font = RFONT(12);
    [self.view addSubview:self.tipLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight + 52);
    }];
    
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(14);
    }];
    
    [self.codeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jobLabel.mas_bottom).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(240, 240));
    }];
    
    [self.codeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.codeContentView.mas_centerX);
        make.centerY.equalTo(self.codeContentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.codeContentView.mas_bottom).offset(30);
    }];
    
    self.nameLabel.text = @"张伟";
    self.jobLabel.text = @"南昌****律师事务所  总经理";
//    self.codeIV.image = [self createQRCode];
    self.tipLabel.text = @"扫一扫 查看名片";
    if (self.model) {
        self.nameLabel.text = self.model.name;
        self.jobLabel.text = [NSString stringWithFormat:@"%@    %@",self.model.companyName,self.model.duty];
        self.codeIV.image = [self createQRCodeWithCodeStr:self.model.qrCodeUrl];
    }
    
}

- (UIImage *)createQRCodeWithCodeStr:(NSString *)codeStr {
    
    //1.生成coreImage框架中的滤镜来生产二维码
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
//    NSString *str = codeStr;
    [filter setValue:[codeStr dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //4.获取生成的图片
    CIImage *ciImg= filter.outputImage;
    //放大ciImg,默认生产的图片很小
    
    //5.设置二维码的前景色和背景颜色
    CIFilter *colorFilter=[CIFilter filterWithName:@"CIFalseColor"];
    //5.1设置默认值
    [colorFilter setDefaults];
    [colorFilter setValue:ciImg forKey:@"inputImage"];
    [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor1"];
    //5.3获取生存的图片
    ciImg = colorFilter.outputImage;
    
    CGAffineTransform scale=CGAffineTransformMakeScale(10, 10);
    ciImg = [ciImg imageByApplyingTransform:scale];
    
    //6.在中心增加一张图片
    UIImage *img=[UIImage imageWithCIImage:ciImg];
    //7.生存图片
    //7.1开启图形上下文
    UIGraphicsBeginImageContext(img.size);
    
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    //7.3在中心划入其他图片
    
    UIImage *centerImg = [UIImage imageNamed:@"citizenBg"];
    
    CGFloat centerW = 48;
    CGFloat centerH = 48;
    CGFloat centerX = (img.size.width)*0.5;
    CGFloat centerY = (img.size.height)*0.5;
    
    [centerImg drawInRect:CGRectMake(centerX - 24, centerY -24, centerW, centerH)];
    
    //7.4获取绘制好的图片
    UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
    
    //7.5关闭图像上下文
    UIGraphicsEndImageContext();
    return finalImg;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
