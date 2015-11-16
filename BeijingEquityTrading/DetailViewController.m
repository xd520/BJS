//
//  DetailViewController.m
//  BeijingEquityTrading
//
//  Created by mac on 15/11/11.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "MarkViewController.h"

@interface DetailViewController ()
{
    UIImageView *image;
    
    UITableView *table;
    NSMutableArray *dataList;
    NSString *start;
    NSString *limit;
    BOOL hasMore;
    UITableViewCell *moreCell;
    
    NSString *endTime;
    NSString *price;
    
    

}

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    start = @"1";
    limit = @"10";
    _searchStr = @"";
    endTime = @"0";
    price = @"0";
    
     image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 150)];
    image.userInteractionEnabled = YES;
    image.image = [UIImage imageNamed:@"logo"];
    
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 30, 25)];
    back.backgroundColor = [UIColor redColor];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [image addSubview:back];
    
    
    [self.view addSubview:image];
    [self requestMethods];
    
}

-(void)recivedList:(NSDictionary *)strDic{

    //专场列表
    
    
    [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/LbFiles?type=zclogo&id=%@",SERVERURL,[strDic objectForKey:@"ID"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, ScreenWidth , 110)];
    [backView setBackgroundColor:[UIColor whiteColor]];
    backView.layer.cornerRadius = 2;
    backView.layer.masksToBounds = YES;
    
    
    
    //品牌
    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 15)];
    brandLabel.font = [UIFont systemFontOfSize:15];
    [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
    [brandLabel setBackgroundColor:[UIColor clearColor]];
    // brandLabel.numberOfLines = 0;
    brandLabel.text = [strDic objectForKey:@"ZCMC"];
    [backView addSubview:brandLabel];
    
    //最新价
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 , 35, ScreenWidth - 30, 14)];
    dayLabel.text = [strDic objectForKey:@"ZCQH"];
    dayLabel.font = [UIFont systemFontOfSize:14];
    dayLabel.textColor = [ConMethods colorWithHexString:@"999999"];
    [backView addSubview:dayLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth -160, 60, 150, 14)];
    dateLabel.text = [NSString stringWithFormat:@"%@-%@",[strDic objectForKey:@"KSRQ"],[strDic objectForKey:@"JSRQ"]];
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.textColor = [ConMethods colorWithHexString:@"333333"];
    
    [backView addSubview:dateLabel];
    
    
    UILabel *totalLabel= [[UILabel alloc] initWithFrame:CGRectMake(10, 63, 12, 12)];
    totalLabel.text = @"共";
    totalLabel.font = [UIFont systemFontOfSize:12];
    totalLabel.textColor = [ConMethods colorWithHexString:@"999999"];
    [backView addSubview:totalLabel];
    
    
    UILabel *vuleLabel = [[UILabel alloc] init];
    vuleLabel.text = [NSString stringWithFormat:@"%d",[[strDic objectForKey:@"COUNT_BDS"] intValue]];
    vuleLabel.font = [UIFont systemFontOfSize:15];
    vuleLabel.textColor = [ConMethods colorWithHexString:@"950401"];
    vuleLabel.frame = CGRectMake( 24, 60, [PublicMethod getStringWidth:vuleLabel.text font:vuleLabel.font], 15);
    [backView addSubview:vuleLabel];
    
    
    
    UILabel *labelTip= [[UILabel alloc] initWithFrame:CGRectMake(24 + [PublicMethod getStringWidth:vuleLabel.text font:vuleLabel.font], 63, 12*3, 12)];
    labelTip.text = @"标件物";
    labelTip.font = [UIFont systemFontOfSize:12];
    labelTip.textColor = [ConMethods colorWithHexString:@"999999"];
    [backView addSubview:labelTip];
    
    
    //围观
    
    
    
    UILabel *dateLabelMore = [[UILabel alloc] init];
    dateLabelMore.text = [NSString stringWithFormat:@"%d",[[strDic objectForKey:@"WGCS"] intValue]];
    dateLabelMore.font = [UIFont systemFontOfSize:15];
    dateLabelMore.textColor = [ConMethods colorWithHexString:@"950401"];
    dateLabelMore.frame = CGRectMake( labelTip.frame.origin.x + labelTip.frame.size.width, 60, [PublicMethod getStringWidth:dateLabelMore.text font:dateLabelMore.font], 15);
    
    
    
    [backView addSubview:dateLabelMore];
    
   
    UILabel *dayLabelMore = [[UILabel alloc] initWithFrame:CGRectMake(dateLabelMore.frame.origin.x + dateLabelMore.frame.size.width, 63,36, 12)];
    dayLabelMore.text = @"次围观";
    dayLabelMore.font = [UIFont systemFontOfSize:12];
    dayLabelMore.textColor = [ConMethods colorWithHexString:@"999999"];
    [backView addSubview:dayLabelMore];
    
    [self.view addSubview:backView];


    table = [[UITableView alloc] initWithFrame:CGRectMake(0,260 , ScreenWidth,ScreenHeight - 260)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:table];
    
    
    [self requestData:endTime withprice:price];
    
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
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
            //添加背景View
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth - 10, 110)];
            [backView setBackgroundColor:[UIColor whiteColor]];
            backView.layer.cornerRadius = 2;
            backView.layer.masksToBounds = YES;
            
            
            //专场列表
            UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 100)];
            [image1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,[[dataList objectAtIndex:indexPath.row] objectForKey:@"F_XMLOGO"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
            [backView addSubview:image1];
            
            
            //品牌
            UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, ScreenWidth - 120, 15)];
            brandLabel.font = [UIFont systemFontOfSize:15];
            [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
            [brandLabel setBackgroundColor:[UIColor clearColor]];
            // brandLabel.numberOfLines = 0;
            brandLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"XMMC"];
            [backView addSubview:brandLabel];
            
            
            
            UILabel *dayLabelM = [[UILabel alloc] init];
            dayLabelM.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"bj"];
            dayLabelM.font = [UIFont systemFontOfSize:14];
            dayLabelM.textColor = [ConMethods colorWithHexString:@"999999"];
            dayLabelM.frame = CGRectMake(110, 28, [PublicMethod getStringWidth:dayLabelM.text font:dayLabelM.font], 14);
            
            [backView addSubview:dayLabelM];
            
            
            
            //最新价
            UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(dayLabelM.frame.origin.x + dayLabelM.frame.size.width, 28, ScreenWidth - 30, 14)];
          
            dayLabel.font = [UIFont systemFontOfSize:14];
            dayLabel.textColor = [ConMethods colorWithHexString:@"333333"];
            [backView addSubview:dayLabel];
            
   //竞拍中的时候 自由报价时期
            if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"jpz"]){
                
                
           
            UILabel *ziyouLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 105 - 40, ScreenWidth/2 - 30, 14)];
            
            ziyouLabel.font = [UIFont systemFontOfSize:14];
             ziyouLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"JYZT_MC"];
            ziyouLabel.textColor = [ConMethods colorWithHexString:@"333333"];
            [backView addSubview:ziyouLabel];
            } 
            
    //开始时间判定
           
            UILabel *starLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 105 - 12, 60, 12)];
            starLab.textColor = [ConMethods colorWithHexString:@"333333"];
            
            if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"wks"]) {
                
                 starLab.text = @"开始时间";
                
            } else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"jpz"]){
               starLab.text = @"剩余时间";
                
            }else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"cj"]){
               starLab.text = @"结束时间";
            }else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"lp"]){
              starLab.text = @"已结束";
            }

            
            starLab.font = [UIFont systemFontOfSize:12];
            [backView addSubview:starLab];
            
            
    //时间显示
            
            UILabel *timeYuLab = [[UILabel alloc] initWithFrame:CGRectMake(170, 105 - 12, 70, 12)];
            timeYuLab.textColor = [ConMethods colorWithHexString:@"999999"];
           // timeYuLab.backgroundColor = [UIColor redColor];
            timeYuLab.font = [UIFont systemFontOfSize:12];
            [backView addSubview:timeYuLab];
            
            
            UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 60,105 - 50, 60, 25)];
           
            markLab.font = [UIFont systemFontOfSize:15];
            markLab.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:markLab];
            
            //围观
            UILabel *dateLabelMore = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 60,105 - 50 + 25, 60, 25)];
            dateLabelMore.font = [UIFont systemFontOfSize:15];
            dateLabelMore.textAlignment = NSTextAlignmentCenter;
            dateLabelMore.layer.borderWidth = 1;
            [backView addSubview:dateLabelMore];
            
            
            if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"wks"]) {
                markLab.text = @"围观";
                markLab.backgroundColor = [ConMethods colorWithHexString:@"9c7e4a"];
                markLab.textColor = [UIColor whiteColor];
                
                dateLabelMore.textColor = [ConMethods colorWithHexString:@"9c7e4a"];
                dateLabelMore.layer.borderColor = [ConMethods colorWithHexString:@"9c7e4a"].CGColor;
                
                
            } else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"jpz"]){
                markLab.text = @"报价";
                markLab.backgroundColor = [ConMethods colorWithHexString:@"bd0100"];
                markLab.textColor = [UIColor whiteColor];
              
                dateLabelMore.textColor = [ConMethods colorWithHexString:@"bd0100"];
                dateLabelMore.layer.borderColor = [ConMethods colorWithHexString:@"bd0100"].CGColor;
                
            }else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"cj"]){
                
                markLab.text = @"报价";
                markLab.backgroundColor = [ConMethods colorWithHexString:@"9b9b9b"];
                markLab.textColor = [UIColor whiteColor];
                
                dateLabelMore.textColor = [ConMethods colorWithHexString:@"9b9b9b"];
                dateLabelMore.layer.borderColor = [ConMethods colorWithHexString:@"9b9b9b"].CGColor;
            }else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"lp"]){
                markLab.text = @"报价";
                markLab.backgroundColor = [ConMethods colorWithHexString:@"9b9b9b"];
                markLab.textColor = [UIColor whiteColor];
                
                dateLabelMore.textColor = [ConMethods colorWithHexString:@"9b9b9b"];
                dateLabelMore.layer.borderColor = [ConMethods colorWithHexString:@"9b9b9b"].CGColor;
            }
            
            
            
           /*
            dayLabel 最新价
           starLab 开始时间判定
            timeYuLab 时间显示
            markLab 围观头标];
            dateLabelMore 围观次数
            
            */
            
            
            [self getStrFormStly:[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] withLab1:dayLabel withLab2:timeYuLab withLab4:dateLabelMore with:[dataList objectAtIndex:indexPath.row]];
            
           
            [cell.contentView addSubview:backView];
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


- (IBAction)callPhone:(UITouch *)sender
{
    
    UIView *view = [sender view];
}




- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MarkViewController *vc = [[MarkViewController alloc] init];
    //vc.hidesBottomBarWhenPushed = YES;
   // vc.strId = [[dataList objectAtIndex:indexPath.row] objectForKey:@"ID"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
}






//请求数据方法
-(void) requestData:(NSString *)_endTime withprice:(NSString *)_price{
    
    NSLog(@"start = %@",start);
    
    NSDictionary *parameters = @{@"pageNo":start,@"pageSize":limit,@"id":_strId,@"endTime":_endTime,@"price":_price};
    
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

-(void)getStrFormStly:(NSString *)str withLab1:(UILabel *)_lab1 withLab2:(UILabel *)_lab2 withLab4:(UILabel *)_lab4 with:(NSDictionary *)_dic{
    if ([str isEqualToString:@"wks"]) {
        _lab1.text = [NSString stringWithFormat:@"￥%@",[_dic objectForKey:@"QPJ"]];
        _lab2.text =[NSString stringWithFormat:@"%@ %@", [_dic objectForKey:@"JJKSRQ"],[_dic objectForKey:@"JJKSSJ"]];
        
       // _lab3.text = @"开始时间";
        
        _lab4.text = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"WGCS"]];
        
    } else if ([str isEqualToString:@"jpz"]){
        _lab1.text = [NSString stringWithFormat:@"￥%@",[_dic objectForKey:@"ZXJG"]];
        _lab2.text = [_dic objectForKey:@"djs"];
        _lab4.text = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"BJZCS"]];
        
    }else if ([str isEqualToString:@"cj"]){
        _lab1.text = [NSString stringWithFormat:@"￥%@",[_dic objectForKey:@"ZGCJJ"]];
        _lab2.text = [NSString stringWithFormat:@"%@ %@", [_dic objectForKey:@"SJSSRQ"],[_dic objectForKey:@"SJJSSJ"]];
        _lab4.text = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"BJZCS"]];
    }else if ([str isEqualToString:@"lp"]){
        _lab1.text = [NSString stringWithFormat:@"￥%@",[_dic objectForKey:@"QPJ"]];
       // _lab2.text = [NSString stringWithFormat:@"%@ %@", [_dic objectForKey:@"SJSSRQ"],[_dic objectForKey:@"SJJSSJ"]];
        _lab4.text = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"BJZCS"]];
    }
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
            [self requestData:endTime withprice:price];
            
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
            
            [self requestData:endTime withprice:price];
            [self.refreshFooter endRefreshing];
        });
    }
}







//请求数据方法
-(void)requestMethods {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"id":_strId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERprjsappIndex] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedList:[[responseObject objectForKey:@"object"] objectForKey:@"zcResult"]];
            
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];

}

@end
