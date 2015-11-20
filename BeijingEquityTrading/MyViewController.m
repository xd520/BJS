//
//  MyViewController.m
//  BeijingEquityTrading
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MyViewController.h"
#import "AppDelegate.h"

@interface MyViewController ()
{
    float addHight;
    NSArray *arrTitle;
     UITableView *table;
     UILabel *nameTitle;
}
@end

@implementation MyViewController

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

     arrTitle = @[@"我的资产",@"当日委托/撤单",@"当月成交记录",@"资金变动查询",@"账户中心"];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight, ScreenWidth,ScreenHeight - 69)];
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
    
      return 150;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view;
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
        view.backgroundColor = [UIColor redColor];
        
        nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 13, ScreenWidth - 100, 17)];
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
           
            
        } else if (indexPath.row == 1){
           
            
            
        }else if (indexPath.row == 2) {
          //  DayDealViewController *vc = [[DayDealViewController alloc] init];
           // vc.hidesBottomBarWhenPushed = YES;
           // [self.navigationController pushViewController:vc animated:YES];
            
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

@end
