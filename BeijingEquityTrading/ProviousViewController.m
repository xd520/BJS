//
//  ProviousViewController.m
//  添金投
//
//  Created by mac on 15/7/15.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "ProviousViewController.h"
#import "AppDelegate.h"
#import "PublicViewController.h"

@interface ProviousViewController ()
{
    UITableView *tableView;
    NSMutableArray *dataList;
    UITableViewCell *moreCell;
    float addHight;
}
@end

@implementation ProviousViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor= [UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods  colorWithHexString:@"a5a5a5"];
    [self.headView addSubview:lineView1];
    
    
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + addHight, ScreenWidth,ScreenHeight - 64)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setBackgroundColor:[UIColor clearColor]];    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    
  
    [self requestData:@"4"];
   
}

//请求数据方法
-(void) requestData:(NSString *)str {
    
  
    
    NSDictionary *parameters = @{@"id":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERinfomenu] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedCategoryList:[[responseObject objectForKey:@"object"] objectForKey:@"app_menuList"]];
            
        } else {
            
            NSMutableArray *arr = [NSMutableArray array];
            [self recivedCategoryList:arr];
            
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


//处理品牌列表
- (void)recivedCategoryList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    
   
        if (dataList.count > 0) {
            [dataList removeAllObjects];
        }
    
    
    if(dataList){
        
        [dataList addObjectsFromArray:[dataArray mutableCopy]];
    } else {
        dataList = [dataArray mutableCopy];
    }
    
    
    [tableView reloadData];
    
}


#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([dataList count] == 0) {
        return 1;
    } else {
        return [dataList count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    if ([dataList count] == 0) {
        moreCell = [tableView dequeueReusableCellWithIdentifier:@"loadMoreCell"];
        moreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMoreCell"];
        [moreCell setBackgroundColor:[UIColor clearColor]];
        moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *toastLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 160, 59)];
        [toastLabel setFont:[UIFont systemFontOfSize:12]];
        toastLabel.backgroundColor = [UIColor clearColor];
        [toastLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
        toastLabel.numberOfLines = 0;
        toastLabel.text = @"更多...";
        toastLabel.textAlignment = UITextAlignmentCenter;
        [moreCell.contentView addSubview:toastLabel];
        return moreCell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor clearColor]];
            //添加背景View
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
            [backView setBackgroundColor:[ConMethods colorWithHexString:@"fafafa"]];
            //品牌
            UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 170, 39)];
            brandLabel.font = [UIFont boldSystemFontOfSize:15];
            [brandLabel setTextColor:[ConMethods colorWithHexString:@"646464"]];
            [brandLabel setBackgroundColor:[UIColor clearColor]];
            brandLabel.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"NAME"];
            [backView addSubview:brandLabel];
         
            UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
            [subView setBackgroundColor:[ConMethods colorWithHexString:@"dedede"]];
            [backView addSubview:subView];
            
              cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            [cell.contentView addSubview:backView];
        }
    }
    return cell;
}
#pragma mark - Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [dataList count]) {
        return 40;
    } else {
        return 40;
    }
    return 95;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PublicViewController *vc = [[PublicViewController alloc] init];
    vc.strId = [[dataList objectAtIndex:indexPath.row] objectForKey:@"ID"];
    vc.title = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"NAME"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
   
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
