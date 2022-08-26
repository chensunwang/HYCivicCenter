//
//  MyBusinessCardController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/17.
//

#import "MyBusinessCardController.h"
#import "EditBusinessCardViewController.h"
#import "BusinessCardViewController.h"
#import "CardCodeViewController.h"
#import "XFUDButton.h"
#import "MyCardDataCollectionViewCell.h"
#import "ScanViewController.h"
#import "XFLRButton.h"
#import "EditBusinessCardTableViewCell.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface MyBusinessCardController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,EditDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *mailBoxLabel;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *cardsBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *datasArr;
@property (nonatomic, strong) EditBusinessCardModel *cardModel;
@property (nonatomic, copy) NSString *uuid;

@end

NSString *const mycardCell = @"mycardCell";
@implementation MyBusinessCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"我的名片";
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"我的名片"];
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self configNavi];
    
    [self configUI];
    
    [self loadData];
    
}

- (void)loadData {
    
    [HttpRequest postPath:@"/phone/v2/card/myCardData" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
       
        NSLog(@" 我的名片数据== %@ ",responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.cardModel = [EditBusinessCardModel mj_objectWithKeyValues:responseObject[@"data"]];
            NSDictionary *dataDic = responseObject[@"data"];
            self.companyLabel.text = dataDic[@"companyName"]?dataDic[@"companyName"]:@"";
//            self.headerIV.backgroundColor = [UIColor redColor];
            [self.headerIV sd_setImageWithURL:[NSURL URLWithString:self.cardModel.headPhoto] placeholderImage:[UIImage imageNamed:@"touxiang"]];
            self.nameLabel.text = dataDic[@"name"];
            self.jobLabel.text = dataDic[@"duty"];
            self.phoneLabel.text = dataDic[@"phone"];
            self.mailBoxLabel.text = dataDic[@"email"];
            self.uuid = dataDic[@"uuid"];
            [self.datasArr addObject:dataDic[@"shardNumber"]];
            [self.datasArr addObject:dataDic[@"fansNumber"]];
            [self.collectionView reloadData];
            
        }
        
    }];
    
}

- (void)configNavi {
    
    XFLRButton *rightbutton = [XFLRButton buttonWithType:UIButtonTypeCustom];
    rightbutton.padding = 10;
    [rightbutton addTarget:self action:@selector(scanClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitle:@"扫一扫" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    rightbutton.titleLabel.font = RFONT(15);
    rightbutton.frame = CGRectMake(0 , 0, 80, 44);
    
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:rightbutton];

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    spaceItem.width = -15;
    self.navigationItem.rightBarButtonItems = @[spaceItem,rightItem];
    
}

- (void)configUI {
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopNavHeight, SCREEN_WIDTH, 216)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    
    UIImageView *bgIV = [[UIImageView alloc]init];
    bgIV.image = [UIImage imageNamed:@"businessBG"];
    [self.topView addSubview:bgIV];
    
    UIImageView *contentIV = [[UIImageView alloc]init];
    contentIV.image = [UIImage imageNamed:@"busiContent"];
    contentIV.userInteractionEnabled = YES;
    [self.topView addSubview:contentIV];
    
    self.companyLabel = [[UILabel alloc]init];
    self.companyLabel.textColor = [UIColor whiteColor];
    self.companyLabel.font = RFONT(12);
    [contentIV addSubview:self.companyLabel];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = RFONT(18);
    [contentIV addSubview:self.nameLabel];
    
    self.jobLabel = [[UILabel alloc]init];
    self.jobLabel.textColor = [UIColor whiteColor];
    self.jobLabel.font = RFONT(12);
    [contentIV addSubview:self.jobLabel];
    
    self.headerIV = [[UIImageView alloc]init];
    self.headerIV.layer.cornerRadius = 8;
    self.headerIV.clipsToBounds = YES;
    self.headerIV.image = [UIImage imageNamed:@"touxiang"];
    [contentIV addSubview:self.headerIV];
    
    self.phoneLabel = [[UILabel alloc]init];
    self.phoneLabel.textColor = [UIColor whiteColor];
    self.phoneLabel.font = RFONT(12);
    [contentIV addSubview:self.phoneLabel];
    
    self.mailBoxLabel = [[UILabel alloc]init];
    self.mailBoxLabel.textColor = [UIColor whiteColor];
    self.mailBoxLabel.font = RFONT(12);
    [contentIV addSubview:self.mailBoxLabel];
    
    UIView *cardContentView = [[UIView alloc]init];
    cardContentView.backgroundColor = [UIColor whiteColor];
    cardContentView.layer.cornerRadius = 8;
    cardContentView.clipsToBounds = YES;
    [self.view addSubview:cardContentView];
    
    NSArray *imagesArr = @[@"editCard",@"cards",@"share"];
    NSArray *titlesArr = @[@"编辑名片",@"名片夹",@"分享名片"];
    // 35
    CGFloat padding = (SCREEN_WIDTH - 32 - 70 - 60 * 3) / 2;
    for (NSInteger i = 0; i < titlesArr.count; i++) {
        
        XFUDButton *button = [[XFUDButton alloc]init];
        button.padding = 8;
        [button setTitle:titlesArr[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font = RFONT(12);
        [button setImage:[UIImage imageNamed:imagesArr[i]] forState:UIControlStateNormal];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(cardClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(35 + (padding + 60) * i, 7, 60, 70);
        [cardContentView addSubview:button];
        
    }
    
    UIButton *cardCodeView = [[UIButton alloc]init];
    cardCodeView.backgroundColor = [UIColor whiteColor];
    cardCodeView.layer.cornerRadius = 8;
    cardCodeView.clipsToBounds = YES;
    [cardCodeView addTarget:self action:@selector(cardCodeClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cardCodeView];
    
    UILabel *showCodeLabel = [[UILabel alloc]init];
    showCodeLabel.textColor = UIColorFromRGB(0x333333);
    showCodeLabel.font = RFONT(15);
    showCodeLabel.text = @"出示名片码";
    [cardCodeView addSubview:showCodeLabel];
    
    UIImageView *codeIV = [[UIImageView alloc]init];
    codeIV.image = [UIImage imageNamed:@"cardCode"];
    [cardCodeView addSubview:codeIV];
    
    UIView *dataView = [[UIView alloc]init];
    dataView.backgroundColor = [UIColor whiteColor];
    dataView.layer.cornerRadius = 8;
    dataView.clipsToBounds = YES;
    [self.view addSubview:dataView];
    
    UILabel *myDataLabel = [[UILabel alloc]init];
    myDataLabel.text = @"我的名片数据";
    myDataLabel.textColor = UIColorFromRGB(0x333333);
    myDataLabel.font = RFONT(15);
    [dataView addSubview:myDataLabel];
    
//    CGRect rect = [detailString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, MAXFLOAT)             options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:RFONT(12)}
//                                         context:nil];
    [dataView addSubview:self.collectionView];
    [self.collectionView registerClass:[MyCardDataCollectionViewCell class] forCellWithReuseIdentifier:mycardCell];
    
    
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.topView);
        make.height.mas_equalTo(154);
    }];
    
    [contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(16);
        make.top.equalTo(self.topView.mas_top).offset(16);
        make.right.equalTo(self.topView.mas_right).offset(-16);
        make.height.mas_equalTo(200);
    }];
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentIV.mas_left).offset(32);
        make.top.equalTo(contentIV.mas_top).offset(24);
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentIV.mas_top).offset(21);
        make.right.equalTo(contentIV.mas_right).offset(-21);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.mailBoxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentIV.mas_left).offset(32);
        make.bottom.equalTo(contentIV.mas_bottom).offset(-23);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentIV.mas_left).offset(32);
        make.bottom.equalTo(self.mailBoxLabel.mas_top).offset(-11);
    }];
    
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentIV.mas_left).offset(32);
        make.bottom.equalTo(self.phoneLabel.mas_top).offset(-26);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentIV.mas_left).offset(32);
        make.bottom.equalTo(self.jobLabel.mas_top).offset(-12);
    }];
    
    [cardContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.top.equalTo(self.topView.mas_bottom).offset(16);
        make.height.mas_equalTo(85);
    }];
    
    [cardCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.top.equalTo(cardContentView.mas_bottom).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.mas_equalTo(60);
    }];
    
    [codeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(cardCodeView);
        make.width.mas_equalTo(81.5);
    }];
    
    [showCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeIV.mas_right).offset(26);
        make.centerY.equalTo(cardCodeView.mas_centerY);
    }];
    
    [dataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.top.equalTo(cardCodeView.mas_bottom).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.mas_equalTo(130);
    }];
    
    [myDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dataView.mas_left).offset(16);
        make.top.equalTo(dataView.mas_top).offset(16);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dataView.mas_left).offset(16);
        make.bottom.equalTo(dataView.mas_bottom).offset(-5);
        make.right.equalTo(dataView.mas_right).offset(-16);
        make.height.mas_equalTo(70);
    }];
    
    self.companyLabel.text = @"南昌****有限公司";
//    self.headerIV.backgroundColor = [UIColor redColor];
    self.nameLabel.text = @"张三";
    self.jobLabel.text = @"总经理";
    self.phoneLabel.text = @"13721929123";
    self.mailBoxLabel.text = @"andone@163.com";
    
}

- (void)cardCodeClicked {
    
    CardCodeViewController *codeVC = [[CardCodeViewController alloc]init];
    codeVC.model = self.cardModel;
    [self.navigationController pushViewController:codeVC animated:YES];
    
}

- (void)cardClicked:(XFUDButton *)button {
    
    if (button.tag - 100 == 0) { // 编辑名片
        
        EditBusinessCardViewController *editVC = [[EditBusinessCardViewController alloc]init];
        editVC.delegate = self;
        [self.navigationController pushViewController:editVC animated:YES];
        
    }else if (button.tag - 100 == 1) { // 名片夹
        
        BusinessCardViewController *cardVC = [[BusinessCardViewController alloc]init];
        [self.navigationController pushViewController:cardVC animated:YES];
        
    }else if (button.tag - 100 == 2) { // 分享名片
        
        [HttpRequest postPathPointParams:@{@"buriedPointType": @"moduleVisit",@"eventId": @"E0061",@"applicationId":@"H020"} resuleBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            NSLog(@" 埋点 == %@ ",responseObject);
        }];
        if (self.uuid.length == 0) {
            return;
        }
        
        [HttpRequest postPath:@"/phone/v1/card/addShareNumber" params:nil resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
            NSLog(@"  分享  == %@ ",responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                
                SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc]init];
                sendReq.scene = WXSceneSession;
                sendReq.bText = NO;
                WXMediaMessage *mediaMessage = [WXMediaMessage message];
                WXImageObject *imageObject = [[WXImageObject alloc]init];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:responseObject[@"msg"]]];
                imageObject.imageData = data;
                mediaMessage.mediaObject = imageObject;
                sendReq.message = mediaMessage;
                [WXApi sendReq:sendReq completion:nil];
                
            }
        }];
//        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc]init];
//        sendReq.scene = WXSceneSession;
//        sendReq.bText = NO;
//        WXMediaMessage *mediaMessage = [WXMediaMessage message];
//        WXImageObject *imageObject = [[WXImageObject alloc]init];
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.cardModel.qrCodeUrl]];
//        imageObject.imageData = data;
//        mediaMessage.mediaObject = imageObject;
//        sendReq.message = mediaMessage;
//        [WXApi sendReq:sendReq completion:nil];
        
    }
    
}

#pragma mark - 压缩图片
- (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

#pragma EditDelegate
- (void)editCardReload {
    
    [self loadData];
    
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
    
//    UIImage *centerImg = [UIImage imageNamed:@"citizenBg"];
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

#pragma collectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 2;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCardDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mycardCell forIndexPath:indexPath];
    
    NSArray *datasArr = @[@"44",@"78"];
    NSArray *namesArr = @[@"分享",@"粉丝"];
    if (self.datasArr.count > 0) {
        cell.dataLabel.text = [self.datasArr[indexPath.row] stringValue];
    }else {
        cell.dataLabel.text = datasArr[indexPath.row];
    }
    
    cell.nameLabel.text = namesArr[indexPath.row];
    
    return cell;
    
}

- (void)scanClicked:(UIButton *)button {
    
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
    
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
    
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 20;
        CGFloat itemW = (SCREEN_WIDTH - 20 - 64)/ 2.0;
        CGFloat itemH = 70;
        _flowLayout.itemSize = CGSizeMake(itemW, itemH);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
    
}

- (NSMutableArray *)datasArr {
    
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
    
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
