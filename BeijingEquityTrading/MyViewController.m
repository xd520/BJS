//
//  MyViewController.m
//  BeijingEquityTrading
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MyViewController.h"
#import "AppDelegate.h"
#import "PropertyViewController.h"
#import "TradeViewController.h"
#import "AttentionViewController.h"
#import "CertifyViewController.h"
#import "MeansViewController.h"
#import "NewsViewController.h"
#import "LoginViewController.h"

@interface MyViewController ()
{
    float addHight;
    NSArray *arrTitle;
     UITableView *table;
     UILabel *nameTitle;
   UIImageView *imgHeadVeiw;
}
@end

@implementation MyViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        [self getUIFirst];
}



-(void)getUIFirst {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.loginUser.count > 0) {
        if ([[delegate.loginUser objectForKey:@"success"] boolValue] == YES) {
            
            nameTitle.text = [[delegate.loginUser objectForKey:@"object"] objectForKey:@"username"];
            [self requestCategoryList];
            
            
            } else {
            
            //delegate.strlogin = @"1";
            LoginViewController *VC = [[LoginViewController alloc] init];
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
          
        }
        
    } else {
        // delegate.strlogin = @"1";
        LoginViewController *VC = [[LoginViewController alloc] init];
        
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        
        
    }
    
}


//获取验证图形
- (void)requestCategoryList
{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSURLRequest *reqest;
    
    
    if ([[delegate.loginUser objectForKey:@"object"] objectForKey:@"isTX"] == [NSNull null]) {
        reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/res/prj/default/images/avatar_default.jpg",SERVERURL]]];
    } else {
        
        if ([[[delegate.loginUser objectForKey:@"object"] objectForKey:@"isTX"] boolValue] == 0 ) {
            reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/res/prj/default/images/avatar_default.jpg",SERVERURL]]];
        } else {
            
            reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/LbFiles/type=tx/%@.jpg",SERVERURL,[[delegate.loginUser objectForKey:@"object"] objectForKey:@"USERID"]]]];
        }
    }

    
    //reqest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/captcha",SERVERURL]]];
    
    [imgHeadVeiw setImageWithURLRequest:reqest placeholderImage:[UIImage imageNamed:@""] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        NSLog(@"JSON: %@  %@ %@", request,response,image);
        //self.codeImgve.image = nil;
        
        // self.codeImgve.image =  [UIImage  safeImageWithData:image];;
        
        imgHeadVeiw.image = image;
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        
        NSLog(@"JSON: %@  %@ %@", request,response,error);
    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor= [ConMethods colorWithHexString:@"d23838"];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
        
    }

      arrTitle = @[@"我的资产",@"我的交易",@"我的关注",@"认证中心",@"个人资料",@"消息中心"];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight - 49)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    table.bounces = NO;
    
    [self.view addSubview:table];
    
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
      return 180;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view;
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
        view.backgroundColor = [ConMethods colorWithHexString:@"be1212"];
        
        
        imgHeadVeiw = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 100)/2, 40, 100, 100)];
        imgHeadVeiw.backgroundColor = [UIColor redColor];
        
        imgHeadVeiw.layer.cornerRadius = imgHeadVeiw.frame.size.width / 2;
        imgHeadVeiw.clipsToBounds = YES;
        imgHeadVeiw.layer.borderWidth = 4.0f;
        imgHeadVeiw.layer.borderColor = [ConMethods colorWithHexString:@"d23838"].CGColor;
        imgHeadVeiw.image = [UIImage imageNamed:@"logo"];
        [view addSubview:imgHeadVeiw];
        
        
        
        
        nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 150, ScreenWidth - 100, 17)];
        nameTitle.text = @"我的账户";
        nameTitle.backgroundColor = [UIColor clearColor];
        nameTitle.textAlignment = NSTextAlignmentCenter;
        nameTitle.textColor = [UIColor whiteColor];
        nameTitle.font = [UIFont systemFontOfSize:17];
        [view addSubview:nameTitle];
        
        
        
     
    }
    return view;
    
}




- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        PropertyViewController *vc = [[PropertyViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } else if (indexPath.row == 1){
        
        TradeViewController *vc = [[TradeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 2) {
        AttentionViewController *vc = [[AttentionViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == 3){
        CertifyViewController *vc = [[CertifyViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4){
        MeansViewController *vc = [[MeansViewController alloc] init];
        vc.headViewImg = imgHeadVeiw.image;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 5){
        NewsViewController *vc = [[NewsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
}



/*
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}
*/


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

@end
