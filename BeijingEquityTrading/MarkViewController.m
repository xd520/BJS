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
    
   // NSString *timeStr;
    UILabel *timeValue;
    
    UIView *MyBackView;
    NSDictionary *myDic;
    UILabel *numLabTip;
    
    long long timeAll;
    
    UIButton *commitBtn;
    
    UIImageView *summitBackImg;
   UITextField *sureText;
    
    
}
@end

@implementation MarkViewController

#pragma mark - 进入后刷新
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self isGetPriceAndSure];

}




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
    scrollView.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
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
    
    timeAll = timeAll - 1;
    
    
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


#pragma mark - FoucsOn
-(void)foucsMehtods:(UIButton *)btn{
    if (btn.tag == 101) {//关注
       [btn setImage:[UIImage imageNamed:@"未关注"] forState:UIControlStateNormal];
         numLabTip.text = @"未关注";
        btn.tag = 102;
    } else {
    
    [btn setImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
     numLabTip.text = @"已关注";
     btn.tag = 101;
    
    }

}


#pragma mark - initWitUIData

-(void)recivedList:(NSDictionary *)dic {
    
    myDic = dic;
    
     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIImageView *imagelogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenWidth)];
    imagelogo.userInteractionEnabled = YES;
    [imagelogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,[[dic objectForKey:@"detail"] objectForKey:@"F_XMLOGO"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    //背景设置：
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth, 30)];
    backView.backgroundColor = [ConMethods colorWithHexString:@"ffffff" withApla:0.8];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"wks"]) {
        image.image = [UIImage imageNamed:@"即将开始"];
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 85, 14)];
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
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 85, 14)];
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
        timeAll = [[[dic objectForKey:@"detail"] objectForKey:@"djs"] longLongValue];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod1:) userInfo:nil repeats:YES];
        
        
    } else {
    
        image.image = [UIImage imageNamed:@"已结束"];
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 85, 14)];
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
    [self.view addSubview:backView];
    [scrollView addSubview:imagelogo];
    
   

    
    
 //名称
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.font = [UIFont systemFontOfSize:15];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textColor = [ConMethods colorWithHexString:@"666666"];
    nameLab.text = [[dic objectForKey:@"detail"] objectForKey:@"XMMC"];
    nameLab.frame = CGRectMake(10,10 + ScreenWidth, ScreenWidth - 20 - 50, [PublicMethod getStringHeight:nameLab.text font:nameLab.font]);
    [scrollView addSubview:nameLab];
    
 //第几期
    UILabel *qiLab = [[UILabel alloc] initWithFrame:CGRectMake(10, nameLab.frame.origin.y + nameLab.frame.size.height + 10, ScreenWidth - 70, 13)];
    qiLab.font = [UIFont systemFontOfSize:13];
    qiLab.backgroundColor = [UIColor clearColor];
    qiLab.textColor = [ConMethods colorWithHexString:@"c8c8ca"];
    qiLab.text = [[dic objectForKey:@"zcxx"] objectForKey:@"ZCQH"];
    [scrollView addSubview:qiLab];
    
 //标的编号
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(10, qiLab.frame.size.height + qiLab.frame.origin.y + 10, ScreenWidth - 20, 14)];
    numLab.font = [UIFont systemFontOfSize:14];
    numLab.backgroundColor = [UIColor clearColor];
    numLab.textColor = [ConMethods colorWithHexString:@"808080"];
    numLab.text = [NSString stringWithFormat:@"标的编号:%@",[[dic objectForKey:@"detail"] objectForKey:@"XMBH"]];
    [scrollView addSubview:numLab];

    UIView *img = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 61,ScreenWidth + 15, 1, 50)];
    img.backgroundColor = [ConMethods colorWithHexString:@"d9d9da"];
    [scrollView addSubview:img];
    
    
    if ([[[dic objectForKey:@"myFocusPrj"] objectForKey:@"FOCUS"] boolValue] == 1) {
        
        UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        focusBtn.frame = CGRectMake(ScreenWidth - 50,ScreenWidth + 15, 30, 30);
        [focusBtn setImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
        focusBtn.tag = 101;
        [focusBtn addTarget:self action:@selector(foucsMehtods:) forControlEvents:UIControlEventTouchUpInside];
        
       // UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 50,ScreenWidth + 15, 30, 30)];
       // img.image = [UIImage imageNamed:@"已关注"];
        [scrollView addSubview:focusBtn];
        
        numLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 50,ScreenWidth + 50, 50, 12)];
        numLabTip.font = [UIFont systemFontOfSize:12];
        numLabTip.backgroundColor = [UIColor clearColor];
        numLabTip.textColor = [ConMethods colorWithHexString:@"333333"];
        numLabTip.text = @"已关注";
        [scrollView addSubview:numLabTip];
        
        
    } else {
        
        UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        focusBtn.frame = CGRectMake(ScreenWidth - 50,ScreenWidth + 15, 30, 30);
        [focusBtn setImage:[UIImage imageNamed:@"未关注"] forState:UIControlStateNormal];
        focusBtn.tag = 102;
        [focusBtn addTarget:self action:@selector(foucsMehtods:) forControlEvents:UIControlEventTouchUpInside];
 
        [scrollView addSubview:focusBtn];
        
        numLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 50,ScreenWidth + 50, 50, 12)];
        numLabTip.font = [UIFont systemFontOfSize:12];
        numLabTip.backgroundColor = [UIColor clearColor];
        numLabTip.textColor = [ConMethods colorWithHexString:@"333333"];
        numLabTip.text = @"未关注";
        [scrollView addSubview:numLabTip];
        
    }

    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, numLab.frame.origin.y + numLab.frame.size.height + 9, ScreenWidth - 20, 1)];
    lineView1.backgroundColor = [ConMethods  colorWithHexString:@"f1f1f1"];
    [scrollView addSubview:lineView1];
    
    
    float hight;
    
    if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"wks"]) {
        
        UILabel *starLab = [[UILabel alloc] initWithFrame:CGRectMake(10, numLab.frame.origin.y + numLab.frame.size.height + 23, 50, 12)];
        starLab.font = [UIFont systemFontOfSize:12];
        starLab.backgroundColor = [UIColor clearColor];
        starLab.textColor = [ConMethods colorWithHexString:@"716f70"];
        starLab.text = @"起始价:";
        [scrollView addSubview:starLab];
        
        
        UILabel *starVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, numLab.frame.origin.y + numLab.frame.size.height + 20, ScreenWidth - 70, 15)];
        starVauleLab.font = [UIFont systemFontOfSize:15];
        starVauleLab.backgroundColor = [UIColor clearColor];
        starVauleLab.textColor = [ConMethods colorWithHexString:@"333333"];
        starVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue]]]];
        [scrollView addSubview:starVauleLab];
        
 //保证金
        UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectMake(10, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, 50, 12)];
        sureLab.font = [UIFont systemFontOfSize:12];
        sureLab.backgroundColor = [UIColor clearColor];
        sureLab.textColor = [ConMethods colorWithHexString:@"716f70"];
        sureLab.text = @"保证金:";
        [scrollView addSubview:sureLab];
        
        NSMutableArray *arr = [[dic objectForKey:@"bzjInfoPageResult"] objectForKey:@"object"];
        
        
        UILabel *sureVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, ScreenWidth - 70, 15)];
        sureVauleLab.font = [UIFont systemFontOfSize:15];
        sureVauleLab.backgroundColor = [UIColor clearColor];
        sureVauleLab.textColor = [ConMethods colorWithHexString:@"ae4a5d"];
        sureVauleLab.text = [NSString stringWithFormat:@"￥%@(%@)",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[arr objectAtIndex:0] objectForKey:@"BZJJE"] floatValue]]],[[arr objectAtIndex:0] objectForKey:@"TCMC"]];
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
        newVauleLab.textColor = [ConMethods colorWithHexString:@"716f70"];
        newVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dic objectForKey:@"detail"] objectForKey:@"ZXJG"] floatValue]]]];
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
        starVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue]]]];
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
        
         NSMutableArray *arr = [[dic objectForKey:@"bzjInfoPageResult"] objectForKey:@"object"];
        
        
        UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectMake(10, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, 50, 12)];
        sureLab.font = [UIFont systemFontOfSize:12];
        sureLab.backgroundColor = [UIColor clearColor];
        sureLab.textColor = [ConMethods colorWithHexString:@"716f70"];
        sureLab.text = @"保证金:";
        [scrollView addSubview:sureLab];
        
        
        UILabel *sureVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, ScreenWidth - 70, 15)];
        sureVauleLab.font = [UIFont systemFontOfSize:15];
        sureVauleLab.backgroundColor = [UIColor clearColor];
        sureVauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
        sureVauleLab.text = [NSString stringWithFormat:@"￥%@(%@)",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[arr objectAtIndex:0] objectForKey:@"BZJJE"] floatValue]]],[[arr objectAtIndex:0] objectForKey:@"TCMC"]];
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
        sureLab.textColor = [ConMethods colorWithHexString:@"716f70"];
        sureLab.text = @"起始价:";
        [scrollView addSubview:sureLab];
        
        
        UILabel *sureVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, starVauleLab.frame.origin.y + starVauleLab.frame.size.height + 10, ScreenWidth - 70, 15)];
        sureVauleLab.font = [UIFont systemFontOfSize:15];
        sureVauleLab.backgroundColor = [UIColor clearColor];
        sureVauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
        sureVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[dic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue]]]];
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
        sureLab.textColor = [ConMethods colorWithHexString:@"716f70"];
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
    lineView2.backgroundColor = [ConMethods colorWithHexString:@"f1f1f1"];
    [scrollView addSubview:lineView2];
//加价幅度  服务费  限时报价期
   
    UILabel *addLab = [[UILabel alloc] initWithFrame:CGRectMake(10, lineView2.frame.origin.y + lineView2.frame.size.height + 10, ScreenWidth - 70, 12)];
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
    serviceLab.text = [NSString stringWithFormat:@"服务费:%@",[[dic objectForKey:@"detail"] objectForKey:@"FWF_BL_SRF"]];
    [scrollView addSubview:serviceLab];

    
    UILabel *xianLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 120, lineView2.frame.origin.y + lineView2.frame.size.height + 10, 110, 12)];
    xianLab.font = [UIFont systemFontOfSize:12];
    xianLab.backgroundColor = [UIColor clearColor];
    xianLab.textColor = [ConMethods colorWithHexString:@"666666"];
    xianLab.textAlignment = NSTextAlignmentRight;
    xianLab.text = [NSString stringWithFormat:@"限时报价期:%@秒",[[dic objectForKey:@"detail"] objectForKey:@"YSBJSC"]];
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
    lineView3.backgroundColor = [ConMethods colorWithHexString:@"d5d5d5"];
    [scrollView addSubview:lineView3];
    
 //标的描述
    UIButton *decBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    decBtn.frame = CGRectMake(0, lineView3.frame.origin.y + lineView3.frame.size.height, ScreenWidth, 35);
    UILabel *decLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 15)];
    decLab.text = @"标的描述";
    decLab.textColor = [ConMethods colorWithHexString:@"3e3e3e"];
    decLab.font = [UIFont systemFontOfSize:15];
    [decBtn addSubview:decLab];
    
    UIImageView *fangImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 2.5, 20, 30)];
    fangImg.image = [UIImage imageNamed:@"next"];
    [decBtn addSubview:fangImg];
    
    decBtn.tag = 10001;
    
    [decBtn addTarget:self action:@selector(pushDec:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:decBtn];
    
 //报价记录
    
    
    UIButton *baoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    baoBtn.frame = CGRectMake(0, decBtn.frame.origin.y + decBtn.frame.size.height, ScreenWidth, 35);
    baoBtn.backgroundColor = [ConMethods colorWithHexString:@"f8f8f8"];
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth , 1)];
    lineView4.backgroundColor = [ConMethods colorWithHexString:@"d5d5d5"];
    [baoBtn addSubview:lineView4];
    
    
    
    UILabel *baoLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 15)];
    baoLab.text = @"报价记录";
    baoLab.textColor = [ConMethods colorWithHexString:@"3e3e3e"];
    baoLab.font = [UIFont systemFontOfSize:15];
    [baoBtn addSubview:baoLab];
    
    UIImageView *baoImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 2.5, 20, 30)];
    baoImg.image = [UIImage imageNamed:@"next"];
    [baoBtn addSubview:baoImg];
    
    //[baoBtn setBackgroundImage:[UIImage imageNamed:@"详情页按钮阴影底边"] forState:UIControlStateNormal];
    
    UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(0,34, ScreenWidth , 1)];
    lineView5.backgroundColor = [ConMethods colorWithHexString:@"d5d5d5"];
    [baoBtn addSubview:lineView5];
    
    
    
    baoBtn.tag = 10002;
    [baoBtn addTarget:self action:@selector(pushDec:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:baoBtn];
    
 // 交纳保证金
    
  
    
    
     if ([[[dic objectForKey:@"bzjInfo"] objectForKey:@"isSubmitBzj"] boolValue] == NO) {
    
         UILabel *baoLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 30 - 100, 10, 100, 12)];
         baoLab.text = @"提交保证金后查看";
         baoLab.textColor = [ConMethods colorWithHexString:@"8e8d8e"];
         baoLab.font = [UIFont systemFontOfSize:12];
         [baoBtn addSubview:baoLab];
         
         
         
         UIImageView *endViewImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,  ScreenHeight - 75, ScreenWidth, 75)];
         endViewImg.image = [UIImage imageNamed:@"详情页按钮阴影底边"];
         
         
         commitBtn = [[UIButton alloc] initWithFrame: CGRectMake(40, 30, ScreenWidth - 80, 35)];
         
         commitBtn.layer.masksToBounds = YES;
         commitBtn.layer.cornerRadius = 4;
         commitBtn.backgroundColor = [ConMethods colorWithHexString:@"850301"];
         
         [commitBtn setTitle:@"交纳保证金" forState:UIControlStateNormal];
         [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         
         commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
         commitBtn.tag = 10003;
         [commitBtn addTarget:self action:@selector(pushDec:) forControlEvents:UIControlEventTouchUpInside];
         endViewImg.userInteractionEnabled = YES;
         [endViewImg addSubview:commitBtn];
         [self.view addSubview:endViewImg];
         
         
         
         
    
     } else {
         
         UIImageView *endViewImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,  ScreenHeight - 75 , ScreenWidth, 75)];
         endViewImg.image = [UIImage imageNamed:@"详情页按钮阴影底边"];
         
             commitBtn = [[UIButton alloc] initWithFrame: CGRectMake(40, 30, ScreenWidth - 80, 35)];
             commitBtn.layer.masksToBounds = YES;
             commitBtn.layer.cornerRadius = 4;
             commitBtn.backgroundColor = [ConMethods colorWithHexString:@"850301"];
         
         if ([[delegate.loginUser objectForKey:@"success"] boolValue] == YES) {
             commitBtn.tag = 10003;
             [commitBtn setTitle:@"交纳保证金" forState:UIControlStateNormal];
         } else {
         
             commitBtn.tag = 10004;
             [commitBtn setTitle:@"报价" forState:UIControlStateNormal];
         }
             [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
             
             commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
             
             [commitBtn addTarget:self action:@selector(pushDec:) forControlEvents:UIControlEventTouchUpInside];
             endViewImg.userInteractionEnabled = YES;
             [endViewImg addSubview:commitBtn];
             
             [self.view addSubview:endViewImg];
         
     }
    
    
    
    [scrollView setContentSize:CGSizeMake(ScreenWidth, baoBtn.frame.origin.y + baoBtn.frame.size.height + 55)];
    
}

#pragma mark - 判断是否登录的时候 为报价还是交纳保证金

-(void)isGetPriceAndSure {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if ([[delegate.loginUser objectForKey:@"success"] boolValue] == YES) {
        commitBtn.tag = 10003;
        [commitBtn setTitle:@"交纳保证金" forState:UIControlStateNormal];
    } else {
        
        commitBtn.tag = 10004;
        [commitBtn setTitle:@"报价" forState:UIControlStateNormal];
    }


}


#pragma mark - 是否同意协议按钮

-(void)selectMethods:(UIButton *)btn{



}


#pragma mark - 提交保证金按钮

-(void)pushDec:(UIButton *)btn {
    
    if (btn.tag == 10001) {
       
    } else if (btn.tag == 10002) {
    
    
    } else if(btn.tag == 10003){//保证金
    
     [self initBackViewMehtods];
    
    } else if(btn.tag == 10004){//报价
    
        [self summitBackViewMehtods];
    
    } else if(btn.tag == 10005){
        
        [MyBackView removeFromSuperview];
    } else if(btn.tag == 10006){
        
        [MyBackView removeFromSuperview];
    }
    
}

#pragma mark - 从保证金到 报价的时候报价记录 frame的变化



#pragma mark - 提交报价按钮弹窗
-(void)summitBackViewMehtods {
    summitBackImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 170, ScreenWidth, 170)];
    summitBackImg.image = [UIImage imageNamed:@"详情页按钮阴影底边"];
    summitBackImg.userInteractionEnabled = YES;
    
    NSArray *arr = @[@"+100",@"+200",@"+300"];
    
    for (int i = 0; i < 3; i++) {
        
    
    UILabel *starLabel1 = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 260)/2 + 90*i,50, 80, 30)];
    starLabel1.font = [UIFont systemFontOfSize:14];
    starLabel1.text = [arr objectAtIndex:i];
        starLabel1.backgroundColor = [ConMethods colorWithHexString:@"f9f9f9"];
    starLabel1.textColor = [ConMethods colorWithHexString:@"c2ae7f"];
    starLabel1.textAlignment = NSTextAlignmentCenter;
    starLabel1.layer.cornerRadius = 2;
    starLabel1.layer.masksToBounds = YES;
    starLabel1.layer.borderWidth = 1;
    starLabel1.layer.borderColor = [ConMethods colorWithHexString:@"c7c7c7"].CGColor;
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    starLabel1.tag = i;
        //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
        //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    [starLabel1 addGestureRecognizer:singleTap1];
        
    [summitBackImg addSubview:starLabel1];
    
    }
    
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(70, 85, ScreenWidth - 140, 35)];
    btnView.layer.cornerRadius = 4;
    btnView.layer.borderWidth = 1;
    btnView.layer.borderColor = [ConMethods colorWithHexString:@"cbcbcb"].CGColor;
    btnView.layer.masksToBounds = YES;
    
   UIButton *jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jianBtn.frame = CGRectMake(5, 5, 25, 25);
    [jianBtn setTitle:@"-" forState:UIControlStateNormal];
    [jianBtn setTitleColor:[ConMethods colorWithHexString:@"959595"] forState:UIControlStateNormal];
    jianBtn.tag = 10001;
    //[jianBtn setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
    
    [jianBtn addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:jianBtn];
    
  UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(ScreenWidth - 140 - 30, 5, 25, 25);
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[ConMethods colorWithHexString:@"850301"] forState:UIControlStateNormal];
     addBtn.tag = 10002;
    [addBtn addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:addBtn];
    
    sureText = [[UITextField alloc] initWithFrame:CGRectMake(35, 0, ScreenWidth - 140 - 70, 35)];
    sureText.backgroundColor = [UIColor whiteColor];
    sureText.placeholder = @"输入转让数量";
   // sureText.text = [NSString stringWithFormat:@"%.2f",[[_dic objectForKey:@"kmcsl_sl"] floatValue]];
    
    sureText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sureText.clearButtonMode = UITextFieldViewModeWhileEditing;
    sureText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    sureText.font = [UIFont systemFontOfSize:15];
    
    sureText.delegate = self;
    
    [btnView addSubview:sureText];
    
    [summitBackImg addSubview:btnView];
    
   UIButton *commit = [[UIButton alloc] initWithFrame: CGRectMake(40, 125, ScreenWidth - 80, 35)];
    
    commit.layer.masksToBounds = YES;
    commit.layer.cornerRadius = 4;
    commit.backgroundColor = [ConMethods colorWithHexString:@"850301"];
    
    [commit setTitle:@"报价" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    commit.titleLabel.font = [UIFont systemFontOfSize:15];
    commit.tag = 10003;
    [commit addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
    
    [summitBackImg addSubview:commit];

    [self.view addSubview:summitBackImg];

}

#pragma mark - 提交报价按钮

- (IBAction)summitBtnMethods:(UIButton *)btn {
    if (btn.tag == 10001) {
        
    } else if (btn.tag == 10002){
    
    
    
    } else if (btn.tag == 10003){
        
        [summitBackImg removeFromSuperview];
        
    }

}


- (IBAction)callPhone:(UITouch *)sender
{
    
    UIView *view = [sender view];
    if (view.tag == 0) {

    }
}

#pragma mark - 提交保证金弹窗
-(void)initBackViewMehtods {
    if (MyBackView) {
        [MyBackView removeFromSuperview];
    }
    
    
        MyBackView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        MyBackView.backgroundColor = [ConMethods colorWithHexString:@"bfbfbf" withApla:0.8];
        MyBackView.layer.masksToBounds = YES;
        MyBackView.layer.cornerRadius = 4;
        
        UIView *litleView = [[UIView alloc] initWithFrame:CGRectMake(20, (ScreenHeight - 200)/2, ScreenWidth - 40, 200)];
        litleView.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
        
          NSMutableArray *arr = [[myDic objectForKey:@"bzjInfoPageResult"] objectForKey:@"object"];
        
        float lengh = [PublicMethod getStringWidth:[NSString stringWithFormat:@"交纳￥%@保证金",[[arr objectAtIndex:0] objectForKey:@"BZJJE"]] font:[UIFont systemFontOfSize:15]];
        
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 40 - lengh)/2, 50, 30, 15)];
        nameLab.text = @"交纳";
        nameLab.textColor = [ConMethods colorWithHexString:@"333333"];
        nameLab.font = [UIFont systemFontOfSize:15];
        [litleView addSubview:nameLab];
        
        
        UILabel *vauleLab = [[UILabel alloc] init];
        vauleLab.text = [NSString stringWithFormat:@"￥%@",[[arr objectAtIndex:0] objectForKey:@"BZJJE"]];
        vauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
        vauleLab.font = [UIFont systemFontOfSize:15];
        vauleLab.frame = CGRectMake((ScreenWidth - 40 - lengh)/2 + 30, 50, [PublicMethod getStringWidth:vauleLab.text font:vauleLab.font], 15);
        [litleView addSubview:vauleLab];
        
        UILabel *nameLabTip = [[UILabel alloc] initWithFrame:CGRectMake(vauleLab.frame.origin.x + vauleLab.frame.size.width, 50, 45, 15)];
        nameLabTip.text = @"保证金";
        nameLabTip.textColor = [ConMethods colorWithHexString:@"333333"];
        nameLabTip.font = [UIFont systemFontOfSize:15];
        [litleView addSubview:nameLabTip];
        
        
        
        
        UILabel *vauleLabTip = [[UILabel alloc] init];
        vauleLabTip.text = [[arr objectAtIndex:0] objectForKey:@"TCMC"];
        vauleLabTip.textColor = [ConMethods colorWithHexString:@"bd0100"];
        vauleLabTip.font = [UIFont systemFontOfSize:15];
        vauleLabTip.frame = CGRectMake(10, 75, ScreenWidth - 60, 15);
        vauleLabTip.textAlignment = NSTextAlignmentCenter;
        [litleView addSubview:vauleLabTip];
        
        
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 97.5, 15, 15)];
        [selectBtn setImage:[UIImage imageNamed:@"select0"] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectMethods:) forControlEvents:UIControlEventTouchUpInside];
        selectBtn.tag = 100;
        [litleView addSubview:selectBtn];
        
        UILabel *agreeTip = [[UILabel alloc] initWithFrame:CGRectMake(25, 100, 30, 10)];
        agreeTip.text = @"我同意";
        agreeTip.textColor = [ConMethods colorWithHexString:@"333333"];
        agreeTip.font = [UIFont systemFontOfSize:10];
        [litleView addSubview:agreeTip];
        
        
        UILabel *agreeUserTip = [[UILabel alloc] initWithFrame:CGRectMake(55, 100, 60, 10)];
        agreeUserTip.text = @"用户竞价协议";
        agreeUserTip.textColor = [ConMethods colorWithHexString:@"bd0100"];
        agreeUserTip.font = [UIFont systemFontOfSize:10];
        [litleView addSubview:agreeUserTip];
        
        
        UILabel *agree = [[UILabel alloc] init];
        agree.text = @",并且理解了";
        agree.textColor = [ConMethods colorWithHexString:@"333333"];
        agree.font = [UIFont systemFontOfSize:10];
        agree.frame = CGRectMake(115, 100, [PublicMethod getStringWidth:agree.text font:agree.font], 10);
        [litleView addSubview:agree];
        
        
        UILabel *agreeUser = [[UILabel alloc] init];
        agreeUser.text = @"《保证金详细规则》";
        agreeUser.textColor = [ConMethods colorWithHexString:@"bd0100"];
        agreeUser.font = [UIFont systemFontOfSize:10];
        agreeUser.frame = CGRectMake(agree.frame.origin.x + agree.frame.size.width , 100, [PublicMethod getStringWidth:agreeUser.text font:agreeUser.font], 10);
        
        [litleView addSubview:agreeUser];
        
  //确定 取消
        UIButton *commitB = [[UIButton alloc] initWithFrame: CGRectMake((ScreenWidth - 40)/2 - 95, 130, 80, 30)];
        commitB.layer.masksToBounds = YES;
        commitB.layer.cornerRadius = 4;
        commitB.backgroundColor = [ConMethods colorWithHexString:@"850301"];
        
        [commitB setTitle:@"确定" forState:UIControlStateNormal];
        [commitB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        commitB.titleLabel.font = [UIFont systemFontOfSize:15];
        commitB.tag = 10005;
        [commitB addTarget:self action:@selector(pushDec:) forControlEvents:UIControlEventTouchUpInside];
        [litleView addSubview:commitB];
        
        
        
        UIButton *quitBtn = [[UIButton alloc] initWithFrame: CGRectMake((ScreenWidth - 40)/2 + 15, 130, 80, 30)];
        quitBtn.layer.masksToBounds = YES;
        quitBtn.layer.cornerRadius = 4;
        quitBtn.backgroundColor = [ConMethods colorWithHexString:@"aaaaaa"];
        
        [quitBtn setTitle:@"取消" forState:UIControlStateNormal];
        [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        quitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        quitBtn.tag = 10006;
        [quitBtn addTarget:self action:@selector(pushDec:) forControlEvents:UIControlEventTouchUpInside];
        [litleView addSubview:quitBtn];
        
        [MyBackView addSubview:litleView];
        [self.view addSubview:MyBackView];
        
    



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
