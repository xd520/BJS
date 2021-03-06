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
#import "ProviousViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CPVTabViewController.h"

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
    UIImageView *imageViewHead;
    
    BOOL hasMore;
    
    
}
@end

@implementation MainViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
     [self requestMethods];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    str = @"";
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        
        statusBarView.backgroundColor=[UIColor blackColor];
        
       // [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    hasMore = YES;
    
    NSLog(@"%f %f",ScreenWidth,ScreenHeight);
    
    // 定时器 循环
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];

    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 130 , ScreenWidth,ScreenHeight  - 130)];
    [table setDelegate:self];
    [table setDataSource:self];
    //table.bounces = YES;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
    table.tableFooterView = [[UIView alloc] init];
    
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
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    
     if (dataList.count > 0) {
   
        if (dataListPast.count > 0) {
            
        if (dataListPast.count % 2 == 0) {
           count =  dataList.count + 4 + dataListPast.count/2;
        } else {
        count =  dataList.count + 4 + (dataListPast.count + 1)/2;
        }
        } else {
            count =  dataList.count + 3;
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
    
        if ([dataList count] == 0 ) {
            
            if (hasMore) {
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
                
            } else {
            
            
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
            [backView setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
            //图标
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 57)/2, 100, 57, 57)];
            [iconImageView setImage:[UIImage imageNamed:@"wifi"]];
            [backView addSubview:iconImageView];
            //提示
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + iconImageView.frame.size.height + 10, ScreenWidth, 15)];
            [tipLabel setFont:[UIFont systemFontOfSize:15]];
            [tipLabel setTextAlignment:NSTextAlignmentCenter];
            [tipLabel setTextColor:[ConMethods colorWithHexString:@"404040"]];
            tipLabel.backgroundColor = [UIColor clearColor];
            [tipLabel setText:@"网络不给力哦~"];
            [backView addSubview:tipLabel];
            
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - 100)/2, iconImageView.frame.origin.y + iconImageView.frame.size.height + 17 + 25, 100, 30)];
            btn.backgroundColor = [UIColor lightTextColor];
           // btn.titleLabel.text = @"点击加载";
            [btn setTitle:@"点击加载" forState:UIControlStateNormal];
            btn.layer.borderColor = [ConMethods colorWithHexString:@"dedede"].CGColor;
            btn.layer.borderWidth = 1;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 4;
            [btn setTitleColor:[ConMethods colorWithHexString:@"333333"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn addTarget:self action:@selector(addData) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:btn];
            
            [cell.contentView addSubview:backView];
            }
        } else{
           
            NSInteger countAll = 0;
            
            if (dataListPast.count > 0) {
                
                if (dataListPast.count % 2 == 0) {
                    countAll = dataListPast.count/2;
                } else {
                    countAll = (dataListPast.count + 1)/2;
                }
            }
            
            
            if (indexPath.row == 0) {
               
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
                    //添加背景View
                    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                    [backView setBackgroundColor:[UIColor clearColor]];
                  
 
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, 19, ScreenWidth/2 - 10 - 30, 2)];
                lineView.backgroundColor = [UIColor blackColor];
                [backView addSubview:lineView];
                
                UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 35, 19, ScreenWidth/2 - 10 - 30, 2)];
                lineView1.backgroundColor = [UIColor blackColor];
                [backView addSubview:lineView1];
                
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 30, 12.5, 30, 15)];
                lab.text = @"专场";
                lab.textColor = [UIColor redColor];
                lab.font = [UIFont systemFontOfSize:15];
                lab.backgroundColor = [UIColor clearColor];
                [backView addSubview:lab];
                
                
                UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 12.5, 30, 15)];
                lab1.text = @"列表";
                lab1.font = [UIFont systemFontOfSize:15];
                lab1.textColor = [UIColor blackColor];
                lab1.backgroundColor = [UIColor clearColor];
                [backView addSubview:lab1];
                
                [cell.contentView addSubview:backView];
                
                }
                return cell;
            }else if (indexPath.row >0 &&indexPath.row <= dataList.count){

            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 270)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, ScreenWidth - 10, 260)];
                [backView setBackgroundColor:[UIColor whiteColor]];
                backView.layer.cornerRadius = 2;
                backView.layer.masksToBounds = YES;
                backView.layer.borderWidth = 1;
                backView.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
                
                 //专场列表
                
                
                
                 UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 10, 150)];
                 [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/LbFiles/zclogo_app/%@.jpg",SERVERURL,[[dataList objectAtIndex:indexPath.row - 1] objectForKey:@"ID"]]] placeholderImage:[UIImage imageNamed:@"loading_zc"]];
                [backView addSubview:image];
                
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 160, ScreenWidth - 30, 15)];
                brandLabel.font = [UIFont systemFontOfSize:15];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                // brandLabel.numberOfLines = 0;
                brandLabel.text = [[dataList objectAtIndex:indexPath.row - 1] objectForKey:@"ZCMC"];
                [backView addSubview:brandLabel];
                
                //最新价
                UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 , 185, ScreenWidth - 30, 14)];
                dayLabel.text = [[dataList objectAtIndex:indexPath.row - 1] objectForKey:@"ZCQH"];
                dayLabel.font = [UIFont systemFontOfSize:14];
                dayLabel.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:dayLabel];
                
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 205, ScreenWidth - 30, 14)];
                dateLabel.text = [NSString stringWithFormat:@"%@-%@",[[dataList objectAtIndex:indexPath.row - 1] objectForKey:@"KSRQ"],[[dataList objectAtIndex:indexPath.row - 1] objectForKey:@"JSRQ"]];
                dateLabel.font = [UIFont systemFontOfSize:14];
                dateLabel.textColor = [ConMethods colorWithHexString:@"333333"];
                
                [backView addSubview:dateLabel];
                
                
                
                UILabel *totalLabel= [[UILabel alloc] initWithFrame:CGRectMake(10, 233, 12, 12)];
                totalLabel.text = @"共";
                totalLabel.font = [UIFont systemFontOfSize:12];
                totalLabel.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:totalLabel];
                
                
                UILabel *vuleLabel = [[UILabel alloc] init];
                vuleLabel.text = [NSString stringWithFormat:@"%@",[[dataList objectAtIndex:indexPath.row - 1] objectForKey:@"COUNT_BDS"]];
                vuleLabel.font = [UIFont systemFontOfSize:15];
                vuleLabel.textColor = [ConMethods colorWithHexString:@"950401"];
                vuleLabel.frame = CGRectMake( 24, 230, [PublicMethod getStringWidth:vuleLabel.text font:vuleLabel.font], 15);
                [backView addSubview:vuleLabel];
                
                
                
                UILabel *labelTip= [[UILabel alloc] initWithFrame:CGRectMake(26 + [PublicMethod getStringWidth:vuleLabel.text font:vuleLabel.font], 233, 12*3, 12)];
                labelTip.text = @"件标物";
                labelTip.font = [UIFont systemFontOfSize:12];
                labelTip.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:labelTip];
                
                
                //围观
               
                UILabel *dateLabelMore = [[UILabel alloc] init];
                
                if ([[dataList objectAtIndex:indexPath.row - 1] objectForKey:@"WGCS"] == [NSNull null]) {
                    dateLabelMore.text = @"0";
                } else {
                
                dateLabelMore.text = [NSString stringWithFormat:@"%@",[[dataList objectAtIndex:indexPath.row - 1] objectForKey:@"WGCS"]];
                }
                dateLabelMore.textAlignment = NSTextAlignmentCenter;
                dateLabelMore.font = [UIFont systemFontOfSize:14];
                dateLabelMore.frame = CGRectMake(2 + labelTip.frame.size.width + labelTip.frame.origin.x, 231, [PublicMethod getStringWidth:dateLabelMore.text font:dateLabelMore.font], 14);
                dateLabelMore.textColor = [ConMethods colorWithHexString:@"950401"];
                
                [backView addSubview:dateLabelMore];
                
                UILabel *dayLabelMore = [[UILabel alloc] initWithFrame:CGRectMake(dateLabelMore.frame.size.width + dateLabelMore.frame.origin.x, 232, 39, 13)];
                dayLabelMore.text = @"次围观";
                dayLabelMore.font = [UIFont systemFontOfSize:13];
                dayLabelMore.textColor = [ConMethods colorWithHexString:@"999999"];
                [backView addSubview:dayLabelMore];
                
                
                [cell.contentView addSubview:backView];
            }
        
        }else if ( indexPath.row == dataList.count + 1){
            
                
                cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
                    
                    UIView  *backView = [[UIView alloc] initWithFrame:CGRectMake(5 , 10, ScreenWidth - 10, 30)];
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
        } else if (dataListPast.count > 0 && indexPath.row == dataList.count + 2){
        
            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
                //添加背景View
                UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
                [backView setBackgroundColor:[UIColor clearColor]];
               
                
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5,19, ScreenWidth/2 - 10 - 30, 2)];
                lineView.backgroundColor = [UIColor blackColor];
                [backView addSubview:lineView];
                
                UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 35,19, ScreenWidth/2 - 10 - 30, 2)];
                lineView1.backgroundColor = [UIColor blackColor];
                [backView addSubview:lineView1];
                
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 - 30, 12.5, 30, 15)];
                lab.text = @"最热";
                lab.textColor = [UIColor redColor];
                lab.font = [UIFont systemFontOfSize:15];
                lab.backgroundColor = [UIColor clearColor];
                [backView addSubview:lab];
                UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2, 12.5, 30, 15)];
                lab1.text = @"拍品";
                lab1.font = [UIFont systemFontOfSize:15];
                lab1.textColor = [UIColor blackColor];
                lab1.backgroundColor = [UIColor clearColor];
                [backView addSubview:lab1];
                
                [cell.contentView addSubview:backView];
                
            }
        
        
        }else if (dataListPast.count > 0 && indexPath.row > dataList.count + 2 && indexPath.row < dataList.count + 3 + countAll){
            
            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2 - 7.5 + 70)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
                
                
                if (dataListPast.count % 2 == 0) {
                    
                
                
                //添加背景View
                UIView *backView,*backViewlast;
            backView.tag = (indexPath.row - dataList.count - 3)*2;
           
            
                backView = [[UIView alloc] initWithFrame:CGRectMake(5 , 0, ScreenWidth/2 - 7.5,ScreenWidth/2 - 7.5 + 60)];
                [backView setBackgroundColor:[UIColor clearColor]];
                backView.layer.cornerRadius = 2;
                backView.layer.masksToBounds = YES;
            backView.layer.borderWidth = 1;
            backView.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
            
                UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2 - 7.5, ScreenWidth/2 - 7.5)];
            NSString *baseStr = [[Base64XD encodeBase64String:@"200,200"] strBase64];
                [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_%@.jpg",SERVERURL,[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2] objectForKey:@"F_XMLOGO"],baseStr]] placeholderImage:[UIImage imageNamed:@"loading_bd"]];
            
            NSLog(@"%@",[NSString stringWithFormat:@"%@%@_%@.jpg",SERVERURL,[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2] objectForKey:@"F_XMLOGO"],baseStr]);
            
                [backView addSubview:image];
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,ScreenWidth/2 - 7.5 + 7.5, (ScreenWidth - 15)/2 - 10, 15)];
                brandLabel.font = [UIFont systemFontOfSize:14];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                brandLabel.text = [[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)] objectForKey:@"BDMC"];
                [backView addSubview:brandLabel];
                
                //当前价
                UIView *lastView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenWidth/2 - 7.5 + 30, (ScreenWidth - 15)/2, 30)];
                lastView.backgroundColor = [UIColor whiteColor];
                
                UILabel *fenLabTip = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 30, 10)];
                fenLabTip.font = [UIFont systemFontOfSize:10];
                [fenLabTip setTextColor:[ConMethods colorWithHexString:@"999999"]];
                
                fenLabTip.text = @"当前价";
                [lastView addSubview:fenLabTip];
                
                UILabel *fenLabel = [[UILabel alloc] init];
                fenLabel.font = [UIFont systemFontOfSize:10];
                [fenLabel setTextColor:[ConMethods colorWithHexString:@"950401"]];
                fenLabel.text = [NSString stringWithFormat:@"￥%.2f",[[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2] objectForKey:@"ZXJG"] doubleValue]];
            
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
                priceLabel.text = [NSString stringWithFormat:@"%@",[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2] objectForKey:@"COUNT_JJCS"]];
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
                  backViewlast = [[UIView alloc] initWithFrame:CGRectMake(2.5 +ScreenWidth/2, 0, ScreenWidth/2 - 7.5, ScreenWidth/2 - 7.5 + 60)];
             backViewlast.tag = (indexPath.row - dataList.count - 3)*2 + 1;
                    [backViewlast setBackgroundColor:[UIColor clearColor]];
                    backViewlast.layer.cornerRadius = 2;
                    backViewlast.layer.masksToBounds = YES;
            backViewlast.layer.borderWidth = 1;
            backViewlast.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
            
                    UIImageView *imagep = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2 - 7.5, ScreenWidth/2 - 7.5)];
            
            
                    [imagep setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_%@.jpg",SERVERURL,[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2 + 1] objectForKey:@"F_XMLOGO"],baseStr]] placeholderImage:[UIImage imageNamed:@"loading_bd"]];
                    [backViewlast addSubview:imagep];
                    
                    //品牌
                    UILabel *brandLabelp = [[UILabel alloc] initWithFrame:CGRectMake(5,ScreenWidth/2 - 7.5 + 7.5, (ScreenWidth - 15)/2 - 10, 15)];
                    brandLabelp.font = [UIFont systemFontOfSize:14];
                    [brandLabelp setTextColor:[ConMethods colorWithHexString:@"333333"]];
                    [brandLabelp setBackgroundColor:[UIColor clearColor]];
                    brandLabelp.text = [[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2 + 1] objectForKey:@"BDMC"];
                    [backViewlast addSubview:brandLabelp];
                    
                //当前价
                UIView *lastViewp = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenWidth/2 - 7.5 + 30, (ScreenWidth - 15)/2, 30)];
                lastViewp.backgroundColor = [UIColor whiteColor];
                
                UILabel *fenLabTipP = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 30, 10)];
                fenLabTipP.font = [UIFont systemFontOfSize:10];
                [fenLabTipP setTextColor:[ConMethods colorWithHexString:@"999999"]];
                
                fenLabTipP.text = @"当前价";
                [lastViewp addSubview:fenLabTipP];
                
                UILabel *fenLabelp = [[UILabel alloc] init];
                fenLabelp.font = [UIFont systemFontOfSize:10];
                [fenLabelp setTextColor:[ConMethods colorWithHexString:@"950401"]];
                fenLabelp.text = [NSString stringWithFormat:@"￥%.2f",[[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2 + 1] objectForKey:@"ZXJG"] doubleValue]];
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
                priceLabelp.text = [NSString stringWithFormat:@"%@",[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2 +1] objectForKey:@"COUNT_JJCS"]];
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
                
                    if ((indexPath.row - dataList.count - 3)*2 + 1 == dataListPast.count) {
                        
                    
                    //添加背景View
                    UIView *backView;
                    backView.tag = (indexPath.row - dataList.count - 3)*2;
                    
                    backView = [[UIView alloc] initWithFrame:CGRectMake(5 , 0, ScreenWidth/2 - 7.5, 165)];
                        [backView setBackgroundColor:[UIColor clearColor]];
                        backView.layer.cornerRadius = 2;
                        backView.layer.masksToBounds = YES;
                        backView.layer.borderWidth = 1;
                        backView.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
                        
                        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2 - 7.5, ScreenWidth/2 - 7.5)];
                         NSString *baseStr = [[Base64XD encodeBase64String:@"200,200"] strBase64];
                        
                        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_%@.jpg",SERVERURL,[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2] objectForKey:@"F_XMLOGO"],baseStr]] placeholderImage:[UIImage imageNamed:@"loading_bd"]];
                        [backView addSubview:image];
                        
                        //品牌
                        UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 107.5, (ScreenWidth - 15)/2 - 10, 15)];
                        brandLabel.font = [UIFont systemFontOfSize:14];
                        [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                        [brandLabel setBackgroundColor:[UIColor clearColor]];
                        brandLabel.text = [[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)] objectForKey:@"BDMC"];
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
                        fenLabel.text = [NSString stringWithFormat:@"￥%.2f",[[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2] objectForKey:@"ZXJG"] doubleValue]];
                        
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
                        priceLabel.text = [NSString stringWithFormat:@"%@",[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2] objectForKey:@"COUNT_JJCS"]];
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
                       NSString *baseStr = [[Base64XD encodeBase64String:@"200,200"] strBase64];
                        
                        [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_%@.jpg",SERVERURL,[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2] objectForKey:@"F_XMLOGO"],baseStr]] placeholderImage:[UIImage imageNamed:@"loading_bd"]];
                        [backView addSubview:image];
                        
                        //品牌
                        UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 107.5, (ScreenWidth - 15)/2 - 10, 15)];
                        brandLabel.font = [UIFont systemFontOfSize:14];
                        [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                        [brandLabel setBackgroundColor:[UIColor clearColor]];
                        brandLabel.text = [[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)] objectForKey:@"BDMC"];
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
                        fenLabel.text = [NSString stringWithFormat:@"￥%.2f",[[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2] objectForKey:@"ZXJG"] doubleValue]];
                        
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
                        priceLabel.text = [NSString stringWithFormat:@"%@",[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2] objectForKey:@"COUNT_JJCS"]];
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
                        backViewlast = [[UIView alloc] initWithFrame:CGRectMake(2.5 +ScreenWidth/2, 0, ScreenWidth/2 - 7.5, ScreenWidth/2 - 7.5)];
                        [backViewlast setBackgroundColor:[UIColor clearColor]];
                        backViewlast.layer.cornerRadius = 2;
                        backViewlast.layer.masksToBounds = YES;
                        backViewlast.layer.borderWidth = 1;
                        backViewlast.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
                        
                        UIImageView *imagep = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2 - 7.5, 100)];
                        
                        
                        
                        [imagep setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_%@.jpg",SERVERURL,[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2 + 1] objectForKey:@"F_XMLOGO"],baseStr]] placeholderImage:[UIImage imageNamed:@"loading_bd"]];
                        [backViewlast addSubview:imagep];
                        
                        //品牌
                        UILabel *brandLabelp = [[UILabel alloc] initWithFrame:CGRectMake(5, 107.5, (ScreenWidth - 15)/2 - 10, 15)];
                        brandLabelp.font = [UIFont systemFontOfSize:14];
                        [brandLabelp setTextColor:[ConMethods colorWithHexString:@"333333"]];
                        [brandLabelp setBackgroundColor:[UIColor clearColor]];
                        brandLabelp.text = [[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2 + 1] objectForKey:@"BDMC"];
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
                        fenLabelp.text = [NSString stringWithFormat:@"￥%.2f",[[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2 + 1] objectForKey:@"ZXJG"] doubleValue]];
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
                        priceLabelp.text = [NSString stringWithFormat:@"%@",[[dataListPast objectAtIndex:(indexPath.row - dataList.count - 3)*2 +1] objectForKey:@"COUNT_JJCS"]];
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
        } else if(dataListPast.count > 0 && indexPath.row < dataList.count + 3 + countAll){
            
            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
                
                UIView  *backView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, ScreenWidth , 50)];
                [backView setBackgroundColor:[UIColor whiteColor]];
                
                UIImageView *zixunview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 40)];
                zixunview.image = [UIImage imageNamed:@"zx_title"];
                [backView addSubview:zixunview];
                
                UIView *shuView = [[UIView alloc] initWithFrame:CGRectMake(75, 5, 1, 40)];
                shuView.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
                [backView addSubview:shuView];
                
                
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 18, ScreenWidth - 90, 14)];
                brandLabel.font = [UIFont systemFontOfSize:14];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                
                brandLabel.text = @"关于平台充值、提现额度调整的公告";
                [backView addSubview:brandLabel];
                
                [cell.contentView addSubview:backView];
                
            }
        } else if(dataListPast.count > 0 && indexPath.row == dataList.count + 3 + countAll){
            
            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 60)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
                
                UIView  *backView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, ScreenWidth , 50)];
                [backView setBackgroundColor:[UIColor whiteColor]];
                
                UIImageView *zixunview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 40)];
                zixunview.image = [UIImage imageNamed:@"zx_title"];
                [backView addSubview:zixunview];
                
                UIView *shuView = [[UIView alloc] initWithFrame:CGRectMake(75, 5, 1, 40)];
                shuView.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
                [backView addSubview:shuView];
                
                
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 18, ScreenWidth - 90, 14)];
                brandLabel.font = [UIFont systemFontOfSize:14];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                
                brandLabel.text = @"关于平台充值、提现额度调整的公告";
                [backView addSubview:brandLabel];
                
                [cell.contentView addSubview:backView];
                
            }
        } else if(indexPath.row == dataList.count + 2){
            
            cell = [tbleView dequeueReusableCellWithIdentifier:RepairCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
                
                UIView  *backView = [[UIView alloc] initWithFrame:CGRectMake(0 , 10, ScreenWidth , 50)];
                [backView setBackgroundColor:[UIColor whiteColor]];
                
                UIImageView *zixunview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 40)];
                zixunview.image = [UIImage imageNamed:@"zx_title"];
                [backView addSubview:zixunview];
                
                UIView *shuView = [[UIView alloc] initWithFrame:CGRectMake(75, 5, 1, 40)];
                shuView.backgroundColor = [ConMethods colorWithHexString:@"dedede"];
                [backView addSubview:shuView];
                
                
                
                //品牌
                UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 18, ScreenWidth - 90, 14)];
                brandLabel.font = [UIFont systemFontOfSize:14];
                [brandLabel setTextColor:[ConMethods colorWithHexString:@"333333"]];
                [brandLabel setBackgroundColor:[UIColor clearColor]];
                
                brandLabel.text = @"关于平台充值、提现额度调整的公告";
                [backView addSubview:brandLabel];
                
                [cell.contentView addSubview:backView];
                
            }
        }
    
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (dataList.count == 0) {
        return 90;
    } else {
        if (indexPath.row == 0) {
            return 40;
        } else if (indexPath.row > 0&&indexPath.row <= dataList.count) {
        return 270;
        } else if(indexPath.row == dataList.count + 1){
        
            return 40;
        }else {
            if (dataListPast.count > 0) {
                if (indexPath.row == dataList.count + 1) {
                    return 40;
                } else if(indexPath.row == dataList.count + 2){
                return 40 ;
                } else {
                    NSInteger countAll;
                     if (dataListPast.count % 2 == 0) {
                         countAll = dataListPast.count/2;
                     }else {
                         
                       countAll = (dataListPast.count + 1)/2;
                     }
                    
                    if (indexPath.row > dataList.count + 2 && indexPath.row < dataList.count + 3 + countAll ) {
                        return ScreenWidth/2 - 7.5 + 65;
                    } else {
                   return 60;
                    }
                }
                
            } else {
            
            return 60;
            }
        
        }
    }
    
}




- (IBAction)callPhone:(UITouch *)sender
{
    
    UIView *view = [sender view];
    
    NSLog(@"%ld",view.tag);
   
        MarkViewController *vc = [[MarkViewController alloc] init];
        vc.strId = [NSString stringWithFormat:@"%@",[[dataListPast objectAtIndex:view.tag] objectForKey:@"XMID"]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    
}





- (void)tableView:(UITableView *)tbleView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger countA;
    if (dataListPast.count % 2 == 0) {
        countA = dataListPast.count /2;
    } else {
    
    countA = (dataListPast.count + 1 )/2;
    }
    
    if (dataList.count > 0) {
        
    if (indexPath.row > 0 && indexPath.row <= dataList.count) {
        
        DetailViewController *vc = [[DetailViewController alloc] init];
        vc.strId = [NSString stringWithFormat:@"%@",[[dataList objectAtIndex:indexPath.row - 1] objectForKey:@"ID"]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
      
    } else if (indexPath.row == dataList.count + 1){
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.tabBarController.selectedIndex = 1;
        CPVTabViewController *osTabbarVC = delegate.tabBarController;
        UINavigationController *navVC = [osTabbarVC viewControllers][1];
        [navVC popViewControllerAnimated:NO];
        osTabbarVC.selectedViewController = navVC;
        
    } else if (indexPath.row == dataList.count + 2&&dataListPast.count == 0){
        ProviousViewController *cv = [[ProviousViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
    
    } else if(indexPath.row == dataList.count + 3 + countA && dataListPast.count > 0){
        ProviousViewController *cv = [[ProviousViewController alloc] init];
        cv.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cv animated:YES];
    
    }
   } 
        
    [tbleView deselectRowAtIndexPath:indexPath animated:YES];
}




-(void)reloadData:(NSMutableArray *)arr {
    imageArray = arr;
    
    //imageArray = [[NSMutableArray alloc] initWithArray:@[@"http://218.66.59.169:8400/LbFiles?type=zclogo&id=20", @"http://218.66.59.169:8400/LbFiles?type=zclogo&id=22", @"http://218.66.59.169:8400/LbFiles?type=zclogo&id=24"]];
    

    CGRect bound=CGRectMake(0, 0, ScreenWidth, 150);
    
    scrollViewImage = [[UIScrollView alloc] initWithFrame:bound];
    
    scrollViewImage.bounces = NO;
    scrollViewImage.pagingEnabled = YES;
    scrollViewImage.delegate = self;
    scrollViewImage.userInteractionEnabled = YES;
    //隐藏水平滑动条
    scrollViewImage.showsVerticalScrollIndicator = FALSE;
    scrollViewImage.showsHorizontalScrollIndicator = FALSE;
    
   // scrollViewImage.contentOffset = CGPointMake(ScreenWidth, 0);
    
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
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth *i + ScreenWidth, 0, ScreenWidth, 150)];
        [imageView1 setTag:i + 10000];
          // [imageView1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/LbFiles/tggw_app/%@.jpg",SERVERURL,[[imageArray objectAtIndex:i] objectForKey:@"ID"]]] placeholderImage:[UIImage imageNamed:@"loading_zc"]];
           
           [imageView1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/LbFiles/tggw/%@.jpg",SERVERURL,[[imageArray objectAtIndex:i] objectForKey:@"ID"]]] placeholderImage:[UIImage imageNamed:@"loading_zc"]];
           
           
           
           
        imageView1.userInteractionEnabled = YES;
         
           UITapGestureRecognizer *singleTap;
           
           singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhoneTab:)];
           
           //单点触摸
           singleTap.numberOfTouchesRequired = 1;
           //点击几次，如果是1就是单击
           singleTap.numberOfTapsRequired = 1;
           [imageView1 addGestureRecognizer:singleTap];
           
         [scrollViewImage addSubview:imageView1];
          
       }
        
        
        // 取数组最后一张图片 放在第0页
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
       // imgView.tag = 4 + 10000;
        
        [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/LbFiles/tggw/%@.jpg",SERVERURL,[[imageArray objectAtIndex:imageArray.count - 1] objectForKey:@"ID"]]] placeholderImage:[UIImage imageNamed:@"loading_zc"]];
        
        
        imgView.userInteractionEnabled = YES;
       
        UITapGestureRecognizer *singleTap;
        
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhoneTab:)];
        
        //单点触摸
        singleTap.numberOfTouchesRequired = 1;
        //点击几次，如果是1就是单击
        singleTap.numberOfTapsRequired = 1;
        [imgView addGestureRecognizer:singleTap];
        
        
        [scrollViewImage addSubview:imgView];
        
        // 取数组第一张图片 放在最后1页
        
        UIImageView *imgViewl = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth * ([imageArray count] + 1)) , 0, ScreenWidth, 150)];
        imgViewl.tag = 5 + 10000;
        
        imgViewl.userInteractionEnabled = YES;
       
       // UITapGestureRecognizer *singleTap;
        
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhoneTab:)];
        
        //单点触摸
        singleTap.numberOfTouchesRequired = 1;
        //点击几次，如果是1就是单击
        singleTap.numberOfTapsRequired = 1;
        [imgViewl addGestureRecognizer:singleTap];
        
        
         //[imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/LbFiles/tggw/%@.jpg",SERVERURL,[[imageArray objectAtIndex:0] objectForKey:@"ID"]]] placeholderImage:[UIImage imageNamed:@"loading_zc"]];
        
        [imgViewl setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/LbFiles/tggw/%@.jpg",SERVERURL,[[imageArray objectAtIndex:0] objectForKey:@"ID"]]] placeholderImage:[UIImage imageNamed:@"loading_zc"]];
        
       
        
        
        // 添加第1页在最后 循环
        [scrollViewImage addSubview:imgViewl];
        
        [scrollViewImage setContentSize:CGSizeMake(ScreenWidth * ([imageArray count] + 2), 150)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
        [scrollViewImage setContentOffset:CGPointMake(0, 0)];
        [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth,0,ScreenWidth,150) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
        
        
    } else {
        
        if (imageViewHead) {
            [imageViewHead removeFromSuperview];
        }
        
     imageViewHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        imageViewHead.image = [UIImage imageNamed:@"loading_zc"];
    [scrollViewImage addSubview:imageViewHead];
    }
    
}


- (IBAction)callPhoneTab:(UITouch *)sender
{
    
    //UIView *view = [sender view];
    NSLog(@"%ld",pageControl.currentPage);
    NSLog(@"%@",[[imageArray objectAtIndex:pageControl.currentPage] objectForKey:@"LINK_ADDR"]);
    
    if ([[imageArray objectAtIndex:pageControl.currentPage] objectForKey:@"LINK_ADDR"] != [NSNull null]) {
        if ([[[imageArray objectAtIndex:pageControl.currentPage] objectForKey:@"LINK_ADDR"] hasPrefix:@"ZC"]) {
           NSString *string = [[[imageArray objectAtIndex:pageControl.currentPage] objectForKey:@"LINK_ADDR"] substringFromIndex:3];
            
            DetailViewController *vc = [[DetailViewController alloc] init];
            vc.strId = string;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        } else {
         NSString *string = [[[imageArray objectAtIndex:pageControl.currentPage] objectForKey:@"LINK_ADDR"] substringFromIndex:3];
            MarkViewController *vc = [[MarkViewController alloc] init];
            vc.strId = string;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        
        }
        
    }

}




//请求数据方法
-(void)requestMethods {
   // [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
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
            
           
            
            /*
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
           */
            
            if (imageViewHead) {
                [imageViewHead removeFromSuperview];
            }
            
            
            [self recivedCategoryList:[responseObject objectForKey:@"object"]];
            
        } else {
            
             hasMore = YES;
            
            if (imageViewHead) {
                [imageViewHead removeFromSuperview];
            }
            imageViewHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
            imageViewHead.image = [UIImage imageNamed:@"loading_failed_zc"];
            [self.view addSubview:imageViewHead];
            
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:[responseObject objectForKey:@"msg"]
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            NSLog(@"JSON: %@", responseObject);
            NSLog(@"JSON: %@", [responseObject objectForKey:@"msg"]);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         hasMore = NO;
        
        
        if (imageViewHead) {
            [imageViewHead removeFromSuperview];
        }
        imageViewHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        imageViewHead.image = [UIImage imageNamed:@"loading_failed_zc"];
        [self.view addSubview:imageViewHead];
        
        [[HttpMethods Instance] activityIndicate:NO
                                      tipContent:notNetworkConnetTip
                                   MBProgressHUD:nil
                                          target:self.view
                                 displayInterval:3];
       
      
       
        
        
      //dataList = [UIImageView sharedImageCache];
        
        
        
        NSLog(@"Error: %@", error);
    }];
    
    
}


/*

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
 
     if(scrollView == scrollViewImage){
    
    CGFloat pagewidth = scrollViewImage.frame.size.width;
    int page = floor((scrollViewImage.contentOffset.x - pagewidth/([imageArray count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
        
        
    pageControl.currentPage = page;
    }
}


// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollV
{
    if (scrollV == scrollViewImage) {
        
    CGFloat pagewidth = scrollViewImage.frame.size.width;
    int currentPage = floor((scrollViewImage.contentOffset.x - pagewidth/ ([imageArray count]+2)) / pagewidth) + 1;
      
    if (currentPage==0)
    {
        [scrollViewImage scrollRectToVisible:CGRectMake(ScreenWidth * [imageArray count],0,ScreenWidth,150) animated:NO]; // 序号0 最后1页
    }else if (currentPage==([imageArray count] + 1))
    {
        [scrollViewImage scrollRectToVisible:CGRectMake(0,0,ScreenWidth,150) animated:NO]; // 最后+1,循环第1页
    }
       
    //pageControl.currentPage = currentPage;
   }
}

*/

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = scrollViewImage.frame.size.width;
    int page = floor((scrollViewImage.contentOffset.x - pagewidth/([imageArray count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    pageControl.currentPage = page;
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
