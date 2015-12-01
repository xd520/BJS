//
//  MainViewController.m
//  BeijingEquityTrading
//
//  Created by mac on 15/10/15.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MarkViewController.h"

@interface MainViewController ()
{
    float addHight;
    UIScrollView *scrollViewImage;
    UIPageControl *pageControl;
    NSMutableArray *imageArray;
    
    UITableView *table;
    NSMutableArray *dataList;
    NSMutableArray *dataListPast;
    
    NSString *str;
    
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    str = @"";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    
    NSLog(@"%f %f",ScreenWidth,ScreenHeight);
    
    
    _loginBtn.backgroundColor = [ConMethods colorWithHexString:@"950401"];
    _loginBtn.layer.cornerRadius = 4;
    _loginBtn.layer.masksToBounds= YES;
    
    _regestBtn.backgroundColor = [ConMethods colorWithHexString:@"950401"];
    _regestBtn.layer.cornerRadius = 4;
    _regestBtn.layer.masksToBounds= YES;
    

    table = [[UITableView alloc] initWithFrame:CGRectMake(0, addHight + 150 + 44, ScreenWidth,ScreenHeight - 64 - 49 - 150)];
    [table setDelegate:self];
    [table setDataSource:self];
    table.bounces = YES;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
   // table.tableFooterView = [[UIView alloc] init];
    //table.bounces = NO;
    
    table.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view addSubview:table];
    
    [self requestMethods];
    
    
}






- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}




//处理品牌列表
- (void)recivedCategoryList:(NSMutableDictionary *)dataArray
{
    NSLog(@"%s %d %@", __FUNCTION__, __LINE__, @"处理品牌列表数据");
    
        if (dataList.count > 0) {
            [dataList removeAllObjects];
        }
        
   
    if(dataList){
        
        [dataList addObjectsFromArray:[[dataArray objectForKey:@"tzcxxList"] mutableCopy]];
    } else {
        dataList = [[dataArray objectForKey:@"tzcxxList"] mutableCopy];
    }
    
    
    if (dataListPast.count > 0) {
        [dataListPast removeAllObjects];
    }
    
    
    if(dataListPast){
        
        [dataListPast addObjectsFromArray:[[dataArray objectForKey:@"hotProjectList"] mutableCopy]];
    } else {
        dataListPast = [[dataArray objectForKey:@"hotProjectList"] mutableCopy];
    }

    str = [NSString stringWithFormat:@"共%@场>",[[dataArray objectForKey:@"tzcxxTotalCount"] objectForKey:@"TOTAL_COUNT"]];
    
    
    
   [self reloadData:[dataArray objectForKey:@"bannerList"]];
    
    [table reloadData];
    
}


#pragma mark - UITableView DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (dataList.count > 0) {
        return 3;
    } else {
     return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    
     if (dataList.count > 0) {
    if (section == 0) {
        count = dataList.count;
    }else if (section == 1) {
    
        count = 1;
        
    } else if (section == 2) {
        if (dataListPast.count % 2 == 0) {
           count = dataListPast.count/2;
        } else {
        count = (dataListPast.count + 1)/2;
        }
        }
    }else {
     
        count = 1;
     }
         
    return count;
}

-(void)addData{

    [self requestMethods];

}




- (UITableViewCell *)tableView:(UITableView *)tbleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setScrollEnabled:NO]; tableView 不能滑动
    static NSString *RepairCellIdentifier = @"RepairCellIdentifier";
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    if (indexPath.section == 0) {
        
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
            [tipLabel setText:@"网络不给力哦~"];
            [backView addSubview:tipLabel];
            
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - 100)/2, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27 + 25, 100, 30)];
            btn.backgroundColor = [UIColor lightTextColor];
            btn.titleLabel.text = @"点击加载";
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn addTarget:self action:@selector(addData) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:btn];
            
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
                vuleLabel.text = [NSString stringWithFormat:@"%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"COUNT_BDS"]];
                vuleLabel.font = [UIFont systemFontOfSize:15];
                vuleLabel.textColor = [ConMethods colorWithHexString:@"950401"];
                vuleLabel.frame = CGRectMake( 24, 180, [PublicMethod getStringWidth:vuleLabel.text font:vuleLabel.font], 15);
                [backView addSubview:vuleLabel];
                
                
                
                UILabel *labelTip= [[UILabel alloc] initWithFrame:CGRectMake(26 + [PublicMethod getStringWidth:vuleLabel.text font:vuleLabel.font], 183, 12*3, 12)];
                labelTip.text = @"件标物";
                labelTip.font = [UIFont systemFontOfSize:12];
                labelTip.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:labelTip];
                
                
                //围观
               
                UILabel *dateLabelMore = [[UILabel alloc] init];
                dateLabelMore.text = [NSString stringWithFormat:@"%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"WGCS"]];
                dateLabelMore.textAlignment = NSTextAlignmentCenter;
                dateLabelMore.font = [UIFont systemFontOfSize:14];
                dateLabelMore.frame = CGRectMake(2 + labelTip.frame.size.width + labelTip.frame.origin.x, 181, [PublicMethod getStringWidth:dateLabelMore.text font:dateLabelMore.font], 14);
                dateLabelMore.textColor = [ConMethods colorWithHexString:@"950401"];
                
                [backView addSubview:dateLabelMore];
                
                UILabel *dayLabelMore = [[UILabel alloc] initWithFrame:CGRectMake(dateLabelMore.frame.size.width + dateLabelMore.frame.origin.x, 182, 39, 13)];
                dayLabelMore.text = @"次围观";
                dayLabelMore.font = [UIFont systemFontOfSize:13];
                dayLabelMore.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:dayLabelMore];
                
                
                [cell.contentView addSubview:backView];
            }
        
    }
    }else if (indexPath.section == 2){
        if ( [dataListPast count] == 0) {
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
            [tipLabel setText:@"网络不给力哦~"];
            [backView addSubview:tipLabel];
            
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - 100)/2, iconImageView.frame.origin.y + iconImageView.frame.size.height + 27 + 25, 100, 30)];
            btn.backgroundColor = [UIColor lightTextColor];
            btn.titleLabel.text = @"点击加载";
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn addTarget:self action:@selector(addData) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:btn];
            
            [cell.contentView addSubview:backView];
            
        } else{

            
            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
                
                
        if (dataListPast.count % 2 == 0) {
                    
                
                
                //添加背景View
                UIView *backView,*backViewlast;
            backView.tag = indexPath.row*2;
            backViewlast.tag = indexPath.row*2 + 1;
            
                backView = [[UIView alloc] initWithFrame:CGRectMake(5 , 0, ScreenWidth/2 - 7.5, 165)];
                [backView setBackgroundColor:[UIColor clearColor]];
                backView.layer.cornerRadius = 2;
                backView.layer.masksToBounds = YES;
            backView.layer.borderWidth = 1;
            backView.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
            
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2 - 7.5, 100)];
                [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,[[dataListPast objectAtIndex:indexPath.row*2] objectForKey:@"F_XMLOGO"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
                [backView addSubview:image];
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 107.5, (ScreenWidth - 15)/2 - 10, 15)];
                brandLabel.font = [UIFont systemFontOfSize:14];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"BDMC"];
                [backView addSubview:brandLabel];
                
                //当前价
                UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, (ScreenWidth - 15)/2, 30)];
                lastView.backgroundColor = [UIColor whiteColor];
                
                UILabel *fenLabTip = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 30, 10)];
                fenLabTip.font = [UIFont systemFontOfSize:10];
                [fenLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                
                fenLabTip.text = @"当前价";
                [lastView addSubview:fenLabTip];
                
                UILabel *fenLabel = [[UILabel alloc] init];
                fenLabel.font = [UIFont systemFontOfSize:10];
                [fenLabel setTextColor:[ConMethods colorWithHexString:@"950401"]];
                fenLabel.text = [NSString stringWithFormat:@"￥%.2f",[[[dataListPast objectAtIndex:indexPath.row*2] objectForKey:@"ZXJG"] doubleValue]];
            
            fenLabel.frame = CGRectMake(35,10, [PublicMethod getStringWidth:fenLabel.text font:fenLabel.font], 10);
            
                [lastView addSubview:fenLabel];
//多少次报价
            
            UILabel *ciLabTip = [[UILabel alloc] initWithFrame:CGRectMake(lastView.frame.size.width - 15, 10, 30, 10)];
            ciLabTip.font = [UIFont systemFontOfSize:10];
            [ciLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
            
            ciLabTip.text = @"次";
            [lastView addSubview:ciLabTip];
            
            
            
                
                UILabel *priceLabel = [[UILabel alloc] init];
                priceLabel.font = [UIFont systemFontOfSize:10];
                [priceLabel setTextColor:[ConMethods colorWithHexString:@"950401"]];
                priceLabel.text = [NSString stringWithFormat:@"%@",[[dataListPast objectAtIndex:indexPath.row*2] objectForKey:@"COUNT_JJCS"]];
            priceLabel.textAlignment = NSTextAlignmentRight;
            priceLabel.frame = CGRectMake(lastView.frame.size.width - 15 - [PublicMethod getStringWidth:priceLabel.text font:priceLabel.font], 10, [PublicMethod getStringWidth:priceLabel.text font:priceLabel.font], 10);
            
                [lastView addSubview:priceLabel];
            
            UILabel *baoLabTip = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x - 20, 10, 20, 10)];
            baoLabTip.font = [UIFont systemFontOfSize:10];
            [baoLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
            
            baoLabTip.text = @"报价";
            [lastView addSubview:baoLabTip];
            [backView addSubview:lastView];
                
                
                
                /**********  backViewlast  ************/
                  backViewlast = [[UIView alloc] initWithFrame:CGRectMake(2.5 +ScreenWidth/2, 0, ScreenWidth/2 - 7.5, 165)];
                    [backViewlast setBackgroundColor:[UIColor clearColor]];
                    backViewlast.layer.cornerRadius = 2;
                    backViewlast.layer.masksToBounds = YES;
            backViewlast.layer.borderWidth = 1;
            backViewlast.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
            
                    UIImageView *imagep = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2 - 7.5, 100)];
                    [imagep setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,[[dataListPast objectAtIndex:indexPath.row*2 + 1] objectForKey:@"F_XMLOGO"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
                    [backViewlast addSubview:imagep];
                    
                    //品牌
                    UILabel *brandLabelp = [[UILabel alloc] initWithFrame:CGRectMake(5, 107.5, (ScreenWidth - 15)/2 - 10, 15)];
                    brandLabelp.font = [UIFont systemFontOfSize:14];
                    [brandLabelp setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    [brandLabelp setBackgroundColor:[UIColor clearColor]];
                    brandLabelp.text = [[dataListPast objectAtIndex:indexPath.row*2 + 1] objectForKey:@"BDMC"];
                    [backViewlast addSubview:brandLabelp];
                    
                //当前价
                UIView *lastViewp = [[UIView alloc] initWithFrame:CGRectMake(0, 135, (ScreenWidth - 15)/2, 30)];
                lastViewp.backgroundColor = [UIColor whiteColor];
                
                UILabel *fenLabTipP = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 30, 10)];
                fenLabTipP.font = [UIFont systemFontOfSize:10];
                [fenLabTipP setTextColor:[ConMethods colorWithHexString:@"999999"]];
                
                fenLabTipP.text = @"当前价";
                [lastViewp addSubview:fenLabTipP];
                
                UILabel *fenLabelp = [[UILabel alloc] init];
                fenLabelp.font = [UIFont systemFontOfSize:10];
                [fenLabelp setTextColor:[ConMethods colorWithHexString:@"950401"]];
                fenLabelp.text = [NSString stringWithFormat:@"￥%.2f",[[[dataListPast objectAtIndex:indexPath.row*2 + 1] objectForKey:@"ZXJG"] doubleValue]];
            fenLabelp.frame = CGRectMake(35,10, [PublicMethod getStringWidth:fenLabelp.text font:fenLabelp.font], 10);
            [lastViewp addSubview:fenLabelp];
            
            
            
            UILabel *ciLabTi = [[UILabel alloc] initWithFrame:CGRectMake(lastViewp.frame.size.width - 15, 10, 30, 10)];
            ciLabTi.font = [UIFont systemFontOfSize:10];
            [ciLabTi setTextColor:[ConMethods colorWithHexString:@"999999"]];
            
            ciLabTi.text = @"次";
            [lastViewp addSubview:ciLabTi];
            
                
                UILabel *priceLabelp = [[UILabel alloc] init];
                priceLabelp.font = [UIFont systemFontOfSize:10];
                [priceLabelp setTextColor:[ConMethods colorWithHexString:@"950401"]];
                priceLabelp.text = [NSString stringWithFormat:@"%@",[[dataListPast objectAtIndex:indexPath.row*2 +1] objectForKey:@"COUNT_JJCS"]];
                priceLabelp.textAlignment = NSTextAlignmentRight;
            
            priceLabelp.frame = CGRectMake(lastViewp.frame.size.width - 15 - [PublicMethod getStringWidth:priceLabelp.text font:priceLabelp.font], 10, [PublicMethod getStringWidth:priceLabelp.text font:priceLabelp.font], 10);;
                [lastViewp addSubview:priceLabelp];
            
            
            UILabel *baoL = [[UILabel alloc] initWithFrame:CGRectMake(priceLabelp.frame.origin.x - 20, 10, 20, 10)];
            baoL.font = [UIFont systemFontOfSize:10];
            [baoL setTextColor:[ConMethods colorWithHexString:@"999999"]];
            
            baoL.text = @"报价";
            [lastViewp addSubview:baoL];
            
                [backViewlast addSubview:lastViewp];
            
            
            UITapGestureRecognizer *singleTap1;
            
            singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
            //单点触摸
            singleTap1.numberOfTouchesRequired = 1;
            //点击几次，如果是1就是单击
            singleTap1.numberOfTapsRequired = 1;
            [backView addGestureRecognizer:singleTap1];
            
            
            UITapGestureRecognizer *singleTap;
            
            singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
            
            //单点触摸
            singleTap.numberOfTouchesRequired = 1;
            //点击几次，如果是1就是单击
            singleTap.numberOfTapsRequired = 1;
            [backViewlast addGestureRecognizer:singleTap];
            
            
                 [cell.contentView addSubview:backViewlast];
                [cell.contentView addSubview:backView];
            
                } else {
                
                    if (indexPath.row*2 + 1 == dataListPast.count) {
                        
                    
                    //添加背景View
                    UIView *backView;
                    backView.tag = indexPath.row*2;
                    
                    backView = [[UIView alloc] initWithFrame:CGRectMake(5 , 0, ScreenWidth/2 - 7.5, 165)];
                        [backView setBackgroundColor:[UIColor clearColor]];
                        backView.layer.cornerRadius = 2;
                        backView.layer.masksToBounds = YES;
                        backView.layer.borderWidth = 1;
                        backView.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
                        
                        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2 - 7.5, 100)];
                        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,[[dataListPast objectAtIndex:indexPath.row*2] objectForKey:@"F_XMLOGO"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
                        [backView addSubview:image];
                        
                        //品牌
                        UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 107.5, (ScreenWidth - 15)/2 - 10, 15)];
                        brandLabel.font = [UIFont systemFontOfSize:14];
                        [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                        [brandLabel setBackgroundColor:[UIColor clearColor]];
                        brandLabel.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"BDMC"];
                        [backView addSubview:brandLabel];
                        
                        //当前价
                        UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, (ScreenWidth - 15)/2, 30)];
                        lastView.backgroundColor = [UIColor whiteColor];
                        
                        UILabel *fenLabTip = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 30, 10)];
                        fenLabTip.font = [UIFont systemFontOfSize:10];
                        [fenLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                        
                        fenLabTip.text = @"当前价";
                        [lastView addSubview:fenLabTip];
                        
                        UILabel *fenLabel = [[UILabel alloc] init];
                        fenLabel.font = [UIFont systemFontOfSize:10];
                        [fenLabel setTextColor:[ConMethods colorWithHexString:@"950401"]];
                        fenLabel.text = [NSString stringWithFormat:@"￥%.2f",[[[dataListPast objectAtIndex:indexPath.row*2] objectForKey:@"ZXJG"] doubleValue]];
                        
                        fenLabel.frame = CGRectMake(35,10, [PublicMethod getStringWidth:fenLabel.text font:fenLabel.font], 10);
                        
                        [lastView addSubview:fenLabel];
                        //多少次报价
                        
                        UILabel *ciLabTip = [[UILabel alloc] initWithFrame:CGRectMake(lastView.frame.size.width - 15, 10, 30, 10)];
                        ciLabTip.font = [UIFont systemFontOfSize:10];
                        [ciLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                        
                        ciLabTip.text = @"次";
                        [lastView addSubview:ciLabTip];
                        
                        
                        
                        
                        UILabel *priceLabel = [[UILabel alloc] init];
                        priceLabel.font = [UIFont systemFontOfSize:10];
                        [priceLabel setTextColor:[ConMethods colorWithHexString:@"950401"]];
                        priceLabel.text = [NSString stringWithFormat:@"%@",[[dataListPast objectAtIndex:indexPath.row*2] objectForKey:@"COUNT_JJCS"]];
                        priceLabel.textAlignment = NSTextAlignmentRight;
                        priceLabel.frame = CGRectMake(lastView.frame.size.width - 15 - [PublicMethod getStringWidth:priceLabel.text font:priceLabel.font], 10, [PublicMethod getStringWidth:priceLabel.text font:priceLabel.font], 10);
                        
                        [lastView addSubview:priceLabel];
                        
                        UILabel *baoLabTip = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x - 20, 10, 20, 10)];
                        baoLabTip.font = [UIFont systemFontOfSize:10];
                        [baoLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                        
                        baoLabTip.text = @"报价";
                        [lastView addSubview:baoLabTip];
                       
                        

                    
                        UITapGestureRecognizer *singleTap1;
                        
                        singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
                        
                        //单点触摸
                        singleTap1.numberOfTouchesRequired = 1;
                        //点击几次，如果是1就是单击
                        singleTap1.numberOfTapsRequired = 1;
                        [backView addGestureRecognizer:singleTap1];
                        
                        
                        
                        
                    [backView addSubview:lastView];
                    [cell.contentView addSubview:backView];
                    
                    }else {
                        
                        
                        
                        //添加背景View
                        UIView *backView,*backViewlast;
                        
                         backView.tag = indexPath.row*2;
                         backViewlast.tag = indexPath.row*2 + 1;
                        
                        backView = [[UIView alloc] initWithFrame:CGRectMake(5 , 0, ScreenWidth/2 - 7.5, 165)];
                        [backView setBackgroundColor:[UIColor clearColor]];
                        backView.layer.cornerRadius = 2;
                        backView.layer.masksToBounds = YES;
                        backView.layer.borderWidth = 1;
                        backView.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
                        
                        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2 - 7.5, 100)];
                        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,[[dataListPast objectAtIndex:indexPath.row*2] objectForKey:@"F_XMLOGO"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
                        [backView addSubview:image];
                        
                        //品牌
                        UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 107.5, (ScreenWidth - 15)/2 - 10, 15)];
                        brandLabel.font = [UIFont systemFontOfSize:14];
                        [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                        [brandLabel setBackgroundColor:[UIColor clearColor]];
                        brandLabel.text = [[dataListPast objectAtIndex:indexPath.row] objectForKey:@"BDMC"];
                        [backView addSubview:brandLabel];
                        
                        //当前价
                        UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, (ScreenWidth - 15)/2, 30)];
                        lastView.backgroundColor = [UIColor whiteColor];
                        
                        UILabel *fenLabTip = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 30, 10)];
                        fenLabTip.font = [UIFont systemFontOfSize:10];
                        [fenLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                        
                        fenLabTip.text = @"当前价";
                        [lastView addSubview:fenLabTip];
                        
                        UILabel *fenLabel = [[UILabel alloc] init];
                        fenLabel.font = [UIFont systemFontOfSize:10];
                        [fenLabel setTextColor:[ConMethods colorWithHexString:@"950401"]];
                        fenLabel.text = [NSString stringWithFormat:@"￥%.2f",[[[dataListPast objectAtIndex:indexPath.row*2] objectForKey:@"ZXJG"] doubleValue]];
                        
                        fenLabel.frame = CGRectMake(35,10, [PublicMethod getStringWidth:fenLabel.text font:fenLabel.font], 10);
                        
                        [lastView addSubview:fenLabel];
                        //多少次报价
                        
                        UILabel *ciLabTip = [[UILabel alloc] initWithFrame:CGRectMake(lastView.frame.size.width - 15, 10, 30, 10)];
                        ciLabTip.font = [UIFont systemFontOfSize:10];
                        [ciLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                        
                        ciLabTip.text = @"次";
                        [lastView addSubview:ciLabTip];
                        
                        
                        
                        
                        UILabel *priceLabel = [[UILabel alloc] init];
                        priceLabel.font = [UIFont systemFontOfSize:10];
                        [priceLabel setTextColor:[ConMethods colorWithHexString:@"950401"]];
                        priceLabel.text = [NSString stringWithFormat:@"%@",[[dataListPast objectAtIndex:indexPath.row*2] objectForKey:@"COUNT_JJCS"]];
                        priceLabel.textAlignment = NSTextAlignmentRight;
                        priceLabel.frame = CGRectMake(lastView.frame.size.width - 15 - [PublicMethod getStringWidth:priceLabel.text font:priceLabel.font], 10, [PublicMethod getStringWidth:priceLabel.text font:priceLabel.font], 10);
                        
                        [lastView addSubview:priceLabel];
                        
                        UILabel *baoLabTip = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.origin.x - 20, 10, 20, 10)];
                        baoLabTip.font = [UIFont systemFontOfSize:10];
                        [baoLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                        
                        baoLabTip.text = @"报价";
                        [lastView addSubview:baoLabTip];
                        [backView addSubview:lastView];
                        
                        
                        
                        /**********  backViewlast  ************/
                        backViewlast = [[UIView alloc] initWithFrame:CGRectMake(2.5 +ScreenWidth/2, 0, ScreenWidth/2 - 7.5, 165)];
                        [backViewlast setBackgroundColor:[UIColor clearColor]];
                        backViewlast.layer.cornerRadius = 2;
                        backViewlast.layer.masksToBounds = YES;
                        backViewlast.layer.borderWidth = 1;
                        backViewlast.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
                        
                        UIImageView *imagep = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2 - 7.5, 100)];
                        [imagep setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,[[dataListPast objectAtIndex:indexPath.row*2 + 1] objectForKey:@"F_XMLOGO"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
                        [backViewlast addSubview:imagep];
                        
                        //品牌
                        UILabel *brandLabelp = [[UILabel alloc] initWithFrame:CGRectMake(5, 107.5, (ScreenWidth - 15)/2 - 10, 15)];
                        brandLabelp.font = [UIFont systemFontOfSize:14];
                        [brandLabelp setTextColor:[ConMethods colorWithHexString:@"333333"]];
                        [brandLabelp setBackgroundColor:[UIColor clearColor]];
                        brandLabelp.text = [[dataListPast objectAtIndex:indexPath.row*2 + 1] objectForKey:@"BDMC"];
                        [backViewlast addSubview:brandLabelp];
                        
                        //当前价
                        UIView *lastViewp = [[UIView alloc] initWithFrame:CGRectMake(0, 135, (ScreenWidth - 15)/2, 30)];
                        lastViewp.backgroundColor = [UIColor whiteColor];
                        
                        UILabel *fenLabTipP = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 30, 10)];
                        fenLabTipP.font = [UIFont systemFontOfSize:10];
                        [fenLabTipP setTextColor:[ConMethods colorWithHexString:@"999999"]];
                        
                        fenLabTipP.text = @"当前价";
                        [lastViewp addSubview:fenLabTipP];
                        
                        UILabel *fenLabelp = [[UILabel alloc] init];
                        fenLabelp.font = [UIFont systemFontOfSize:10];
                        [fenLabelp setTextColor:[ConMethods colorWithHexString:@"950401"]];
                        fenLabelp.text = [NSString stringWithFormat:@"￥%.2f",[[[dataListPast objectAtIndex:indexPath.row*2 + 1] objectForKey:@"ZXJG"] doubleValue]];
                        fenLabelp.frame = CGRectMake(35,10, [PublicMethod getStringWidth:fenLabelp.text font:fenLabelp.font], 10);
                        [lastViewp addSubview:fenLabelp];
                        
                        
                        
                        UILabel *ciLabTi = [[UILabel alloc] initWithFrame:CGRectMake(lastViewp.frame.size.width - 15, 10, 30, 10)];
                        ciLabTi.font = [UIFont systemFontOfSize:10];
                        [ciLabTi setTextColor:[ConMethods colorWithHexString:@"999999"]];
                        
                        ciLabTi.text = @"次";
                        [lastViewp addSubview:ciLabTi];
                        
                        
                        UILabel *priceLabelp = [[UILabel alloc] init];
                        priceLabelp.font = [UIFont systemFontOfSize:10];
                        [priceLabelp setTextColor:[ConMethods colorWithHexString:@"950401"]];
                        priceLabelp.text = [NSString stringWithFormat:@"%@",[[dataListPast objectAtIndex:indexPath.row*2 +1] objectForKey:@"COUNT_JJCS"]];
                        priceLabelp.textAlignment = NSTextAlignmentRight;
                        
                        priceLabelp.frame = CGRectMake(lastViewp.frame.size.width - 15 - [PublicMethod getStringWidth:priceLabelp.text font:priceLabelp.font], 10, [PublicMethod getStringWidth:priceLabelp.text font:priceLabelp.font], 10);;
                        [lastViewp addSubview:priceLabelp];
                        
                        
                        UILabel *baoL = [[UILabel alloc] initWithFrame:CGRectMake(priceLabelp.frame.origin.x - 20, 10, 20, 10)];
                        baoL.font = [UIFont systemFontOfSize:10];
                        [baoL setTextColor:[ConMethods colorWithHexString:@"999999"]];
                        
                        baoL.text = @"报价";
                        [lastViewp addSubview:baoL];
                        
                        [backViewlast addSubview:lastViewp];
                        
                        
                        UITapGestureRecognizer *singleTap1;
                        
                        singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
                        
                        //单点触摸
                        singleTap1.numberOfTouchesRequired = 1;
                        //点击几次，如果是1就是单击
                        singleTap1.numberOfTapsRequired = 1;
                        [backView addGestureRecognizer:singleTap1];
                        
                        
                        UITapGestureRecognizer *singleTap;
                        
                        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
                        
                        //单点触摸
                        singleTap.numberOfTouchesRequired = 1;
                        //点击几次，如果是1就是单击
                        singleTap.numberOfTapsRequired = 1;
                        [backViewlast addGestureRecognizer:singleTap];
                        
                        
                        [cell.contentView addSubview:backViewlast];
                        [cell.contentView addSubview:backView];
                        
                    }

                
                }
                
        
    }
    }
    } else if(indexPath.section == 1){
        if (dataListPast.count > 0) {
            
        
        
            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
                
                UIView  *backView = [[UIView alloc] initWithFrame:CGRectMake(5 , 0, ScreenWidth - 10, 30)];
                [backView setBackgroundColor:[UIColor whiteColor]];
                backView.layer.cornerRadius = 2;
                backView.layer.masksToBounds = YES;
                backView.layer.borderWidth = 1;
                backView.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7.5, ScreenWidth - 30, 15)];
                brandLabel.font = [UIFont systemFontOfSize:15];
                [brandLabel setTextColor:[UIColor redColor]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.textAlignment = NSTextAlignmentCenter;
                brandLabel.text = str;
                [backView addSubview:brandLabel];
                
                [cell.contentView addSubview:backView];
                
                }
            }
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
       return 220;
    } else if (indexPath.section == 1){
        return  30;
    }else {
    
    return 170;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    float count;
    if (section == 0) {
        count = 40;
    } else if(section == 1){
      count = 5;
    }else{
        count = 40;
    }
    return count;
}


- (IBAction)callPhone:(UITouch *)sender
{
    
    UIView *view = [sender view];
    
   
        MarkViewController *vc = [[MarkViewController alloc] init];
        vc.strId = [NSString stringWithFormat:@"%@",[[dataListPast objectAtIndex:view.tag] objectForKey:@"XMID"]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    
    
    
}



- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view;
    if (section == 2) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 19, ScreenWidth, 40)];
       // view.backgroundColor = [UIColor clearColor];
        [view setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5,19, ScreenWidth/2 - 10 - 30, 2)];
        lineView.backgroundColor = [UIColor blackColor];
        [view addSubview:lineView];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 35,19, ScreenWidth/2 - 10 - 30, 2)];
        lineView1.backgroundColor = [UIColor blackColor];
        [view addSubview:lineView1];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 30, 12.5, 30, 15)];
        lab.text = @"最热";
        lab.textColor = [UIColor redColor];
        lab.font = [UIFont systemFontOfSize:15];
        lab.backgroundColor = [UIColor clearColor];
        [view addSubview:lab];
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 12.5, 30, 15)];
        lab1.text = @"拍品";
        lab1.font = [UIFont systemFontOfSize:15];
        lab1.textColor = [UIColor blackColor];
        lab1.backgroundColor = [UIColor clearColor];
        [view addSubview:lab1];
       

        
        
        
    } else if (section == 0){
    
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 19, ScreenWidth/2 - 10 - 30, 2)];
        lineView.backgroundColor = [UIColor blackColor];
        [view addSubview:lineView];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 35, 19, ScreenWidth/2 - 10 - 30, 2)];
        lineView1.backgroundColor = [UIColor blackColor];
        [view addSubview:lineView1];
        
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 30, 12.5, 30, 15)];
        lab.text = @"专场";
        lab.textColor = [UIColor redColor];
        lab.font = [UIFont systemFontOfSize:15];
        lab.backgroundColor = [UIColor clearColor];
        [view addSubview:lab];
        
    
        UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 12.5, 30, 15)];
        lab1.text = @"列表";
        lab1.font = [UIFont systemFontOfSize:15];
        lab1.textColor = [UIColor blackColor];
        lab1.backgroundColor = [UIColor clearColor];
        [view addSubview:lab1];
        
    
    } else{
     view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    [view setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
    
    }
    
    
    return view;
    
}



- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        DetailViewController *vc = [[DetailViewController alloc] init];
        vc.strId = [NSString stringWithFormat:@"%@",[[dataList objectAtIndex:indexPath.row] objectForKey:@"ID"]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
      
    } else if (indexPath.section == 1){
        
    }
    
    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
}




-(void)reloadData:(NSMutableArray *)arr {
    imageArray = arr;

    CGRect bound=CGRectMake(0, addHight + 44, ScreenWidth, 150);
    
    scrollViewImage = [[UIScrollView alloc] initWithFrame:bound];
    
    //scrollView.bounces = YES;
    scrollViewImage.pagingEnabled = YES;
    scrollViewImage.delegate = self;
    scrollViewImage.userInteractionEnabled = YES;
    //隐藏水平滑动条
    scrollViewImage.showsVerticalScrollIndicator = FALSE;
    scrollViewImage.showsHorizontalScrollIndicator = FALSE;
    [scrollViewImage flashScrollIndicators];
    [self.view addSubview:scrollViewImage];
    
    // 初始化 pagecontrol
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth - 90,150 - 20,80,10)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[ConMethods colorWithHexString:@"e3a325"]];
    [pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    pageControl.numberOfPages = [imageArray count];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self.view addSubview:pageControl];
    
    if (imageArray.count > 0) {
       for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * i) + ScreenWidth, 0, ScreenWidth, 150)];
        [imageView1 setTag:i + 10000];
           [imageView1 setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"logo"]];
         [scrollViewImage addSubview:imageView1];
           
       }
        
        
        // 取数组最后一张图片 放在第0页
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        imgView.tag = 4 + 10000;
        
        [imgView setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:imageArray.count - 1]] placeholderImage:[UIImage imageNamed:@"logo"]];
        
        
        
        [scrollViewImage addSubview:imgView];
        
        // 取数组第一张图片 放在最后1页
        
        UIImageView *imgViewl = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * ([imageArray count] + 1)) , 0, ScreenWidth, 150)];
        imgViewl.tag = 5 + 10000;
        
         [imgView setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"logo"]];
        
        // 添加第1页在最后 循环
        [scrollViewImage addSubview:imgViewl];
        
        [scrollViewImage setContentSize:CGSizeMake(ScreenWidth * ([imageArray count] + 2), 150)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
        [scrollViewImage setContentOffset:CGPointMake(0, 0)];
        [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,150) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
        
        
    } else {
     UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        imageView1.image = [UIImage imageNamed:@"logo"];
    [scrollViewImage addSubview:imageView1];
    }
    
    
}



//请求数据方法
-(void)requestMethods {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERappIndex] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
           
            [self recivedCategoryList:[responseObject objectForKey:@"object"]];
            
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


// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = (int)pageControl.currentPage; // 获取当前的page
    [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth*(page+1),0,ScreenWidth,150) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}
// 定时器 绑定的方法
- (void)runTimePage
{
    int page = (int)pageControl.currentPage; // 获取当前的page
    page++;
    page = page > (imageArray.count - 1) ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == table) {
        
    
    //去掉UItableview headerview黏性(sticky)
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }

    } else {
    
    
    
    CGFloat pagewidth = scrollViewImage.frame.size.width;
    int page = floor((scrollViewImage.contentOffset.x - pagewidth/([imageArray count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    pageControl.currentPage = page;
    }
}


// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollV
{
    CGFloat pagewidth = scrollViewImage.frame.size.width;
    int currentPage = floor((scrollViewImage.contentOffset.x - pagewidth/ ([imageArray count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth * [imageArray count],0,ScreenWidth,150) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([imageArray count]+1))
    {
        [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,150) animated:NO]; // 最后+1,循环第1页
    }
    //pageControl.currentPage = currentPage;
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)loginMethods:(id)sender {
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)regestMethods:(id)sender {
}
@end
