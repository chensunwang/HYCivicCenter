//
//  FaceRecViewController.m
//  HelloFrame
//
//  Created by 谌孙望 on 2023/5/25.
//

#import "FaceRecViewController.h"
#import "HYCivicCenterCommand.h"
#import <AlipayVerifySDK/APVerifyService.h>
#import <AlipayVerifySDK/MPVerifySDKService.h>
    
@interface FaceRecViewController ()

@end

@implementation FaceRecViewController

- (void)loadView {
    [super loadView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    
    [self getCertifyId];
    
}

- (void)getCertifyId {
    NSString *urlString = @"/api/third/face/certify/url";
    NSString *encodeUrl = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet URLQueryAllowedCharacterSet] invertedSet]];
    [HttpRequest postPathGov:@"" params:@{@"uri": encodeUrl, @"bizCode": @"FACE_SDK", @"devicetype": @"2", @"type": @"1"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 身份认证链接 == %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200 && [responseObject[@"success"] intValue] == 1) {
            NSString *certifyId = responseObject[@"data"][@"certifyId"];
            NSString *url = responseObject[@"data"][@"url"];
            
            // 旧链路
            [[APVerifyService sharedService] startVerifyService:@{@"url": url, @"certifyId": certifyId, @"bizcode": @"FACE_SDK"} target:self block:^(NSMutableDictionary *resultDic) {
                NSLog(@"resultDic:%@", resultDic);
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    [self getCertifyResultWith:certifyId];
                }
            }];
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"获取认证ID失败"];
        }
    }];
}

- (void)getCertifyResultWith:(NSString *)certifyId {
    NSString *urlString = @"/api/third/face/certify/result";
    NSString *encodeUrl = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet URLQueryAllowedCharacterSet] invertedSet]];
    [HttpRequest postPathGov:@"" params:@{@"uri": encodeUrl, @"certifyId": certifyId, @"devicetype": @"2"} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 身份识别结果== %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            if ([responseObject[@"success"] intValue] == 1) {
                if ([self.delegate respondsToSelector:@selector(getFaceResult:)]) {
                    [self.delegate getFaceResult:YES];
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"获取认证结果失败"];
                if ([self.delegate respondsToSelector:@selector(getFaceResult:)]) {
                    [self.delegate getFaceResult:NO];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
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
