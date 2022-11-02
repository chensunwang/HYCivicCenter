//
//  MineViewController.m
//  HYCivicCenter_Example
//
//  Created by 谌孙望 on 2022/11/2.
//  Copyright © 2022 chensunwang. All rights reserved.
//

#import "MineViewController.h"
#import "HYGovernmentViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.grayColor;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"进入政务" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor darkGrayColor]];
}

- (void)btnClicked:(UIButton *)sender {
    HYGovernmentViewController *vc = [[HYGovernmentViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
