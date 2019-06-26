//
//  ViewController.m
//  SXCrashLogProfiler
//
//  Created by Sunny on 2019/6/26.
//  Copyright © 2019 Sunny. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 200, 200, 30);
    [btn setTitle:@"点击进入日历列表" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionPushToList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton * btnCrash = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCrash.frame = CGRectMake(100, 300, 200, 30);
    [btnCrash setTitle:@"点击crash" forState:UIControlStateNormal];
    [btnCrash setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCrash addTarget:self action:@selector(actionCrash:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCrash];
}


- (void)actionPushToList:(UIButton *)btn
{
    [self.navigationController pushViewController:[NSClassFromString(@"SXLocalLogListVC") new] animated:YES];
}

- (void)actionCrash:(UIButton *)btn
{
    id dict = @{};
    dict[0] = @"1";
}


@end
