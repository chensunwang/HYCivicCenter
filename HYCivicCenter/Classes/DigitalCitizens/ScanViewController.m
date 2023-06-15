//
//  ScanViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/25.
//

#import "ScanViewController.h"
#import "XFUDButton.h"
#import "CardDetailViewController.h"
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, strong) XFUDButton *libraryBtn;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"扫码加名片";
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"扫码加名片"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
    
}

- (void)configUI {
    
    CGFloat scanW = [UIScreen mainScreen].bounds.size.width * 0.65;
    CGFloat padding = 10.0f;
    CGFloat cornerW = 26.0f;
    CGFloat marginX = ([UIScreen mainScreen].bounds.size.width - scanW) * 0.5;
//    CGFloat marginY = ([UIScreen mainScreen].bounds.size.height - scanW - padding - kTopNavHeight) * 0.5;
    CGFloat marginY = 150;
    
    //遮盖视图
    for (int i = 0; i < 4; i++) {
        UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, (marginY + scanW) * i + kTopNavHeight, [UIScreen mainScreen].bounds.size.width, marginY + padding * i)];//marginY + padding * i
        // [UIScreen mainScreen].bounds.size.height - marginY - scanW - kTopNavHeight
        if (i == 1) {
            cover.frame = CGRectMake(0, (marginY + scanW) * i + kTopNavHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - marginY - scanW - kTopNavHeight);
        }
        if (i == 2 || i == 3) {
            cover.frame = CGRectMake((marginX + scanW) * (i - 2), marginY + kTopNavHeight, marginX, scanW);
        }
        cover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self.view addSubview:cover];
    }
    
    //扫描视图
    UIView *scanView = [[UIView alloc] initWithFrame:CGRectMake(marginX, marginY + kTopNavHeight, scanW, scanW)];
    [self.view addSubview:scanView];
    
    //扫描线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scanW, 2)];
    [self drawLineForImageView:line];
    [scanView addSubview:line];
    self.line = line;
    
    //边框
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scanW, scanW)];
    borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    borderView.layer.borderWidth = 1.0f;
    [scanView addSubview:borderView];
    
    //扫描视图四个角
    for (int i = 0; i < 4; i++) {
        CGFloat imgViewX = (scanW - cornerW) * (i % 2);
        CGFloat imgViewY = (scanW - cornerW) * (i / 2);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewX, imgViewY, cornerW, cornerW)];
        if (i == 0 || i == 1) {
            imgView.transform = CGAffineTransformRotate(imgView.transform, M_PI_2 * i);
        }else {
            imgView.transform = CGAffineTransformRotate(imgView.transform, - M_PI_2 * (i - 1));
        }
        [self drawImageForImageView:imgView];
        [scanView addSubview:imgView];
    }
    
    //library
    self.libraryBtn = [[XFUDButton alloc]init];
    [self.libraryBtn setImage:HyBundleImage(@"library") forState:UIControlStateNormal];
    [self.libraryBtn setTitle:@"相册" forState:UIControlStateNormal];
    self.libraryBtn.padding = 10;
    self.libraryBtn.titleLabel.font = RFONT(12);
    [self.libraryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.libraryBtn addTarget:self action:@selector(libraryClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.libraryBtn];
    
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.font = RFONT(12);
    self.tipLabel.text = @"----  请扫描名片码  ----";
    [self.view addSubview:self.tipLabel];
    
    [self.libraryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-(kSafeAreaBottomHeight+40));
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(70, 40));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(scanView.mas_bottom).offset(40);
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupCamera];
    
    [self addTimer];
    
}

- (void)setupCamera
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //初始化相机设备
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        //初始化输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        //初始化输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        //设置代理，主线程刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        self.session = [[AVCaptureSession alloc] init];
        //高质量采集率
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([self.session canAddInput:input]) [self.session addInput:input];
        if ([self.session canAddOutput:output]) [self.session addOutput:output];
        
        //条码类型（二维码/条形码）
        output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
        
        //更新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            self.preview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            [self.view.layer insertSublayer:self.preview atIndex:0];
            [self.session startRunning];
        });
    });
}

- (void)addTimer
{
    self.distance = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction
{
    if (self.distance++ > [UIScreen mainScreen].bounds.size.width * 0.65) self.distance = 0;
    self.line.frame = CGRectMake(0, self.distance, [UIScreen mainScreen].bounds.size.width * 0.65, 2);
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

//绘制角图片
- (void)drawImageForImageView:(UIImageView *)imageView
{
    UIGraphicsBeginImageContext(imageView.bounds.size);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条宽度
    CGContextSetLineWidth(context, 6.0f);
    //设置颜色
    CGContextSetStrokeColorWithColor(context, [UIColorFromRGB(0x157AFF) CGColor]);
    //路径
    CGContextBeginPath(context);
    //设置起点坐标
    CGContextMoveToPoint(context, 0, imageView.bounds.size.height);
    //设置下一个点坐标
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, imageView.bounds.size.width, 0);
    //渲染，连接起点和下一个坐标点
    CGContextStrokePath(context);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

//绘制线图片
- (void)drawLineForImageView:(UIImageView *)imageView
{
    CGSize size = imageView.bounds.size;
    UIGraphicsBeginImageContext(size);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建一个颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //设置开始颜色
    const CGFloat *startColorComponents = CGColorGetComponents([[UIColor greenColor] CGColor]);
    //设置结束颜色
    const CGFloat *endColorComponents = CGColorGetComponents([[UIColor whiteColor] CGColor]);
    //颜色分量的强度值数组
    CGFloat components[8] = {startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]
    };
    //渐变系数数组
    CGFloat locations[] = {0.0, 1.0};
    //创建渐变对象
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    //绘制渐变
    CGContextDrawRadialGradient(context, gradient, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.25, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.5, kCGGradientDrawsBeforeStartLocation);
    //释放
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma AVCaptureMetaDataOutPutObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if ([metadataObjects count] > 0) {
        
//        [[metadataObjects firstObject] stringValue]
//        NSString * str;
        
        NSLog(@"扫描数据== %@",[[metadataObjects firstObject] stringValue]);
        if ([[[metadataObjects firstObject] stringValue] rangeOfString:@"{\"uuid\":\""].location != NSNotFound && [[[metadataObjects firstObject] stringValue] rangeOfString:@"\"}"].location != NSNotFound) {
            
            NSString *tempStr = [[[metadataObjects firstObject] stringValue] stringByReplacingOccurrencesOfString:@"{\"uuid\":\"" withString:@""];
            NSString *codeStr = [tempStr stringByReplacingOccurrencesOfString:@"\"}" withString:@""];
            NSLog(@" 最终的二维码数据== %@ ",codeStr);
            
            CardDetailViewController *detailVC = [[CardDetailViewController alloc]init];
            detailVC.cardID = codeStr;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
        
        [self stopScanning];
        
    }
    
}

// 相册
- (void)libraryClicked {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma UIImagePicker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
       
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        NSLog(@" 相册扫码结果== %@ ",[[features firstObject] messageString]);
        if (features.count > 0) {
            
            if ([[[features firstObject] messageString] rangeOfString:@"{\"uuid\":\""].location != NSNotFound && [[[features firstObject] messageString] rangeOfString:@"\"}"].location != NSNotFound) {
                
                NSString *tempStr = [[[features firstObject] messageString] stringByReplacingOccurrencesOfString:@"{\"uuid\":\"" withString:@""];
                NSString *codeStr = [tempStr stringByReplacingOccurrencesOfString:@"\"}" withString:@""];
                NSLog(@" 最终的二维码数据== %@ ",codeStr);
                
                CardDetailViewController *detailVC = [[CardDetailViewController alloc]init];
                detailVC.cardID = codeStr;
                [self.navigationController pushViewController:detailVC animated:YES];
                
            }
            
            [self stopScanning];
            
        }else {
            
        }
        
    }];
    
}

- (void)stopScanning
{
    [self.session stopRunning];
    self.session = nil;
    [self.preview removeFromSuperlayer];
    [self removeTimer];
}

- (void)dealloc {
    
    [self stopScanning];
    
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
