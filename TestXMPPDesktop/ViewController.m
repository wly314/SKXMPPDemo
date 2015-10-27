//
//  ViewController.m
//  TestXMPPDesktop
//
//  Created by LeouW on 15/10/19.
//  Copyright © 2015年 CC. All rights reserved.
//

#import "ViewController.h"

#import "SKXMPPViewController.h"

@interface ViewController ()<UITextViewDelegate> {
    
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 80, 100, 30);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    /*
     *navigation设置－此处设置将会在下一级页面生效
     */
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnClick {
    
    SKXmppViewController *xmppVC = [[SKXmppViewController alloc] init];
    xmppVC.navigationItem.title = @"群组列表";
    [self.navigationController pushViewController:xmppVC animated:YES];
//    xmppVC.skXMPPUserNameString = @"51327";
//    xmppVC.skXMPPUserPasswordString = @"admin";
//    
//    xmppVC.skDomainString = @"murp-ymm2003";//XMPP主机
//    xmppVC.skResourceString = @"iphone_teacher_1.0.8";//resource
//    xmppVC.skServerString = @"w.xlm1.com";//服务器地址
//    xmppVC.skServerPort = 42079;//服务器端口
    
}



- (IBAction)touchDowns:(id)sender {
}
@end
