//
//  HYServiceWebViewController.m
//  HelloFrame
//
//  Created by nuchina on 2021/12/1.
//

#import "HYServiceWebViewController.h"
#import <WebKit/WebKit.h>

@interface HYServiceWebViewController () <WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation HYServiceWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:@"可享服务"];

    [self configUI];
    
}

- (void)configUI {
    
    self.webView = [[WKWebView alloc]init];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.serviceUrl]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kTopNavHeight, 0, 0, 0));
    }];
    
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
