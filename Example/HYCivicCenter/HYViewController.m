//
//  HYViewController.m
//  HYCivicCenter
//
//  Created by chensunwang on 08/23/2022.
//  Copyright (c) 2022 chensunwang. All rights reserved.
//

#import "HYViewController.h"
#import "DigitalcitizenViewController.h"
#import "HYNavigationController.h"
#import "HYGovernmentViewController.h"
#import "HYHandleAffairsViewController.h"
#import "MainApi.h"

@interface HYViewController ()

@end

@implementation HYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    MainApi *mainApi = [MainApi sharedInstance];
    mainApi.token = @"44_WyvH4LoajBX1HpSV3Fcfh00k";

    UIButton *clicked = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 40)];
    [clicked setTitle:@"政务办事" forState:UIControlStateNormal];
    [clicked setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [clicked addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clicked];

    UIButton *zhengwu = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 40)];
    [zhengwu setTitle:@"政务服务" forState:UIControlStateNormal];
    [zhengwu setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [zhengwu addTarget:self action:@selector(zhengwu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhengwu];
}

- (void)clicked {
//    DigitalcitizenViewController *vc = [[DigitalcitizenViewController alloc] init];
    HYHandleAffairsViewController *vc = [[HYHandleAffairsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)zhengwu {
    HYGovernmentViewController *vc = [[HYGovernmentViewController alloc] init];
    vc.hyTitleColor = UIColor.blackColor;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
