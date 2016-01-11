//
//  PayForViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/14.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "PayForViewController.h"
#import "AppDelegate.h"
#import "Child.h"
#import "UserProcrolViewController.h"

@interface PayForViewController ()
{
    float addHight;
    Child *child;
    int count;
}
@end

@implementation PayForViewController

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

   
    UIView *lineView0 = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 1)];
    lineView0.backgroundColor = [ConMethods  colorWithHexString:@"a5a5a5"];
    [self.backView addSubview:lineView0];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,59, ScreenWidth - 10, 1)];
    lineView.backgroundColor = [ConMethods  colorWithHexString:@"dedede"];
    [self.backView addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10,90 + 13, ScreenWidth - 10, 1)];
    lineView1.backgroundColor = [ConMethods  colorWithHexString:@"dedede"];
    [self.backView addSubview:lineView1];
    
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10,120 + 27, ScreenWidth - 10, 1)];
    lineView2.backgroundColor = [ConMethods  colorWithHexString:@"dedede"];
    [self.backView addSubview:lineView2];
    
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0,_backView.frame.size.height - 1, ScreenWidth, 1)];
    lineView3.backgroundColor = [ConMethods  colorWithHexString:@"dedede"];
    [self.backView addSubview:lineView3];
    
    
    //_loginBtn.backgroundColor = [ConMethods colorWithHexString:@"b30000"];
    _sureBtn.layer.cornerRadius = 4;
    _sureBtn.layer.masksToBounds = YES;
    
    
    
    _codeBtn.layer.cornerRadius = 2;
    _codeBtn.layer.masksToBounds = YES;
    _codeBtn.userInteractionEnabled = YES;
    _codeBtn.backgroundColor = [ConMethods colorWithHexString:@"087dcd"];
    
    
    
    [self requestData:_strId withMark:_markId];
    
}


#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//监听方法

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"%@",change);
    
    if ([[change objectForKey:@"new"] integerValue] <= 0) {
        
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeBtn.enabled = YES;
        _codeBtn.backgroundColor = [ConMethods colorWithHexString:@"087dcd"];
        [child removeObserver:self forKeyPath:@"age"];
    } else {
        
        [_codeBtn setTitle:[NSString stringWithFormat:@"%@秒后获取",[change objectForKey:@"new"]] forState:UIControlStateNormal];
        _codeBtn.enabled = NO;
        _codeBtn.backgroundColor = [UIColor grayColor];
        
        
    }
}



-(void) requestData {
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqytsendVcode] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"获取成功"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            //注册观察者
            child = [[Child alloc] init];
            child.age = [[[responseObject objectForKey:@"object"] objectForKey:@"time"] integerValue];
            [child addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"xxxx"];
            
        } else {
            
            _codeBtn.enabled = YES;
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _codeBtn.enabled = YES;
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}


-(void) requestSummitData {
    
    NSDictionary *parameters = @{@"bzjbz":_markId,@"jymm":[[Base64XD encodeBase64String:_jiaoyiPassword.text] strBase64],@"id":_strId,@"yzm":_code.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqytsubmitApplyOutMoney] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        child.age = 0;
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"退款申请提交成功"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self requestDatacheckBindCardResult:[[responseObject objectForKey:@"object"] objectForKey:@"FID_SQH"]];
            
        } else {
            
            _codeBtn.enabled = YES;
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _codeBtn.enabled = YES;
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}


-(void) requestDatacheckBindCardResult:(NSString *)str {
    
    NSDictionary *parameters = @{@"sqh":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERqytcheckBindCardResult] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            _codeBtn.enabled = YES;
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _codeBtn.enabled = YES;
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}





//请求数据方法
-(void) requestData:(NSString *)str withMark:(NSString *)markStr{
    
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@/service/pay/qyt/app_applyOutMoney?id=%@&bzjbz=%@",SERVERURL,str,markStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            
            _payMoney.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[responseObject objectForKey:@"object"] objectForKey:@"zzje"] floatValue]]]];
            _payBigMoney.text = [ConMethods digitUppercase:[NSString stringWithFormat:@"%.2f",[[[responseObject objectForKey:@"object"] objectForKey:@"zzje"] floatValue]]];
            
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


- (IBAction)back:(id)sender {
    if (child.age != 0) {
         child.age = 0;
    }
   
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)codeMethods:(id)sender {
    _codeBtn.enabled = NO;
    [self requestData];
}
- (IBAction)remberMethods:(id)sender {
    count++;
    if (count % 2 == 0) {
        [sender setImage:[UIImage imageNamed:@"select0"] forState:UIControlStateNormal];
        
    } else {
        
        [sender setImage:[UIImage imageNamed:@"select1"] forState:UIControlStateNormal];
    }
    

}

- (IBAction)ProctalMethods:(id)sender {
    UserProcrolViewController *vc = [[UserProcrolViewController alloc] init];
    vc.strName = @"退款协议";
    vc.strId = @"QKXY";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)sureMethods:(id)sender {
    [self.view endEditing:YES];
    
    if (count%2 == 0) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请同意并阅读退款协议"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
    } else if ([_code.text isEqualToString:@""]){
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"验证码不能为空"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
    } else if ([_jiaoyiPassword.text isEqualToString:@""]){
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"交易密码不能为空"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
    } else {
    
        [self requestSummitData];
    }
}

-(void)dealloc {
    
    //[child removeObserver:self forKeyPath:@"age"];
    
}


@end
