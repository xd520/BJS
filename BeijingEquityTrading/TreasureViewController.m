//
//  TreasureViewController.m
//  BeijingEquityTrading
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "TreasureViewController.h"
#import "AppDelegate.h"
#import "MoreTableViewCell.h"
#import "ListData.h"

@interface TreasureViewController ()
{
    float addHight;
    
    UITableView *table;
    NSMutableArray *dataList;
    NSString *start;
    NSString *limit;
    BOOL hasMore;
    UITableViewCell *moreCell;
    UITextField *searchText;
    
    NSString *endTime;
    NSString *price;
    
    UILabel *lab1;
    UILabel *lab2;
    UILabel *lab3;
    UILabel *lab4;

    NSInteger countin;
    NSInteger indext;
    NSInteger tipcount;
    
    
}

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;


@end

@implementation TreasureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    start = @"1";
    limit = @"10";
    _searchStr = @"";
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 0.5)];
    lineView1.backgroundColor = [ConMethods  colorWithHexString:@"a5a5a5"];
    [self.headView addSubview:lineView1];
    
    
    
   UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth - 10, 30)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.masksToBounds = YES;
    view1.layer.cornerRadius = 4;
    view1.layer.borderWidth = 1;
    view1.layer.borderColor = [ConMethods colorWithHexString:@"dedede"].CGColor;
    
    UIView  *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 10, 1)];
    lineview.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [view1 addSubview:lineview];
    
    
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth - 10 - 30, 30)];
    searchText.delegate = self;
    searchText.placeholder = @"搜索标的名称或编号";
    searchText.textColor = [ConMethods colorWithHexString:@"333333"];
    searchText.font = [UIFont systemFontOfSize:15];
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.backgroundColor = [UIColor clearColor];
    [view1 addSubview:searchText];
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(ScreenWidth - 10 - 25, 5, 20, 20);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchMthods) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:searchBtn];
    [_headView addSubview:view1];
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    
    
    //默认选择按钮
    
    NSArray *titleArrTranfer = @[@"默认",@"限时报价开始时间▲",@"价格▲",@"类别"];
    
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [[UIButton alloc] init];
        
        btn.tag = i;
        btn.backgroundColor = [UIColor whiteColor];
        
        if (i == 0) {
            
            btn.frame = CGRectMake(0, 0, 50 , 30);
            
            lab1 = [[UILabel alloc] init];
            lab1.frame = CGRectMake(0, 0,  50 - 0.5, 30);
            lab1.text = [titleArrTranfer objectAtIndex:i];
            lab1.textAlignment = NSTextAlignmentCenter;
            lab1.font = [UIFont systemFontOfSize:13];
            //lab1.userInteractionEnabled = YES;
            lab1.textColor = [ConMethods colorWithHexString:@"fe8103"];
            [btn addSubview:lab1];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(50 - 0.5, 7.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        } else if(i == 1){
            btn.frame = CGRectMake(50, 0, 130 , 30);
            lab2 = [[UILabel alloc] init];
            lab2.frame = CGRectMake(0, 0,130 - 0.5, 30);
            lab2.text = [titleArrTranfer objectAtIndex:i];
            lab2.font = [UIFont systemFontOfSize:13];
            lab2.textAlignment = NSTextAlignmentCenter;
            lab2.textColor = [ConMethods colorWithHexString:@"999999"];
            //lab2.userInteractionEnabled = YES;
            lab2.textColor = [UIColor grayColor];
            [btn addSubview:lab2];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(130 - 0.5, 7.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        } else if(i == 2){
            btn.frame = CGRectMake(180, 0, 60, 30);
            lab3 = [[UILabel alloc] init];
            lab3.frame = CGRectMake(0, 0,60 - 0.5, 30);
            lab3.text = [titleArrTranfer objectAtIndex:i];
            lab3.font = [UIFont systemFontOfSize:13];
            lab3.textAlignment = NSTextAlignmentCenter;
            lab3.textColor = [ConMethods colorWithHexString:@"999999"];
            //lab3.userInteractionEnabled = YES;
            lab3.textColor = [UIColor grayColor];
            [btn addSubview:lab3];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(60- 0.5, 7.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        } else {
            btn.frame = CGRectMake(240, 0, ScreenWidth - 240, 30);
            lab4 = [[UILabel alloc] init];
            lab4.frame = CGRectMake(0, 0,ScreenWidth - 240 - 0.5, 30);
            lab4.text = [titleArrTranfer objectAtIndex:i];
            lab4.font = [UIFont systemFontOfSize:13];
            lab4.textAlignment = NSTextAlignmentCenter;
            lab4.textColor = [ConMethods colorWithHexString:@"999999"];
            //lab3.userInteractionEnabled = YES;
            lab4.textColor = [UIColor grayColor];
            [btn addSubview:lab4];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 240 - 0.5, 7.5, 0.5, 15)];
            img.image = [UIImage imageNamed:@"line_iocn"];
            [btn addSubview:img];
        
        
        }
        // btn.titleLabel.font = [UIFont systemFontOfSize:13];
        //btn.titleLabel.textColor = [UIColor redColor];
        
        [btn addTarget:self action:@selector(secelectMenthosd:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:btn];
        
    }
    
    [self.view addSubview:backView];
    
    
    
    
    
    
    
    
    
    //添加tableView
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0,addHight + 44 + 30, ScreenWidth,ScreenHeight - 20 - 49)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"F7F7F5"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:table];
    
    
    [self requestData:@"0" withprice:@"2" with:@""];
    
    [self setupHeader];
    [self setupFooter];

}




-(void)secelectMenthosd:(UIButton *)btn {
    
    // NSArray *titleArr = @[@"默认",@"预期收益↑",@"投资期限↑",@"起投金额↑"];
    //↓▲▼▶◀★☆▲■◆●◕✪✚✖❤
    
    
    if (btn.tag == countin) {
        indext++;
    } else {
        countin = btn.tag;
        indext = 0;
    }
    
    
    if (btn.tag == 0) {
        lab2.textColor = [ConMethods colorWithHexString:@"999999"];
        lab3.textColor = [ConMethods colorWithHexString:@"999999"];
        lab1.textColor = [ConMethods colorWithHexString:@"fe8103"];
        
        endTime = @"0";
        price = @"0";
        
    } else if (btn.tag == 1) {
        
        lab3.textColor = [UIColor grayColor];
        lab1.textColor = [UIColor grayColor];
        
        price = @"0";
        
        if (indext%2 == 0) {
            lab2.textColor = [ConMethods colorWithHexString:@"fe8103"];
            lab2.text = @"限时报价开始时间▲";
            endTime = @"1";
            
        } else {
            
            lab2.textColor = [ConMethods colorWithHexString:@"fe8103"];
            lab2.text = @"限时报价开始时间▼";
            endTime = @"2";
        }
        
        
        
        
    } else if (btn.tag == 2){
        lab2.textColor = [ConMethods colorWithHexString:@"999999"];
        lab1.textColor = [ConMethods colorWithHexString:@"999999"];
        
        endTime = @"0";
        
        if (indext%2 == 0) {
            lab3.textColor = [ConMethods colorWithHexString:@"fe8103"];
            lab3.text = @"价格▲";
            price = @"1";
        } else {
            
            lab3.textColor = [ConMethods colorWithHexString:@"fe8103"];
            lab3.text = @"价格▼";
            price = @"2";
        }
        
    }
    
    start = @"1";
    searchText.text = @"";
    [self requestData:endTime withprice:price with:searchText.text];
    
}


-(void)searchMthods{
    
    [self.view endEditing:YES];
    
    start = @"1";
    endTime = @"0";
    price = @"0";
    [self requestData:endTime withprice:price with:searchText.text];
}






- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}




//请求数据方法
-(void) requestData:(NSString *)_endTime withprice:(NSString *)_price with:(NSString *)search{
    
    NSLog(@"start = %@",start);
    
    NSDictionary *parameters = @{@"pageNo":start,@"pageSize":limit,@"id":@"23",@"endTime":_endTime,@"price":_price,@"search":search};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERprjsappIndexli] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedCategoryList:[[[responseObject objectForKey:@"object"] objectForKey:@"prjList"] objectForKey:@"object"]];
            
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

static NSString *rosterItemTableIdentifier = @"TZGGItem";

- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    
    	MoreTableViewCell *cell = (MoreTableViewCell * ) [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
    
    
   // UITableViewCell *cell;
    //cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    if ([dataList count] == 0 ) {
        cell = [[MoreTableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
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
        
        NSString * nibName = @"MoreTableViewCell";

        if (cell == nil) {
            
           // cell = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex: 0];
            
           // cell = [[MoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
            
            //[tbleView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:rosterItemTableIdentifier];
            
            ListData *listD = [[ListData alloc] initWithListData:[dataList objectAtIndex:indexPath.row]];
            
            cell = [MoreTableViewCell testCell];
                 [cell setModel:listD];
            
            
        }
        
        if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"jpz"]){
        
            cell.timeEnd = [[dataList objectAtIndex:indexPath.row] objectForKey:@"djs"];
        }
            
        
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (dataList.count == 0) {
        return 90;
    } else {
        return 120;
        
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
    
    UIView *view;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    return view;
    
}



- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (indexPath.row == 0) {
        //  MoneyAccountViewController *vc = [[MoneyAccountViewController alloc] init];
        //vc.hidesBottomBarWhenPushed = YES;
        //[self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == 1){
        
        
        
    }else if (indexPath.row == 2) {
        
        
    }
    
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
            
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" owner:self options:nil]];
            [arr removeAllObjects];
            
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
           
            [self requestData:_searchStr];
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
            
            [self requestData:_searchStr];
            [self.refreshFooter endRefreshing];
        });
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
