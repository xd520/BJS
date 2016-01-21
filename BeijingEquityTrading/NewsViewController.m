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
    
    NSMutableArray *dataList;
    UITableViewCell *moreCell;
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
    lineView1.backgroundColor = [ConMethods colorWithHexString:@"a2a2a2"];
    [self.view addSubview:lineView1];
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight + 45, ScreenWidth,ScreenHeight - 65)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    //table.bounces = NO;
    
    [self.view addSubview:table];
    
    
    
    [self setupHeader];
    
    [self requestData];
    
    
}

- (void)setupHeader
{
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:table];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self requestData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    // [refreshHeader beginRefreshing];
}



-(void) requestDataDetel:(NSString *)str {
    
    NSDictionary *parameters = @{@"id":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERdelete] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"删除成功"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
           
            [self requestData];
        } else {
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
          if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
            
            if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.loginUser removeAllObjects];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
          }

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




-(void) requestData {

    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERinboxList] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedCategoryList:[[[responseObject objectForKey:@"object"] objectForKey:@"message"] objectForKey:@"object"]];
            
        } else {
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
            
            if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.loginUser removeAllObjects];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                }
            
            }
            
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
    
    [table reloadData];
    
}





#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    
    if ([dataList count] == 0) {
        
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
            [backView setBackgroundColor:[ConMethods colorWithHexString:@"ececec"]];
            //图标
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 100, 57, 57)];
            [iconImageView setImage:[UIImage imageNamed:@"icon_none"]];
            [backView addSubview:iconImageView];
            //提示
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27, ScreenWidth, 15)];
            [tipLabel setFont:[UIFont systemFontOfSize:15]];
            [tipLabel setTextAlignment:NSTextAlignmentCenter];
            [tipLabel setTextColor:[ConMethods colorWithHexString:@"404040"]];
            tipLabel.backgroundColor = [UIColor clearColor];
            [tipLabel setText:@"没有任何消息哦~"];
            [backView addSubview:tipLabel];
            [cell.contentView addSubview:backView];
        
    }else {
     cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];

    if (cell == nil) {
     
        float totalHigh;
        
        totalHigh = [PublicMethod getStringHeight:[[dataList objectAtIndex:indexPath.row] objectForKey:@"FSNR"] font:[UIFont systemFontOfSize:13] with:ScreenWidth - 30] + 45;
        
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, totalHigh + 10)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
       
        //添加背景View
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, ScreenWidth - 10, totalHigh)];
        [backView setBackgroundColor:[UIColor whiteColor]];
        backView.layer.cornerRadius = 2;
        backView.layer.masksToBounds = YES;
        
       
        //品牌
        UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, ScreenWidth - 140, 20)];
        brandLabel.font = [UIFont systemFontOfSize:15];
        [brandLabel setTextColor:[ConMethods colorWithHexString:@"bd0100"]];
        [brandLabel setBackgroundColor:[UIColor clearColor]];
        // brandLabel.numberOfLines = 0;
        brandLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"TITLE"];
        [backView addSubview:brandLabel];
        
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth - 135, 15, 120, 10)];
        dayLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FSRQ"];
        dayLabel.font = [UIFont systemFontOfSize:11];
        dayLabel.textAlignment = NSTextAlignmentRight;
        dayLabel.textColor = [ConMethods colorWithHexString:@"999999"];
        [backView addSubview:dayLabel];
        
        UIView *firstVeiw = [[UIView alloc] init];
        firstVeiw.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FSNR"];
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.textColor = [ConMethods colorWithHexString:@"333333"];
        dateLabel.numberOfLines = 0;
        dateLabel.frame = CGRectMake(5,0, ScreenWidth - 30, [PublicMethod getStringHeight:dateLabel.text font: dateLabel.font with:ScreenWidth - 30]);
        firstVeiw.frame = CGRectMake(5, 35, ScreenWidth - 20, [PublicMethod getStringHeight:dateLabel.text font: dateLabel.font with:ScreenWidth - 30]);
        [firstVeiw addSubview:dateLabel];
        [backView addSubview:firstVeiw];
    [cell.contentView addSubview:backView];
    }
}
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (dataList.count == 0) {
        
        return 95;
    } else {
    
        float totalHigh;
        
        totalHigh = [PublicMethod getStringHeight:[[dataList objectAtIndex:indexPath.row] objectForKey:@"FSNR"] font:[UIFont systemFontOfSize:13] with:ScreenWidth - 30] + 45 + 10;
        return totalHigh;
    }
    
}


- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIAlertView *outAlert = [[UIAlertView alloc] initWithTitle:[[dataList objectAtIndex:indexPath.row] objectForKey:@"TITLE"] message:@"是否要删除该消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    outAlert.tag = indexPath.row;
    [outAlert show];
    
    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
        if (buttonIndex != 0) {
            
            [self requestDataDetel:[[dataList objectAtIndex:alertView.tag] objectForKey:@"KEYID"]];
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
@end
