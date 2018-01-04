//
//  ViewController.m
//  MyUtility
//
//  Created by tracetion on 14-9-5.
//  Copyright (c) 2014年 YMQ. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "AddContactAction.h"
#import "ChineseToPinyin.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSDate *date = [NSDate date];
    NSDate *week = [date beginningOfMonth];
    debugLog(@"%@",week);
    debugMethod();
    
    UILabel *label = [[UILabel alloc]init];
    
    int a = 2;
    NSLog(@"%f",a/1.5);

    [self.view addSubview:label];
    
    
    NSDate *date1 = [NSDate date];
    NSString *str = [NSDate getMonthBeginAndEndWith:date1 Type:NSCalendarUnitMonth];
    debugLog(@"%@",str);
    
    UIButton *btn = [UIButton creatBtnWithFram:CGRectMake(20, 40, 100, 50) WithNBGTitle:@"dasda" WithHTitle:nil WithTarget:self WithSEL:@selector(btnClick:)];
    btn.backgroundColor = [UIColor blackColor];
    btn.section = 20;
    [self.view addSubview:btn];
    
}

- (void)btnClick:(UIButton *)btn
{
    debugLog(@"%lu",btn.section);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
