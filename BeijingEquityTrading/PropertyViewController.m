//
//  PropertyViewController.m
//  BeijingEquityTrading
//
//  Created by 熊永辉 on 15/11/26.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "PropertyViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "BackMoneyViewController.h"
#import "PayForViewController.h"

@interface PropertyViewController ()
{
    float addHight;
    UIView *lineView;
    
    //标记前一个按钮的tag
    NSInteger countBtn;
    NSMutableArray *arrBtn;
    NSMutableArray *allBtn;
    
    UITableView *table;
    UITableView *tablePast;
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
    
    UIView *MyBackView;
    //
    NSInteger indexBtn;
    
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooterPast;

@end

@implementation PropertyViewController



-(void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    start = @"1";
    [self requestData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    start = @"1";
    limit = @"10";
    startBak = @"";
    startPast = @"1";
    limitPast = @"10";
    startBakPast = @"";
    
    
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
    
    
    
    NSArray *arr = @[@"我的保证金",@"交易记录"];
    
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth/2*i, 1, ScreenWidth/2, 30);
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
    lineView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth/2 - 75)/2, 28, 75, 2)];
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
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth*2, scrollViewHeight)];
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
    
    [self requestData];
    
    [self setupHeader];
    [self setupFooter];
    
    [self setupHeaderPast];
    [self setupFooterPast];

    
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



/*
#pragma mark -  滑动条选择条

-(void)selectMethods:(UIButton *)btn {
    
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
        
        
        lineView.frame = CGRectMake((ScreenWidth/3 - 75)/2 + ScreenWidth/3*countBtn, 28, 75, 2);
        
    }
        
}
*/

#pragma mark -  滑动条选择条

-(void)selectMethods:(UIButton *)btn {
    
    __weak typeof(self) weakSelf = self;
    
    if (btn.tag == 0) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(0 , 0, ScreenWidth, ScreenHeight  - 64 - 32) animated:YES];
        start = @"1";
        [self requestData];
    }else {
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(ScreenWidth , 0, ScreenWidth, ScreenHeight  - 64 - 32) animated:YES];
        startPast = @"1";
        [self requestMyGqzcPaging];
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
        
        
        lineView.frame = CGRectMake((ScreenWidth/2 - 75)/2 + ScreenWidth/2*countBtn, 28, 75, 2);
        
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
            
            start = @"1";
            [self requestData];
            
        } else {
            
            
            UIButton *btnfirst = [arrBtn objectAtIndex:0];
            
            [btnfirst setTitleColor:[ConMethods colorWithHexString:@"333333"] forState:UIControlStateNormal];
            
            countBtn = 2;
            UIButton *btn = [allBtn objectAtIndex:2];
            [btn setTitleColor:[ConMethods colorWithHexString:@"950401"] forState:UIControlStateNormal];
            [arrBtn removeAllObjects];
            [arrBtn addObject:btn];
            
            startPast = @"1";
            [self requestMyGqzcPaging];
            
        }
        lineView.frame = CGRectMake((ScreenWidth/2 - 75)/2 + ScreenWidth/2*page, 28, 75, 2);
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
    } else {
        
        if ([dataListPast count] == 0) {
            return 1;
        }  else {
            return [dataListPast count];
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
            [tipLabel setText:@"没有任何保证金记录哦~"];
            [backView addSubview:tipLabel];
            [cell.contentView addSubview:backView];
            
        } else {
            
            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 125)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 115)];
                [backView setBackgroundColor:[UIColor whiteColor]];
                backView.layer.cornerRadius = 2;
                backView.layer.masksToBounds = YES;
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 40, 30)];
                brandLabel.font = [UIFont systemFontOfSize:13];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.textAlignment = NSTextAlignmentCenter;
                brandLabel.text = [NSString stringWithFormat:@"付款时间：%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"FKSJ"]];
                [backView addSubview:brandLabel];
                
                
                UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 29, ScreenWidth - 20, 1)];
                lineV.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
                [backView addSubview:lineV];
                
              
                //品牌
                UILabel *brandName = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth - 140, 15)];
                brandName.font = [UIFont systemFontOfSize:14];
                [brandName setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandName setBackgroundColor:[UIColor clearColor]];
                
                brandName.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"TCMC"];
                [backView addSubview:brandName];
                
  //支付类型
                
                UILabel *brandClass = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 135, 43, 120, 12)];
                brandClass.font = [UIFont systemFontOfSize:12];
                [brandClass setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandClass setBackgroundColor:[UIColor clearColor]];
                
                brandClass.text = [NSString stringWithFormat:@"支付类型：%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"ZFLX"]];
                [backView addSubview:brandClass];
                
 //退款申请：
                UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 30 - 80, 65, 80, 25)];
                quitBtn.backgroundColor = [ConMethods colorWithHexString:@"f8f8f8"];
               
                quitBtn.layer.borderWidth = 1;
                [quitBtn setTitle:@"退款申请" forState:UIControlStateNormal];
               
                quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                quitBtn.tag = indexPath.row;
                [quitBtn addTarget:self action:@selector(payForMoney:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"enableTK"] boolValue]) {
                     quitBtn.backgroundColor = [ConMethods colorWithHexString:@"f8f8f8"];
                    [quitBtn setTitleColor:[ConMethods colorWithHexString:@"000000"] forState:UIControlStateNormal];
                    quitBtn.layer.borderColor = [ConMethods colorWithHexString:@"bcbabb"].CGColor;
                    
                    [backView addSubview:quitBtn];
                } else {
                
                    if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"BZJSQBZ"] isEqualToString:@"3"]) {
                       
                        UILabel *brandCla = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 30 - 80, 65, 80, 25)];
                        brandCla.font = [UIFont systemFontOfSize:14];
                        [brandCla setTextColor:[ConMethods colorWithHexString:@"333333"]];
                        [brandCla setBackgroundColor:[UIColor clearColor]];
                        
                        brandCla.text = @"支付成功";
                        [backView addSubview:brandCla];
                        
                        
                    } else {
                        
                     quitBtn.backgroundColor = [ConMethods colorWithHexString:@"fbfbfb"];    
                    [quitBtn setTitleColor:[ConMethods colorWithHexString:@"eeeeee"] forState:UIControlStateNormal];
                    quitBtn.layer.borderColor = [ConMethods colorWithHexString:@"eeeeee"].CGColor;
                    quitBtn.enabled = NO;
                     [backView addSubview:quitBtn];
                    }
                }
                
                /*
                if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"BZJSQBZ"] isEqualToString:@"1"]||[[[dataList objectAtIndex:indexPath.row] objectForKey:@"BZJSQBZ"] isEqualToString:@"2"]) {
                   [backView addSubview:quitBtn];
                }
                */
                
                 
                
                //保证金
                UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 50, 12)];
                sureLab.font = [UIFont systemFontOfSize:12];
                sureLab.backgroundColor = [UIColor clearColor];
                sureLab.textColor = [ConMethods colorWithHexString:@"716f70"];
                sureLab.text = @"保证金:";
                [backView addSubview:sureLab];
                
        
                
                UILabel *sureVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 65, ScreenWidth/2 - 70, 15)];
                sureVauleLab.font = [UIFont systemFontOfSize:15];
                sureVauleLab.backgroundColor = [UIColor clearColor];
                sureVauleLab.textColor = [ConMethods colorWithHexString:@"ae4a5d"];
                sureVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"BZJ_YXF"] floatValue]]]];
                [backView addSubview:sureVauleLab];
                
              
                UILabel *totalLabel= [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 12, 12)];
                totalLabel.text = @"共";
                totalLabel.font = [UIFont systemFontOfSize:12];
                totalLabel.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:totalLabel];
                
                
                UILabel *vuleLabel = [[UILabel alloc] init];
                vuleLabel.text = [NSString stringWithFormat:@"%d",[[[dataList objectAtIndex:indexPath.row] objectForKey:@"BDS"] intValue]];
                vuleLabel.font = [UIFont systemFontOfSize:15];
                vuleLabel.textColor = [ConMethods colorWithHexString:@"950401"];
                vuleLabel.frame = CGRectMake( 24, 87, [PublicMethod getStringWidth:vuleLabel.text font:vuleLabel.font], 15);
                [backView addSubview:vuleLabel];
                
                
                
                UILabel *labelTip= [[UILabel alloc] initWithFrame:CGRectMake(24 + [PublicMethod getStringWidth:vuleLabel.text font:vuleLabel.font], 90, 12*3, 12)];
                labelTip.text = @"件标物";
                labelTip.font = [UIFont systemFontOfSize:12];
                labelTip.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:labelTip];
                
                
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
            [tipLabel setText:@"没有任何交易记录哦~"];
            tipLabel.backgroundColor = [UIColor clearColor];
            [backView addSubview:tipLabel];
            [cell.contentView addSubview:backView];
            
        } else {
            
            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                
                
                
                float hight = [PublicMethod getStringHeight:[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"ZY"] font:[UIFont systemFontOfSize:13] with:ScreenWidth - 110];
                
                
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55 + hight)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ConMethods colorWithHexString:@"eeeeee"]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 55 + hight)];
                [backView setBackgroundColor:[UIColor whiteColor]];
                backView.layer.cornerRadius = 2;
                backView.layer.masksToBounds = YES;
                
               //时间
                UILabel *kuiLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 35)];
                kuiLabTip.font = [UIFont systemFontOfSize:13];
                kuiLabTip.numberOfLines = 0;
                [kuiLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                
                kuiLabTip.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"CJSJ"];
                [backView addSubview:kuiLabTip];
                
              
                //最新价
                
                UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 13, 150, 17)];
                newLabel.font = [UIFont systemFontOfSize:17];
                [newLabel setTextColor:[ConMethods colorWithHexString:@"000000"]];
                
                
                if ([[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FSJE"] hasPrefix:@"-"]) {
                  newLabel.text = [NSString stringWithFormat:@"-%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",0 - [[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FSJE"] floatValue]]]];
                } else {
                newLabel.text = [ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"FSJE"] floatValue]]];
                
                
                }
                
                
                [backView addSubview:newLabel];
                
                
                
                
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] init];
                brandLabel.font = [UIFont systemFontOfSize:13];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
               
                brandLabel.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"ZY"];
                brandLabel.frame = CGRectMake(100, 40, ScreenWidth - 110, [PublicMethod getStringHeight:brandLabel.text font:brandLabel.font with:ScreenWidth - 110]);
                brandLabel.numberOfLines = 0;
                [backView addSubview:brandLabel];
                
                //持有份额
                UILabel *fenLabTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, 52, 13)];
                fenLabTip.font = [UIFont systemFontOfSize:13];
                [fenLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                
                fenLabTip.text = @"持有份额";
                //[backView addSubview:fenLabTip];
                
                UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, backView.frame.size.height - 1, ScreenWidth, 1)];
                lineView2.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
                [backView addSubview:lineView2];
                
                
                [cell.contentView addSubview:backView];
                
            }
            
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
            return 125;
        }
        
    } else if (tableView == tablePast){
        if ([indexPath row] == [dataListPast count]) {
            return 50;
        } else {
            
            float hight = [PublicMethod getStringHeight:[[dataListPast objectAtIndex:indexPath.row] objectForKey:@"ZY"] font:[UIFont systemFontOfSize:13] with:ScreenWidth - 110];
            
            return 55 + hight;
        }
    }
    
    return 95;
}

- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
            if (tbleView == table) {
                
                [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                
              
                
            }else if (tbleView == tablePast){
                [tbleView deselectRowAtIndexPath:indexPath animated:YES];
                
               
                
            }
    
}

#pragma mark - 退款申请
-(void)payForMoney:(UIButton *)btn {
    
    indexBtn = btn.tag;
    
    
    if ([[[dataList objectAtIndex:btn.tag] objectForKey:@"XMID"] isEqualToString:@""]||[[dataList objectAtIndex:btn.tag] objectForKey:@"XMID"] == [NSNull null]) {
       
       // [self requestData:[[dataList objectAtIndex:btn.tag] objectForKey:@"TCID"] withMark:@"1"];
        
        PayForViewController *vc = [[PayForViewController alloc] init];
        vc.strId = [[dataList objectAtIndex:btn.tag] objectForKey:@"TCID"];
        vc.markId = @"1";
        [self.navigationController pushViewController:vc animated:YES];
        

        
    } else {
      // [self requestData:[[dataList objectAtIndex:btn.tag] objectForKey:@"XMID"] withMark:@"0"];
        
        PayForViewController *vc = [[PayForViewController alloc] init];
        vc.strId = [[dataList objectAtIndex:btn.tag] objectForKey:@"XMID"];
        vc.markId = @"0";
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
}

//请求数据方法
-(void) requestData:(NSString *)str withMark:(NSString *)markStr{
    
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@/service/pay/qyt/app_applyOutMoney?id=%@&bzjbz=%@",SERVERURL,str,markStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
           
            
            
            [self summitBaoJianWindows:[NSString stringWithFormat:@"%.2f",[[[responseObject objectForKey:@"object"] objectForKey:@"zzje"] floatValue]]];
            
            
        } else {
            
            
          
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.navigationController.view
                                         displayInterval:3];
            
            
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
                if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                    
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.loginUser removeAllObjects];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
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



#pragma mark - 提交报价弹窗
-(void)summitBaoJianWindows:(NSString *)str{
    if (MyBackView) {
        [MyBackView removeFromSuperview];
    }
    
    
    MyBackView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    MyBackView.backgroundColor = [ConMethods colorWithHexString:@"bfbfbf" withApla:0.8];
    MyBackView.layer.masksToBounds = YES;
    MyBackView.layer.cornerRadius = 4;
    
    UIView *litleView = [[UIView alloc] initWithFrame:CGRectMake(20, (ScreenHeight - 200)/2, ScreenWidth - 40, 200)];
    litleView.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
    
    
    UILabel *nameLabTip = [[UILabel alloc] init];
    nameLabTip.text = @"您的报价为：";
    nameLabTip.textColor = [ConMethods colorWithHexString:@"333333"];
    nameLabTip.font = [UIFont systemFontOfSize:15];
    nameLabTip.frame = CGRectMake(20, 50, [PublicMethod getStringWidth:nameLabTip.text font:nameLabTip.font], 15);
    [litleView addSubview:nameLabTip];
    
    
    UILabel *vauleLab = [[UILabel alloc] init];
    vauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:str]];
    vauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
    vauleLab.font = [UIFont systemFontOfSize:16];
    vauleLab.frame = CGRectMake(nameLabTip.frame.origin.x + nameLabTip.frame.size.width, 49, [PublicMethod getStringWidth:vauleLab.text font:vauleLab.font], 16);
    [litleView addSubview:vauleLab];
    
    
    UILabel *nameLTip = [[UILabel alloc] init];
    nameLTip.text = @",";
    nameLTip.textColor = [ConMethods colorWithHexString:@"333333"];
    nameLTip.font = [UIFont systemFontOfSize:15];
    nameLTip.frame = CGRectMake(vauleLab.frame.origin.x + vauleLab.frame.size.width, 50, 15, 15);
    [litleView addSubview:nameLTip];
    
    
    
    
    
   
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = @"服务费：";
    nameLab.textColor = [ConMethods colorWithHexString:@"333333"];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.frame = CGRectMake(20, 85, [PublicMethod getStringWidth:nameLab.text font:nameLab.font], 15);
    
    [litleView addSubview:nameLab];
    
    
    UILabel *vauleLabTip = [[UILabel alloc] init];
    //vauleLabTip.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[sureText.text floatValue]*[[[myDic objectForKey:@"detail"] objectForKey:@"FWF_BL_SRF"] floatValue]]]];
    vauleLabTip.text = @"0.00";
    vauleLabTip.textColor = [ConMethods colorWithHexString:@"bd0100"];
    vauleLabTip.font = [UIFont systemFontOfSize:15];
    vauleLabTip.frame = CGRectMake(nameLab.frame.origin.x + nameLab.frame.size.width, 85, [PublicMethod getStringWidth:vauleLab.text font:vauleLab.font], 15);
    [litleView addSubview:vauleLabTip];
    
    
    
    
    
    //确定 取消
    UIButton *commitB = [[UIButton alloc] initWithFrame: CGRectMake((ScreenWidth - 40)/2 - 95, 130, 80, 30)];
    commitB.layer.masksToBounds = YES;
    commitB.layer.cornerRadius = 4;
    commitB.backgroundColor = [ConMethods colorWithHexString:@"850301"];
    
    [commitB setTitle:@"确定" forState:UIControlStateNormal];
    [commitB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    commitB.titleLabel.font = [UIFont systemFontOfSize:15];
    commitB.tag = 10004;
    [commitB addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
    [litleView addSubview:commitB];
    
    
    
    UIButton *quitBtn = [[UIButton alloc] initWithFrame: CGRectMake((ScreenWidth - 40)/2 + 15, 130, 80, 30)];
    quitBtn.layer.masksToBounds = YES;
    quitBtn.layer.cornerRadius = 4;
    quitBtn.backgroundColor = [ConMethods colorWithHexString:@"aaaaaa"];
    
    [quitBtn setTitle:@"取消" forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    quitBtn.tag = 10005;
    [quitBtn addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
    [litleView addSubview:quitBtn];
    
    [MyBackView addSubview:litleView];
    [self.view addSubview:MyBackView];
    
    
}


-(void)summitBtnMethods:(UIButton *)btn {
    if (btn.tag == 10004) {
        if ([[[dataList objectAtIndex:indexBtn] objectForKey:@"XMID"] isEqualToString:@""]||[[dataList objectAtIndex:indexBtn] objectForKey:@"XMID"] == [NSNull null]) {
            
            [self sumimBaojia:[[dataList objectAtIndex:indexBtn] objectForKey:@"TCID"] withMark:@"1"];
            
        } else {
            [self sumimBaojia:[[dataList objectAtIndex:indexBtn] objectForKey:@"XMID"] withMark:@"0"];
        }

        
        
    } else {
    [MyBackView removeFromSuperview];
    
    }

}


-(void)sumimBaojia:(NSString *)str withMark:(NSString *)markStr
{
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在提交..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@/service/pay/qyt/app_submitApplyOutMoney?id=%@&bzjbz=%@",SERVERURL,str,markStr] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"提交成功"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            
            [MyBackView removeFromSuperview];
            MyBackView = nil;

            
            
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







#pragma mark - 请求交易记录数据方法
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
    
     NSDictionary *parameters = @{@"pageNo":startPast,@"pageSize":limitPast};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERwdjyjl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            
        } else {
            

                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.navigationController.view
                                         displayInterval:3];
            
             if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
                 if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                     
                     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                     [delegate.loginUser removeAllObjects];
                     
                     [self.navigationController popToRootViewControllerAnimated:YES];
                 }
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




-(void)requestMyGqzcPaging{
    NSLog(@"start = %@",startPast);
    
    NSDictionary *parameters = @{@"pageNo":startPast,@"pageSize":limitPast};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERwdjyjl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedmyGqzcPagingList:[[[responseObject objectForKey:@"object"] objectForKey:@"jyjlPageResult"] objectForKey:@"object"]];
            
        } else {
            
           
                
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:[responseObject objectForKey:@"msg"]
                                           MBProgressHUD:nil
                                                  target:self.navigationController.view
                                         displayInterval:3];
         if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
             
             if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                 
                 AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                 [delegate.loginUser removeAllObjects];
                 
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
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




-(void) requestData {
    
    NSLog(@"start = %@",start);
    
    NSDictionary *parameters = @{@"pageNo":start,@"pageSize":limit};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERwdbzj] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedCategoryList:[[[responseObject objectForKey:@"object"] objectForKey:@"wdbzjPageResult"] objectForKey:@"object"]];
            
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
