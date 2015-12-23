//
//  ForgetPWDViewController.m
//  添金投
//
//  Created by mac on 15/9/29.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "ForgetPWDViewController.h"
#import "AppDelegate.h"
#import "Child.h"
#import "FoggterAgainViewController.h"

@interface ForgetPWDViewController ()
{
     Child *child;
}
@end

@implementation ForgetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    }
    
    _nextBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _nextBtn.layer.borderWidth = 1;
    
    _nextBtn.layer.masksToBounds = YES;
    
    _nextBtn.layer.cornerRadius = 15;
    
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"title_bg"] forState:UIControlStateNormal];
    
     
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _phoneNum) {
        
            NSString *emailRegex = @"^1[3|4|5|8][0-9]\\d{8}$";
            NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            bool sfzNo = [emailTest evaluateWithObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            
            if (!sfzNo) {
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:@"请输入正确的手机号码"
                                           MBProgressHUD:nil
                                                  target:self.view
                                         displayInterval:3];
                
                
                textField.text = @"";
            }
    }
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


-(void) requestData {
    
    NSDictionary *parameters = @{@"pageNo":@"",@"pageSize":@""};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERwdbzj] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            
            FoggterAgainViewController *vc = [[FoggterAgainViewController alloc] init];
            //vc.sessionId = [dataArray objectForKey:@"sessionId"];
            
            //vc.phoneNumStr = _phoneNum.text;
            [self.navigationController pushViewController:vc animated:YES];
            
           
            
        } else {
           
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}





           


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextMethods:(id)sender {
    [self.view endEditing:YES];
    if ([_phoneNum.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入有效的手机号码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
       
    } else if ([_userName.text isEqualToString:@""]){
    
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入曾经注册过的用户名"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
   
    } else {
    
        
           
            NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
            [paraDic setObject:_phoneNum.text forKey:@"mobilePhone"];
             [paraDic setObject:_userName.text forKey:@"username"];
        
        
    
    }
}


@end
