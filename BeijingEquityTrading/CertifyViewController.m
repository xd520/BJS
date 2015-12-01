//
//  CertifyViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/11/26.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "CertifyViewController.h"
#import "AppDelegate.h"

@interface CertifyViewController ()
{
    float addHight;
    UIView *lineView;
    
    //标记前一个按钮的tag
    NSInteger countBtn;
    
    
}
@end

@implementation CertifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    countBtn = 0;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }

    UIView *headVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth, 32)];
   UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [headVeiw addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 31, ScreenWidth, 1)];
    lineView2.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [headVeiw addSubview:lineView2];
    
    
    
    NSArray *arr = @[@"我的银行卡",@"我的保证金",@"交易记录"];
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth/3*i, 1, ScreenWidth/3, 30);
        btn.tag = i;
        if (i == 0) {
        [btn setTintColor:[ConMethods colorWithHexString:@"950401"]];
        } else {
        [btn setTintColor:[ConMethods colorWithHexString:@"333333"]];
        
        }
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectMethods:) forControlEvents:UIControlEventTouchUpInside];
        [headVeiw addSubview:btn];
        
        
    }
    lineView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth/3 - 75)/2, 28, 75, 2)];
    lineView.backgroundColor = [ConMethods colorWithHexString:@"950401"];
    [headVeiw addSubview:lineView];
    
    
    
}


#pragma mark -  滑动条选择条

-(void)selectMethods:(UIButton *)btn {
    
    if (btn.tag == countBtn) {
       [btn setTintColor:[ConMethods colorWithHexString:@"950401"]];
        lineView.frame = CGRectMake((ScreenWidth/3 - 75)/2 + ScreenWidth/3*countBtn, 28, 75, 2);
        
        
    } else {
     UIButton *btnfirst = (UIButton *)[self.view viewWithTag:countBtn];
         [btnfirst setTintColor:[ConMethods colorWithHexString:@"333333"]];
        countBtn = btn.tag;
        [btn setTintColor:[ConMethods colorWithHexString:@"950401"]];
        lineView.frame = CGRectMake((ScreenWidth/3 - 75)/2 + ScreenWidth/3*countBtn, 28, 75, 2);
    
    }
    


}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
