//
//  FirstRealNameViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/5.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "FirstRealNameViewController.h"
#import "AppDelegate.h"
#import "RealNameViewController.h"

@interface FirstRealNameViewController ()
{
    float addHight;
}
@end

@implementation FirstRealNameViewController

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
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 43, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods colorWithHexString:@"a2a2a2"];
    [self.view addSubview:lineView1];
    
    
    _nextBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // _sureBtn.layer.borderWidth = 1;
    
    _nextBtn.layer.masksToBounds = YES;
    
    _nextBtn.layer.cornerRadius = 4;
    _nextBtn.backgroundColor = [ConMethods colorWithHexString:@"fe8103"];
    // [_sureBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, 84 + addHight, ScreenWidth - 10, 1)];
    view1.backgroundColor = [ConMethods colorWithHexString:@"a2a2a2"];
    [self.view addSubview:view1];
    
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 124 + addHight, ScreenWidth - 10, 1)];
    view2.backgroundColor = [ConMethods colorWithHexString:@"a2a2a2"];
    [self.view addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(10, 164 + addHight, ScreenWidth - 10, 1)];
    view3.backgroundColor = [ConMethods colorWithHexString:@"a2a2a2"];
    [self.view addSubview:view3];
   
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(0, 204 + addHight, ScreenWidth , 1)];
    view0.backgroundColor = [ConMethods colorWithHexString:@"a2a2a2"];
    [self.view addSubview:view0];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextMthods:(id)sender {
    RealNameViewController *vc = [[RealNameViewController alloc] init];
    vc.idCard = _identiyNum.text;
    vc.name = _userName.text;
    vc.password = _passWord.text;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
