//
//  RealNameViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/5.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "RealNameViewController.h"
#import "AppDelegate.h"
#import "Child.h"
#import "CityViewController.h"
#import "ProviceViewController.h"


@interface RealNameViewController (){
    float addHight;
    Child *child;
    
    NSDictionary *proviceDic;
    NSDictionary *cityDic;

}

@end

@implementation RealNameViewController

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
    
    
    _sureBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // _sureBtn.layer.borderWidth = 1;
    
    _sureBtn.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 4;
    _sureBtn.backgroundColor = [ConMethods colorWithHexString:@"fe8103"];
    
    _codeBtn.layer.cornerRadius = 2;
    _codeBtn.layer.masksToBounds = YES;
    _codeBtn.userInteractionEnabled = YES;
    _codeBtn.backgroundColor = [ConMethods colorWithHexString:@"087dcd"];
    
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    self.prvoiceView.tag = 1;
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
   
    [self.prvoiceView addGestureRecognizer:singleTap1];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    self.cityView.tag = 2;
    //单点触摸
    singleTap.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap.numberOfTapsRequired = 1;
    
    [self.cityView addGestureRecognizer:singleTap];
    
   // [self requestCodeData];
    
}

- (void)reloadProviousTableView:(NSDictionary *)code{
    
    proviceDic = code;

    _proviceLab.text = [code objectForKey:@"XZQYMC"];
}


- (void)reloadCityTableView:(NSDictionary *)code{
    cityDic = code;
    _cityLab.text = [code objectForKey:@"XZQYMC"];

}


#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)even{
    [self.view endEditing:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame;
    if (textField == _code) {
        frame = _codeView.frame;
    } else if(textField == _address) {
    
     frame = _adressView.frame;
    } else {
    frame = textField.frame;
    }
    
    
    int offset = frame.origin.y + 76 - (self.view.frame.size.height - 256.0);//键盘高度216
       //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
   
    [UIView commitAnimations];
    
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
}








-(void)callPhone:(UITouch *)touch {
    UIView *view = [touch view];
    if (view.tag == 1) {
        ProviceViewController *vc = [[ProviceViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        
        if (proviceDic.count > 0) {
            
            CityViewController *vc = [[CityViewController alloc] init];
            vc.strCode = [proviceDic objectForKey:@"XZQYDM"];
            vc.strTitle = [proviceDic objectForKey:@"XZQYMC"];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"请选择城市"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
      
        }
    }

}



-(void) requestCodeData {
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERpwdManageappVcode] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
                                 displayInterval:2];
        
        NSLog(@"Error: %@", error);
    }];
    
    
}


-(void) requestData {
    
    
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在认证..." MBProgressHUD:nil target:self.navigationController.view displayInterval:2.0];
    
    
    
    NSString *str = [[Base64XD encodeBase64String:_password] strBase64];
    
    
    NSDictionary *parameters = @{@"idCard":_idCard,@"name":_name,@"password":str,@"passwordConfirm":str,@"address":_address.text,@"province":[proviceDic objectForKey:@"XZQYDM"],@"city":[cityDic objectForKey:@"XZQYDM"],@"sec":_section.text,@"captcha":_code.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERpwdManageappKh] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        child.age = 0;
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"实名认证成功"
                                       MBProgressHUD:nil
                                              target:self.navigationController.view
                                     displayInterval:3];
            
            
           NSMutableArray * array =[[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
             UIViewController *vc = [array objectAtIndex:array.count-2];
            
            
            if ([vc.nibName isEqualToString:@"FirstRealNameViewController"]) {
                [array removeObjectAtIndex:array.count-1];
                [array removeObjectAtIndex:array.count-1];
                [self.navigationController setViewControllers:array];
            }
            
            //[self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            _codeBtn.enabled = YES;
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.navigationController.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _codeBtn.enabled = YES;
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.navigationController.view
                                 displayInterval:2];
        
        NSLog(@"Error: %@", error);
    }];
    
    
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
- (IBAction)sureMethods:(id)sender {
    
    if ([_proviceLab.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请选择省份"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:2];
    } else if ([_cityLab.text isEqualToString:@""]){
    
        if ( [_proviceLab.text isEqualToString:@"中央单位"]) {
            
        } else {
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"请选择城市"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:2];
        
        }
    
    } else if ([_code.text isEqualToString:@""]) {
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:@"请输入验证码"
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:2];
    } else {
    
        [self requestData];
    }
    
}
- (IBAction)codeMethods:(id)sender {
    _codeBtn.enabled = NO;
    [self requestCodeData];
}
@end
