//
//  CertificateDetailViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/30.
//

#import "CertificateDetailViewController.h"
#import "CertificateInfoViewController.h"
#import <CTID_Verification/CTID_Verification.h>
#import "FaceTipViewController.h"
#import "OpenIDCardViewController.h"
#import "HYCivicCenterCommand.h"

@interface CertificateDetailViewController () <FaceResultDelegate>

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) UIImageView *codeIV;
@property (nonatomic, strong) UIImageView *centerIV;
@property (nonatomic, strong) UIImageView *maskView;
@property (nonatomic, copy) NSString *randomNum;
@property (nonatomic, copy) NSString *bsn;
@property (nonatomic, copy) NSString *idcardAuthInfo;
@property (nonatomic, copy) NSString *skey;
@property (nonatomic, copy) NSString *qrcodeBsn;
@property (nonatomic, copy) NSString *qrRandomNum;
@property (nonatomic, copy) NSString *codeAuthInfo;
@property (nonatomic, copy) NSString *image_str;
@property (nonatomic, copy) NSString *deviceID;

@end

@implementation CertificateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"证件详情";
    
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self configUI];
    
    [self loadData];
    
}

- (void)configUI {
    CGFloat kscreenWith = [UIScreen mainScreen].bounds.size.width;
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 8;
    contentView.clipsToBounds = YES;
    [self.view addSubview:contentView];
    
    UIImageView *cardBgIV = [[UIImageView alloc]init];
    cardBgIV.image = HyBundleImage(@"idcard1");
    [contentView addSubview:cardBgIV];
    
    UIImageView *headerIV = [[UIImageView alloc]init];
    headerIV.image = HyBundleImage(@"idcardHeader1");
    [cardBgIV addSubview:headerIV];
    
    UILabel *cardNameLabel = [[UILabel alloc]init];
    cardNameLabel.textColor = UIColorFromRGB(0x333333);
    cardNameLabel.font = RFONT(18);
    cardNameLabel.text = self.cardName;
    [cardBgIV addSubview:cardNameLabel];
    
    UILabel *cardNumLabel = [[UILabel alloc]init];
    cardNumLabel.textColor = UIColorFromRGB(0x666666);
    cardNumLabel.font = RFONT(12);
    if (self.cardNum.length > 9) {
        cardNumLabel.text = [self setNoSeeText:self.cardNum first:6 last:3];
    }
    [cardBgIV addSubview:cardNumLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [contentView addSubview:lineView];
    
    UILabel *codeLabel = [[UILabel alloc]init];
    codeLabel.textColor = UIColorFromRGB(0x333333);
    codeLabel.font = RFONT(15);
    codeLabel.text = [NSString stringWithFormat:@"%@二维码",self.cardName];
    [contentView addSubview:codeLabel];
    
    NSString *imgStream = [[NSUserDefaults standardUserDefaults]objectForKey:@"imgStream"];
    NSString *imgWidth = [[NSUserDefaults standardUserDefaults]objectForKey:@"imgwidth"];
    
    UIImageView *codeIV = [[UIImageView alloc]init];
    codeIV.image = [self createQRCodeWithCodeStr:@"O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs=O862ssJuMeiUQthakzaluAQsUhl/2AS9jMs="];
    codeIV.userInteractionEnabled = YES;
    codeIV.alpha = 0.1;
    [contentView addSubview:codeIV];
    self.codeIV = codeIV;
    
    self.centerIV = [[UIImageView alloc]init];
    self.centerIV.image = HyBundleImage(@"citizenBg");
    self.centerIV.hidden = YES;
    [codeIV addSubview:self.centerIV];
    
    MainApi *api = [MainApi sharedInstance];
    if (api.isShow) {
        UIImageView *imageView = [CtidVerifySdk creatQRCodeImageWithImgStreamStr:imgStream width:[imgWidth integerValue] withFrame:CGRectMake(0, 0, 206, 206)];
        codeIV.alpha = 1;
        codeIV.image = imageView.image;
        self.centerIV.hidden = NO;
    }
    
    self.maskView = [[UIImageView alloc]init];
    self.maskView.userInteractionEnabled = YES;
    self.maskView.hidden = api.isShow;
    [contentView addSubview:self.maskView];
    
    UIImageView *citizenIV = [[UIImageView alloc]init];
    citizenIV.image = HyBundleImage(@"citizenBg");
    [self.maskView addSubview:citizenIV];
    
    UIButton *downloadBtn = [[UIButton alloc]init];
    [downloadBtn setTitle:@"网证下载" forState:UIControlStateNormal];
    [downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downloadBtn setBackgroundColor:UIColorFromRGB(0x3776FF)];
    downloadBtn.titleLabel.font = RFONT(15);
    downloadBtn.layer.cornerRadius = 4;
    downloadBtn.clipsToBounds = YES;
    [downloadBtn addTarget:self action:@selector(netCardDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.maskView addSubview:downloadBtn];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.textColor = UIColorFromRGB(0x999999);
    tipLabel.font =RFONT(12);
    tipLabel.text = @"让工作人员扫一扫即可识别证件信息";
    [contentView addSubview:tipLabel];
    
    UIButton *bottomBtn = [[UIButton alloc]init];
    [bottomBtn setBackgroundColor:[UIColor whiteColor]];
    bottomBtn.layer.cornerRadius = 8;
    bottomBtn.clipsToBounds = YES;
    [bottomBtn addTarget:self action:@selector(detailClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.text = @"查看证照详情";
    detailLabel.textColor = UIColorFromRGB(0x333333);
    detailLabel.font = RFONT(14);
    [bottomBtn addSubview:detailLabel];
    
    UIImageView *rightIV = [[UIImageView alloc]init];
    rightIV.image = HyBundleImage(@"enter");
    [bottomBtn addSubview:rightIV];
    
    CGFloat contentHeight = (kscreenWith - 64) * 0.41 + 16 + 50 + 206 + 50 + 16;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.top.equalTo(self.view.mas_top).offset(kTopNavHeight + 16);
        make.height.mas_equalTo(contentHeight);
    }];
    
    [cardBgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(16);
        make.top.equalTo(contentView.mas_top).offset(16);
        make.right.equalTo(contentView.mas_right).offset(-16);
        make.height.mas_equalTo((kscreenWith - 64) * 0.41);
    }];
    
    [headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cardBgIV.mas_left).offset(10);
        make.top.equalTo(cardBgIV.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [cardNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerIV.mas_right).offset(8);
        make.top.equalTo(cardBgIV.mas_top).offset(10);
    }];
    
    [cardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerIV.mas_right).offset(8);
        make.top.equalTo(cardNameLabel.mas_bottom).offset(10);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(cardBgIV.mas_bottom).offset(16);
        make.height.mas_equalTo(1);
    }];
    
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(16);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    [codeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeLabel.mas_bottom).offset(16);
        make.centerX.equalTo(contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(206, 206));
    }];
    
    [self.centerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(codeIV.mas_centerX);
        make.centerY.equalTo(codeIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentView.mas_bottom).offset(-16);
        make.centerX.equalTo(contentView.mas_centerX);
    }];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.top.equalTo(contentView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.mas_equalTo(50);
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBtn.mas_left).offset(16);
        make.centerY.equalTo(bottomBtn.mas_centerY);
    }];
    
    [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomBtn.mas_right).offset(-16);
        make.centerY.equalTo(bottomBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeLabel.mas_bottom).offset(16);
        make.centerX.equalTo(contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(206, 206));
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
    
    if ([self.license_item_code isEqualToString:@"107012901"]) { // 不动产权证书
        cardBgIV.image = HyBundleImage(@"idcard5");
        headerIV.image = HyBundleImage(@"idcardHeader4");
    }else if ([self.license_item_code isEqualToString:@"107013001"]) { // 不动产权证明
        cardBgIV.image = HyBundleImage(@"idcard5");
        headerIV.image = HyBundleImage(@"idcardHeader4");
    }else if ([self.license_item_code isEqualToString:@"100018901"]) { //身份证电子凭证
        cardBgIV.image = HyBundleImage(@"idcard1");
        headerIV.image = HyBundleImage(@"idcardHeader1");
    }else if ([self.license_item_code isEqualToString:@"100019001"]) {// 户口簿电子电子凭证
        cardBgIV.image = HyBundleImage(@"idcard4");
        headerIV.image = HyBundleImage(@"idcardHeader1");
    }else if ([self.license_item_code isEqualToString:@"100018801"]) { // 驾驶证
        cardBgIV.image = HyBundleImage(@"idcard2");
        headerIV.image = HyBundleImage(@"idcardHeader3");
    }else if ([self.license_item_code isEqualToString:@"100018601"]) { // 行驶证
        cardBgIV.image = HyBundleImage(@"idcard15");
        headerIV.image = HyBundleImage(@"idcardHeader11");
    }else if ([self.license_item_code isEqualToString:@"100001001"]) { // 结婚证
        cardBgIV.image = HyBundleImage(@"idcard3");
        headerIV.image = HyBundleImage(@"idcardHeader2");
    }else if ([self.license_item_code isEqualToString:@"100000401"]) { // 离婚证
        cardBgIV.image = HyBundleImage(@"idcard3");
        headerIV.image = HyBundleImage(@"idcardHeader2");
    }else if ([self.license_item_code isEqualToString:@"100043701"]) { // 电子营业执照
        cardBgIV.image = HyBundleImage(@"idcard13");
        headerIV.image = HyBundleImage(@"idcardHeader1");
        
    }else if ([self.license_item_code isEqualToString:@"105003101"]) {// 公共场所卫生许可证
        
        cardBgIV.image = HyBundleImage(@"idcard8");
        headerIV.image = HyBundleImage(@"idcardHeader7");
        
    }else if ([self.license_item_code isEqualToString:@"106006501"]) { // 供水单位卫生许可证
        
        cardBgIV.image = HyBundleImage(@"idcard10");
        headerIV.image = HyBundleImage(@"idcardHeader9");
        
    }else if ([self.license_item_code isEqualToString:@"110002301"]) { // 食品生产许可证
        
        cardBgIV.image = HyBundleImage(@"idcard9");
        headerIV.image = HyBundleImage(@"idcardHeader8");
        
    }else if ([self.license_item_code isEqualToString:@"100007801"]) { // 建设用地规划许可证
        
        cardBgIV.image = HyBundleImage(@"idcard6");
        headerIV.image = HyBundleImage(@"idcardHeader5");
        
    }else if ([self.license_item_code isEqualToString:@"501006601"]) {// 同意接用城市照明电源告知书
        
        cardBgIV.image = HyBundleImage(@"idcard11");
        headerIV.image = HyBundleImage(@"idcardHeader10");
        
    }else if ([self.license_item_code isEqualToString:@"110003901"]) { // 外国人工作许可证
        
        cardBgIV.image = HyBundleImage(@"idcard12");
        headerIV.image = HyBundleImage(@"idcardHeader1");
        
    }else if ([self.license_item_code isEqualToString:@"100001701"]) { // 药品经营许可证
        
        cardBgIV.image = HyBundleImage(@"idcard7");
        headerIV.image = HyBundleImage(@"idcardHeader6");
        
    }
    
}

- (UIImage *)createQRCodeWithCodeStr:(NSString *)codeStr {
    
    //1.生成coreImage框架中的滤镜来生产二维码
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
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
    
//    UIImage *centerImg = HyBundleImage(@"citizenBg"];
//
//    CGFloat centerW = 36;
//    CGFloat centerH = 36;
//    CGFloat centerX = (img.size.width)*0.5;
//    CGFloat centerY = (img.size.height)*0.5;
//
//    [centerImg drawInRect:CGRectMake(centerX - 18, centerY - 18, centerW, centerH)];
    
    //7.4获取绘制好的图片
    UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
    
    //7.5关闭图像上下文
    UIGraphicsEndImageContext();
    return finalImg;
    
}

- (void)loadData {
    
    NSString *eventID = @"H004";
    if ([self.license_item_code isEqualToString:@"107012901"]) { // 不动产权证书
        eventID = @"H008";
    }else if ([self.license_item_code isEqualToString:@"107013001"]) { // 不动产权证明
        eventID = @"H008";
    }else if ([self.license_item_code isEqualToString:@"100018901"]) { //身份证电子凭证
        eventID = @"H004";
    }else if ([self.license_item_code isEqualToString:@"100019001"]) {// 户口簿电子电子凭证
        eventID = @"H005";
    }else if ([self.license_item_code isEqualToString:@"100018801"]) { // 驾驶证
        eventID = @"H006";
    }else if ([self.license_item_code isEqualToString:@"100018601"]) { // 行驶证
        eventID = @"H003";
    }else if ([self.license_item_code isEqualToString:@"100001001"]) { // 结婚证
        eventID = @"H007";
    }else if ([self.license_item_code isEqualToString:@"100043701"]) { // 电子营业执照
        eventID = @"H015";
    }else if ([self.license_item_code isEqualToString:@"106006501"]) { // 供水单位卫生许可证
        eventID = @"H011";
    }else if ([self.license_item_code isEqualToString:@"110002301"]) { // 食品生产许可证
        eventID = @"H014";
    }else if ([self.license_item_code isEqualToString:@"100007801"]) { // 建设用地规划许可证
        eventID = @"H009";
    }else if ([self.license_item_code isEqualToString:@"501006601"]) {// 同意接用城市照明电源告知书
        eventID = @"H012";
    }else if ([self.license_item_code isEqualToString:@"110003901"]) { // 外国人工作许可证
        eventID = @"H013";
    }else if ([self.license_item_code isEqualToString:@"100001701"]) { // 药品经营许可证
        eventID = @"H010";
    }
    [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit",@"eventId": @"E0021",@"applicationId":eventID} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 埋点 == %@ ",responseObject);
    }];
    
    [HttpRequest postPath:@"/phone/v2/idPhoto/getIdPhotoPdf" params:@{@"holder_identity_num_encrypt":self.holder_identity_num,@"license_item_code":self.license_item_code,@"idPhotoType":self.idPhoneType} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 证件数据== %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            if ([responseObject[@"data"] count] > 0) {
                self.urlString = responseObject[@"data"][0];
            }
            
        }
    }];
    
}

- (NSString *)setNoSeeText:(NSString *)text first:(NSInteger)first last:(NSInteger)last {
    
    NSString *newText = @"";
    for (int i = 0; i < text.length; i++) {
        
        NSString *itemString = [text substringWithRange:NSMakeRange(i, 1)];
        if (i < first) {
            newText = [newText stringByAppendingString:itemString];
        }else if (i >= text.length - last) {
            newText = [newText stringByAppendingString:itemString];
        }else {
            newText = [newText stringByAppendingString:@"*"];
        }
    }
    
    return newText;
    
}

- (void)detailClicked {
    
    CertificateInfoViewController *infoVC = [[CertificateInfoViewController alloc]init];
    infoVC.urlString = [NSString stringWithFormat:@"%@%@",@"https://nccsdn.yunshangnc.com",self.urlString];
    [self.navigationController pushViewController:infoVC animated:YES];
    
}

// 网证下载
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
            [self faceScan];
        }
    }];
    
}

- (void)faceScan {
    
    FaceTipViewController *faceTipVC = [[FaceTipViewController alloc]init];
    faceTipVC.delegate = self;
    [self.navigationController pushViewController:faceTipVC animated:YES];
    
}

- (void)getFaceResultWithImageStr:(NSString *)imageStr deviceId:(NSString *)deviceid skey:(NSString *)skey {
    
    [[NSUserDefaults standardUserDefaults]setValue:imageStr?:@"" forKey:@"HYImageStr"];
    [[NSUserDefaults standardUserDefaults]setValue:skey?:@"" forKey:@"HYSkey"];
    [[NSUserDefaults standardUserDefaults]setValue:deviceid?:@"" forKey:@"HYDeviceid"];
    NSString *idCard = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYIdCard"];
    NSString *idName = [[NSUserDefaults standardUserDefaults]objectForKey:@"HYName"];
    // 网证下载
    [HttpRequest postPathGov:@"" params:@{@"uri":@"/apiFile/haiDunBase/downloadNet",@"file":imageStr,@"nickname":idName,@"idCard":idCard,@"bsn":self.bsn,@"idcardAuthData":self.idcardAuthInfo?:@"",@"source":@"2",@"skey":skey,@"deviceId":deviceid,@"app":@"ios"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@" 网证下载33== %@ ",responseObject);
        
        if ([responseObject[@"success"] intValue] == 1) {
            
            //responseObject[@"data"][@"ctid"];  网证
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.netDownloadBtn.hidden = YES;
                [[NSUserDefaults standardUserDefaults]setValue:responseObject[@"data"][@"ctid"]?:@"" forKey:@"CTID"];
                [self applyQrcodeWithImageStr:imageStr withSkey:skey withDeviceId:deviceid];
            });
            
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
                            self.centerIV.hidden = NO;
                            self.codeIV.image = imageView.image;
                            self.codeIV.alpha = 1;
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

@end
