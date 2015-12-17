//
//  PublicViewController.m
//  贵州金融资产股权交易
//
//  Created by Yonghui Xiong on 15-5-11.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "PublicViewController.h"
#import "AppDelegate.h"
#import "WebDetailViewController.h"

@interface PublicViewController ()
{
     float addHight;
    UITableView *table;
    NSString *start;
    NSString *startBak;
    NSString *limit;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
    
}

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;


@end

@implementation PublicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    start = @"1";
    limit = @"20";
    startBak = @"";
    
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods  colorWithHexString:@"a5a5a5"];
    [self.headView addSubview:lineView1];
    
    _titleLab.text = self.title;
    
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 50;
    
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0 , 44 + addHight, ScreenWidth,  ScreenHeight - 64)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[UIColor clearColor]];    table.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:table];
    
    [self setupHeader];
   // [self setupFooter];
    
//夏金所公告
    [self requestData:_strId];

}


- (void)setupHeader
{
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:table];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
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



-(void) requestData:(NSString *)str {
    

    NSDictionary *parameters = @{@"id":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERinfolist] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedCategoryList:[[[responseObject objectForKey:@"object"] objectForKey:@"list_li"] objectForKey:@"object"]];
            
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
   
        if ([dataList count] == 0) {
            return 1;
        } else {
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
            if (YES) {
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
                [tipLabel setText:@"没有任何公告哦~"];
                [backView addSubview:tipLabel];
                [cell.contentView addSubview:backView];
                
            }
        } else {
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    
                    float lineHight;
                    
                    lineHight = 40 - 15 + [PublicMethod getStringHeight:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"TITLE"] font:[UIFont systemFontOfSize:15] with:ScreenWidth - 120];
                    
                    
                    
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, lineHight)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[UIColor clearColor]];
                    //添加背景View
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, lineHight)];
                    [backView setBackgroundColor:[ConMethods colorWithHexString:@"fafafa"]];
                    //品牌
                    
                    UILabel *brandLabel = [[UILabel alloc] init];
                    brandLabel.backgroundColor = [UIColor clearColor];
                    brandLabel.font = [UIFont boldSystemFontOfSize:15];
                    [brandLabel setTextColor:[ConMethods colorWithHexString:@"646464"]];
                    brandLabel.numberOfLines = 0;
                    [brandLabel setBackgroundColor:[UIColor clearColor]];
                   
                    brandLabel.text = [[dataList objectAtIndex:[indexPath row]] objectForKey:@"TITLE"];
                    
                     brandLabel.frame = CGRectMake(10, 12, ScreenWidth - 120, [PublicMethod getStringHeight:brandLabel.text font:brandLabel.font with:ScreenWidth - 120]);
                    
                    [backView addSubview:brandLabel];
                    
                    
                    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 0, ScreenWidth - 240, 39)];
                    timeLabel.font = [UIFont systemFontOfSize:13];
                    [timeLabel setTextColor:[ConMethods colorWithHexString:@"646464"]];
                    [timeLabel setBackgroundColor:[UIColor clearColor]];
                    timeLabel.backgroundColor = [UIColor clearColor];
                    timeLabel.textAlignment = NSTextAlignmentRight;
                    
                    NSMutableString *strDate = [[NSMutableString alloc] initWithString:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"PUBTIME"]];
                    // NSString *newStr = [strDate insertring:@"-" atIndex:3];
                   // [strDate insertString:@"-" atIndex:4];
                    //[strDate insertString:@"-" atIndex:(strDate.length - 2)];
                    timeLabel.text = [NSString stringWithFormat:@"%@",strDate];
                    
                    [backView addSubview:timeLabel];
                    
                    
                    
                        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, backView.frame.size.height - 1, ScreenWidth, 1)];
                        [subView setBackgroundColor:[ConMethods colorWithHexString:@"dedede"]];
                      [backView addSubview:subView];
                    
                    [cell.contentView addSubview:backView];
                    
                    
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
        return cell;
        
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if ([dataList count] == 0) {
            return 95;
        } else {
            
            float lineHight;
            
            lineHight = 40 - 15 + [PublicMethod getStringHeight:[[dataList objectAtIndex:[indexPath row]] objectForKey:@"TITLE"] font:[UIFont systemFontOfSize:15] with:ScreenWidth - 120];
            
            return lineHight;
        }
    
    return 95;
}



- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            
            WebDetailViewController *goodsDetailViewController = [[WebDetailViewController alloc] init];
            
            goodsDetailViewController.name = [[dataList objectAtIndex:indexPath.row] objectForKey:@"TITLE"];
            goodsDetailViewController.Id = [[dataList objectAtIndex:indexPath.row] objectForKey:@"ID"];
     [self.navigationController pushViewController:goodsDetailViewController animated:YES];
    
        [tbleView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
