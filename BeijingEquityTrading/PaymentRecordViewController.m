//
//  PaymentRecordViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/12/23.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "PaymentRecordViewController.h"
#import "AppDelegate.h"

@interface PaymentRecordViewController ()
{
    UITableView *table;
    UITableView *tablePast;
    NSString *start;
    NSString *startBak;
    NSString *limit;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
    float addHight;
}
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation PaymentRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    start = @"0";
    limit = @"10";
    startBak = @"";
   
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }

    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 43, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods colorWithHexString:@"a5a5a5"];
    [self.view addSubview:lineView1];
    
    
    //添加tableView
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth,ScreenHeight - 64)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:table];
    
    
    [self requestData];
    
    [self setupHeader];
    [self setupFooter];
    
}

-(void) requestData {
    
    NSLog(@"start = %@",start);
    
    NSDate *nowDate = [NSDate date];
    NSDate *yestDate = [self getPriousorLaterDateFromDate:nowDate withMonth:-1];
    
    
   // NSDictionary *parameters = @{@"pageIndex":start,@"pageSize":limit,@"ksrq":[self dateToStringDate:yestDate],@"jsrq":[self dateToStringDate:nowDate]};
    
    NSDictionary *parameters = @{@"pageIndex":start,@"pageSize":limit,@"ksrq":[self dateToStringDate:nowDate],@"jsrq":[self dateToStringDate:nowDate]};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERtransRecordList] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedCategoryList:[responseObject objectForKey:@"object"]];
            
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

#pragma mark - date A months Ago
//给一个时间，给一个数，正数是以后n个月，负数是前n个月；
-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    [comps setMonth:month];
    [comps setDay:-1];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}


#pragma mark - date change Metholds

- (NSString *)dateToStringDate:(NSDate *)Date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //HH:mm:ss zzz
    NSString *destDateString = [dateFormatter stringFromDate:Date];
    // destDateString = [destDateString substringToIndex:10];
    
    return destDateString;
}


//处理品牌列表
- (void)recivedCategoryList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    
    if ([start isEqualToString:@"0"]) {
        if (dataList.count > 0) {
            [dataList removeAllObjects];
        }
        
    }
    
    if(dataList){
        
        [dataList addObjectsFromArray:[dataArray mutableCopy]];
    } else {
        dataList = [dataArray mutableCopy];
    }
    
    
    
    if ([dataArray count] < 10) {
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
            
            start = @"0";
            [self requestData];
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
            
            [self requestData];
            [self.refreshFooter endRefreshing];
        });
    }
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
        }  else {
            return [dataList count];
        }
    
    
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
            [tipLabel setText:@"没有任何保证金记录哦~"];
            [backView addSubview:tipLabel];
            [cell.contentView addSubview:backView];
            
        } else {
            
            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                
                
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,70)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 70)];
                [backView setBackgroundColor:[UIColor whiteColor]];
                backView.layer.cornerRadius = 2;
                backView.layer.masksToBounds = YES;
                
                //时间
                UILabel *kuiLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 35)];
                kuiLabTip.font = [UIFont systemFontOfSize:13];
                kuiLabTip.numberOfLines = 0;
                [kuiLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                
                kuiLabTip.text = [NSString stringWithFormat:@"%@    %@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_SQRQ"],[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_SQSJ"]];
                [backView addSubview:kuiLabTip];
                
                
                //最新价
                
                UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 13, 150, 17)];
                newLabel.font = [UIFont systemFontOfSize:17];
                [newLabel setTextColor:[ConMethods colorWithHexString:@"000000"]];
                
                
                if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_FSJE"] hasPrefix:@"-"]) {
                    newLabel.text = [NSString stringWithFormat:@"-%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",0 - [[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_FSJE"] floatValue]]]];
                } else {
                    newLabel.text = [ConMethods AddComma:[NSString stringWithFormat:@"+%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_FSJE"] floatValue]]];
                    
                    
                }
                
                
                [backView addSubview:newLabel];
                
                
                
                
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] init];
                brandLabel.font = [UIFont systemFontOfSize:13];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                
                if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_YWLB"] isEqualToString:@"1"]) {
                     brandLabel.text = @"银转商";
                } else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_YWLB"] isEqualToString:@"2"]) {
                    brandLabel.text = @"商转银";
                } else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_YWLB"] isEqualToString:@"4"]) {
                    brandLabel.text = @"查询";
                } else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_YWLB"] isEqualToString:@"8"]) {
                    brandLabel.text = @"开户";
                } else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_YWLB"] isEqualToString:@"16"]) {
                    brandLabel.text = @"销户";
                }
                
                
               
                brandLabel.frame = CGRectMake(ScreenWidth - 120, 10, 110, 13);
                brandLabel.textAlignment = NSTextAlignmentRight;
                [backView addSubview:brandLabel];
                
                //持有份额
                UILabel *fenLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 260, 43, 250, 13)];
                fenLabTip.font = [UIFont systemFontOfSize:13];
                fenLabTip.textAlignment = NSTextAlignmentRight;
                [fenLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                fenLabTip.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"FID_JGSM"];
                    
                
                
                
                [backView addSubview:fenLabTip];
                
                UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, backView.frame.size.height - 1, ScreenWidth, 1)];
                lineView2.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
                [backView addSubview:lineView2];
                
                
                [cell.contentView addSubview:backView];
                
            }
            
        }
        return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if ([indexPath row] == [dataList count]) {
            return 50;
        } else {
            return 70;
        }
    
        return 95;
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

-(void)dealloc {
   
    [self.refreshFooter removeFromSuperview];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
