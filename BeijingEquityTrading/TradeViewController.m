//
//  TradeViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/11/26.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "TradeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface TradeViewController ()
{
    float addHight;
    UIView *lineView;
    
    //所有剩余时间数组
    NSMutableArray *totalLastTime;
    NSTimer *timer;
    
    //标记前一个按钮的tag
    NSInteger countBtn;
    NSMutableArray *arrBtn;
    NSMutableArray *allBtn;
    
    
    
    UITableView *table;
    UITableView *tablePast;
    UITableView *tableFinsh;
    NSString *start;
    NSString *startBak;
    NSString *limit;
    NSMutableArray *dataList;
    BOOL hasMore;
    UITableViewCell *moreCell;
    
    NSString *startPast;
    NSString *startBakPast;
    NSString *limitPast;
    NSMutableArray *dataListPast;
    BOOL hasMorePast;
    UITableViewCell *moreCellPast;
    
   
    NSString *startFinsh;
    NSString *startBakFinsh;
    NSString *limitFinsh;
    NSMutableArray *dataListFinsh;
    BOOL hasMoreFinsh;
    UITableViewCell *moreCellFinsh;
    
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooterPast;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooterFinsh;

@end

@implementation TradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    start = @"1";
    limit = @"10";
    startBak = @"";
    startPast = @"1";
    limitPast = @"10";
    startBakPast = @"";
    startFinsh = @"1";
    limitFinsh = @"10";
    startBakFinsh = @"";
    
    totalLastTime = [NSMutableArray array];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }

    arrBtn = [NSMutableArray array];
    allBtn = [NSMutableArray array];
    
    
    UIView *headVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth, 32)];
    headVeiw.backgroundColor = [UIColor whiteColor];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [headVeiw addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 31, ScreenWidth, 1)];
    lineView2.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [headVeiw addSubview:lineView2];
    
    
    
    NSArray *arr = @[@"报价中",@"已成交",@"未成交"];
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth/3*i, 1, ScreenWidth/3, 30);
        btn.tag = i;
        if (i == 0) {
            [btn setTitleColor:[ConMethods colorWithHexString:@"950401"] forState:UIControlStateNormal];
            [arrBtn addObject:btn];
            
            
        } else {
            
            [btn setTitleColor:[ConMethods colorWithHexString:@"333333"] forState:UIControlStateNormal];
        }
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectMethods:) forControlEvents:UIControlEventTouchUpInside];
        [headVeiw addSubview:btn];
        
        [allBtn addObject:btn];
    }
    lineView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth/3 - 45)/2, 28, 45, 2)];
    lineView.backgroundColor = [ConMethods colorWithHexString:@"950401"];
    [headVeiw addSubview:lineView];
    [self.view addSubview:headVeiw];
    
    
    float scrollViewHeight = 0;
    scrollViewHeight = ScreenHeight  - 64 - 32;
    
    //初始化scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 32 + 44 + addHight, ScreenWidth, scrollViewHeight)];
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.bounces = NO;
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth*4, scrollViewHeight)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 32 + 44 + addHight, ScreenWidth, scrollViewHeight) animated:NO];
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    
    //添加tableView
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,scrollViewHeight)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    table.tableFooterView = [[UIView alloc] init];
    
    [self.scrollView addSubview:table];
    
    //添加tableView
    
    tablePast = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth,0, ScreenWidth, scrollViewHeight)];
    [tablePast setDelegate:self];
    [tablePast setDataSource:self];
    tablePast.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tablePast setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    tablePast.tableFooterView = [[UIView alloc] init];
    
    [self.scrollView addSubview:tablePast];
    
    
    tableFinsh = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*2,0, ScreenWidth, scrollViewHeight)];
    [tableFinsh setDelegate:self];
    [tableFinsh setDataSource:self];
    tableFinsh.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableFinsh setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
    tableFinsh.tableFooterView = [[UIView alloc] init];
    
    [self.scrollView addSubview:tableFinsh];

    
    
    
    [self requestData];
    
    [self setupHeader];
    [self setupFooter];
    
    [self setupHeaderPast];
    [self setupFooterPast];
    
    [self setupHeaderFinsh];
    [self setupFooterFinsh];
    
    
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


- (void)setupHeaderPast
{
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:tablePast];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            startPast = @"1";
            [self requestMyGqzcPaging];
            
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    // [refreshHeader beginRefreshing];
}



- (void)setupFooterPast
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:tablePast];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefreshPast)];
    _refreshFooterPast = refreshFooter;
}


- (void)footerRefreshPast
{
    
    
    if (hasMorePast == NO) {
        [self.refreshFooterPast endRefreshing];
    } else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self requestMyGqzcPaging];
            
            [self.refreshFooterPast endRefreshing];
        });
    }
}


- (void)setupHeaderFinsh
{
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:tableFinsh];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            startFinsh = @"1";
            [self requestMethods];
            
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    // [refreshHeader beginRefreshing];
}



- (void)setupFooterFinsh
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:tableFinsh];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefreshFinsh)];
    _refreshFooterFinsh = refreshFooter;
}


- (void)footerRefreshFinsh
{
    
    
    if (hasMoreFinsh == NO) {
        [self.refreshFooterFinsh endRefreshing];
    } else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self requestMethods];
            
            [self.refreshFooterFinsh endRefreshing];
        });
    }
}





#pragma mark -  滑动条选择条

-(void)selectMethods:(UIButton *)btn {
    
     __weak typeof(self) weakSelf = self;
    
    if (btn.tag == 0) {
      
       [weakSelf.scrollView scrollRectToVisible:CGRectMake(0 , 0, ScreenWidth, ScreenHeight  - 64 - 32) animated:YES];
        
        
    } else if (btn.tag == 1) {
    [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth , 0, ScreenWidth, ScreenHeight  - 64 - 32) animated:YES];
    
        startPast = @"1";
        [self requestMyGqzcPaging];
        
    }else {
    
     [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth*2 , 0, ScreenWidth, ScreenHeight  - 64 - 32) animated:YES];
        
        startFinsh = @"1";
        [self requestMethods];
    }
    
    
    
    
    if (btn.tag == countBtn) {
        //[btn setTitleColor:[ConMethods colorWithHexString:@"950401"] forState:UIControlStateNormal];
        
        //lineView.frame = CGRectMake((ScreenWidth/3 - 75)/2 + ScreenWidth/3*countBtn, 28, 75, 2);
        
        
    } else {
        UIButton *btnfirst = [arrBtn objectAtIndex:0];
        
        [btnfirst setTitleColor:[ConMethods colorWithHexString:@"333333"] forState:UIControlStateNormal];
        
        countBtn = btn.tag;
        [btn setTitleColor:[ConMethods colorWithHexString:@"950401"] forState:UIControlStateNormal];
        [arrBtn removeAllObjects];
        [arrBtn addObject:btn];
        
        
        lineView.frame = CGRectMake((ScreenWidth/3 - 45)/2 + ScreenWidth/3*countBtn, 28, 45, 2);
        
    }
    
}


// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollV
{
    
    if (scrollV == _scrollView) {
        CGFloat pageWidth = ScreenWidth;
        NSInteger page = _scrollView.contentOffset.x / pageWidth ;
       
      
        
        if (page == 0) {
            
            
            
            UIButton *btnfirst = [arrBtn objectAtIndex:0];
            
            [btnfirst setTitleColor:[ConMethods colorWithHexString:@"333333"] forState:UIControlStateNormal];
            
            countBtn = 0;
            UIButton *btn = [allBtn objectAtIndex:0];
            [btn setTitleColor:[ConMethods colorWithHexString:@"950401"] forState:UIControlStateNormal];
            [arrBtn removeAllObjects];
            [arrBtn addObject:btn];
            
           
            
            
        } else if (page == 1){
            
            UIButton *btnfirst = [arrBtn objectAtIndex:0];
            
            [btnfirst setTitleColor:[ConMethods colorWithHexString:@"333333"] forState:UIControlStateNormal];
            
            countBtn = 1;
            UIButton *btn = [allBtn objectAtIndex:1];
            [btn setTitleColor:[ConMethods colorWithHexString:@"950401"] forState:UIControlStateNormal];
            [arrBtn removeAllObjects];
            [arrBtn addObject:btn];
            
            startPast = @"1";
            [self requestMyGqzcPaging];
            
        } else {
            
            
            UIButton *btnfirst = [arrBtn objectAtIndex:0];
            
            [btnfirst setTitleColor:[ConMethods colorWithHexString:@"333333"] forState:UIControlStateNormal];
            
            countBtn = 2;
            UIButton *btn = [allBtn objectAtIndex:2];
            [btn setTitleColor:[ConMethods colorWithHexString:@"950401"] forState:UIControlStateNormal];
            [arrBtn removeAllObjects];
            [arrBtn addObject:btn];
        
            startFinsh = @"1";
            [self requestMethods];
        
        }
         lineView.frame = CGRectMake((ScreenWidth/3 - 45)/2 + ScreenWidth/3*page, 28, 45, 2);
    }
}





#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == table) {
        if ([dataList count] == 0) {
            return 1;
        }  else {
            return [dataList count];
        }
    } else if(tableView == tablePast){
        
        if ([dataListPast count] == 0) {
            return 1;
        }  else {
            return [dataListPast count];
        }
    } else {
        if ([dataListFinsh count] == 0) {
            return 1;
        }  else {
            return [dataListFinsh count];
        }
    
    
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    if (tbleView == table) {
        
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
            [tipLabel setText:@"没有任何商品哦~"];
            [backView addSubview:tipLabel];
            [cell.contentView addSubview:backView];
            
        } else {
            
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
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 40, 30)];
                brandLabel.font = [UIFont systemFontOfSize:13];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.textAlignment = NSTextAlignmentCenter;
                
                
                brandLabel.tag = indexPath.row + 1000;
                NSDictionary *dic = @{@"indexPath":indexPath,@"lastTime":[[dataList objectAtIndex:indexPath.row] objectForKey:@"SYSJ"]};
                [totalLastTime addObject:dic];
                [self startTimer];
                
               // brandLabel.text = [NSString stringWithFormat:@"剩余时间：%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"SYSJ"]];
                [backView addSubview:brandLabel];
                
                
                UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 29, ScreenWidth - 10, 1)];
                lineV.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
                [backView addSubview:lineV];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 35, 95, 95)];
                [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,[[dataList objectAtIndex:indexPath.row] objectForKey:@"F_XMLOGO"]]] placeholderImage:[UIImage imageNamed:@"loading_bd"]];
                [backView addSubview:image];
                
                
                
                //品牌
                UILabel *brandName = [[UILabel alloc] initWithFrame:CGRectMake(105, 40, ScreenWidth - 120, 15)];
                brandName.font = [UIFont systemFontOfSize:15];
                [brandName setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandName setBackgroundColor:[UIColor clearColor]];
                
                brandName.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"BDWMC"];
                [backView addSubview:brandName];
                
                
                
                //当前价
                UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 65, 50, 12)];
                sureLab.font = [UIFont systemFontOfSize:12];
                sureLab.backgroundColor = [UIColor clearColor];
                sureLab.textColor = [ConMethods colorWithHexString:@"716f70"];
                sureLab.text = @"当前价：";
                [backView addSubview:sureLab];
                
                
                
                UILabel *sureVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(155, 65, ScreenWidth/2 - 50, 15)];
                sureVauleLab.font = [UIFont systemFontOfSize:15];
                sureVauleLab.backgroundColor = [UIColor clearColor];
                sureVauleLab.textColor = [ConMethods colorWithHexString:@"ae4a5d"];
                sureVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"WTJE"] floatValue]]]];
                [backView addSubview:sureVauleLab];
                
                
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
                
                
                [cell.contentView addSubview:backView];
            }
            
            // return cell;
        }
        return cell;
        
    } else if (tablePast == tbleView){
        if ([dataListPast count] == 0) {
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
            [tipLabel setText:@"没有任何商品哦~"];
            tipLabel.backgroundColor = [UIColor clearColor];
            [backView addSubview:tipLabel];
            [cell.contentView addSubview:backView];
            
        } else {
            
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
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake((backView.frame.size.width - 180)/2, 0, 180, 30)];
                brandLabel.font = [UIFont systemFontOfSize:12];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.textAlignment = NSTextAlignmentCenter;
                brandLabel.text = [NSString stringWithFormat:@"结束时间：%@",[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"JSSJ"]];
                [backView addSubview:brandLabel];
                
                
                //当前价
                UILabel *ztLab = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width - 55, 0, 50, 30)];
                ztLab.font = [UIFont systemFontOfSize:12];
                ztLab.backgroundColor = [UIColor clearColor];
                ztLab.textColor = [ConMethods colorWithHexString:@"999999"];
                
                
    //判定交易状态
                if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"CJZT"] isEqualToString:@"2"]){
                  
                   ztLab.text = @"成交确认";
                    
                    
                } else if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"CJZT"] isEqualToString:@"1"]){
                ztLab.text = @"等待付款";
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(10, 5, 20, 20);
                    
                    if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"selected"] isEqualToString:@"1"]) {
                        [button setImage:[UIImage imageNamed:@"quan1"] forState:UIControlStateNormal];
                    } else {
                        [button setImage:[UIImage imageNamed:@"付款未勾选"] forState:UIControlStateNormal];
                    }
                    
                    //[button setImage:[UIImage imageNamed:@"付款未勾选"] forState:UIControlStateNormal];
                    button.tag = indexPath.row;
                    [button addTarget:self action:@selector(payForMoney:) forControlEvents:UIControlEventTouchUpInside];
                    [backView addSubview:button];
                    
                
                } else if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"CJZT"] isEqualToString:@"3"]){
                
                ztLab.text = @"超时违约";
                
                } else if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"CJZT"] isEqualToString:@"4"]){
                    
                    ztLab.text = @"交易成功";
                    
                }else if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"CJZT"] isEqualToString:@"5"]){
                    
                    ztLab.text = @"已交割";
                    
                }
                
                [backView addSubview:ztLab];
                
                
                UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 29, ScreenWidth - 10, 1)];
                lineV.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
                [backView addSubview:lineV];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 35, 95, 95)];
                [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"F_XMLOGO"]]] placeholderImage:[UIImage imageNamed:@"loading_bd"]];
                [backView addSubview:image];
                
                
                
                //品牌
                UILabel *brandName = [[UILabel alloc] initWithFrame:CGRectMake(105, 40, ScreenWidth - 120, 15)];
                brandName.font = [UIFont systemFontOfSize:14];
                [brandName setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandName setBackgroundColor:[UIColor clearColor]];
                
                brandName.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"BDWMC"];
                [backView addSubview:brandName];
                
                
                
                //当前价
                UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 65, ScreenWidth - 20 - 115, 12)];
                sureLab.font = [UIFont systemFontOfSize:12];
                sureLab.backgroundColor = [UIColor clearColor];
                sureLab.textColor = [ConMethods colorWithHexString:@"716f70"];
                sureLab.text = [NSString stringWithFormat:@"标的编号：%@",[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"XMBH"]];
                [backView addSubview:sureLab];
                
                
                
               
                
                
                //支付类型
                
                UILabel *payLabel = [[UILabel alloc] init];
                payLabel.font = [UIFont systemFontOfSize:13];
                [payLabel setTextColor:[ConMethods colorWithHexString:@"999999"]];
                [payLabel setBackgroundColor:[UIColor clearColor]];
                payLabel.text = @"应付款：";
                payLabel.frame = CGRectMake(105, 85, [PublicMethod getStringWidth:payLabel.text font:payLabel.font], 13);
                
                [backView addSubview:payLabel];
                
                
                
                
                UILabel *brandClass = [[UILabel alloc] init];
                brandClass.font = [UIFont systemFontOfSize:13];
                [brandClass setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandClass setBackgroundColor:[UIColor clearColor]];
                
                brandClass.text = [NSString stringWithFormat:@"¥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"CJJE"] floatValue]]]];
                brandClass.frame = CGRectMake(payLabel.frame.origin.x + payLabel.frame.size.width, 83, [PublicMethod getStringWidth:brandClass.text font:brandClass.font], 13);
                [backView addSubview:brandClass];
                
                
                UILabel *starLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(105,102, ScreenWidth - 135, 13)];
                starLabel1.font = [UIFont systemFontOfSize:13];
                starLabel1.text = [NSString stringWithFormat:@"（服务费：¥%@）",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"SXF"] floatValue]]]];
                starLabel1.textColor = [ConMethods colorWithHexString:@"9a9a9a"];
                
                [backView addSubview:starLabel1];
                
                
                [cell.contentView addSubview:backView];
            }
            
            // return cell;
        }
        return cell;
    } else   if (tbleView == tableFinsh) {
        
        if ([dataListFinsh count] == 0) {
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
            [tipLabel setText:@"没有任何商品哦~"];
            [backView addSubview:tipLabel];
            [cell.contentView addSubview:backView];
            
        } else {
            
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
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 40, 30)];
                brandLabel.font = [UIFont systemFontOfSize:13];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.textAlignment = NSTextAlignmentCenter;
                brandLabel.text = [NSString stringWithFormat:@"结束时间：%@",[[dataListFinsh objectAtIndex:indexPath.row] objectForKey:@"JSSJ"]];
                [backView addSubview:brandLabel];
                
                
                UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 29, ScreenWidth - 10, 1)];
                lineV.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
                [backView addSubview:lineV];
                
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(5, 35, 95, 95)];
                [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,[[dataListFinsh objectAtIndex:indexPath.row] objectForKey:@"F_XMLOGO"]]] placeholderImage:[UIImage imageNamed:@"loading_bd"]];
                [backView addSubview:image];
                
                
                
                //品牌
                UILabel *brandName = [[UILabel alloc] initWithFrame:CGRectMake(105, 40, ScreenWidth - 120, 15)];
                brandName.font = [UIFont systemFontOfSize:15];
                [brandName setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandName setBackgroundColor:[UIColor clearColor]];
                
                brandName.text = [[dataListFinsh objectAtIndex:indexPath.row] objectForKey:@"BDWMC"];
                [backView addSubview:brandName];
                
                
                
                //当前价
                UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectMake(105, 65, 60, 12)];
                sureLab.font = [UIFont systemFontOfSize:12];
                sureLab.backgroundColor = [UIColor clearColor];
                sureLab.textColor = [ConMethods colorWithHexString:@"716f70"];
                sureLab.text = @"成交总价：";
                [backView addSubview:sureLab];
                
                
                
                UILabel *sureVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(165, 65, ScreenWidth/2 - 50, 15)];
                sureVauleLab.font = [UIFont systemFontOfSize:15];
                sureVauleLab.backgroundColor = [UIColor clearColor];
                sureVauleLab.textColor = [ConMethods colorWithHexString:@"ae4a5d"];
                sureVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataListFinsh objectAtIndex:indexPath.row] objectForKey:@"CJJE"] floatValue]]]];
                [backView addSubview:sureVauleLab];
                
                
                //支付类型
                
                UILabel *brandClass = [[UILabel alloc] initWithFrame:CGRectMake(105, 85, ScreenWidth - 115, 12)];
                brandClass.font = [UIFont systemFontOfSize:12];
                [brandClass setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandClass setBackgroundColor:[UIColor clearColor]];
                
                brandClass.text = [NSString stringWithFormat:@"我的最高报价：¥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataListFinsh objectAtIndex:indexPath.row] objectForKey:@"WTJE"] floatValue]]]];
                [backView addSubview:brandClass];
                
                
               
                
                
                [cell.contentView addSubview:backView];
            }
            
            // return cell;
        }
        return cell;
        
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == table) {
        if ([indexPath row] == [dataList count]) {
            return 50;
        } else {
            return 145;
        }
        
    } else if (tableView == tablePast){
        if ([indexPath row] == [dataListPast count]) {
            return 50;
        } else {
            return 145;
        }
    } else if (tableView == tableFinsh){
        if ([indexPath row] == [dataListFinsh count]) {
            return 50;
        } else {
            return 145;
        }
    }
    
    return 95;
}


#pragma mark - 开启定时器倒计时方法
- (void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLessTime) userInfo:nil repeats:YES];
    
    // 如果不添加下面这条语句，在UITableView拖动的时候，会阻塞定时器的调用
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
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
    // int miao = minCount;
    
    NSString *time = [NSString stringWithFormat:@"%i日%i小时%i分钟",day,hour,min];
    return time;
    
}



#pragma mark - 付款按钮方法

-(void)payForMoney:(UIButton *)btn {

    //[UIImage imageNamed:@"付款未勾选"]
    
    //[btn setImage:[UIImage imageNamed:@"quan1"] forState:UIControlStateNormal];
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] initWithDictionary:[dataListPast objectAtIndex:btn.tag]];
    if ([[tempDic objectForKey:@"selected"] isEqualToString:@"1"]) {
        [tempDic setObject:@"0" forKey:@"selected"];
        [btn setImage:[UIImage imageNamed:@"付款未勾选"] forState:UIControlStateNormal];
    } else {
        [tempDic setObject:@"1" forKey:@"selected"];
        [btn setImage:[UIImage imageNamed:@"quan1"] forState:UIControlStateNormal];
    }
    
    [dataListPast replaceObjectAtIndex:btn.tag withObject:tempDic];
    
    
   // [self refreshPrice];
    

}


- (void)refreshPrice
{
    int price = 0;
    if ([dataListPast count] > 0) {
        for (NSMutableDictionary *dic in dataListPast) {
            if ([[dic objectForKey:@"selected"] isEqualToString:@"1"]) {
               // price += [[dic objectForKey:@"KYJE"] integerValue];
            }
        }
    }
}




- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tbleView == table) {
        
        [tbleView deselectRowAtIndexPath:indexPath animated:YES];
        
        
        
    }else if (tbleView == tablePast){
        [tbleView deselectRowAtIndexPath:indexPath animated:YES];
        
        
        
    } else if (tbleView == tableFinsh){
        [tbleView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}




//未成交请求数据方法
-(void)requestMethods {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    /*
     <AFURLRequestSerialization>`
     - `AFHTTPRequestSerializer`
     - `AFJSONRequestSerializer`
     - `AFPropertyListRequestSerializer`
     * `<AFURLResponseSerialization>`
     - `AFHTTPResponseSerializer`
     - `AFJSONResponseSerializer`
     - `AFXMLParserResponseSerializer`
     - `AFXMLDocumentResponseSerializer` _(Mac OS X)_
     - `AFPropertyListResponseSerializer`
     - `AFImageResponseSerializer`
     - `AFCompoundResponseSerializer`
     
     */
    
    NSDate *nowDate = [NSDate date];
    NSDate *yestDate = [self getPriousorLaterDateFromDate:nowDate withMonth:-1];
    
    NSDictionary *parameters = @{@"pageNo":startFinsh,@"pageSize":limitFinsh,@"ksrq":[self dateToStringDate:yestDate],@"jsrq":[self dateToStringDate:nowDate]};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERappwcj] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedFinshList:[[[responseObject objectForKey:@"object"] objectForKey:@"wcjPageResult"] objectForKey:@"object"]];
            
            
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




-(void)requestMyGqzcPaging{
    NSLog(@"start = %@",startPast);
    
    NSDate *nowDate = [NSDate date];
    NSDate *yestDate = [self getPriousorLaterDateFromDate:nowDate withMonth:-1];
    
    NSDictionary *parameters = @{@"pageNo":startPast,@"pageSize":limitPast,@"ksrq":[self dateToStringDate:yestDate],@"jsrq":[self dateToStringDate:nowDate]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERappycj] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedmyGqzcPagingList:[[[responseObject objectForKey:@"object"] objectForKey:@"ycjPageResult"] objectForKey:@"object"]];
            
        } else {
            
            
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
                
                if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                    
                    [[HttpMethods Instance] activityIndicate:NO
                                                  tipContent:[responseObject objectForKey:@"msg"]
                                               MBProgressHUD:nil
                                                      target:self.navigationController.view
                                             displayInterval:3];
                    
                    
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.loginUser removeAllObjects];
                    
                    LoginViewController *vc = [[LoginViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.view
                                         displayInterval:3];
                
            }
            
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
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //HH:mm:ss zzz
    NSString *destDateString = [dateFormatter stringFromDate:Date];
    // destDateString = [destDateString substringToIndex:10];
    
    return destDateString;
}



-(void) requestData {
    
    NSLog(@"start = %@",start);
    
    NSDictionary *parameters = @{@"pageNo":start,@"pageSize":limit};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERappbjz] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedCategoryList:[[[responseObject objectForKey:@"object"] objectForKey:@"bjzPageResult"] objectForKey:@"object"]];
            
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
- (void)recivedmyGqzcPagingList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    
    if ([startPast isEqualToString:@"1"]) {
        if (dataListPast.count > 0) {
            [dataListPast removeAllObjects];
        }
        
    }
    
    if(dataListPast){
        
        [dataListPast addObjectsFromArray:[dataArray mutableCopy]];
    } else {
        dataListPast = [dataArray mutableCopy];
    }
    
    [tablePast reloadData];
    
    if ([dataArray count] < 10) {
        hasMorePast = NO;
    } else {
        hasMorePast = YES;
        startPast = [NSString stringWithFormat:@"%d", [startPast intValue] + 1];
    }
    
    if (hasMorePast) {
        if (!_refreshFooterPast) {
            [self setupFooterPast];
        }
    } else {
        [_refreshFooterPast removeFromSuperview];
    }
    
    [tablePast reloadData];
    
}



//处理品牌列表
- (void)recivedFinshList:(NSMutableArray *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    
    if ([startFinsh isEqualToString:@"1"]) {
        if (dataListFinsh.count > 0) {
            [dataListFinsh removeAllObjects];
        }
        
    }
    
    if(dataListFinsh){
        
        [dataListFinsh addObjectsFromArray:[dataArray mutableCopy]];
    } else {
        dataListFinsh = [dataArray mutableCopy];
    }
    
    
    
    if ([dataArray count] < 10) {
        hasMoreFinsh = NO;
    } else {
        hasMoreFinsh = YES;
        startFinsh = [NSString stringWithFormat:@"%d", [startFinsh intValue] + 1];
    }
    
    if (hasMoreFinsh) {
        if (!_refreshFooterFinsh) {
            [self setupFooter];
        }
    } else {
        [_refreshFooterFinsh removeFromSuperview];
    }
    
    [tableFinsh reloadData];
    
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





-(void)dealloc {
    //[self.refreshHeader removeFromSuperview];
    [self.refreshFooter removeFromSuperview];
    
    // [self.refreshHeaderPast removeFromSuperview];
    [self.refreshFooterPast removeFromSuperview];
    
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
