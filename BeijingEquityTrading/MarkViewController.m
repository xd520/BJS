//
//  MarkViewController.m
//  BeijingEquityTrading
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MarkViewController.h"
#import "AppDelegate.h"


@interface MarkViewController ()
{
    UIScrollView *scrollView;
    float addHight;
    
    NSString *timeStr;
    UILabel *timeValue;
    
    
}
@end

@implementation MarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    
    
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  addHight + 44, ScreenWidth, ScreenHeight - 49 - 20)];
    scrollView.bounces = NO;
    scrollView.backgroundColor = [ConMethods colorWithHexString:@"f7f7f5"];
    [self.view addSubview:scrollView];
    
    
    [self requestMethods];
    
    
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
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERappDetail] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self recivedList:[responseObject objectForKey:@"object"]];
            
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


- (void)timerFireMethod1:(NSTimer*)theTimer{
    
    long long timeAll = [timeStr longLongValue];
    
    //day
    long long dayCount = timeAll%(3600*24);
    long long day = (timeAll - dayCount)/(3600*24);
    
    //hour
    long long hourCount = dayCount%3600;
    long long hour = (dayCount - hourCount)/3600;
    //min
    long long minCount = hourCount%60;
    long long min = (hourCount - minCount)/60;
    
    long long miao = minCount;
   
    
    if (day > 0) {
        timeValue.text = [NSString stringWithFormat:@"%lld天%lld小时%lld分钟%lld秒",day, hour, min,miao];
    } else {
        
        if (hour > 0) {
            timeValue.text = [NSString stringWithFormat:@"%lld小时%lld分钟%lld秒", hour, min,miao];
        } else {
            if (min > 0) {
                timeValue.text = [NSString stringWithFormat:@"%lld分钟%lld秒", min,miao];
            } else {
                if (miao == 0) {
                    timeValue.text = @"0秒";
                    
                } else {
                    timeValue.text = [NSString stringWithFormat:@"%lld秒",miao];
                }
            }
        }
    }
    
}





-(void)recivedList:(NSDictionary *)dic {

    UIImageView *imagelogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenWidth)];
    imagelogo.userInteractionEnabled = YES;
    [imagelogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,[[dic objectForKey:@"detail"] objectForKey:@"F_XMLOGO"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    //背景设置：
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [ConMethods colorWithHexString:@"eeeeee" withApla:0.3];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"wks"]) {
        image.image = [UIImage imageNamed:@"即将开始"];
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 85, 14)];
        timeLab.font = [UIFont systemFontOfSize:14];
        timeLab.backgroundColor = [UIColor clearColor];
        timeLab.textColor = [UIColor whiteColor];
        timeLab.text = @"即将开拍";
        [image addSubview:timeLab];
        
        //剩余时间
        UILabel *timeValueLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, ScreenWidth - 120, 30)];
        timeValueLab.font = [UIFont systemFontOfSize:14];
        timeValueLab.backgroundColor = [UIColor clearColor];
        timeValueLab.textColor = [ConMethods colorWithHexString:@"333333"];
        timeValueLab.text = [NSString stringWithFormat:@"开始时间:%@  %@",[[dic objectForKey:@"detail"] objectForKey:@"JJKSRQ"],[[dic objectForKey:@"detail"] objectForKey:@"JJKSSJ"]];
        [backView addSubview:timeValueLab];

        
    } else if([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"jpz"]){
        image.image = [UIImage imageNamed:@"正在竞价"];
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 85, 14)];
        timeLab.font = [UIFont systemFontOfSize:14];
        timeLab.backgroundColor = [UIColor clearColor];
        timeLab.textColor = [UIColor whiteColor];
        timeLab.text = @"自由报价期";
        [image addSubview:timeLab];
        
        //剩余时间
        timeValue = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, ScreenWidth - 120, 30)];
        timeValue.font = [UIFont systemFontOfSize:14];
        timeValue.backgroundColor = [UIColor clearColor];
        timeValue.textColor = [ConMethods colorWithHexString:@"333333"];
       
        [backView addSubview:timeValue];
        timeStr = [[dic objectForKey:@"detail"] objectForKey:@"djs"];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod1:) userInfo:nil repeats:YES];
        
        
    } else {
    
        image.image = [UIImage imageNamed:@"已结束"];
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 85, 14)];
        timeLab.font = [UIFont systemFontOfSize:14];
        timeLab.backgroundColor = [UIColor clearColor];
        timeLab.textColor = [UIColor whiteColor];
        timeLab.text = @"已结束";
        [image addSubview:timeLab];

        //剩余时间
        UILabel *timeValueLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, ScreenWidth - 120, 30)];
        timeValueLab.font = [UIFont systemFontOfSize:14];
        timeValueLab.backgroundColor = [UIColor clearColor];
        timeValueLab.textColor = [ConMethods colorWithHexString:@"333333"];
        timeValueLab.text = [NSString stringWithFormat:@"开始时间:%@  %@",[[dic objectForKey:@"detail"] objectForKey:@"SJSSRQ"],[[dic objectForKey:@"detail"] objectForKey:@"SJJSSJ"]];
        [backView addSubview:timeValueLab];
        
        
    }
    
    [backView addSubview:image];
    [imagelogo addSubview:backView];
    [scrollView addSubview:imagelogo];
    
   

    
    
 //名称
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textColor = [ConMethods colorWithHexString:@"333333"];
    nameLab.text = [[dic objectForKey:@"detail"] objectForKey:@"XMMC"];
    nameLab.frame = CGRectMake(10,10 + ScreenWidth, ScreenWidth - 20 - 50, [PublicMethod getStringHeight:nameLab.text font:nameLab.font]);
    [scrollView addSubview:nameLab];
    
 //第几期
    UILabel *qiLab = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLab.frame.origin.y + nameLab.frame.size.height + 10, ScreenWidth - 70, 13)];
    qiLab.font = [UIFont systemFontOfSize:13];
    qiLab.backgroundColor = [UIColor clearColor];
    qiLab.textColor = [ConMethods colorWithHexString:@"333333"];
    qiLab.text = [[dic objectForKey:@"detail"] objectForKey:@"ZCQH"];
    [scrollView addSubview:qiLab];
    
 //标的编号
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, ScreenWidth - 120, 30)];
    numLab.font = [UIFont systemFontOfSize:14];
    numLab.backgroundColor = [UIColor clearColor];
    numLab.textColor = [ConMethods colorWithHexString:@"333333"];
    numLab.text = [NSString stringWithFormat:@"标的编号:%@",[[dic objectForKey:@"detail"] objectForKey:@"XMBH"]];
    [scrollView addSubview:numLab];

    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 61,ScreenWidth + 15, 0.5, 15)];
    img.image = [UIImage imageNamed:@"line_iocn"];
    [scrollView addSubview:img];
    
    
    if ([[[dic objectForKey:@"myFocusPrj"] objectForKey:@"FOCUS"] boolValue] == 1) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 50,ScreenWidth + 15, 30, 30)];
        img.image = [UIImage imageNamed:@"已关注"];
        [scrollView addSubview:img];
        
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 50,ScreenWidth + 50, 50, 12)];
        numLab.font = [UIFont systemFontOfSize:12];
        numLab.backgroundColor = [UIColor clearColor];
        numLab.textColor = [ConMethods colorWithHexString:@"333333"];
        numLab.text = @"已关注";
        [scrollView addSubview:numLab];
        
        
    } else {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 50,ScreenWidth + 15, 30, 30)];
        img.image = [UIImage imageNamed:@"未关注"];
        [scrollView addSubview:img];
        
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 50,ScreenWidth + 50, 50, 12)];
        numLab.font = [UIFont systemFontOfSize:12];
        numLab.backgroundColor = [UIColor clearColor];
        numLab.textColor = [ConMethods colorWithHexString:@"333333"];
        numLab.text = @"未关注";
        [scrollView addSubview:numLab];
        
    }

    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, numLab.frame.origin.y + numLab.frame.size.height + 9, ScreenWidth - 20, 1)];
    lineView1.backgroundColor = [ConMethods  colorWithHexString:@"a5a5a5"];
    [scrollView addSubview:lineView1];
    
    
    float hight;
    
    if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"wks"]) {
        
        UILabel *starLab = [[UILabel alloc] initWithFrame:CGRectMake(10, numLab.frame.origin.y + numLab.frame.size.height + 23, 50, 12)];
        starLab.font = [UIFont systemFontOfSize:12];
        starLab.backgroundColor = [UIColor clearColor];
        starLab.textColor = [ConMethods colorWithHexString:@"333333"];
        starLab.text = @"起始价:";
        [scrollView addSubview:starLab];
        
        
        UILabel *starVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, numLab.frame.origin.y + numLab.frame.size.height + 20, ScreenWidth - 70, 15)];
        starVauleLab.font = [UIFont systemFontOfSize:15];
        starVauleLab.backgroundColor = [UIColor clearColor];
        starVauleLab.textColor = [ConMethods colorWithHexString:@"333333"];
        starVauleLab.text = [NSString stringWithFormat:@"￥%@",[[dic objectForKey:@"detail"] objectForKey:@"QPJ"]];
        [scrollView addSubview:starVauleLab];
        
 //保证金
        UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectMake(10, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, 50, 12)];
        sureLab.font = [UIFont systemFontOfSize:12];
        sureLab.backgroundColor = [UIColor clearColor];
        sureLab.textColor = [ConMethods colorWithHexString:@"333333"];
        sureLab.text = @"保证金:";
        [scrollView addSubview:sureLab];
        
        NSMutableArray *arr = [[dic objectForKey:@"bzjInfoPageResult"] objectForKey:@"object"];
        
        
        UILabel *sureVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, ScreenWidth - 70, 15)];
        sureVauleLab.font = [UIFont systemFontOfSize:15];
        sureVauleLab.backgroundColor = [UIColor clearColor];
        sureVauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
        sureVauleLab.text = [NSString stringWithFormat:@"￥%@%@",[[arr objectAtIndex:0] objectForKey:@"BZJJE"],[[arr objectAtIndex:0] objectForKey:@"TCMC"]];
        [scrollView addSubview:sureVauleLab];
        
        hight = sureVauleLab.frame.origin.y + sureVauleLab.frame.size.height;
        
    } else if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"jpz"]){
        UILabel *newLab = [[UILabel alloc] initWithFrame:CGRectMake(10, numLab.frame.origin.y + numLab.frame.size.height + 23, 50, 12)];
        newLab.font = [UIFont systemFontOfSize:12];
        newLab.backgroundColor = [UIColor clearColor];
        newLab.textColor = [ConMethods colorWithHexString:@"333333"];
        newLab.text = @"当前价:";
        [scrollView addSubview:newLab];
        
        
        UILabel *newVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, numLab.frame.origin.y + numLab.frame.size.height + 20, ScreenWidth - 70, 15)];
        newVauleLab.font = [UIFont systemFontOfSize:15];
        newVauleLab.backgroundColor = [UIColor clearColor];
        newVauleLab.textColor = [ConMethods colorWithHexString:@"333333"];
        newVauleLab.text = [NSString stringWithFormat:@"￥%@",[[dic objectForKey:@"detail"] objectForKey:@"ZXJG"]];
        [scrollView addSubview:newVauleLab];

    
        UILabel *starLab = [[UILabel alloc] initWithFrame:CGRectMake(10, newVauleLab.frame.origin.y + newVauleLab.frame.size.height + 10, 50, 12)];
        starLab.font = [UIFont systemFontOfSize:12];
        starLab.backgroundColor = [UIColor clearColor];
        starLab.textColor = [ConMethods colorWithHexString:@"333333"];
        starLab.text = @"起始价:";
        [scrollView addSubview:starLab];
        
        
        UILabel *starVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, newVauleLab.frame.origin.y + newVauleLab.frame.size.height + 10, ScreenWidth/2 - 60, 12)];
        starVauleLab.font = [UIFont systemFontOfSize:12];
        starVauleLab.backgroundColor = [UIColor clearColor];
        starVauleLab.textColor = [ConMethods colorWithHexString:@"333333"];
        starVauleLab.text = [NSString stringWithFormat:@"￥%@",[[dic objectForKey:@"detail"] objectForKey:@"QPJ"]];
        [scrollView addSubview:starVauleLab];

 //溢价率
        UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2 + 10, newVauleLab.frame.origin.y + newVauleLab.frame.size.height + 10, 50, 12)];
        priceLab.font = [UIFont systemFontOfSize:12];
        priceLab.backgroundColor = [UIColor clearColor];
        priceLab.textColor = [ConMethods colorWithHexString:@"333333"];
        priceLab.text = @"溢价率:";
        [scrollView addSubview:priceLab];
        
        
        UILabel *priceVauleLab = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/2 + 60, newVauleLab.frame.origin.y + newVauleLab.frame.size.height + 10, ScreenWidth/2 - 70, 12)];
        priceVauleLab.font = [UIFont systemFontOfSize:12];
        priceVauleLab.backgroundColor = [UIColor clearColor];
        priceVauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
        priceVauleLab.text = [[dic objectForKey:@"detail"] objectForKey:@"YJL"];
        [scrollView addSubview:priceVauleLab];
        
        
        //保证金
        UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectMake(10, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, 50, 12)];
        sureLab.font = [UIFont systemFontOfSize:12];
        sureLab.backgroundColor = [UIColor clearColor];
        sureLab.textColor = [ConMethods colorWithHexString:@"333333"];
        sureLab.text = @"保证金:";
        [scrollView addSubview:sureLab];
        
        
        UILabel *sureVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, ScreenWidth - 70, 15)];
        sureVauleLab.font = [UIFont systemFontOfSize:15];
        sureVauleLab.backgroundColor = [UIColor clearColor];
        sureVauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
        sureVauleLab.text = [NSString stringWithFormat:@"￥%@%@",[[[dic objectForKey:@"bzjInfoPageResult"] objectForKey:@"object"] objectForKey:@"BZJJE"],[[[dic objectForKey:@"bzjInfoPageResult"] objectForKey:@"object"] objectForKey:@"TCMC"]];
        [scrollView addSubview:sureVauleLab];
        
        hight = sureVauleLab.frame.origin.y + sureVauleLab.frame.size.height;
        
        
    
    } else if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"lp"]){
        UILabel *starVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, numLab.frame.origin.y + numLab.frame.size.height + 20, ScreenWidth - 20, 15)];
        starVauleLab.font = [UIFont systemFontOfSize:15];
        starVauleLab.backgroundColor = [UIColor clearColor];
        starVauleLab.text = @"标的已流标，无人报价！";
        [scrollView addSubview:starVauleLab];
        
        //起始价
        UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectMake(10, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, 50, 12)];
        sureLab.font = [UIFont systemFontOfSize:12];
        sureLab.backgroundColor = [UIColor clearColor];
        sureLab.textColor = [ConMethods colorWithHexString:@"333333"];
        sureLab.text = @"起始价:";
        [scrollView addSubview:sureLab];
        
        
        UILabel *sureVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, ScreenWidth - 70, 15)];
        sureVauleLab.font = [UIFont systemFontOfSize:15];
        sureVauleLab.backgroundColor = [UIColor clearColor];
        sureVauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
        sureVauleLab.text = [NSString stringWithFormat:@"￥%@",[[dic objectForKey:@"detail"] objectForKey:@"QPJ"]];
        [scrollView addSubview:sureVauleLab];
        
        hight = sureVauleLab.frame.origin.y + sureVauleLab.frame.size.height;
        
        
    } else  {
        
        UILabel *starVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, numLab.frame.origin.y + numLab.frame.size.height + 20, ScreenWidth - 20, 15)];
        starVauleLab.font = [UIFont systemFontOfSize:15];
        starVauleLab.backgroundColor = [UIColor clearColor];

        if ([[[dic objectForKey:@"user"] objectForKey:@"isCybj"] boolValue] == 1) {
            if ([[[dic objectForKey:@"user"] objectForKey:@"isZgbjr"] boolValue] == 1) {
              starVauleLab.text = @"恭喜您成为最高报价方！";
            starVauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
            } else {
            starVauleLab.text = @"感谢您的参与，标的竞价结束。";
            
            }
        } else {
            
           starVauleLab.text = @"标的竞价结束。";
        }
        
       
        [scrollView addSubview:starVauleLab];

    
        //起始价
        UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectMake(10, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, 85, 12)];
        sureLab.font = [UIFont systemFontOfSize:12];
        sureLab.backgroundColor = [UIColor clearColor];
        sureLab.textColor = [ConMethods colorWithHexString:@"333333"];
        sureLab.text = @"最高报价金额:";
        [scrollView addSubview:sureLab];
        
        
        UILabel *sureVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(95, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, ScreenWidth - 70, 15)];
        sureVauleLab.font = [UIFont systemFontOfSize:15];
        sureVauleLab.backgroundColor = [UIColor clearColor];
        sureVauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
        sureVauleLab.text = [NSString stringWithFormat:@"￥%@",[[dic objectForKey:@"detail"] objectForKey:@"ZGCJJ"]];
        [scrollView addSubview:sureVauleLab];
        
        
        hight = sureVauleLab.frame.origin.y + sureVauleLab.frame.size.height;
        
 //点击付款
        if ([[[dic objectForKey:@"user"] objectForKey:@"isZgbjr"] boolValue] == 1) {
            
            UIButton *fukuanBtn = [[UIButton alloc] initWithFrame:CGRectMake(sureVauleLab.frame.origin.x + sureVauleLab.frame.size.height + 10,  starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10 - 5, 80, 20)];
            fukuanBtn.layer.borderWidth = 1;
            fukuanBtn.layer.borderColor = [ConMethods colorWithHexString:@"eeeeee"].CGColor;
            fukuanBtn.titleLabel.text = @"确认付款";
            fukuanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [fukuanBtn addTarget:self action:@selector(payMehtods:) forControlEvents:UIControlEventTouchUpInside];
            
            [scrollView addSubview:fukuanBtn];
        }
        
    }
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, hight + 10, ScreenWidth - 20, 1)];
    lineView2.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [scrollView addSubview:lineView2];
//加价幅度  服务费  限时报价期
   
    UILabel *addLab = [[UILabel alloc] initWithFrame:CGRectMake(95, lineView2.frame.origin.y + lineView2.frame.size.height + 10, ScreenWidth - 70, 12)];
    addLab.font = [UIFont systemFontOfSize:12];
    addLab.backgroundColor = [UIColor clearColor];
    addLab.textColor = [ConMethods colorWithHexString:@"666666"];
    addLab.text = [NSString stringWithFormat:@"加价幅:￥%.2f",[[[dic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]];
    [scrollView addSubview:addLab];

    UILabel *serviceLab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 80)/2, lineView2.frame.origin.y + lineView2.frame.size.height + 10, 80, 12)];
    serviceLab.font = [UIFont systemFontOfSize:12];
    serviceLab.backgroundColor = [UIColor clearColor];
    serviceLab.textAlignment = NSTextAlignmentCenter;
    serviceLab.textColor = [ConMethods colorWithHexString:@"666666"];
   // serviceLab.text = [NSString stringWithFormat:@"服务费:￥%.2f",[[[dic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]];
     serviceLab.text = [NSString stringWithFormat:@"服务费:5%"];
    [scrollView addSubview:addLab];

    
    UILabel *xianLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 120, lineView2.frame.origin.y + lineView2.frame.size.height + 10, 110, 12)];
    xianLab.font = [UIFont systemFontOfSize:12];
    xianLab.backgroundColor = [UIColor clearColor];
    xianLab.textColor = [ConMethods colorWithHexString:@"666666"];
    xianLab.textAlignment = NSTextAlignmentRight;
    xianLab.text = [NSString stringWithFormat:@"限时报价期:%@秒",[[dic objectForKey:@"detail"] objectForKey:@"ZBSC"]];
    [scrollView addSubview:xianLab];

    
    
//自由报价开始时间:
    
    
    UILabel *starTipLab = [[UILabel alloc] initWithFrame:CGRectMake(10, addLab.frame.origin.y + addLab.frame.size.height + 10, ScreenWidth - 20, 12)];
    starTipLab.font = [UIFont systemFontOfSize:12];
    starTipLab.backgroundColor = [UIColor clearColor];
    starTipLab.textColor = [ConMethods colorWithHexString:@"666666"];
    starTipLab.text = [NSString stringWithFormat:@"自由报价开始时间:%@",[[dic objectForKey:@"detail"] objectForKey:@"ZYBJKSSJ"]];
    [scrollView addSubview:starTipLab];
    
    
//限时报价开始时间:
   
    UILabel *xianTipLab = [[UILabel alloc] initWithFrame:CGRectMake(10, starTipLab.frame.origin.y + starTipLab.frame.size.height + 10, ScreenWidth - 20, 12)];
    xianTipLab.font = [UIFont systemFontOfSize:12];
    xianTipLab.backgroundColor = [UIColor clearColor];
    xianTipLab.textColor = [ConMethods colorWithHexString:@"666666"];
    xianTipLab.text = [NSString stringWithFormat:@"自由报价开始时间:%@",[[dic objectForKey:@"detail"] objectForKey:@"XSBJKSSJ"]];
    [scrollView addSubview:xianTipLab];
    
    
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0,xianTipLab.frame.origin.y + xianTipLab.frame.size.height + 10, ScreenWidth , 1)];
    lineView3.backgroundColor = [ConMethods colorWithHexString:@"eeeeee"];
    [scrollView addSubview:lineView3];
    
 //标的描述
    
    
    
    
    
}

-(void)payMehtods:(UIButton *)btn {



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

- (IBAction)shareMethods:(id)sender {
}
@end
