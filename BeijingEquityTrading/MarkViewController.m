//
//  MarkViewController.m
//  BeijingEquityTrading
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "MarkViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MarkListViewController.h"
#import "SureMoneyViewController.h"
#import "SRWebSocket.h"
#import "PayMoneyViewController.h"
#import "UserProcrolViewController.h"
#import "MarkDetailViewController.h"


@interface MarkViewController ()<SRWebSocketDelegate>
{
    UIScrollView *scrollView;
    float addHight;
    int count;
    UILabel *timeValue;
    UILabel *zbztimeValue;
    
    NSMutableArray *arrImag;
    
    UIView *MyBackView;
    NSDictionary *myDic;
    UILabel *numLabTip;
    
    long long timeAll;
    
    long long zbztimeAll;
    
    long long timeAllAgain;
    
    UIButton *commitBtn;
    
    UIImageView *summitBackImg;
   UITextField *sureText;
    UILabel *endVauleLab; //成交的时候登录几种情况
    
    UIView *baoBackView;
    NSTimer *timer;
     NSTimer *zbztimer;
    
    
    NSTimer *timerNew;
    
    //
    UIButton *baoBtn;
   UILabel *baoLabTip;
    UILabel *addLab;
    UILabel *jianLab;
    UIButton *jianBtn;
    
    UILabel *newVauleLab;
    NSDictionary *updataDic;
    
    SRWebSocket *_webSocket;
    //溢价率
    UILabel *priceVauleLab;
    UILabel *timeLabFree;
    
    UILabel *zbztimeLabFree;
    
    
    
}
@end

@implementation MarkViewController
@synthesize isUpDate;

#pragma mark - 进入后刷新

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _reconnect];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self isGetPriceAndSure];
    
    if (isUpDate) {
     [self requestMethods];
    }
    
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = nil;
}


/////SRWebSocket///////

- (void)_reconnect;
{
    _webSocket.delegate = nil;
    [_webSocket close];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/websocket/bidInfoServer/%@",SERVERURL1,_strId]]];
    [request setHTTPShouldUsePipelining:YES];
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    
    //ws://192.168.1.84:8089/websocket/bidInfoServer/allMgr  ws://localhost:9000/chat
    
    _webSocket.delegate = self;
    
    //self.title = @"Opening Connection...";
    [_webSocket open];
    
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    //self.title = @"Connected!";
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    //self.title = @"Connection Failed! (see logs)";
    _webSocket = nil;
    
    [self _reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
    NSLog(@"55555%@",message);
    
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    NSDictionary *messDic = [dic objectForKey:@"object"];
    
    if ([[[myDic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:[messDic objectForKey:@"style"]]) {
        
         [self requestBaojiaMethods:[[myDic objectForKey:@"detail"] objectForKey:@"KEYID"]];
        
        
        if ([[messDic objectForKey:@"style"] isEqualToString:@"jpz"]) {
            
            updataDic = messDic;
            
            
             timeLabFree.text = [NSString stringWithFormat:@"%@期",[messDic objectForKey:@"JYZTSM"]];
            
            
            timeAll = ([[messDic objectForKey:@"STAMP"] longLongValue] - [[messDic objectForKey:@"fixTakeTime"] longLongValue])/1000;
            
           // timeAllAgain = ([[messDic objectForKey:@"STAMP"] longLongValue] - [[messDic objectForKey:@"fixTakeTime"] longLongValue])/1000;
            
                       
           // timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        } else if([[messDic objectForKey:@"style"] isEqualToString:@"zbz"]){
        
            updataDic = messDic;
            
            
            zbztimeLabFree.text = [NSString stringWithFormat:@"%@期",[messDic objectForKey:@"JYZTSM"]];
            
            
            zbztimeAll = ([[messDic objectForKey:@"STAMP"] longLongValue] - [[messDic objectForKey:@"fixTakeTime"] longLongValue])/1000;
        
        
        }
        
        NSLog(@"%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[messDic objectForKey:@"ZGJ"] floatValue]]]);
        
        newVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[messDic  objectForKey:@"ZGJ"] floatValue]]]];
        
        float yijianlv = ([[messDic  objectForKey:@"ZGJ"] floatValue] - [[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue])/[[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue]*100;
        priceVauleLab.text = [NSString stringWithFormat:@"%.2f%@",yijianlv,@"%"];
        
    } else {
        
        [self requestMethods];
    }
    
  
    
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.title = @"Connection Closed! (see logs)";
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSLog(@"Websocket received pong");
}




/////SRWebSocket//////


- (void)viewDidLoad {
    [super viewDidLoad];
    
    isUpDate = YES;
    
    count = 0;
    _shareBtn.hidden = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0) {
        addHight = 20;
        UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        statusBarView.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:statusBarView];
    } else {
        addHight = 0;
    }
    
    arrImag = [NSMutableArray array];
    
    
    
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
    lineView1.backgroundColor = [ConMethods  colorWithHexString:@"a5a5a5"];
    [self.headView addSubview:lineView1];

    [self requestMethods];
    
    
}




#pragma mark - 获取报价记录委托列表
-(void)requestBaojiaMethods:(NSString *)str {

     NSDictionary *parameters = @{@"cpdm":str};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERappWtList] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            /*
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            */
            [self getDataForList:[[[responseObject objectForKey:@"object"] objectForKey:@"wtResult"] objectForKey:@"object"]];
            
        } else {
            
            
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
                    
                    LoginViewController *cv = [[LoginViewController alloc] init];
                    // cv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cv animated:YES];
                    
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


-(void)getDataForList:(NSMutableArray *)arr {
    
    if (arr.count > 0 && arr.count <= 3) {
        
        for (int i = 0; i < arr.count; i++) {
            
            NSString *colorStr;
            NSString *nameStr;
            
            
            if (i == 0) {
                if ([[myDic objectForKey:@"style"] objectForKey:@"cj"]) {
                   nameStr = @"成交";
                 colorStr = @"850301";
                } else {
                    nameStr = @"领先";
                    colorStr = @"9c7e4a";
                    
                }
  
            } else {
            nameStr = @"出局";
             colorStr = @"a4a2a3";
            
            }
            
            
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5 + (ScreenWidth - 20)/3*i + 5*i, 10, (ScreenWidth - 20)/3, 35)];
            backView.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
            backView.layer.borderWidth = 1;
            backView.layer.borderColor = [ConMethods colorWithHexString:@"bcbcbc"].CGColor;
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, -1, 40, 20)];
            nameL.text = nameStr;
            nameL.backgroundColor = [ConMethods colorWithHexString:colorStr];
            nameL.textColor = [UIColor whiteColor];
            nameL.font = [UIFont systemFontOfSize:15];
            nameL.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:nameL];
            
            
            UILabel *nameTip = [[UILabel alloc] initWithFrame:CGRectMake( 40, 0, backView.frame.size.width - 40, 20)];
            nameTip.text = [NSString stringWithFormat:@"%@号",[[arr objectAtIndex:i] objectForKey:@"WTH"]];
            nameTip.backgroundColor = [UIColor clearColor];
            nameTip.textColor = [ConMethods colorWithHexString:colorStr];
            nameTip.font = [UIFont systemFontOfSize:14];
            nameTip.textAlignment = NSTextAlignmentRight;
            [backView addSubview:nameTip];
            
            
            UILabel *vuleTip = [[UILabel alloc] initWithFrame:CGRectMake( 10, 20, backView.frame.size.width - 20, 15)];
            vuleTip.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[arr objectAtIndex:i] objectForKey:@"WTJG"] floatValue]]]];
            vuleTip.backgroundColor = [UIColor clearColor];
            vuleTip.textColor = [ConMethods colorWithHexString:colorStr];
            vuleTip.font = [UIFont systemFontOfSize:10];
            vuleTip.textAlignment = NSTextAlignmentRight;
            [backView addSubview:vuleTip];
            
            [baoBackView addSubview:backView];
            
        }
        
        
    } else if (arr.count > 3){
        for (int i = 0; i < 3; i++) {
            
            NSString *colorStr;
            NSString *nameStr;
            
            
            
            
            if (i == 0) {
                if ([myDic objectForKey:@""]) {
                    nameStr = @"成交";
                    colorStr = @"850301";
                } else {
                    nameStr = @"领先";
                    colorStr = @"9c7e4a";
                    
                }
                
            } else {
                nameStr = @"出局";
                colorStr = @"a4a2a3";
                
            }

            
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5 + (ScreenWidth - 20)/3*i + 5*i, 10, (ScreenWidth - 20)/3, 35)];
            backView.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
            backView.layer.borderWidth = 1;
            backView.layer.borderColor = [ConMethods colorWithHexString:@"bcbcbc"].CGColor;
            UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, -1, 40, 20)];
            nameL.text = nameStr;
            nameL.backgroundColor = [ConMethods colorWithHexString:colorStr];
            nameL.textColor = [UIColor whiteColor];
            nameL.font = [UIFont systemFontOfSize:15];
            nameL.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:nameL];
            
            
            UILabel *nameTip = [[UILabel alloc] initWithFrame:CGRectMake( 40, 0, backView.frame.size.width - 40, 20)];
            nameTip.text = [NSString stringWithFormat:@"%@号",[[arr objectAtIndex:i] objectForKey:@"WTH"]];
            nameTip.backgroundColor = [UIColor clearColor];
            nameTip.textColor = [ConMethods colorWithHexString:colorStr];
            nameTip.font = [UIFont systemFontOfSize:14];
            nameTip.textAlignment = NSTextAlignmentRight;
            [backView addSubview:nameTip];
            
            
            UILabel *vuleTip = [[UILabel alloc] initWithFrame:CGRectMake( 10, 20, backView.frame.size.width - 20, 15)];
            vuleTip.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[arr objectAtIndex:i] objectForKey:@"WTJG"] floatValue]]]];
            vuleTip.backgroundColor = [UIColor clearColor];
            vuleTip.textColor = [ConMethods colorWithHexString:colorStr];
            vuleTip.font = [UIFont systemFontOfSize:10];
            vuleTip.textAlignment = NSTextAlignmentRight;
            [backView addSubview:vuleTip];
            
            [baoBackView addSubview:backView];
            
        }
    
    
    }
}





#pragma mark - 请求数据方法
-(void)requestMethods {
    //[[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"id":_strId};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
   
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",SERVERURL,USERappDetail]);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERappDetail] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            /*
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            */
            [self recivedList:[responseObject objectForKey:@"object"]];
            
        } else {
            
            
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
                    
                    LoginViewController *cv = [[LoginViewController alloc] init];
                    // cv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cv animated:YES];
                    
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


/*

- (void)timerFireMethod:(NSTimer*)theTimer{
    
    timeAllAgain = timeAllAgain - 1;
    if (timeAllAgain < 0) {
        timeValue.hidden = YES;
    } else {
    
    //day
    long long dayCount = timeAllAgain%(3600*24);
    long long day = (timeAllAgain - dayCount)/(3600*24);
    //hour
    long long hourCount = dayCount%3600;
    long long hour = (dayCount - hourCount)/3600;
    //min
    long long minCount = hourCount%60;
    long long min = (hourCount - minCount)/60;
    
    long long miao = minCount;
    
    timeValue.text = [NSString stringWithFormat:@"%lld天%lld小时%lld分钟%lld秒",day, hour, min,miao];
    }
    
}
*/


- (void)zbztimerFireMethod1{
    
    zbztimeAll = zbztimeAll - 1;
    
    if (zbztimeAll > 0) {
        zbztimeValue.hidden = NO;
        
        //day
        long long dayCount = zbztimeAll%(3600*24);
        long long day = (zbztimeAll - dayCount)/(3600*24);
        
        //hour
        long long hourCount = dayCount%3600;
        long long hour = (dayCount - hourCount)/3600;
        //min
        long long minCount = hourCount%60;
        long long min = (hourCount - minCount)/60;
        
        long long miao = minCount;
        
        zbztimeValue.text = [NSString stringWithFormat:@"%lld天%lld小时%lld分钟%lld秒",day, hour, min,miao];
    } else {
        
        zbztimeValue.hidden = YES;
    }
}





- (void)timerFireMethod1{
    
    timeAll = timeAll - 1;
    
    if (timeAll > 0) {
     timeValue.hidden = NO;
    
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
   
    timeValue.text = [NSString stringWithFormat:@"%lld天%lld小时%lld分钟%lld秒",day, hour, min,miao];
    } else {
    
        timeValue.hidden = YES;
    }
}


#pragma mark - FoucsOn
-(void)foucsMehtods:(UIButton *)btn{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[delegate.loginUser objectForKey:@"success"] boolValue] == YES) {
        if (btn.tag == 101) {//quxiao关注
            
            [self focuscancelMethods:btn];
            
            
        } else if(btn.tag == 102){
            
            [self focusOnMethods:btn];
            
            
            
        }

    } else {
        
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
  
}




-(void)focusOnMethods:(UIButton*)btn {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"xmid":[[myDic objectForKey:@"detail"] objectForKey:@"KEYID"]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERfocusPrj] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]){
           
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"关注成功"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            
                [btn setImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
                numLabTip.text = @"已关注";
                btn.tag = 101;

        } else {
            
            
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
                    
                    LoginViewController *cv = [[LoginViewController alloc] init];
                    // cv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cv animated:YES];
                    
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


-(void)focuscancelMethods:(UIButton*)btn {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在加载..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"xmid":[[myDic objectForKey:@"detail"] objectForKey:@"KEYID"]};
    
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
            
           
                [btn setImage:[UIImage imageNamed:@"未关注"] forState:UIControlStateNormal];
                numLabTip.text = @"未关注";
                btn.tag = 102;
                
        
            
        } else {
            
            
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
                    
                    LoginViewController *cv = [[LoginViewController alloc] init];
                    // cv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cv animated:YES];
                    
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




#pragma mark - initWitUIData

-(void)recivedList:(NSDictionary *)dic {
    if (scrollView) {
        scrollView.delegate = nil;
        [scrollView removeFromSuperview];
        scrollView = nil;
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  addHight + 44, ScreenWidth, ScreenHeight - 49 - 20)];
    scrollView.bounces = NO;
    scrollView.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    arrImag = [[dic objectForKey:@"bdwxx"] objectForKey:@"F_XMTP_ARR"];
    
    myDic = dic;
    
    
    
    if (arrImag.count < 2) {
        UIImageView *imagelogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenWidth)];
        imagelogo.userInteractionEnabled = YES;
         NSString *baseStr = [[Base64XD encodeBase64String:@"400,400"] strBase64];
        
        [imagelogo setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_%@.jpg",SERVERURL,[[dic objectForKey:@"detail"] objectForKey:@"F_XMLOGO"],baseStr]] placeholderImage:[UIImage imageNamed:@"loading_bd"]];
        [scrollView addSubview:imagelogo];
    } else {
        
        if (_scrollViewImg) {
             _scrollViewImg.delegate = nil;
            [_scrollViewImg removeFromSuperview];
            [self removeTimer];
        }
        
        
        _scrollViewImg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , ScreenWidth)];
        
        //添加5张图片
             for (int i = 0; i < arrImag.count; i++) {
                     UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenWidth)];
              NSString *baseStr = [[Base64XD encodeBase64String:@"400,400"] strBase64];
                [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@_%@.jpg",SERVERURL,[arrImag objectAtIndex:i],baseStr]] placeholderImage:[UIImage imageNamed:@"loading_bd"]];
             //        隐藏指示条
                    _scrollViewImg.showsHorizontalScrollIndicator = NO;
                 
                     [_scrollViewImg addSubview:imageView];
                }
             _scrollViewImg.contentSize = CGSizeMake(ScreenWidth*arrImag.count, ScreenWidth);
         _scrollViewImg.pagingEnabled = YES;
        _scrollViewImg.delegate = self;
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenWidth -20,ScreenWidth,10)]; // 初始化mypagecontrol
        [_pageControl setCurrentPageIndicatorTintColor:[ConMethods colorWithHexString:@"e3a325"]];
        [_pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
        

        _pageControl.numberOfPages = arrImag.count;
        _pageControl.currentPage = 0;
        
        [_scrollViewImg addSubview:_pageControl];
        
        
        [scrollView addSubview:_scrollViewImg];
        
        
        if (self.timerImg) {
            [self removeTimer];
        }
        
        [self addTimer];
   
    }
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
       
        
        timeLabFree = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 85, 14)];
        timeLabFree.font = [UIFont systemFontOfSize:14];
        timeLabFree.backgroundColor = [UIColor clearColor];
        timeLabFree.textColor = [UIColor whiteColor];
       
        
        timeLabFree.text = @"自由报价期";
        
        
        
        [image addSubview:timeLabFree];
        
        //剩余时间
        
        
        timeValue = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, ScreenWidth - 120, 30)];
        timeValue.font = [UIFont systemFontOfSize:14];
        timeValue.backgroundColor = [UIColor clearColor];
        timeValue.textColor = [ConMethods colorWithHexString:@"333333"];
       
        [backView addSubview:timeValue];
        timeAll = [[[dic objectForKey:@"detail"] objectForKey:@"djs"] longLongValue];
        
        //[self timerFireMethod1];
        if (zbztimer) {
            [zbztimer invalidate];
            zbztimer = nil;
        }
        
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        
       timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod1) userInfo:nil repeats:YES];
        [self requestdatafornew];
        
    }  else if([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"zbz"]){
        image.image = [UIImage imageNamed:@"正在竞价"];
        
       
        zbztimeLabFree = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 85, 14)];
        zbztimeLabFree.font = [UIFont systemFontOfSize:14];
        zbztimeLabFree.backgroundColor = [UIColor clearColor];
        zbztimeLabFree.textColor = [UIColor whiteColor];
        
        zbztimeLabFree.text = @"准备报价期";
        
        
        [image addSubview:zbztimeLabFree];
        
        //剩余时间
        
        
        zbztimeValue = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, ScreenWidth - 120, 30)];
        zbztimeValue.font = [UIFont systemFontOfSize:14];
        zbztimeValue.backgroundColor = [UIColor clearColor];
        zbztimeValue.textColor = [ConMethods colorWithHexString:@"333333"];
        
        [backView addSubview:zbztimeValue];
        zbztimeAll = [[[dic objectForKey:@"detail"] objectForKey:@"djs"] longLongValue];
    
        //[self timerFireMethod1];
        
        if (timer) {
            [timer invalidate];
            timer = nil;
        }

    
    
        if (zbztimer) {
            [zbztimer invalidate];
            zbztimer = nil;
            }
            
           zbztimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(zbztimerFireMethod1) userInfo:nil repeats:YES];
        
        [self requestdatafornew];
        
    }else if([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"zt"]){
        image.image = [UIImage imageNamed:@"正在竞价"];
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 85, 14)];
        timeLab.font = [UIFont systemFontOfSize:14];
        timeLab.backgroundColor = [UIColor clearColor];
        timeLab.textColor = [UIColor whiteColor];
        timeLab.text = @"暂停报价期";
        [image addSubview:timeLab];
        
        //剩余时间
        UILabel *timeValueLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, ScreenWidth - 120, 30)];
        timeValueLab.font = [UIFont systemFontOfSize:14];
        timeValueLab.backgroundColor = [UIColor clearColor];
        timeValueLab.textColor = [ConMethods colorWithHexString:@"333333"];
        
       
            
           // timeValueLab.text = [NSString stringWithFormat:@"结束时间:%@  %@",[[dic objectForKey:@"detail"] objectForKey:@"SJJSRQ"],[[dic objectForKey:@"detail"] objectForKey:@"SJJSSJ"]];
        
        
        //[backView addSubview:timeValueLab];
        
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
        
      
            if ([[dic objectForKey:@"detail"] objectForKey:@"SJJSSJ"] != [NSNull null]) {
                 timeValueLab.text = [NSString stringWithFormat:@"结束时间:%@  %@",[[dic objectForKey:@"detail"] objectForKey:@"SJJSRQ"],[[dic objectForKey:@"detail"] objectForKey:@"SJJSSJ"]];
            }
            
        [backView addSubview:timeValueLab];
        
        
    }
    
    [backView addSubview:image];
    [self.view addSubview:backView];
   
    
   

    
    
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
    
    if ([dic objectForKey:@"zcxx"] != [NSNull null]) {
    
    if ([[dic objectForKey:@"zcxx"] objectForKey:@"ZCQH"] == [NSNull null]) {
       qiLab.text =@"";
    }else {
    qiLab.text = [[dic objectForKey:@"zcxx"] objectForKey:@"ZCQH"];
    }
    }    
    [scrollView addSubview:qiLab];
    
 //标的编号
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(10, qiLab.frame.size.height + qiLab.frame.origin.y + 10, ScreenWidth - 20, 14)];
    numLab.font = [UIFont systemFontOfSize:14];
    numLab.backgroundColor = [UIColor clearColor];
    numLab.textColor = [ConMethods colorWithHexString:@"808080"];
    numLab.text = [NSString stringWithFormat:@"项目编号:%@",[[dic objectForKey:@"detail"] objectForKey:@"XMBH"]];
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
        
    } else if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"jpz"]||[[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"zt"]||[[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"zbz"]){
        UILabel *newLab = [[UILabel alloc] initWithFrame:CGRectMake(10, numLab.frame.origin.y + numLab.frame.size.height + 23, 50, 12)];
        newLab.font = [UIFont systemFontOfSize:12];
        newLab.backgroundColor = [UIColor clearColor];
        newLab.textColor = [ConMethods colorWithHexString:@"333333"];
        newLab.text = @"当前价:";
        [scrollView addSubview:newLab];
        
        
        newVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(60, numLab.frame.origin.y + numLab.frame.size.height + 20, ScreenWidth - 70, 15)];
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
        
        
        priceVauleLab = [[UILabel alloc] initWithFrame:CGRectMake( ScreenWidth/2 + 60, newVauleLab.frame.origin.y + newVauleLab.frame.size.height + 10, ScreenWidth/2 - 70, 12)];
        priceVauleLab.font = [UIFont systemFontOfSize:12];
        priceVauleLab.backgroundColor = [UIColor clearColor];
        priceVauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
        
        float yijianlv = ([[[myDic objectForKey:@"detail"]  objectForKey:@"ZXJG"] floatValue] - [[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue])/[[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue]*100;
        if ([[[myDic objectForKey:@"detail"]  objectForKey:@"ZXJG"] floatValue] - [[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue] > 0) {
           priceVauleLab.text = [NSString stringWithFormat:@"%.2f%@",yijianlv,@"%"];
        } else {
        
         priceVauleLab.text = @"0.00%";
        }
       
        
        //priceVauleLab.text = [[dic objectForKey:@"detail"] objectForKey:@"YJL"];
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
        if (arr.count > 0) {
           sureVauleLab.text = [NSString stringWithFormat:@"￥%@(%@)",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[arr objectAtIndex:0] objectForKey:@"BZJJE"] floatValue]]],[[arr objectAtIndex:0] objectForKey:@"TCMC"]];
        } else {
        sureVauleLab.text = @"";
        }
        
       
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
        
       endVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, numLab.frame.origin.y + numLab.frame.size.height + 20, ScreenWidth - 20, 15)];
        endVauleLab.font = [UIFont systemFontOfSize:15];
        endVauleLab.backgroundColor = [UIColor clearColor];

        if ([[[dic objectForKey:@"user"] objectForKey:@"isCybj"] boolValue] == 1) {
            if ([[[dic objectForKey:@"user"] objectForKey:@"isZgbjr"] boolValue] == 1) {
              endVauleLab.text = @"恭喜您成为最高报价方！";
            endVauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
            } else {
            endVauleLab.text = @"感谢您的参与，标的竞价结束。";
            
            }
        } else {
            
           endVauleLab.text = @"标的竞价结束。";
        }
        
       
        [scrollView addSubview:endVauleLab];

    
        //起始价
        UILabel *sureLab = [[UILabel alloc] initWithFrame:CGRectMake(10, endVauleLab.frame.origin.y + endVauleLab.frame.size.height + 10, 85, 12)];
        sureLab.font = [UIFont systemFontOfSize:12];
        sureLab.backgroundColor = [UIColor clearColor];
        sureLab.textColor = [ConMethods colorWithHexString:@"716f70"];
        sureLab.text = @"最高报价金额:";
        [scrollView addSubview:sureLab];
        
        
        UILabel *sureVauleLab = [[UILabel alloc] initWithFrame:CGRectMake(95, endVauleLab.frame.origin.y + endVauleLab.frame.size.height + 10, ScreenWidth - 70, 15)];
        sureVauleLab.font = [UIFont systemFontOfSize:15];
        sureVauleLab.backgroundColor = [UIColor clearColor];
        sureVauleLab.textColor = [ConMethods colorWithHexString:@"bd0100"];
        sureVauleLab.text = [NSString stringWithFormat:@"￥%@",[[dic objectForKey:@"detail"] objectForKey:@"ZXJG"]];
        [scrollView addSubview:sureVauleLab];
        
        
        hight = sureVauleLab.frame.origin.y + sureVauleLab.frame.size.height;
        
 //点击付款
        if ([[[dic objectForKey:@"user"] objectForKey:@"isZgbjr"] boolValue] == 1) {
            
            UIButton *fukuanBtn = [[UIButton alloc] initWithFrame:CGRectMake( ScreenWidth - 100,  endVauleLab.frame.origin.y + endVauleLab.frame.size.height + 10 - 10, 80, 25)];
            fukuanBtn.layer.borderWidth = 1;
            fukuanBtn.layer.borderColor = [ConMethods colorWithHexString:@"eeeeee"].CGColor;
           // fukuanBtn.titleLabel.text = @"确认付款";
            [fukuanBtn setTitle:@"确认付款" forState:UIControlStateNormal];
            [fukuanBtn setTitleColor:[ConMethods colorWithHexString:@"333333"] forState:UIControlStateNormal];
            
            fukuanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [fukuanBtn addTarget:self action:@selector(payMehtods:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([[dic objectForKey:@"enableFK"] boolValue]) {
               [scrollView addSubview:fukuanBtn];
            }
            
           
        }
        
    }
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, hight + 10, ScreenWidth - 20, 1)];
    lineView2.backgroundColor = [ConMethods colorWithHexString:@"f1f1f1"];
    [scrollView addSubview:lineView2];
//加价幅度  服务费  限时报价期
   
    UILabel *addLabx = [[UILabel alloc] init];
    addLabx.font = [UIFont systemFontOfSize:12];
    addLabx.backgroundColor = [UIColor clearColor];
    addLabx.textColor = [ConMethods colorWithHexString:@"666666"];
    addLabx.text = [NSString stringWithFormat:@"加价幅度:￥%.2f",[[[dic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]];
    
    addLabx.frame = CGRectMake(10, lineView2.frame.origin.y + lineView2.frame.size.height + 10, [PublicMethod getStringWidth:addLabx.text font: addLabx.font], 12);
    
    [scrollView addSubview:addLabx];

    UILabel *serviceLab = [[UILabel alloc] initWithFrame:CGRectMake(addLabx.frame.origin.x + addLabx.frame.size.width + 5, lineView2.frame.origin.y + lineView2.frame.size.height + 10, 90, 12)];
    serviceLab.font = [UIFont systemFontOfSize:12];
    serviceLab.backgroundColor = [UIColor clearColor];
    serviceLab.textAlignment = NSTextAlignmentCenter;
    serviceLab.textColor = [ConMethods colorWithHexString:@"666666"];
   // serviceLab.text = [NSString stringWithFormat:@"服务费:￥%.2f",[[[dic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]];
    serviceLab.text = [NSString stringWithFormat:@"服务费:%.2f%@",[[[dic objectForKey:@"detail"] objectForKey:@"FWF_BL_SRF"] floatValue]*100,@"%"];
    [scrollView addSubview:serviceLab];

    
    UILabel *xianLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 120, lineView2.frame.origin.y + lineView2.frame.size.height + 10, 110, 12)];
    xianLab.font = [UIFont systemFontOfSize:12];
    xianLab.backgroundColor = [UIColor clearColor];
    xianLab.textColor = [ConMethods colorWithHexString:@"666666"];
    xianLab.textAlignment = NSTextAlignmentRight;
    xianLab.text = [NSString stringWithFormat:@"限时报价期:%@秒",[[dic objectForKey:@"detail"] objectForKey:@"YSBJSC"]];
    [scrollView addSubview:xianLab];

    
    
//自由报价开始时间:
    
    
    UILabel *starTipLab = [[UILabel alloc] initWithFrame:CGRectMake(10, addLabx.frame.origin.y + addLabx.frame.size.height + 10, ScreenWidth - 20, 12)];
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
    xianTipLab.text = [NSString stringWithFormat:@"限时报价开始时间:%@",[[dic objectForKey:@"detail"] objectForKey:@"XSBJKSSJ"]];
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
    
    UIImageView *fangImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 13/2, 13, 22)];
    fangImg.image = [UIImage imageNamed:@"next"];
    [decBtn addSubview:fangImg];
    
    decBtn.tag = 10001;
    
    [decBtn addTarget:self action:@selector(pushDec:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:decBtn];
    
 //报价记录
    
    
    baoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
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
    
    UIImageView *baoImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 13/2, 13, 22)];
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
    if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"wks"]||[[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"jpz"]||[[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"zbz"]){
        
        if ([[[dic objectForKey:@"bzjInfo"] objectForKey:@"isSubmitBzj"] boolValue] == NO) {
            
            baoLabTip = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 30 - 100, 10, 100, 12)];
            
            baoLabTip.text = @"提交保证金后查看";
            baoLabTip.textColor = [ConMethods colorWithHexString:@"8e8d8e"];
            baoLabTip.font = [UIFont systemFontOfSize:12];
            [baoBtn addSubview:baoLabTip];
            
            
            
            UIImageView *endViewImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,  ScreenHeight - 75, ScreenWidth, 75)];
            endViewImg.image = [UIImage imageNamed:@"详情页按钮阴影底边"];
            baoBtn.enabled = NO;
            
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
            
            
            [scrollView setContentSize:CGSizeMake(ScreenWidth, baoBtn.frame.origin.y + baoBtn.frame.size.height + 55)];
            
        } else {
            
            if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"jpz"]) {
                
            
            baoBtn.enabled = YES;
            UIImageView *endViewImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,  ScreenHeight - 75 , ScreenWidth, 75)];
            endViewImg.image = [UIImage imageNamed:@"详情页按钮阴影底边"];
            
            commitBtn = [[UIButton alloc] initWithFrame: CGRectMake(40, 30, ScreenWidth - 80, 35)];
            commitBtn.layer.masksToBounds = YES;
            commitBtn.layer.cornerRadius = 4;
            commitBtn.backgroundColor = [ConMethods colorWithHexString:@"850301"];
            
            commitBtn.tag = 10004;
            [commitBtn setTitle:@"报价" forState:UIControlStateNormal];
            [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            commitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [commitBtn addTarget:self action:@selector(pushDec:) forControlEvents:UIControlEventTouchUpInside];
            endViewImg.userInteractionEnabled = YES;
            [endViewImg addSubview:commitBtn];
            
            [self.view addSubview:endViewImg];
            
            
            baoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, baoBtn.frame.origin.y + baoBtn.frame.size.height, ScreenWidth, 55)];
            baoBackView.backgroundColor = [ConMethods colorWithHexString:@"f8f8f8"];
            [scrollView addSubview:baoBackView];
            
            [scrollView setContentSize:CGSizeMake(ScreenWidth, baoBtn.frame.origin.y + baoBtn.frame.size.height + 55 + 55)];
            
            [self requestBaojiaMethods:[[dic objectForKey:@"detail"] objectForKey:@"KEYID"]];
            } else {
             [scrollView setContentSize:CGSizeMake(ScreenWidth, baoBtn.frame.origin.y + baoBtn.frame.size.height + 55)];
            }
        }
        
    }else if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"zt"]){
    
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([[delegate.loginUser objectForKey:@"success"] boolValue] == YES && [[[dic objectForKey:@"bzjInfo"] objectForKey:@"isSubmitBzj"] boolValue] == YES) {
            
           
            baoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, baoBtn.frame.origin.y + baoBtn.frame.size.height, ScreenWidth, 55)];
            baoBackView.backgroundColor = [ConMethods colorWithHexString:@"f8f8f8"];
            [scrollView addSubview:baoBackView];
            
            [scrollView setContentSize:CGSizeMake(ScreenWidth, baoBtn.frame.origin.y + baoBtn.frame.size.height + 55)];
            
            [self requestBaojiaMethods:[[dic objectForKey:@"detail"] objectForKey:@"KEYID"]];

            
        } else {
           
                
                UILabel *baoLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 30 - 100, 10, 100, 12)];
                baoLab.text = @"提交保证金后查看";
                baoLab.textColor = [ConMethods colorWithHexString:@"8e8d8e"];
                baoLab.font = [UIFont systemFontOfSize:12];
                [baoBtn addSubview:baoLab];
                
                
                
                UIImageView *endViewImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,  ScreenHeight - 75, ScreenWidth, 75)];
                endViewImg.image = [UIImage imageNamed:@"详情页按钮阴影底边"];
                baoBtn.enabled = NO;
                
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
                
                
                [scrollView setContentSize:CGSizeMake(ScreenWidth, baoBtn.frame.origin.y + baoBtn.frame.size.height + 55)];

        
        }
        
    
    } else {
        
        
        UILabel *baoLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 30 - 100, 10, 90, 12)];
        baoLab.text = @"报价已结束";
        baoLab.textAlignment = NSTextAlignmentRight;
        baoLab.textColor = [ConMethods colorWithHexString:@"8e8d8e"];
        baoLab.font = [UIFont systemFontOfSize:12];
        baoBtn.enabled = NO;
        [baoBtn addSubview:baoLab];
        
        
        baoBackView = [[UIView alloc] initWithFrame:CGRectMake(0, baoBtn.frame.origin.y + baoBtn.frame.size.height, ScreenWidth, 55)];
        baoBackView.backgroundColor = [ConMethods colorWithHexString:@"f8f8f8"];
        [scrollView addSubview:baoBackView];
        
        [scrollView setContentSize:CGSizeMake(ScreenWidth, baoBtn.frame.origin.y + baoBtn.frame.size.height + 55)];
        
        [self requestBaojiaMethods:[[dic objectForKey:@"detail"] objectForKey:@"KEYID"]];

    
    }
    
    
    
    if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"cj"]){
    
    
    }else if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"lp"]){
    
    } else {
        if (timerNew) {
            [timerNew invalidate];
            timerNew = nil;
        }
        
        
    timerNew = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(updateDatafornew:) userInfo:nil repeats:YES];
    
    
    }
    /*
    if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"cj"]) {
        
    } else if ([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"lp"]){
    
    } else {
    
        [self _reconnect];
    }
    */
    
    if (!([[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"cj"]||[[[dic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:@"lp"])){
    
    }
    
}

#pragma mark - 轮播图片

- (void)nextImage
 {
         int page = (int)self.pageControl.currentPage;
         if (page == arrImag.count - 1) {
                page = 0;
             }else{
                page++;
                }
     //  滚动scrollview
          CGFloat x = page * self.scrollViewImg.frame.size.width;
          self.scrollViewImg.contentOffset = CGPointMake(x, 0);
     _pageControl.frame = CGRectMake(page*ScreenWidth, ScreenWidth - 20, ScreenWidth, 10);
     
     
 }

// scrollview滚动的时候调用
 - (void)scrollViewDidScroll:(UIScrollView *)scrollV
 {
         NSLog(@"滚动中 %.2f",scrollView.contentOffset.y);
     //    计算页码
     //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
     
     if (scrollV == scrollView) {
         if (scrollView.contentOffset.y >= 246) {
             if (summitBackImg) {
                 [summitBackImg removeFromSuperview];
                 summitBackImg = nil;
             }
             
         }
     } else {
     
         CGFloat scrollviewW =  self.scrollViewImg.frame.size.width;
         CGFloat x = self.scrollViewImg.contentOffset.x;
         int page = (x + scrollviewW / 2) / scrollviewW;
         self.pageControl.currentPage = page;
     _pageControl.frame = CGRectMake(page*ScreenWidth, ScreenWidth - 20, ScreenWidth, 10);
     
     }
     
}

// 开始拖拽的时候调用
 - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollV
{
    //    关闭定时器(注意点; 定时器一旦被关闭,无法再开启)
     //    [self.timer invalidate];
    
    if (scrollV == scrollView) {
        
    } else {
        [self removeTimer];
    }
}

 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollV willDecelerate:(BOOL)decelerate
{
     //    开启定时器
    if (scrollV == scrollView) {
        
    } else {
    
         [self addTimer];
    }
}

 /**
    100  *  开启定时器
    101  */
 - (void)addTimer{
    
    self.timerImg = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
     }
 /**
*  关闭定时器
*/
 - (void)removeTimer
 {
    [self.timerImg invalidate];
     self.timerImg = nil;
}




#pragma mark - 获取报价信息（应该一段时间轮询1次，建议3秒）
-(void)updateDatafornew:(NSTimer *)timer {

    [self requestdatafornew];
    

}

-(void)requestdatafornew{
  
    
   // NSDictionary *parameters = @{@"cpdm":[[myDic objectForKey:@"bzjInfo"] objectForKey:@"tcid"]};
    NSDictionary *parameters = @{@"cpdm":[[myDic objectForKey:@"detail"] objectForKey:@"KEYID"]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERbidInfo] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]){
           
            
            [self getreciedforupdatenew:[responseObject objectForKey:@"object"]];
            
          
            
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

-(void)getreciedforupdatenew:(NSDictionary *)dic{
    
    if ([[[myDic objectForKey:@"detail"] objectForKey:@"style"] isEqualToString:[dic objectForKey:@"style"]]) {
        
        if ([[dic objectForKey:@"style"] isEqualToString:@"jpz"]) {
         
            updataDic = dic;
            
         timeAll = ([[dic objectForKey:@"STAMP"] longLongValue] - [[dic objectForKey:@"fixTakeTime"] longLongValue])/1000;
        
        
           
            timeLabFree.text = [NSString stringWithFormat:@"%@期",[dic objectForKey:@"JYZTSM"]];
           
            
            
        // timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        } else if ([[dic objectForKey:@"style"] isEqualToString:@"zbz"]) {
        
            updataDic = dic;
            
            zbztimeAll = ([[dic objectForKey:@"STAMP"] longLongValue] - [[dic objectForKey:@"fixTakeTime"] longLongValue])/1000;
            
            zbztimeLabFree.text = [NSString stringWithFormat:@"%@期",[dic objectForKey:@"JYZTSM"]];
            

        }
        
       // NSLog(@"%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"ZGJ"] floatValue]]]);
        
        if ([[dic  objectForKey:@"ZGJ"] floatValue] < [[[myDic objectForKey:@"detail"] objectForKey:@"ZXJG"] floatValue]) {
            newVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"ZXJG"] floatValue]]]];
            
            
            float yijianlv = ([[[myDic objectForKey:@"detail"]  objectForKey:@"ZXJG"] floatValue] - [[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue])/[[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue]*100;
            if ([[[myDic objectForKey:@"detail"]  objectForKey:@"ZXJG"] floatValue] - [[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue] > 0) {
                priceVauleLab.text = [NSString stringWithFormat:@"%.2f%@",yijianlv,@"%"];
            }
            
            
            
        } else {
        
        newVauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[[dic  objectForKey:@"ZGJ"] floatValue]]]];
        }
        
    } else {
    
    [self requestMethods];
    }
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
    count++;
    if (count % 2 == 0) {
        [btn setImage:[UIImage imageNamed:@"select0"] forState:UIControlStateNormal];
        
    } else {
        
        [btn setImage:[UIImage imageNamed:@"select1"] forState:UIControlStateNormal];
    }


}


#pragma mark - 提交保证金按钮

-(void)pushDec:(UIButton *)btn {
    
    if (btn.tag == 10001) {
        MarkDetailViewController *vc = [[MarkDetailViewController alloc] init];
        vc.strId = [[myDic objectForKey:@"detail"] objectForKey:@"KEYID"];
        [self.navigationController pushViewController:vc animated:YES];
       
    } else if (btn.tag == 10002) {
    
        MarkListViewController *vc = [[MarkListViewController alloc] init];
        vc.myDic = myDic;
        vc.strId = [[myDic objectForKey:@"detail"] objectForKey:@"KEYID"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    
    } else if(btn.tag == 10003){//保证金
    
       AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([[delegate.loginUser objectForKey:@"success"] boolValue] == YES) {
            //判定是否实名认证
            [self requestDataISUserName];
            
        } else {
        
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        
        }
        
     
    
    } else if(btn.tag == 10004){//报价
    
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([[delegate.loginUser objectForKey:@"success"] boolValue] == YES) {
             [self summitBackViewMehtods];
        } else {
            
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }

    
    } else if(btn.tag == 10005){
        
        if (count % 2 == 0) {
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"请阅读并同意保证金协议"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
        } else {

            [MyBackView removeFromSuperview];
            isUpDate = YES;
            SureMoneyViewController *vc = [[SureMoneyViewController alloc] init];
            vc.strId = [[myDic objectForKey:@"detail"] objectForKey:@"KEYID"];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        
        //[self summitBaozhenJin];古籍专场
        }
    } else if(btn.tag == 10006){
        
        [MyBackView removeFromSuperview];
        MyBackView = nil;
        isUpDate = YES;
    }
    
}

#pragma mark - 从保证金到 报价的时候报价记录 frame的变化



#pragma mark - 提交报价按钮弹窗
-(void)summitBackViewMehtods {
    summitBackImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 200, ScreenWidth, 200)];
    summitBackImg.image = [UIImage imageNamed:@"详情页按钮阴影底边"];
    summitBackImg.userInteractionEnabled = YES;
    
   // [[myDic objectForKey:@"detail"] objectForKey:@"JJFD"]
    
    //取消按钮
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth - 40)/2, 52.5, 40, 25)];
    // [selectBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [selectBtn setImage:[UIImage imageNamed:@"filter_arrow_down"] forState:UIControlStateNormal];
    selectBtn.tag = 10002;
    [selectBtn addTarget:self action:@selector(quitMethods:) forControlEvents:UIControlEventTouchUpInside];
    [summitBackImg addSubview:selectBtn];
    
    
    
    
    
    NSArray *arr = @[[NSString stringWithFormat:@"¥%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]],[NSString stringWithFormat:@"¥%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]*2],[NSString stringWithFormat:@"¥%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]*3]];
    
    for (int i = 0; i < 3; i++) {
        
    
    UILabel *starLabel1 = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 260)/2 + 90*i,80, 80, 30)];
    starLabel1.font = [UIFont systemFontOfSize:14];
    starLabel1.text = [arr objectAtIndex:i];
        starLabel1.backgroundColor = [ConMethods colorWithHexString:@"f9f9f9"];
    starLabel1.textColor = [ConMethods colorWithHexString:@"c2ae7f"];
    starLabel1.textAlignment = NSTextAlignmentCenter;
    starLabel1.layer.cornerRadius = 2;
    starLabel1.layer.masksToBounds = YES;
    starLabel1.layer.borderWidth = 1;
    starLabel1.layer.borderColor = [ConMethods colorWithHexString:@"c7c7c7"].CGColor;
    starLabel1.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone:)];
    starLabel1.tag = i;
        //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
        //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    [starLabel1 addGestureRecognizer:singleTap1];
        
    [summitBackImg addSubview:starLabel1];
    
    }
    
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(70, 115, ScreenWidth - 140, 35)];
    btnView.layer.cornerRadius = 4;
    btnView.layer.borderWidth = 1;
    btnView.layer.borderColor = [ConMethods colorWithHexString:@"cbcbcb"].CGColor;
    btnView.layer.masksToBounds = YES;
    
    jianBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    jianLab = [[UILabel alloc] initWithFrame:CGRectMake(2.5, 0, 30, 30)];
    jianLab.textColor = [ConMethods colorWithHexString:@"959595"];
    jianLab.backgroundColor = [UIColor clearColor];
    jianLab.text = @"-";
    jianLab.textAlignment = NSTextAlignmentCenter;
    jianLab.font = [UIFont systemFontOfSize:30];
    [jianBtn addSubview:jianLab];
   
    jianBtn.tag = 10001;
    jianBtn.enabled = NO;
    //[jianBtn setBackgroundImage:[UIImage imageNamed:@"jian_btn"] forState:UIControlStateNormal];
    
    [jianBtn addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:jianBtn];
    
  UIButton * addBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 140 - 35, 0, 35, 35)];
    
    addLab = [[UILabel alloc] initWithFrame:CGRectMake(2.5, 0, 30, 30)];
    addLab.textColor = [ConMethods colorWithHexString:@"850301"];
    addLab.backgroundColor = [UIColor clearColor];
    addLab.text = @"+";
    addLab.textAlignment = NSTextAlignmentCenter;
    addLab.font = [UIFont systemFontOfSize:30];
    [addBtn addSubview:addLab];
    
     addBtn.tag = 10002;
    [addBtn addTarget:self action:@selector(summitBtnMethods:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:addBtn];
    
    
    UIView *lineViewBtn = [[UIView alloc] initWithFrame:CGRectMake(35, 0, 1, 35)];
    lineViewBtn.backgroundColor = [ConMethods colorWithHexString:@"cbcbcb"];
    [btnView addSubview:lineViewBtn];
    
    UIView *lineViewBtn1 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - 140 - 36, 0, 1, 35)];
    lineViewBtn1.backgroundColor = [ConMethods colorWithHexString:@"cbcbcb"];
    [btnView addSubview:lineViewBtn1];
    
    
    sureText = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, ScreenWidth - 140 - 80, 35)];
    sureText.backgroundColor = [UIColor whiteColor];
    sureText.placeholder = @"输入报价金额";
    
    if ([[[myDic objectForKey:@"detail"] objectForKey:@"ZXJG"] floatValue] > 0) {
        if ([[updataDic objectForKey:@"ZGJ"] floatValue] > [[myDic objectForKey:@"QPJ"] floatValue]) {
            sureText.text = [NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue] + [[updataDic objectForKey:@"ZGJ"] floatValue]];
        } else {
           sureText.text = [NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue] + [[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue]];
        }
   
    } else {
        
        
        sureText.text = [NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue]];
    
    
    }
    
    
    
    sureText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sureText.clearButtonMode = UITextFieldViewModeWhileEditing;
    sureText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    sureText.font = [UIFont systemFontOfSize:15];
     sureText.autocorrectionType = UITextAutocorrectionTypeNo;
    sureText.delegate = self;
    
    [btnView addSubview:sureText];
    
    [summitBackImg addSubview:btnView];
    
   UIButton *commit = [[UIButton alloc] initWithFrame: CGRectMake(40, 155, ScreenWidth - 80, 35)];
    
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

#pragma mark-文本框代理方法

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    
   // CGRect frame = summitBackImg.frame;
    int offset = 216;//键盘高度216
    //动画
    /*
     NSTimeInterval animationDuration = 0.3f;
     [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
     [UIView setAnimationDuration:animationDuration];
     */
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    // stutas = YES;
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    // [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    //[[UIApplication sharedApplication]setStatusBarHidden:YES animated:YES];
    [UIView commitAnimations];
    
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    if (IOS_VERSION_7_OR_ABOVE) {
    //        self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    //    }else{
    // [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    
    //    }
}


#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)even{
    [self.view endEditing:YES];
}




-(void)quitMethods:(UIButton *)btn {

    [summitBackImg removeFromSuperview];
}



#pragma mark - 提交报价按钮

- (IBAction)summitBtnMethods:(UIButton *)btn {
    if (btn.tag == 10001) {
        
        float zuixiao = [[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue] + [[[myDic objectForKey:@"detail"] objectForKey:@"ZXJG"] floatValue];
        float shengyu = [sureText.text floatValue] - [[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue];
        
        
        
        
        
        if (shengyu <= zuixiao) {
            btn.enabled = NO;
           jianLab.textColor = [ConMethods colorWithHexString:@"959595"];
            sureText.text = [NSString stringWithFormat:@"%.2f",zuixiao];
        } else {
            sureText.text = [NSString stringWithFormat:@"%.2f",shengyu];
        
        }
    } else if (btn.tag == 10002){
        
    sureText.text = [NSString stringWithFormat:@"%.2f",[sureText.text floatValue] + [[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]];
        jianBtn.enabled = YES;
        jianLab.textColor = [ConMethods colorWithHexString:@"850301"];
    
    } else if (btn.tag == 10003){
        
        
        [self summitBaoJianWindows];
        
        
    } else if (btn.tag == 10004){
     [self sumimBaojia];
    
    }else if (btn.tag == 10005){
    
    [MyBackView removeFromSuperview];
        isUpDate = YES;
    MyBackView = nil;
    
    }

}

#pragma mark - 提交报价弹窗
-(void)summitBaoJianWindows{
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
    vauleLab.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[sureText.text floatValue]]]];
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
    vauleLabTip.text = [NSString stringWithFormat:@"￥%@",[ConMethods AddComma:[NSString stringWithFormat:@"%.2f",[sureText.text floatValue]*[[[myDic objectForKey:@"detail"] objectForKey:@"FWF_BL_SRF"] floatValue]]]];
    vauleLabTip.textColor = [ConMethods colorWithHexString:@"bd0100"];
    vauleLabTip.font = [UIFont systemFontOfSize:15];
    vauleLabTip.frame = CGRectMake(nameLab.frame.origin.x + nameLab.frame.size.width, 85, 200, 15);
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



-(void)sumimBaojia {
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在提交..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"id":[[myDic objectForKey:@"detail"] objectForKey:@"KEYID"],@"wtjg":sureText.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERsubmitWt] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue]){
           
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"报价提交成功"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
           
            [MyBackView removeFromSuperview];
            MyBackView = nil;
           [summitBackImg removeFromSuperview];
            summitBackImg = nil;
            
           // [self requestMethods];
            
            
        } else {
            
            
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
                    
                    LoginViewController *cv = [[LoginViewController alloc] init];
                    // cv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cv animated:YES];
                    
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





- (IBAction)callPhone:(UITouch *)sender
{
    
    UILabel *view = (UILabel *)[sender view];
    if (view.tag == 0) {
        
        if (([[updataDic objectForKey:@"ZGJ"] floatValue] > [[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue])) {
            sureText.text = [NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue] + [[updataDic objectForKey:@"ZGJ"] floatValue]];
        } else {
            sureText.text = [NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue] + [[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]];
        }

        
        
       // sureText.text = [NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue] + [[updataDic objectForKey:@"ZGJ"] floatValue]];

    } else if (view.tag == 1) {
        
        if (([[updataDic objectForKey:@"ZGJ"] floatValue] > [[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue])) {
            sureText.text = [NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]*2 + [[updataDic objectForKey:@"ZGJ"] floatValue]];
        } else {
            sureText.text = [NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]*2 + [[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue]];
        }
 
        
           // sureText.text = [NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]*2 + [[updataDic objectForKey:@"ZGJ"] floatValue]];
    
    }else if (view.tag == 2){
        
        if (([[updataDic objectForKey:@"ZGJ"] floatValue] > [[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue])) {
            sureText.text = [NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]*3 + [[updataDic objectForKey:@"ZGJ"] floatValue]];
        } else {
            sureText.text = [NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]*3 + [[[myDic objectForKey:@"detail"] objectForKey:@"QPJ"] floatValue]];
        }

        
        
           // sureText.text = [NSString stringWithFormat:@"%.2f",[[[myDic objectForKey:@"detail"] objectForKey:@"JJFD"] floatValue]*3 + [[updataDic objectForKey:@"ZGJ"] floatValue]];
    
    
    }
}

#pragma mark - 提交保证金弹窗
-(void)initBackViewMehtods {
    if (MyBackView) {
        [MyBackView removeFromSuperview];
    }
    
        count = 0;
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
    agreeUserTip.tag = 10001;
    agreeUserTip.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1;
    
    singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushProcoalVC:)];
    
    //单点触摸
    singleTap1.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap1.numberOfTapsRequired = 1;
    [agreeUserTip addGestureRecognizer:singleTap1];
    //[litleView addSubview:agreeUserTip];
        
        
        UILabel *agree = [[UILabel alloc] init];
        agree.text = @",并且理了解：";
        agree.textColor = [ConMethods colorWithHexString:@"333333"];
        agree.font = [UIFont systemFontOfSize:10];
        agree.frame = CGRectMake(55, 100, [PublicMethod getStringWidth:agree.text font:agree.font], 10);
        [litleView addSubview:agree];
        
        
        UILabel *agreeUser = [[UILabel alloc] init];
        agreeUser.text = @"《经典收藏品受托转让项目动态报价承诺函》";
        agreeUser.textColor = [ConMethods colorWithHexString:@"bd0100"];
        agreeUser.font = [UIFont systemFontOfSize:10];
     agreeUser.tag = 10002;
        agreeUser.frame = CGRectMake(10 , 115, ScreenWidth - 40, 10);
    agreeUser.userInteractionEnabled = YES;
     UITapGestureRecognizer *singleTap;
    agreeUser.textAlignment = NSTextAlignmentCenter;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushProcoalVC:)];
    
    //单点触摸
    singleTap.numberOfTouchesRequired = 1;
    //点击几次，如果是1就是单击
    singleTap.numberOfTapsRequired = 1;
    [agreeUser addGestureRecognizer:singleTap];
    
    
        [litleView addSubview:agreeUser];
    
  //确定 取消
        UIButton *commitB = [[UIButton alloc] initWithFrame: CGRectMake((ScreenWidth - 40)/2 - 95, 145, 80, 30)];
        commitB.layer.masksToBounds = YES;
        commitB.layer.cornerRadius = 4;
        commitB.backgroundColor = [ConMethods colorWithHexString:@"850301"];
    
        [commitB setTitle:@"确定" forState:UIControlStateNormal];
        [commitB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        commitB.titleLabel.font = [UIFont systemFontOfSize:15];
        commitB.tag = 10005;
        [commitB addTarget:self action:@selector(pushDec:) forControlEvents:UIControlEventTouchUpInside];
        [litleView addSubview:commitB];
        
        
        
        UIButton *quitBtn = [[UIButton alloc] initWithFrame: CGRectMake((ScreenWidth - 40)/2 + 15, 145, 80, 30)];
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



- (void)pushProcoalVC:(UITouch *)sender {
    UIView *view = [sender view];
    
    if (view.tag == 10001) {
        
        isUpDate = NO;
        
        UserProcrolViewController *cv = [[UserProcrolViewController alloc] init];
        cv.strId = @"YHXY";
        cv.strName = @"用户竞价协议";
        
        [self.navigationController pushViewController:cv animated:YES];
        
    } else {
    
     isUpDate = NO;   
    UserProcrolViewController *cv = [[UserProcrolViewController alloc] init];
    cv.strId = [[myDic objectForKey:@"detail"] objectForKey:@"KEYID"];
    cv.strName = @"承诺函";
    
    [self.navigationController pushViewController:cv animated:YES];
    }
}

//
-(void) requestDataISUserName {
    
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERpwdManageappappIndex] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            
            /*
             [[HttpMethods Instance] activityIndicate:NO
             tipContent:@"加载完成"
             MBProgressHUD:nil
             target:self.view
             displayInterval:3];
             */
          //  myDic = [responseObject objectForKey:@"object"];
            if ([[[responseObject objectForKey:@"object"] objectForKey:@"isSetCert"] boolValue]) {
                [self initBackViewMehtods];
                isUpDate = NO;
            } else {
                [[HttpMethods Instance] activityIndicate:NO
                                              tipContent:@"请先进行实名认证"
                                           MBProgressHUD:nil
                                                  target:self.view
                                         displayInterval:3];
            
            }
            
        } else {
            
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
                    
                    LoginViewController *cv = [[LoginViewController alloc] init];
                    // cv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cv animated:YES];
                    
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





-(void)summitBaozhenJin{
    
    [[HttpMethods Instance] activityIndicate:YES tipContent:@"正在提交..." MBProgressHUD:nil target:self.view displayInterval:2.0];
    
    NSDictionary *parameters = @{@"cpdm":[[myDic objectForKey:@"detail"] objectForKey:@"KEYID"]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERsubmitBzj] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"success"] boolValue]){
            NSLog(@"JSON: %@", responseObject);
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"提交成功"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [MyBackView removeFromSuperview];
            isUpDate = YES;
            
            
            /*
            baoBtn.enabled = YES;
            baoLabTip.hidden = YES;
            commitBtn.tag = 10004;
            [commitBtn setTitle:@"报价" forState:UIControlStateNormal];
            */
            
            [self requestMethods];
            
        } else {
            
            if ([[responseObject objectForKey:@"object"] isKindOfClass:[NSString class]]) {
                
                if ([[responseObject objectForKey:@"object"] isEqualToString:@"loginTimeout"]) {
                    
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate.loginUser removeAllObjects];
                    
                    LoginViewController *cv = [[LoginViewController alloc] init];
                   // cv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:cv animated:YES];
                    
                }
                
            }
            
            
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




#pragma mark - 提交金额

-(void)payMehtods:(UIButton *)btn {

    PayMoneyViewController *vc = [[PayMoneyViewController alloc] init];
    
    //[dic objectForKey:@"CJJLH"]
    vc.strId = [myDic objectForKey:@"cjjlh"];
    [self.navigationController pushViewController:vc animated:YES];

}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


-(void)dealloc {

    [timerNew invalidate];
    timerNew = nil;
    [timer invalidate];
    timer = nil;
    [self removeTimer];
    
    scrollView.delegate = nil;
    [scrollView removeFromSuperview];
    scrollView = nil;
    _scrollViewImg.delegate = nil;
    [_scrollViewImg removeFromSuperview];

    
   
    [timeValue removeFromSuperview];
    timeValue = nil;
    
    [MyBackView removeFromSuperview];
    MyBackView = nil;
    
    myDic = nil;
    [numLabTip removeFromSuperview];
    
   
    
    [commitBtn removeFromSuperview];
    commitBtn = nil;
    
    [summitBackImg removeFromSuperview];
    summitBackImg = nil;
   sureText.delegate = nil;
    [sureText removeFromSuperview];
    sureText = nil;
    [endVauleLab removeFromSuperview];
    endVauleLab = nil;
     //成交的时候登录几种情况
    
    [baoBackView removeFromSuperview];
    baoBackView = nil;
    
    //
   [baoBtn removeFromSuperview];
    baoBtn = nil;
    [baoLabTip removeFromSuperview];
    baoLabTip = nil;
    [addLab removeFromSuperview];
    addLab = nil;
    [jianLab removeFromSuperview];
    jianLab = nil;
    [jianBtn removeFromSuperview];
    jianBtn = nil;
    
    [newVauleLab removeFromSuperview];
    newVauleLab = nil;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    
    if (timerNew.isValid) {
        [timerNew invalidate];
        timerNew = nil;
    }
    
    if (timer.isValid) {
        [timer invalidate];
        timer = nil;
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareMethods:(id)sender {
}
@end
