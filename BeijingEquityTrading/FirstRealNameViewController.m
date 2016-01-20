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

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _identiyNum) {
        if(![PublicMethod validateIdentityCard:_identiyNum.text]){
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"请输入正确的身份证号码"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
        }
    }else if (textField == _userName) {
        NSString *emailRegex = @"^[\u4E00-\u9FA5]{2,5}(?:·[\u4E00-\u9FA5]{2,5})*$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        bool sfzNo = [emailTest evaluateWithObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        if (!sfzNo) {
            //[self HUDShow:@"请输入正确的身份证号" delay:1.5];
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"请输入正确格式的姓名"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            _userName.text = @"";
        }
        
    }
}


#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)even{
    [self.view endEditing:YES];
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
- (IBAction)nextMthods:(id)sender {
    
    if(![PublicMethod validateIdentityCard:_identiyNum.text]){
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入正确的身份证号码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:2];
        
    }else if ([_identiyNum.text isEqualToString:@""]){
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入身份证号码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:2];
    
    } else if ([_userName.text isEqualToString:@""]){
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入姓名"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:2];
        
    }else if ([_passWord.text isEqualToString:@""]||[_passWordAgain.text isEqualToString:@""]){
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入交易密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:2];
        
    } else if (![_passWord.text isEqualToString:_passWordAgain.text]){
    
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"确认密码与交易密码不一样"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:2];
    }else if ([_passWord.text length] != 6){
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入6位数字的交易密码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:2];
    } else {
    
    RealNameViewController *vc = [[RealNameViewController alloc] init];
    vc.idCard = _identiyNum.text;
    vc.name = _userName.text;
    vc.password = _passWord.text;
    
    [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
