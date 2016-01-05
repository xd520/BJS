//
//  CertifyViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/11/26.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "CertifyViewController.h"
#import "AppDelegate.h"
#import "ChangeLoginPWViewController.h"
#import "ChangerPassWordViewController.h"
#import "PhoneNumViewController.h"
#import "FirstRealNameViewController.h"
#import "SetEmailViewController.h"

@interface CertifyViewController ()
{
    float addHight;
    
    NSArray *arrTitle;
    UITableView *table;
    NSDictionary *myDic;
    NSArray *arrA;
    UILabel *labBank;
    UILabel *emailLab;
    
    
}
@end

@implementation CertifyViewController


-(void)viewDidAppear:(BOOL)animated {

    [self requestData];
}

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

   
   UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [self.view addSubview:lineView1];
    
    [self requestData];
    
    arrA = @[@"已认证",@"修改｜找回",@"修改｜找回"];

    
    arrTitle = @[@"手机认证",@"登录密码",@"交易密码",@"实名认证",@"邮箱认证"];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight + 45, ScreenWidth,ScreenHeight - 65)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    table.bounces = NO;
    
    [self.view addSubview:table];
    
    
}

-(void) requestData {
    
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERpwdManageappappIndex] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            
            /*
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            */
            myDic = [responseObject objectForKey:@"object"];
            
            if (table) {
                table.delegate = nil;
                table.dataSource = nil;
                [table removeFromSuperview];
                table = nil;
            }
            
            table = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight + 45, ScreenWidth,ScreenHeight - 65)];
            [table setDelegate:self];
            [table setDataSource:self];
            table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
            table.tableFooterView = [[UIView alloc] init];
            
            table.bounces = NO;
            
            [self.view addSubview:table];

            
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



#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RepairCellIdentifier];
    }
    
    
    cell.textLabel.text = [arrTitle objectAtIndex:indexPath.row];
    
    if (indexPath.row == 3) {
        if (labBank) {
            [labBank removeFromSuperview];
        }
        
        labBank = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 130, 12.5, 100, 15)];
        labBank.textColor = [ConMethods colorWithHexString:@"666666"];
       
        labBank.font = [UIFont systemFontOfSize:15];
        labBank.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:labBank];
    } else if (indexPath.row == 4) {
        if (emailLab) {
            [emailLab removeFromSuperview];
        }
        
        emailLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 130, 12.5, 100, 15)];
        emailLab.textColor = [ConMethods colorWithHexString:@"666666"];
        
        emailLab.font = [UIFont systemFontOfSize:15];
        emailLab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:emailLab];
    }else {
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 130, 12.5, 100, 15)];
    lab.textColor = [ConMethods colorWithHexString:@"666666"];
    lab.text = [arrA objectAtIndex:indexPath.row];
    lab.font = [UIFont systemFontOfSize:15];
    lab.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:lab];
    }
    
    if (indexPath.row == 3) {
        
        if ([[myDic objectForKey:@"isSetCert"] boolValue]) {
             labBank.text = @"已认证";
         cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
             labBank.text = @"未认证";
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else  if (indexPath.row == 4) {
        
        if ([[myDic objectForKey:@"isSetEmail"] boolValue]) {
            emailLab.text = @"已设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            emailLab.text = @"未设置";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else {
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}




- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        PhoneNumViewController *vc = [[PhoneNumViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        ChangerPassWordViewController *vc = [[ChangerPassWordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if(indexPath.row == 1){
        ChangeLoginPWViewController *vc = [[ChangeLoginPWViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    
    }else if (indexPath.row == 3){
    
        
        if (![[myDic objectForKey:@"isSetCert"] boolValue]){
           
            FirstRealNameViewController *vc = [[FirstRealNameViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        SetEmailViewController *vc = [[SetEmailViewController alloc] init];
         [self.navigationController pushViewController:vc animated:YES];
    
    }
    
     [tbleView deselectRowAtIndexPath:indexPath animated:YES];
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
