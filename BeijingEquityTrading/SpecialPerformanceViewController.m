//
//  SpecialPerformanceViewController.m
//  BeijingEquityTrading
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "SpecialPerformanceViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"

@interface SpecialPerformanceViewController ()
{
    float addHight;
   
    UITableView *table;
    NSMutableArray *dataList;
    NSString *start;
    NSString *limit;
    BOOL hasMore;
    UITableViewCell *moreCell;
    
    UITextField *searchText;
    
}

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation SpecialPerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    start = @"1";
    limit = @"10";
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }

    
    
    //添加tableView
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0,addHight , ScreenWidth,ScreenHeight - 20 - 49)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:table];
    
    
    [self requestData:@""];
    
    [self setupHeader];
    [self setupFooter];
    
    
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
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, ScreenWidth - 10, 210)];
                [backView setBackgroundColor:[UIColor whiteColor]];
                backView.layer.cornerRadius = 2;
                backView.layer.masksToBounds = YES;
                backView.layer.borderWidth = 1;
                backView.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
                
                //专场列表
                
                
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 10, 100)];
                [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/LbFiles?type=zclogo&id=%@",SERVERURL,[[dataList objectAtIndex:indexPath.row] objectForKey:@"ID"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
                [backView addSubview:image];
                
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, ScreenWidth - 30, 15)];
                brandLabel.font = [UIFont systemFontOfSize:15];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                // brandLabel.numberOfLines = 0;
                brandLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"ZCMC"];
                [backView addSubview:brandLabel];
                
                //最新价
                UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 , 135, ScreenWidth - 30, 14)];
                dayLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"ZCQH"];
                dayLabel.font = [UIFont systemFontOfSize:14];
                dayLabel.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:dayLabel];
                
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, ScreenWidth - 30, 14)];
                dateLabel.text = [NSString stringWithFormat:@"%@-%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"KSRQ"],[[dataList objectAtIndex:indexPath.row] objectForKey:@"JSRQ"]];
                dateLabel.font = [UIFont systemFontOfSize:14];
                dateLabel.textColor = [ConMethods colorWithHexString:@"333333"];
                
                [backView addSubview:dateLabel];
                
                
                
                UILabel *totalLabel= [[UILabel alloc] initWithFrame:CGRectMake(10, 183, 12, 12)];
                totalLabel.text = @"共";
                totalLabel.font = [UIFont systemFontOfSize:12];
                totalLabel.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:totalLabel];
                
                
                UILabel *vuleLabel = [[UILabel alloc] init];
                vuleLabel.text = [NSString stringWithFormat:@"%d",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"COUNT_BDS"] intValue]];
                vuleLabel.font = [UIFont systemFontOfSize:15];
                vuleLabel.textColor = [ConMethods colorWithHexString:@"950401"];
                vuleLabel.frame = CGRectMake( 24, 180, [PublicMethod getStringWidth:vuleLabel.text font:vuleLabel.font], 15);
                [backView addSubview:vuleLabel];
                
                
                
                UILabel *labelTip= [[UILabel alloc] initWithFrame:CGRectMake(24 + [PublicMethod getStringWidth:vuleLabel.text font:vuleLabel.font], 183, 12*3, 12)];
                labelTip.text = @"标件物";
                labelTip.font = [UIFont systemFontOfSize:12];
                labelTip.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:labelTip];
                
                
                //围观
                
                
                
                UILabel *dateLabelMore = [[UILabel alloc] init];
                dateLabelMore.text = [NSString stringWithFormat:@"%d",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"WGCS"] intValue]];
                dateLabelMore.font = [UIFont systemFontOfSize:15];
                dateLabelMore.textColor = [ConMethods colorWithHexString:@"950401"];
                dateLabelMore.frame = CGRectMake( labelTip.frame.origin.x + labelTip.frame.size.width, 180, [PublicMethod getStringWidth:dateLabelMore.text font:dateLabelMore.font], 15);
                
                
                
                [backView addSubview:dateLabelMore];
                
                
                UILabel *dayLabelMore = [[UILabel alloc] initWithFrame:CGRectMake(dateLabelMore.frame.origin.x + dateLabelMore.frame.size.width, 183,36, 12)];
                dayLabelMore.text = @"次围观";
                dayLabelMore.font = [UIFont systemFontOfSize:12];
                dayLabelMore.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:dayLabelMore];
                
                
                
                
                
                
                //围观
                /*
                UILabel *dateLabelMore = [[UILabel alloc] initWithFrame:CGRectMake( 10, 180, 28, 14)];
                dateLabelMore.text = [NSString stringWithFormat:@"%d",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"WGCS"] intValue]];
                dateLabelMore.font = [UIFont systemFontOfSize:14];
                dateLabelMore.textColor = [UIColor redColor];
                
                [backView addSubview:dateLabelMore];
                
                UILabel *dayLabelMore = [[UILabel alloc] initWithFrame:CGRectMake(38, 180, ScreenWidth - 60, 14)];
                dayLabelMore.text = @"次围观";
                dayLabelMore.font = [UIFont systemFontOfSize:14];
                dayLabelMore.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:dayLabelMore];
                */
                
                [cell.contentView addSubview:backView];
            }
        
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (dataList.count == 0) {
        return 90;
    } else {
        
        return 220;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}


- (IBAction)callPhone:(UITouch *)sender
{
    
    UIView *view = [sender view];
}



- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view1,*view;
    
     view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 40)];
    view.backgroundColor = [UIColor clearColor];
    
   
    view1 = [[UIView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth - 10, 30)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.masksToBounds = YES;
    view1.layer.cornerRadius = 4;
    
  UIView  *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 10, 1)];
    lineview.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [view1 addSubview:lineview];
    
    
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth - 10 - 40, 30)];
    searchText.delegate = self;
    searchText.placeholder = @"搜索标的名称或编号";
    searchText.textColor = [ConMethods colorWithHexString:@"333333"];
    searchText.font = [UIFont systemFontOfSize:15];
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.backgroundColor = [UIColor clearColor];
    [view1 addSubview:searchText];
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(ScreenWidth - 10 - 35, 2.5, 25, 25);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"nav_icon_search_normal"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchMthods) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:searchBtn];
    [view addSubview:view1];
    
    return view;
    
}


-(void)searchMthods{
    
    [self.view endEditing:YES];
    
    start = @"1";
    [self requestData:searchText.text];
}



- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.strId = [[dataList objectAtIndex:indexPath.row] objectForKey:@"ID"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
}






//请求数据方法
-(void) requestData:(NSString *)str {
    
    NSLog(@"start = %@",start);
    
    NSDictionary *parameters = @{@"pageNo":start,@"pageSize":limit,@"search":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERzcappIndexzc] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedCategoryList:[[[responseObject objectForKey:@"object"] objectForKey:@"zcPageResult"] objectForKey:@"object"]];
            
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
            
           
            start = @"1";
            [self requestData:searchText.text];

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
            
            [self requestData:searchText.text];
            [self.refreshFooter endRefreshing];
        });
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
