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

@interface HYHandleAffairsWebVIewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) UIButton * collectionBtn;

@end

@implementation HYHandleAffairsWebVIewController

- (void)loadView {
    [super loadView];
    
    self.webView = [[WKWebView alloc] init];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel xf_labelWithText:_titleStr];
        
    [self loadData];
        
    [self traitCollectionDidChange:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
