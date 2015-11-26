//
//  MarkListViewController.m
//  BeijingEquityTrading
//
//  Created by mac on 15/11/26.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MarkListViewController.h"
#import "AppDelegate.h"

@interface MarkListViewController ()
{
    float addHight;
    UITableView *table;
    NSMutableArray *dataList;
    NSString *start;
    NSString *limit;
    BOOL hasMore;
    UITableViewCell *moreCell;
}

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@end

@implementation MarkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    start = @"1";
    limit = @"20";
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }

    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 45, ScreenWidth, 30)];
    firstView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 40, 20)];
    lab.text = @"状态";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [ConMethods colorWithHexString:@"333333"];
    lab.font = [UIFont systemFontOfSize:14];
    lab.backgroundColor = [UIColor clearColor];
    [firstView addSubview:lab];
    
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 40, 20)];
    lab1.text = @"序号";
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.textColor = [ConMethods colorWithHexString:@"333333"];
    lab1.font = [UIFont systemFontOfSize:14];
    lab1.backgroundColor = [UIColor clearColor];
    [firstView addSubview:lab1];
    
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, ScreenWidth - 230, 20)];
    lab2.text = @"价格";
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.textColor = [ConMethods colorWithHexString:@"333333"];
    lab2.font = [UIFont systemFontOfSize:14];
    lab2.backgroundColor = [UIColor clearColor];
    [firstView addSubview:lab2];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 140, 5, 135, 20)];
    lab3.text = @"时间";
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.textColor = [ConMethods colorWithHexString:@"333333"];
    lab3.font = [UIFont systemFontOfSize:14];
    lab3.backgroundColor = [UIColor clearColor];
    [firstView addSubview:lab3];
    [self.view addSubview:firstView];
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0,addHight + 45 + 30, ScreenWidth,ScreenHeight - 95)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"F7F7F5"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:table];
    
    
    
    [self setupHeader];
    [self setupFooter];
    
    [self requestData:_strId];
    
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    
    if (dataList.count > 0) {
        
        count = dataList.count;
        
    } else {
        
        count = 1;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    if ([dataList count] == 0 ) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
        [backView setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
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
        [tipLabel setText:@"没有任何商品哦~"];
        [backView addSubview:tipLabel];
        [cell.contentView addSubview:backView];
        
    } else{
    
    
    cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
        //添加背景View
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
       
        
        NSString *strName,*strColor;
        
        
        if (indexPath.row == 0) {
            strName = @"成交";
           strColor = @"850301";
          [backView setBackgroundColor:[ConMethods colorWithHexString:@"fdfec4"]];
        } else {
            
            strName = @"出局";
            strColor = @"989898";
            
            if (indexPath.row%2 == 0) {
              [backView setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
            } else {
            
         [backView setBackgroundColor:[UIColor whiteColor]];
            }
        }
        
        
        
        
        //专场列表
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 40, 20)];
        lab.text = strName;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:14];
        lab.backgroundColor = [ConMethods colorWithHexString:strColor];
        [backView addSubview:lab];
        
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 40, 20)];
        lab1.text = [NSString stringWithFormat:@"%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"WTH"]];
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.textColor = [ConMethods colorWithHexString:strColor];
        lab1.font = [UIFont systemFontOfSize:14];
        lab1.backgroundColor = [UIColor clearColor];
        [backView addSubview:lab1];
        
        
        UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, ScreenWidth - 230, 20)];
        lab2.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"WTJG"] floatValue]]]];
        lab2.textAlignment = NSTextAlignmentCenter;
        lab2.textColor = [ConMethods colorWithHexString:strColor];
        lab2.font = [UIFont systemFontOfSize:14];
        lab2.backgroundColor = [UIColor clearColor];
        [backView addSubview:lab2];
        
        UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 140, 5, 135, 20)];
        lab3.text = [NSString stringWithFormat:@"%@ %@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTRQ"],[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_WTSJ"]];
        lab3.textAlignment = NSTextAlignmentCenter;
        lab3.textColor = [ConMethods colorWithHexString:strColor];
        lab3.font = [UIFont systemFontOfSize:14];
        lab3.backgroundColor = [UIColor clearColor];
        [backView addSubview:lab3];
        
        [cell.contentView addSubview:backView];
        
        }
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (dataList.count == 0) {
        return 90;
    } else {
        
        return 30;
    }
    
}

//请求数据方法
-(void) requestData:(NSString *)str {
    
    NSLog(@"start = %@",start);
    
    NSDictionary *parameters = @{@"pageNo":start,@"pageSize":limit,@"cpdm":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERappWtList] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedCategoryList:[[[responseObject objectForKey:@"object"] objectForKey:@"wtResult"] objectForKey:@"object"]];
            
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
    
    if ([start isEqualToString:@"1"]) {
        if (dataList.count > 0) {
            [dataList removeAllObjects];
        }
        
    }
    
    if(dataList){
        
        [dataList addObjectsFromArray:[dataArray mutableCopy]];
    } else {
        dataList = [dataArray mutableCopy];
    }
    
    
    
    if ([dataArray count] < 20) {
        hasMore = NO;
    } else {
        hasMore = YES;
        start = [NSString stringWithFormat:@"%d", [start intValue] + 1];
    }
    
    if (hasMore) {
        if (!_refreshFooter) {
            [self setupFooter];
        }
    } else {
        [_refreshFooter removeFromSuperview];
    }
    
    [table reloadData];
    
}




- (void)setupHeader
{
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:table];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            start = @"1";
            [self requestData:_strId];
            
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    // [refreshHeader beginRefreshing];
}



- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:table];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}


- (void)footerRefresh
{
    if (hasMore == NO) {
        [self.refreshFooter endRefreshing];
    } else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self requestData:_strId];
            [self.refreshFooter endRefreshing];
        });
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
