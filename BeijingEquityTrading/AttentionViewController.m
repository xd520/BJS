//
//  AttentionViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/11/26.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "AttentionViewController.h"
#import "AppDelegate.h"
#import "MarkViewController.h"

@interface AttentionViewController ()
{
    float addHight;
    //所有剩余时间数组
    NSMutableArray *totalLastTime;
    NSTimer *timer;
    
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

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    start = @"1";
    limit = @"10";
    
    totalLastTime = [NSMutableArray array];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }

    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0,44 + addHight , ScreenWidth,ScreenHeight - 64)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"F7F7F5"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:table];
    
    
    [self requestData:@""];
    
    [self setupHeader];
    [self setupFooter];
    
    
}


-(void) requestData:(NSString *)str{
    
    NSLog(@"start = %@",start);
    
    NSDictionary *parameters = @{@"pageNo":start,@"pageSize":limit,@"search":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERappguanzhu] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
           
            
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

//处理品牌列表
- (void)recivedCategoryList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    
    if ([start isEqualToString:@"1"]) {
        if (dataList.count > 0) {
            [dataList removeAllObjects];
            [totalLastTime removeAllObjects];
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





-(void)dealloc {

    [self.refreshFooter removeFromSuperview];
    
}




- (void)setupHeader
{
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:table];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            searchText.text = @"";
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
    cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
    
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
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 145)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
            //添加背景View
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth - 10, 135)];
            [backView setBackgroundColor:[UIColor whiteColor]];
            backView.layer.cornerRadius = 2;
            backView.layer.masksToBounds = YES;
            
            //品牌
            UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, ScreenWidth - 50 - 70, 30)];
            brandLabel.font = [UIFont systemFontOfSize:12];
            [brandLabel setTextColor:[ConMethods colorWithHexString:@"666666"]];
            [brandLabel setBackgroundColor:[UIColor clearColor]];
            brandLabel.textAlignment = NSTextAlignmentCenter;
            
            if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"wks"]) {
                brandLabel.text = [NSString stringWithFormat:@"开始时间：%@ %@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"JJKSRQ"],[[dataList objectAtIndex:indexPath.row] objectForKey:@"JJKSSJ"]];
            } else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"jpz"]) {
                
                brandLabel.tag = indexPath.row + 1000;
                NSDictionary *dic = @{@"indexPath":indexPath,@"lastTime":[[dataList objectAtIndex:indexPath.row] objectForKey:@"djs"]};
                [totalLastTime addObject:dic];
                [self startThread];
                
                
            // brandLabel.text = [NSString stringWithFormat:@"剩余时间：%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"djs"]];
            } else {
             brandLabel.text = [NSString stringWithFormat:@"结束时间：%@ %@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"JJKSRQ"],[[dataList objectAtIndex:indexPath.row] objectForKey:@"JJKSSJ"]];
            
            }
            
            
            [backView addSubview:brandLabel];
            
       //取消按钮
            UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 50, 2.5, 60, 25)];
            [quitBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            quitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            quitBtn.backgroundColor = [UIColor clearColor];
            [quitBtn setTitleColor:[ConMethods colorWithHexString:@"333333"] forState:UIControlStateNormal];
            quitBtn.tag = indexPath.row;
            [quitBtn addTarget:self action:@selector(focuscancelMethods:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:quitBtn];
            
            
            
            
            
            
            
            UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 29, ScreenWidth - 10, 1)];
            lineV.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
            [backView addSubview:lineV];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 35, 95, 95)];
             NSString *baseStr = [[Base64XD encodeBase64String:@"150,150"] strBase64];
            
            [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_%@.jpg",SERVERURL,[[dataList objectAtIndex:indexPath.row] objectForKey:@"F_XMLOGO"],baseStr]] placeholderImage:[UIImage imageNamed:@"loading_bd"]];
            [backView addSubview:image];
            
            
            
            //品牌
            UILabel *brandName = [[UILabel alloc] initWithFrame:CGRectMake(105, 40, ScreenWidth - 120, 15)];
            brandName.font = [UIFont systemFontOfSize:15];
            [brandName setTextColor:[ConMethods colorWithHexString:@"333333"]];
            [brandName setBackgroundColor:[UIColor clearColor]];
            
            brandName.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"XMMC"];
            [backView addSubview:brandName];
            
            
            
            //当前价
            UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 65, 50, 12)];
            sureLab.font = [UIFont systemFontOfSize:12];
            sureLab.backgroundColor = [UIColor clearColor];
            sureLab.textColor = [ConMethods colorWithHexString:@"716f70"];
            
            UILabel *sureVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(155, 65, ScreenWidth/2 - 50, 15)];
            sureVauleLab.font = [UIFont systemFontOfSize:15];
            sureVauleLab.backgroundColor = [UIColor clearColor];
            
            UILabel *nextLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 85, 50, 12)];
            nextLab.font = [UIFont systemFontOfSize:12];
            nextLab.backgroundColor = [UIColor clearColor];
            nextLab.textColor = [ConMethods colorWithHexString:@"716f70"];
            
            
            UILabel *nextVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(155, 85, ScreenWidth/2 - 50, 15)];
            nextVauleLab.font = [UIFont systemFontOfSize:15];
            nextVauleLab.backgroundColor = [UIColor clearColor];
            
            
            
            
            if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"wks"]) {
            sureLab.text = @"起始价：";
            sureVauleLab.textColor = [ConMethods colorWithHexString:@"333333"];
            sureVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"QPJ"] floatValue]]]];
                
                
            }else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"jpz"]){
            sureLab.text = @"当前价：";
            sureVauleLab.textColor = [ConMethods colorWithHexString:@"ae4a5d"];
            sureVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"ZXJG"] floatValue]]]];
            nextLab.text = @"起始价：";
                nextVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"QPJ"] floatValue]]]];
                
                
            }else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"lp"]){
            sureLab.text = @"起始价：";
            sureVauleLab.textColor = [ConMethods colorWithHexString:@"333333"];
            sureVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"QPJ"] floatValue]]]];
            
            }  else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"cj"]){
             sureLab.text = @"结束价：";
            sureVauleLab.textColor = [ConMethods colorWithHexString:@"ae4a5d"];
            sureVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"ZGCJJ"] floatValue]]]];
                nextLab.text = @"起始价：";
                nextVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"QPJ"] floatValue]]]];
                
            } else {
            sureLab.text = @"当前价：";
            sureVauleLab.textColor = [ConMethods colorWithHexString:@"ae4a5d"];
            sureVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"ZXJG"] floatValue]]]];
                nextLab.text = @"起始价：";
                nextVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"QPJ"] floatValue]]]];
            
            }
            [backView addSubview:sureLab];
            [backView addSubview:sureVauleLab];
            [backView addSubview:nextLab];
            [backView addSubview:nextVauleLab];
            

            
            if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"jpz"]){
                
                UILabel *starLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(105,102, 80, 25)];
                starLabel1.font = [UIFont systemFontOfSize:14];
                starLabel1.text = [NSString stringWithFormat:@"+%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"JJFD"]];
                starLabel1.backgroundColor = [ConMethods colorWithHexString:@"f9f9f9"];
                starLabel1.textColor = [ConMethods colorWithHexString:@"c2ae7f"];
                starLabel1.textAlignment = NSTextAlignmentCenter;
                starLabel1.layer.cornerRadius = 2;
                starLabel1.layer.masksToBounds = YES;
                starLabel1.layer.borderWidth = 1;
                starLabel1.layer.borderColor = [ConMethods colorWithHexString:@"c7c7c7"].CGColor;
                starLabel1.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
                starLabel1.tag = indexPath.row;
                //单点触摸
                singleTap1.numberOfTouchesRequired = 1;
                //点击几次，如果是1就是单击
                singleTap1.numberOfTapsRequired = 1;
                [starLabel1 addGestureRecognizer:singleTap1];
                
                //[backView addSubview:starLabel1];
                
            }
            
            
            
            [backView addSubview:sureVauleLab];
            
            /*
            //支付类型
            
            UILabel *brandClass = [[UILabel alloc] initWithFrame:CGRectMake(105, 85, ScreenWidth - 115, 12)];
            brandClass.font = [UIFont systemFontOfSize:12];
            [brandClass setTextColor:[ConMethods colorWithHexString:@"333333"]];
            [brandClass setBackgroundColor:[UIColor clearColor]];
            
            brandClass.text = [NSString stringWithFormat:@"我的最高报价：%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"WTJE1"] floatValue]]]];
            [backView addSubview:brandClass];
            
            
            UILabel *starLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(105,102, 80, 25)];
            starLabel1.font = [UIFont systemFontOfSize:14];
            starLabel1.text = [NSString stringWithFormat:@"+%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"JJFD"]];
            starLabel1.backgroundColor = [ConMethods colorWithHexString:@"f9f9f9"];
            starLabel1.textColor = [ConMethods colorWithHexString:@"c2ae7f"];
            starLabel1.textAlignment = NSTextAlignmentCenter;
            starLabel1.layer.cornerRadius = 2;
            starLabel1.layer.masksToBounds = YES;
            starLabel1.layer.borderWidth = 1;
            starLabel1.layer.borderColor = [ConMethods colorWithHexString:@"c7c7c7"].CGColor;
            
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
            starLabel1.tag = indexPath.row;
            //单点触摸
            singleTap1.numberOfTouchesRequired = 1;
            //点击几次，如果是1就是单击
            singleTap1.numberOfTapsRequired = 1;
            [starLabel1 addGestureRecognizer:singleTap1];
            
            [backView addSubview:starLabel1];
            */
            
            [cell.contentView addSubview:backView];
        }
        
        // return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MarkViewController *vc = [[MarkViewController alloc] init];
    //vc.hidesBottomBarWhenPushed = YES;
    vc.strId = [[dataList objectAtIndex:indexPath.row] objectForKey:@"KEYID"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 35;
}



- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view1,*view;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 35)];
    view.backgroundColor = [UIColor clearColor];
    
    
    view1 = [[UIView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth - 10, 30)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.masksToBounds = YES;
    view1.layer.cornerRadius = 4;
    view1.layer.borderWidth = 1;
    view1.layer.borderColor = [ConMethods colorWithHexString:@"d8d8d8"].CGColor;
    
    UIView  *lineview = [[UIView alloc] initWithFrame:CGRectMake(2, 1, ScreenWidth - 14, 1)];
    lineview.backgroundColor = [ConMethods colorWithHexString:@"a2a2a2"];
    [view1 addSubview:lineview];
    
    
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, ScreenWidth - 10 - 40, 30)];
    searchText.delegate = self;
    searchText.placeholder = @"搜索标的名称";
    searchText.textColor = [ConMethods colorWithHexString:@"333333"];
    searchText.font = [UIFont systemFontOfSize:15];
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.backgroundColor = [UIColor clearColor];
    [view1 addSubview:searchText];
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(ScreenWidth - 10 - 30, 5, 20, 20);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchMthods) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:searchBtn];
    [view addSubview:view1];
    
    return view;
    
}

-(void)searchMthods {
    [self.view endEditing:YES];
    
    start = @"1";
    [self requestData:searchText.text];
    
}



#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)even{
    [self.view endEditing:YES];
}



-(void)focuscancelMethods:(UIButton*)btn {
    //[[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"xmid":[[dataList objectAtIndex:btn.tag] objectForKey:@"KEYID"]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERcancelFocusPrj] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"取消关注成功"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            start = @"1";
            [self requestData:searchText.text];
            
        } else {
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
          
            if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.loginUser removeAllObjects];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
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


#pragma mark - 开启定时器倒计时方法

//开启定时器方法：

-(void)startThread
{
    
    [self performSelectorInBackground:@selector(startTimer) withObject:nil];
    
}


//开启定时器方法：
- (void)startTimer
{
    
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLessTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}




- (void)refreshLessTime
{
    int time;
    for (int i = 0; i < totalLastTime.count; i++) {
        time = (int)[[[totalLastTime objectAtIndex:i] objectForKey:@"lastTime"]longLongValue] - 1;
        
        NSIndexPath *indexPath = [[totalLastTime objectAtIndex:i] objectForKey:@"indexPath"];
        
        UITableViewCell *cell = (UITableViewCell *)[table cellForRowAtIndexPath:indexPath];
        UILabel *textLab = (UILabel *)[cell viewWithTag:indexPath.row + 1000];
        
        
        textLab.text = [NSString stringWithFormat:@"剩余时间：%@",[self lessSecondToDay:time]];
        NSDictionary *dic = @{@"indexPath":indexPath,@"lastTime": [NSString stringWithFormat:@"%i",time]};
        [totalLastTime replaceObjectAtIndex:i withObject:dic];
    }
}


- (NSString *)lessSecondToDay:(int)seconds
{
    
    int dayCount = seconds%(3600*24);
    int day = (seconds - dayCount)/(3600*24);
    
    int hourCount = dayCount%3600;
    int hour = (dayCount - hourCount)/3600;
    
    int minCount = hourCount%60;
    int min = (hourCount - minCount)/60;
     int miao = minCount;
    
    NSString *time = [NSString stringWithFormat:@"%i日%i小时%i分钟%i秒",day,hour,min,miao];
    return time;
    
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (dataList.count == 0) {
        return 90;
    } else {
        return 145;
        
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
