//
//  HYHandleAffairsWebVIewController.m
//  HelloFrame
//
//  Created by nuchina on 2022/1/4.
//

#import "HYHandleAffairsWebVIewController.h"
#import <WebKit/WebKit.h>
#import "HYCivicCenterCommand.h"
#import "UILabel+XFExtension.h"
#import "UILabel+XFExtension.h"

@interface HYHandleAffairsWebVIewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) UIButton * collectionBtn;
@property (nonatomic, strong) UIButton * backBtn;

@end

@implementation HYHandleAffairsWebVIewController

- (void)loadView {
    [super loadView];
    
    self.webView = [[WKWebView alloc] init];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preference = [[WKPreferences alloc] init];
    preference.minimumFontSize = 0;
    preference.javaScriptEnabled = YES;
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView.UIDelegate = self;  // UI代理
    self.webView.navigationDelegate = self;  // 导航代理
    self.webView.allowsBackForwardNavigationGestures = YES;  // 手势左滑返回
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.jumpUrl]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kTopNavHeight, 0, 0, 0));
    }];
    
    self.collectionBtn = [[UIButton alloc] init];
    [self.view addSubview:self.collectionBtn];
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-160);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectionBtn setTitle:@"取消收藏" forState:UIControlStateSelected];
    self.collectionBtn.titleLabel.font = RFONT(14);
    self.collectionBtn.titleLabel.numberOfLines = 0;
    self.collectionBtn.layer.cornerRadius = 25;
    self.collectionBtn.clipsToBounds = YES;
    [self.collectionBtn addTarget:self action:@selector(collectionClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backBtn = [[UIButton alloc] init];
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    self.backBtn.layer.masksToBounds = YES;
    self.backBtn.layer.cornerRadius = 20;
    [self.backBtn setBackgroundColor:[UIColor lightGrayColor]];
    [self.backBtn setImage:HyBundleImage(@"naviBack") forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:_titleStr];
        
    [self loadData];
        
    [self traitCollectionDidChange:nil];
    
    // 添加监测网页标题title的观察者
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    // 添加监测网页是否可返回
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_collectionBtn.isSelected) {
        [self.collectionBtn setBackgroundColor:UIColorFromRGB(0xE5F1FF)];
    } else {
        [self.collectionBtn setBackgroundColor:UIColorFromRGB(0xFF8F1F)];
    }
    [self.collectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.collectionBtn setTitleColor:UIColorFromRGB(0x126AFB) forState:UIControlStateSelected];
}

- (void)loadData { // 判断是否收藏   /city/4AItems/event/collect/checkCollect
    if ([_titleStr isEqualToString:@"货车通行证"]) {
        // 无法收藏  隐藏收藏按钮
        self.collectionBtn.hidden = YES;
        return;
    }
    [HttpRequest postHttpBodyZWBS:@"city/4AItems/event/collect/checkCollect" params:@{@"eventCode": _code, @"eventName":_titleStr} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@"判断是否收藏== %@", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            if ([responseObject[@"data"] intValue] == 0) {  // 未收藏
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.collectionBtn.selected = NO;
                    [self.collectionBtn setBackgroundColor:UIColorFromRGB(0xFF8F1F)];
                });
            } else {  // 已收藏
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.collectionBtn.selected = YES;
                    [self.collectionBtn setBackgroundColor:UIColorFromRGB(0xE5F1FF)];
                });
            }
        } else {
            SLog(@"判断是否收藏失败:%@", responseObject[@"msg"]);
        }
    }];
}

// 收藏/取消收藏
- (void)collectionClicked:(UIButton *)sender {
    if (!sender.selected) {
        [self requestCollection];
    } else {
        [self requestCancelCollection];
    }
}

- (void)requestCollection {  // 点击收藏  /city/4AItems/event/collect/collectItem
    [HttpRequest postHttpBodyZWBS:@"city/4AItems/event/collect/collectItem" params:@{@"eventCode": _code, @"eventName":_titleStr} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@"点击收藏== %@", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.collectionBtn.selected = YES;
                [self.collectionBtn setBackgroundColor:UIColorFromRGB(0xE5F1FF)];
            });
        } else {
            SLog(@"收藏失败:%@", responseObject[@"msg"]);
        }
    }];
}

- (void)requestCancelCollection {  // 取消收藏  /city/4AItems/event/collect/cancelCollect
    [HttpRequest postHttpBodyZWBS:@"city/4AItems/event/collect/cancelCollect" params:@{@"eventCode": _code} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@"取消收藏== %@", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.collectionBtn.selected = NO;
                [self.collectionBtn setBackgroundColor:UIColorFromRGB(0xFF8F1F)];
            });
        } else {
            SLog(@"取消收藏失败:%@", responseObject[@"msg"]);
        }
    }];
}

// KVO监听title goBack 必须实现此方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"] && object == _webView) {
        self.navigationItem.title = _webView.title;
    }
    else if ([keyPath isEqualToString:@"canGoBack"] && object == _webView) {
        if ([_webView canGoBack]) { // 为YES时表示webView当前加载的html页面级数>=2 否则当前处于html的一级页面
            self.backBtn.hidden = NO;
        } else {
            self.backBtn.hidden = YES;
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)goBack {
    if ([_webView canGoBack]) {  // 判断是否能返回到H5上级页面
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc {
    // 移除观察者
    [_webView removeObserver:self forKeyPath:NSStringFromSelector(@selector((title)))];
    [_webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(canGoBack))];
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
