//
//  SettingViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 16/1/19.
//  Copyright © 2016年 ApexSoft. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "UserHelpViewController.h"
#import "AboutViewController.h"

@interface SettingViewController ()
{
    float addHight;
    
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        
        addHight = 0;
    }
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth, 1)];
    lineView.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
    [self.view addSubview:lineView];
    
    
    UITapGestureRecognizer *singleTap1;
    
    singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    [_helpLeb addGestureRecognizer:singleTap1];
    
    
    UITapGestureRecognizer *singleTap;
    
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    
    //单点触摸
    singleTap.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap.numberOfTapsRequired = 1;
    [_aboutLab addGestureRecognizer:singleTap];
    

}

- (IBAction)callPhone:(UITouch *)sender
{
    
    UIView *view = [sender view];
    
    if (view.tag == 1) {
        UserHelpViewController *vc = [[UserHelpViewController alloc] init];
        vc.strId = @"SYBZ";
        vc.strName = @"使用帮助";
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        AboutViewController *vc = [[AboutViewController alloc] init];
        //vc.strId = @"SYBZ";
        //vc.strName = @"使用帮助";
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
