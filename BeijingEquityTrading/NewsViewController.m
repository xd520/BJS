//
//  NewsViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/11/26.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "NewsViewController.h"
#import "AppDelegate.h"

@interface NewsViewController ()
{
    float addHight;
    
    NSArray *arrTitle;
    UITableView *table;
}
@end

@implementation NewsViewController

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
    
    arrTitle = @[@"手机认证",@"登录密码",@"交易密码",@"银行卡认证",@"安全保护问题"];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight + 45, ScreenWidth,ScreenHeight - 65)];
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
