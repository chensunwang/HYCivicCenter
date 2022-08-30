//
//  MyCtidViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/9/26.
//

#import "MyCtidViewController.h"
#import "FaceTipViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"
#import "OpenIDCardViewController.h"

@interface MyCtidViewController () <FaceResultDelegate>

@property (nonatomic, weak) UILabel *cardNumLabel;
@property (nonatomic, weak) UILabel *cardExpireLabel;
@property (nonatomic, weak) UIImageView *codeIV;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, copy) NSString *bsn;
@property (nonatomic, copy) NSString *randomNum;
@property (nonatomic, copy) NSString *idcardAuthInfo;
@property (nonatomic, copy) NSString *skey;
@property (nonatomic, copy) NSString *qrcodeBsn;
@property (nonatomic, copy) NSString *qrRandomNum;
@property (nonatomic, copy) NSString *codeAuthInfo;
@property (nonatomic, copy) NSString *image_str;
@property (nonatomic, copy) NSString *deviceID;

@end

@implementation MyCtidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"我的CTID"];
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self configUI];
    
}

- (void)configUI {
    
    NSString *CTID = [[NSUserDefaults standardUserDefaults]objectForKey:@"CTID"];
    CtidVerifySdk *ctidVerifyTool = [[CtidVerifySdk alloc]init];
    NSDictionary *dict = [ctidVerifyTool getCtidNum:CTID];
    
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 8;
    contentView.clipsToBounds = YES;
    [self.view addSubview:contentView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"证件照片";
    nameLabel.textColor = UIColorFromRGB(0x333333);
    nameLabel.font = RFONT(15);
    [contentView addSubview:nameLabel];
    
    UIImageView *cardBgIV = [[UIImageView alloc]init];
    cardBgIV.image = [UIImage imageNamed:BundleFile(@"netCardBg")];
    [contentView addSubview:cardBgIV];
    
    UIImageView *headerIV = [[UIImageView alloc]init];
    headerIV.image = [UIImage imageNamed:BundleFile(@"netCerti")];
    [cardBgIV addSubview:headerIV];
    
    UILabel *cardNameLabel = [[UILabel alloc]init];
    cardNameLabel.text = @"居民身份";
    cardNameLabel.font = RFONT(20);
    cardNameLabel.textAlignment = NSTextAlignmentCenter;
    cardNameLabel.textColor = UIColorFromRGB(0x212121);
    [cardBgIV addSubview:cardNameLabel];
    
    UILabel *cardSubLabel = [[UILabel alloc]init];
    cardSubLabel.text = @"网络可信凭证";
    cardSubLabel.textColor = UIColorFromRGB(0x212121);
    cardSubLabel.font = RFONT(27);
    cardSubLabel.textAlignment = NSTextAlignmentCenter;
    [cardBgIV addSubview:cardSubLabel];
    
    UILabel *cardNumLabel = [[UILabel alloc]init];
    cardNumLabel.text = @"网证编号 ";
    cardNumLabel.textColor = UIColorFromRGB(0x333333);
    cardNumLabel.font = RFONT(14);
    if (CTID.length > 0) {
        cardNumLabel.text = [NSString stringWithFormat:@"网证编号 %@",dict[@"SerialNumber"]];
    }else {
        cardNumLabel.text = [NSString stringWithFormat:@"网证编号 暂未获取网证或网证已过期"];
    }
    self.cardNumLabel = cardNumLabel;
    [cardBgIV addSubview:cardNumLabel];
    
    UILabel *cardDateLabel = [[UILabel alloc]init];
    cardDateLabel.text = @"有效期至 ";
    cardDateLabel.font = RFONT(14);
    if (CTID.length > 0) {
        cardDateLabel.text = [NSString stringWithFormat:@"有效期至 %@",dict[@"EndingDate"]];
    }else {
        cardDateLabel.text = [NSString stringWithFormat:@"暂未获取网证或网证已过期"];
    }
    cardDateLabel.textColor = UIColorFromRGB(0x333333);
    self.cardExpireLabel = cardDateLabel;
    [cardBgIV addSubview:cardDateLabel];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"国家“互联网+”可信身份认证平台生成";
    tipLabel.textColor = UIColorFromRGB(0x999999);
    tipLabel.font = RFONT(12);
    [contentView addSubview:tipLabel];
    
    UIView *codeView = [[UIView alloc]init];
    codeView.backgroundColor = [UIColor whiteColor];
    codeView.layer.cornerRadius = 8;
    codeView.clipsToBounds = YES;
    [self.view addSubview:codeView];
    
    UILabel *codeLabel = [[UILabel alloc]init];
    codeLabel.textColor = UIColorFromRGB(0x333333);
    codeLabel.font = RFONT(15);
    codeLabel.text = @"证件二维码";
    [codeView addSubview:codeLabel];
    
    NSString *imgStream = [[NSUserDefaults standardUserDefaults]objectForKey:@"imgStream"];
    NSString *imgWidth = [[NSUserDefaults standardUserDefaults]objectForKey:@"imgwidth"];
    
    UIImageView *codeIV = [[UIImageView alloc]init];
    codeIV.userInteractionEnabled = YES;
    codeIV.alpha = 0.1;
    codeIV.image = [self createQRCodeWithCodeStr:@"O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs="];
    [codeView addSubview:codeIV];
    self.codeIV = codeIV;
    
    MainApi *api = [MainApi sharedInstance];
    if (api.isShow) {
        UIImageView *imageView = [CtidVerifySdk creatQRCodeImageWithImgStreamStr:imgStream width:[imgWidth integerValue] withFrame:CGRectMake(0, 0, 265, 265)];
        codeIV.alpha = 1;
        codeIV.image = imageView.image;
    }
    
    self.maskView = [[UIView alloc]init];
//    self.maskView.backgroundColor = [UIColor whiteColor];
    self.maskView.hidden = api.isShow;
    [codeView addSubview:self.maskView];
    
    UIImageView *citizenIV = [[UIImageView alloc]init];
    citizenIV.image = [UIImage imageNamed:BundleFile(@"citizenBg")];
    [self.maskView addSubview:citizenIV];
    
    UIButton *downloadBtn = [[UIButton alloc]init];
    [downloadBtn setTitle:@"网证下载" forState:UIControlStateNormal];
    [downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downloadBtn setBackgroundColor:UIColorFromRGB(0x3776FF)];
    downloadBtn.titleLabel.font = RFONT(15);
    downloadBtn.layer.cornerRadius = 4;
    downloadBtn.clipsToBounds = YES;
//    downloadBtn.hidden = CTID.length > 0;
    [downloadBtn addTarget:self action:@selector(netCardDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:downloadBtn];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight + 16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.mas_equalTo(([UIScreen mainScreen].bounds.size.width - 64) * 0.63 + 110);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.top.equalTo(contentView.mas_top).offset(17);
    }];
    
    [cardBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(55, 16, 55, 16));
    }];
    
    [headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardBgIV.mas_left).offset(22);
        make.top.equalTo(cardBgIV.mas_top).offset(22);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    
    [cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardBgIV.mas_top).offset(24);
        make.centerX.equalTo(cardBgIV.mas_centerX).offset(38);
    }];
    
    [cardSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerIV.mas_bottom);
        make.centerX.equalTo(cardBgIV.mas_centerX).offset(38);
    }];
    
    [cardDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cardBgIV.mas_bottom).offset(-24);
        make.centerX.equalTo(cardBgIV.mas_centerX);
    }];
    
    [cardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cardDateLabel.mas_top).offset(-16);
        make.centerX.equalTo(cardBgIV.mas_centerX);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.bottom.equalTo(contentView.mas_bottom).offset(-16);
    }];
    
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.top.equalTo(contentView.mas_bottom).offset(24);
        make.height.mas_equalTo(278);
    }];
    
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeView.mas_left).offset(16);
        make.top.equalTo(codeView.mas_top).offset(17);
    }];
    
    [codeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(206, 206));
        make.bottom.equalTo(codeView.mas_bottom).offset(-26);
        make.centerX.equalTo(codeView.mas_centerX);
    }];
    
//    [mainIV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(codeIV.mas_centerX);
//        make.centerY.equalTo(codeIV.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(36, 36));
//    }];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.size.mas_equalTo(CGSizeMake(206, 206));
        make.bottom.equalTo(codeView.mas_bottom).offset(-26);
        make.centerX.equalTo(codeView.mas_centerX);
    }];
    
    [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.maskView.mas_bottom).offset(-57);
        make.centerX.equalTo(self.maskView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 36));
    }];
    
    [citizenIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.maskView.mas_top).offset(57);
        make.centerX.equalTo(self.maskView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
}

- (void)netCardDownload {
    
    NSString *urlString = @"/apiFile/haiDunBase/applyNet?source=2";
    NSString *encodeUrl = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet URLQueryAllowedCharacterSet] invertedSet]];
    [HttpRequest postPathGov:@"" params:@{@"uri":encodeUrl} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 网证下载申请 == %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200 && [responseObject[@"success"] intValue] == 1) {
            self.bsn = responseObject[@"data"][@"bsn"];
            self.randomNum = responseObject[@"data"][@"randomNum"];

            CtidVerifySdk *ctidVerifyTool = [[CtidVerifySdk alloc]init];
            CTIDReq *req = [[CTIDReq alloc]init];
            req.randomNumber = self.randomNum;
            req.organizeId = @"00001405";
            req.appId = @"0002";
            req.type = 3;
            ctidVerifyTool.resultDictBlock = ^(NSDictionary *resultDict) {
                NSLog(@" 获取身份认证数据== %@ ",resultDict);
                if ([resultDict[@"resultCode"] intValue] == 0) {
        //            resultDict[@"resultInfo"]
                    self.idcardAuthInfo = resultDict[@"resultInfo"];
                }
            };
            [ctidVerifyTool getAuthIDCardData:req];
//            [self faceColor];
            [self faceScan];
        }
    }];
    
}

- (void)faceScan {
    
    FaceTipViewController *faceTipVC = [[FaceTipViewController alloc]init];
//        faceTipVC.type = 1;
    faceTipVC.delegate = self;
    [self.navigationController pushViewController:faceTipVC animated:YES];
    
}

- (void)getFaceResultWithImageStr:(NSString *)imageStr deviceId:(NSString *)deviceid skey:(NSString *)skey {
    
    NSString *name = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYName"];
    NSString *idCard = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYIdCard"];
    [HttpRequest postPathGov:@"" params:@{@"uri":@"/apiFile/haiDunBase/downloadNet",@"file":imageStr,@"nickname":name?:@"",@"idCard":idCard?:@"",@"bsn":self.bsn,@"idcardAuthData":self.idcardAuthInfo?:@"",@"source":@"2",@"skey":skey,@"deviceId":deviceid,@"app":@"ios"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 网证下载33== %@ ",responseObject);
        
        if ([responseObject[@"success"] intValue] == 1) {
            
//            self.codeIV.image = [self createQRCodeWithCodeStr:responseObject[@"data"][@"ctid"]];
//            self.maskView.hidden = YES;
            [[NSUserDefaults standardUserDefaults]setValue:responseObject[@"data"][@"ctid"]?:@"" forKey:@"CTID"];
            [self applyQrcodeWithImageStr:imageStr withSkey:skey withDeviceId:deviceid];
            
        }else if ([responseObject[@"code"] intValue] == 500) {
            // 跳转开通网证
            
            NSString *phone = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYPhone"];
            OpenIDCardViewController *idcardVC = [[OpenIDCardViewController alloc]init];
            idcardVC.bsn = self.bsn;
            idcardVC.phone = phone;
            [self.navigationController pushViewController:idcardVC animated:YES];
            
        }
        
    }];
    
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
    //7.4获取绘制好的图片
    UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
    
    //7.5关闭图像上下文
    UIGraphicsEndImageContext();
    return finalImg;
    
}

// 二维码赋码申请
- (void)applyQrcodeWithImageStr:(NSString *)image_str withSkey:(NSString *)skey withDeviceId:(NSString *)device_id {
    
    CtidVerifySdk *ctidVerifyTool = [[CtidVerifySdk alloc]init];
    CTIDReq *req = [[CTIDReq alloc]init];
    req.organizeId = @"00001405";
    req.appId = @"0002";
    req.type = 0;
    NSDictionary *resultDic = [ctidVerifyTool getApplyData:req];
    NSLog(@" 二维码赋码数据==%@ ",resultDic);
    if ([resultDic[@"resultCode"]intValue] == 0) {
        self.codeAuthInfo = resultDic[@"resultInfo"];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"/apiFile/haiDunBase/applyQrCode?source=2&applyData=%@&authMode=G120",self.codeAuthInfo];
    
    NSString *tempString = [self URLEncodedString:urlString];
    NSDictionary *dic = @{
        @"uri":tempString
    };
    NSLog(@" 赋码申请参数 == %@ ",dic);
    // @{@"source":@"2",@"applyData":self.codeAuthInfo}
    [HttpRequest postPathGov:@"" params:dic resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 赋码申请== %@ ",responseObject);
        if ([responseObject[@"success"] intValue] == 1) {
            self.qrcodeBsn = responseObject[@"data"][@"bsn"]?:@"";
            self.qrRandomNum = responseObject[@"data"][@"randomNum"]?:@"";
//            [self getQrcode];
            NSString *ctid = [[NSUserDefaults standardUserDefaults]valueForKey:@"CTID"];
            CtidVerifySdk *ctidVerifyTool = [[CtidVerifySdk alloc]init];
            CTIDReq *ctidReq = [[CTIDReq alloc]init];
            ctidReq.organizeId = @"00001405";
            ctidReq.appId = @"0002";
            ctidReq.randomNumber = self.qrRandomNum;
            ctidReq.ctid = ctid;
            NSDictionary *resultDic = [ctidVerifyTool getReqQRCodeData:ctidReq];
            NSLog(@" 网证获取二维码赋码数据== %@ ",resultDic);
            if ([resultDic[@"resultCode"] isEqualToString:@"0"]) {
        //        NSLog(@" 网证获取二维码赋码数据== %@ ",resultDic);
            }
            
            [SVProgressHUD showWithStatus:@"正在加载中"];
            [HttpRequest postPathGov:@"" params:@{@"uri":@"/apiFile/haiDunBase/assignOrCode",@"app":@"ios",@"authMode":@"G120",@"bsn":self.qrcodeBsn,@"checkData":resultDic[@"resultInfo"],@"deviceId":device_id,@"file":image_str,@"skey":skey,@"source":@"2"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
                NSLog(@" 二维码赋码== %@ ",responseObject);
                    if ([responseObject[@"success"] intValue] == 1) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.maskView.hidden = YES;
                            UIImageView *imageView = [CtidVerifySdk creatQRCodeImageWithImgStreamStr:responseObject[@"data"][@"imgStream"] width:[responseObject[@"data"][@"width"] integerValue] withFrame:CGRectMake(0, 0, 265, 265)];
                            self.codeIV.alpha = 1;
                            self.codeIV.image = imageView.image;
                            [[NSUserDefaults standardUserDefaults]setValue:responseObject[@"data"][@"imgStream"] forKey:@"imgStream"];
                            [[NSUserDefaults standardUserDefaults]setValue:responseObject[@"data"][@"width"] forKey:@"imgwidth"];
                            MainApi *api = [MainApi sharedInstance];
                            api.isShow = YES;
                        });
                    }
                [SVProgressHUD dismiss];
            }];
        }
    }];
    
}

- (NSString *)URLEncodedString:(NSString*)urlStr {
    
    NSString *encodeString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"] invertedSet]];
    return encodeString;
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
