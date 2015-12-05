//
//  MoreViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-2-10.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "MoreViewController.h"
#import "LoginViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "PublicViewController.h"
#import "ProviousViewController.h"

@interface MoreViewController ()
{
    NSArray *array;
    NSArray *arrImage;
    UILabel *_longtime;
     UILabel *_longtime1;
}
@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self getUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    }
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods  colorWithHexString:@"a5a5a5"];
    [self.headView addSubview:lineView1];
    
    
    
    [self.navigationController setNavigationBarHidden:YES];
   [_table setScrollEnabled:NO];
   // array = @[@"信息公告",@"检查更新",@"关于我们"];
     array = @[@"信息公告",@"关于我们"];
   // arrImage = @[[UIImage imageNamed:@"icon_pwd"],[UIImage imageNamed:@"icon_update"],[UIImage imageNamed:@"我的客户经理"]];
    
    
    _logoutBtn.backgroundColor = [ConMethods colorWithHexString:@"b30000"];
    _logoutBtn.layer.cornerRadius = 4;
    _logoutBtn.layer.masksToBounds = YES;
    
    /*
    MyLabel *lab = [[MyLabel alloc] initWithFrame:CGRectMake(50, 200, 200, 40)];
    //lab.backgroundColor = [UIColor brownColor];
    lab.textColor = [UIColor blueColor];
    lab.text = @"You Are Sb!";
    [self.view addSubview:lab];
    
    MyView *view = [[MyView alloc] initWithFrame:CGRectMake(50, 200, 220, 100)];
    [self.view addSubview:view];
    */
    
    
   }

-(void)getUI{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.loginUser.count > 0) {
        if ([[delegate.loginUser objectForKey:@"success"] boolValue] == YES) {
            _logoutBtn.hidden = NO;
        }else {
            
            _logoutBtn.hidden = YES;
        }
    }else {
        _logoutBtn.hidden = YES;
        
    }


}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}




#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
   
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RepairCellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    //cell.imageView.image = [arrImage objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 35, 10, 20, 20)];
    img.image = [UIImage imageNamed:@"next_icon"];
    [cell addSubview:img];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, ScreenWidth, 0.5)];
    [subView setBackgroundColor:[ConMethods colorWithHexString:@"dcdcdc"]];
    //if ([indexPath row] != 2) {
        [cell.contentView addSubview:subView];
    //}
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    /*
     UITableViewCellSelectionStyleNone,
     UITableViewCellSelectionStyleBlue,
     UITableViewCellSelectionStyleGray,
     UITableViewCellSelectionStyleDefault
     
     */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
//    NSLog(@"select:%ld", indexPath.row);
    
       
    if (indexPath.row == 0) {
        ProviousViewController *cv = [[ProviousViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
    }else if (indexPath.row == 1) {
        AboutViewController *cv = [[AboutViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutBtn:(id)sender {
  
    UIAlertView *outAlert = [[UIAlertView alloc] initWithTitle:@"注销" message:@"是否要退出该帐号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    outAlert.tag = 10003;
    [outAlert show];
   
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
            [[UIApplication sharedApplication]openURL:url];
        }
    } else if (alertView.tag==10003){
        
    if (buttonIndex != 0) {
        
        [self requestData];
        }
    }
}


-(void)requestData{
    
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在注销..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    
    /*
     <AFURLRequestSerialization>`
     - `AFHTTPRequestSerializer`
     - `AFJSONRequestSerializer`
     - `AFPropertyListRequestSerializer`
     * `<AFURLResponseSerialization>`
     - `AFHTTPResponseSerializer`
     - `AFJSONResponseSerializer`
     - `AFXMLParserResponseSerializer`
     - `AFXMLDocumentResponseSerializer` _(Mac OS X)_
     - `AFPropertyListResponseSerializer`
     - `AFImageResponseSerializer`
     - `AFCompoundResponseSerializer`
     
     */
   
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERLogout] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]){
            
           
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"注销成功"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:2];
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.loginUser removeAllObjects];
             _logoutBtn.hidden = YES;
            
        } else {
            
            if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.loginUser removeAllObjects];
                
                LoginViewController *cv = [[LoginViewController alloc] init];
                cv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cv animated:YES];
            } else {
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.view
                                         displayInterval:3];
            }
        
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.navigationController.view
                                 displayInterval:3];
        
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc {
   
    [_longtime removeFromSuperview];
    _longtime = nil;
    [_longtime1 removeFromSuperview];
    _longtime1 = nil;
    [_table removeFromSuperview];
    _table = nil;
    [_logoutBtn removeFromSuperview];
    _logoutBtn = nil;

}




@end
