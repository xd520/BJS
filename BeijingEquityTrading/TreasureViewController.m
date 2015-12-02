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
    
    NSString *endTime;
    NSString *price;
    
    UILabel *lab1;
    UILabel *lab2;
    UILabel *lab3;
    UILabel *lab4;

    NSInteger countin;
    NSInteger indext;
    NSInteger tipcount;
    
    UIView *MyView;
    UIScrollView *backscrollView;
    
    NSMutableArray *bigClassList;
    NSMutableArray *littleClassList;
    
    UIView *bigView;
    UIView *littleView;
    UIView *moneyView;
    
    UIView *lineViewLit;
    UIView *lineViewBig;
    
    
    int countBig;
    int countLittle;
    
    float bigHight;
    float littltHight;
    
    UIButton *selectlitBtn;
    
}

@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;


@end

@implementation TreasureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    totalLastTime = [NSMutableArray array];
    
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
    
   
    
    
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(5, 2.5, ScreenWidth - 10 - 30, 25)];
    searchText.delegate = self;
    searchText.placeholder = @"搜索标的名称或编号";
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
    
    UIView  *lineview = [[UIView alloc] initWithFrame:CGRectMake(2, 1, ScreenWidth - 14, 1)];
    lineview.backgroundColor = [ConMethods colorWithHexString:@"a2a2a2"];
    [view1 addSubview:lineview];
    
    
    [_headView addSubview:view1];
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, addHight + 44, ScreenWidth, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    
    
    //默认选择按钮
    
    NSArray *titleArrTranfer = @[@"默认",@"限时报价开始时间▲",@"价格▲",@"类别▲"];
    
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
    
    
    lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, ScreenWidth, 0.5)];
    lineView1.backgroundColor = [ConMethods  colorWithHexString:@"a5a5a5"];
    [backView addSubview:lineView1];
    
    
    [self.view addSubview:backView];
    
    
    
    //添加tableView
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0,addHight + 44 + 30, ScreenWidth,ScreenHeight - 94 - 49)];
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
        
        
        start = @"1";
        searchText.text = @"";
        [self requestData:endTime withprice:price with:searchText.text];
        
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
        
        start = @"1";
        searchText.text = @"";
        [self requestData:endTime withprice:price with:searchText.text];
        
        
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
       
        start = @"1";
        searchText.text = @"";
        [self requestData:endTime withprice:price with:searchText.text];
        
    } else if (btn.tag == 3){
    
       // [self getFlashForSelectWindows:nil];
        [self requestDataForWindows];
        
    }
    
}


#pragma mark - /***** 筛选处理 ******/

#pragma mark - 请求筛选数据方法

-(void) requestDataForWindows {
    
    NSLog(@"start = %@",start);
    
    NSDictionary *parameters = @{};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//设置相应内容类型
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Request-By"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERsearchappIndexli] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"success"] boolValue] == YES){
            
            
            [[HttpMethods Instance] activityIndicate:NO
                                          tipContent:@"加载完成"
                                       MBProgressHUD:nil
                                              target:self.view
                                     displayInterval:3];
            
            [self getFlashForSelectWindows:[responseObject objectForKey:@"object"]];
            
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



#pragma mark - 筛选弹窗

-(void)getFlashForSelectWindows:(NSDictionary *)dic{

    if (MyView) {
        [MyView removeFromSuperview];
    }
    
    
    bigClassList = [[dic objectForKey:@"xmlbList"] objectForKey:@"object"];
    littleClassList = [[dic objectForKey:@"xmzlList"] objectForKey:@"object"];
    
    
    MyView  = [[UIView alloc] initWithFrame:CGRectMake(0, addHight, ScreenWidth, ScreenHeight - 20)];
    MyView.backgroundColor = [ConMethods colorWithHexString:@"bfbfbf" withApla:0.8];
    MyView.layer.masksToBounds = YES;
    MyView.layer.cornerRadius = 4;
    
  

    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, ScreenWidth - 40, 44)];
    headView.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
    
    
    
    //取消按钮
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 19/2, 40, 25)];
    [quitBtn setTitle:@"取消" forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    quitBtn.backgroundColor = [UIColor clearColor];
    [quitBtn setTitleColor:[ConMethods colorWithHexString:@"999999"] forState:UIControlStateNormal];
    quitBtn.tag = 10001;
    [quitBtn addTarget:self action:@selector(quitMethods:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:quitBtn];
    
    
    UILabel *headLab = [[UILabel alloc] initWithFrame:CGRectMake(80, (44 - 18)/2, ScreenWidth - 180, 18)];
    headLab.text = @"筛选";
    headLab.textAlignment = NSTextAlignmentCenter;
    headLab.textColor = [ConMethods colorWithHexString:@"252525"];
    headLab.font = [UIFont systemFontOfSize:18];
    [headView addSubview:headLab];
    
    
    
    //完成按钮
    UIButton *finshBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 80, 19/2, 40, 25)];
    [finshBtn setTitle:@"完成" forState:UIControlStateNormal];
    finshBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    finshBtn.backgroundColor = [UIColor clearColor];
    [finshBtn setTitleColor:[ConMethods colorWithHexString:@"999999"] forState:UIControlStateNormal];
    finshBtn.tag = 10002;
    [finshBtn addTarget:self action:@selector(quitMethods:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:finshBtn];
    [MyView addSubview:headView];
    
    
    backscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 44, ScreenWidth - 40, ScreenHeight - 64)];
    backscrollView.backgroundColor = [ConMethods colorWithHexString:@"f2f2f2"];
    backscrollView.bounces = NO;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 40, 0.5)];
    lineView.backgroundColor = [ConMethods colorWithHexString:@"c8c7cc"];
    [backscrollView addSubview:lineView];
    
    
    [self initBigButtons];
    [self initlittleButtons];
    
    moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, littleView.frame.origin.y + littleView.frame.size.height, ScreenWidth - 40,ScreenHeight - 64 - littleView.frame.origin.y - littleView.frame.size.height - 50)];
    moneyView.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
    
    UILabel *bigLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 18)];
    bigLab.text = @"起拍价";
    // bigLab.textAlignment = NSTextAlignmentCenter;
    bigLab.textColor = [ConMethods colorWithHexString:@"252525"];
    bigLab.font = [UIFont systemFontOfSize:18];
    [moneyView addSubview:bigLab];
    
    //取消按钮
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 80, 19/2, 40, 25)];
    // [selectBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [selectBtn setImage:[UIImage imageNamed:@"付款勾选"] forState:UIControlStateNormal];
    

    selectBtn.tag = 10004;
    [selectBtn addTarget:self action:@selector(quitMethods:) forControlEvents:UIControlEventTouchUpInside];
    [moneyView addSubview:selectBtn];
    [backscrollView addSubview:moneyView];
    
    [MyView addSubview:backscrollView];
    
    
    
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(40, ScreenHeight - 20 - 50, ScreenWidth - 40, 50)];
    endView.backgroundColor = [ConMethods colorWithHexString:@"f2f2f2"];
    
    
    
    //取消按钮
    UIButton *emtyBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7.5, (ScreenWidth - 70)/2, 35)];
    [emtyBtn setTitle:@"清空筛选" forState:UIControlStateNormal];
   // emtyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    //emtyBtn.backgroundColor = [UIColor clearColor];
    [emtyBtn setTitleColor:[ConMethods colorWithHexString:@"363636"] forState:UIControlStateNormal];
    emtyBtn.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
    emtyBtn.layer.masksToBounds = YES;
    emtyBtn.layer.cornerRadius = 2;
    
    emtyBtn.tag = 10004;
    [emtyBtn addTarget:self action:@selector(quitMethods:) forControlEvents:UIControlEventTouchUpInside];
    [endView addSubview:emtyBtn];
    
    
    
    //完成按钮
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 + (ScreenWidth - 70)/2, 7.5, (ScreenWidth - 70)/2, 35)];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
   // sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    sureBtn.backgroundColor = [ConMethods colorWithHexString:@"850301"];
    [sureBtn setTitleColor:[ConMethods colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    sureBtn.tag = 10005;
    [sureBtn addTarget:self action:@selector(quitMethods:) forControlEvents:UIControlEventTouchUpInside];
    [endView addSubview:sureBtn];
    [MyView addSubview:endView];

    
    
    
    
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate.window addSubview:MyView];
}

-(void)initBigButtons{
    
    
    bigView = [[UIView alloc] init];
    bigView.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
    
     countBig = 0;
    
    
    UILabel *bigLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 18)];
    bigLab.text = @"标的大类";
    // bigLab.textAlignment = NSTextAlignmentCenter;
    bigLab.textColor = [ConMethods colorWithHexString:@"252525"];
    bigLab.font = [UIFont systemFontOfSize:18];
    [bigView addSubview:bigLab];
    
    //取消按钮
    UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 80, 19/2, 40, 25)];
   // [selectBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [selectBtn setImage:[UIImage imageNamed:@"付款勾选"] forState:UIControlStateNormal];
    
    //selectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    //selectBtn.backgroundColor = [UIColor clearColor];
    //[selectBtn setTitleColor:[ConMethods colorWithHexString:@"999999"] forState:UIControlStateNormal];
    selectBtn.tag = 10002;
    [selectBtn addTarget:self action:@selector(quitMethods:) forControlEvents:UIControlEventTouchUpInside];
    [bigView addSubview:selectBtn];

    
    
    //求出总共多少行
    NSInteger less = bigClassList.count%3;
    NSInteger row = (bigClassList.count - less)/3 + 1;
  
    
    
    for (int i = 0; i < row; i++) {
        
        if (i == row - 1) {
          
            for (int j = 0; j < less; j++) {
                
                UIButton *selectBigBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + (ScreenWidth - 70)/3*j + 5*j, 50 + 30*i, (ScreenWidth - 70)/3, 25)];
                [selectBigBtn setTitle:[[bigClassList objectAtIndex:i*3 + j] objectForKey:@"XMLBMC"] forState:UIControlStateNormal];
                selectBigBtn.backgroundColor = [ConMethods colorWithHexString:@"b50505"];
                selectBigBtn.layer.masksToBounds = YES;
                selectBigBtn.layer.cornerRadius = 4;
                
                selectBigBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [selectBigBtn setTitleColor:[ConMethods colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                selectBigBtn.tag = 10001;
                [selectBigBtn addTarget:self action:@selector(bigMethods:) forControlEvents:UIControlEventTouchUpInside];
                [bigView addSubview:selectBigBtn];
            }
            
            
        } else {
        
        
        for (int j = 0; j < 3; j++) {
            
            UIButton *selectBigBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + (ScreenWidth - 70)/3*j + 5*j, 50 + 30*i, (ScreenWidth - 70)/3, 25)];
            [selectBigBtn setTitle:[[bigClassList objectAtIndex:3*i + j] objectForKey:@"XMLBMC"] forState:UIControlStateNormal];
            selectBigBtn.backgroundColor = [ConMethods colorWithHexString:@"b50505"];
            selectBigBtn.layer.masksToBounds = YES;
            selectBigBtn.layer.cornerRadius = 4;
            
            selectBigBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [selectBigBtn setTitleColor:[ConMethods colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
            selectBigBtn.tag = 3*i + j;
            [selectBigBtn addTarget:self action:@selector(bigMethods:) forControlEvents:UIControlEventTouchUpInside];
            [bigView addSubview:selectBigBtn];
            }
        }
    }
    
    
    lineViewBig = [[UIView alloc] initWithFrame:CGRectMake(0, 50 + row*30 + 14.5, ScreenWidth - 40, 0.5)];
    lineViewBig.backgroundColor = [ConMethods colorWithHexString:@"c8c7cc"];
    [bigView addSubview:lineViewBig];
    
    bigView.frame = CGRectMake(0, 10, ScreenWidth - 40, 50 + row*30 + 15);
    
    bigHight = 50 + row*30 + 15;
    [backscrollView addSubview:bigView];
    
}





-(void)initlittleButtons{
    
    
    littleView = [[UIView alloc] init];
    littleView.backgroundColor = [ConMethods colorWithHexString:@"ffffff"];
    
    countLittle = 0;
    
    UILabel *littleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 18)];
    littleLab.text = @"标的小类";
    // bigLab.textAlignment = NSTextAlignmentCenter;
    littleLab.textColor = [ConMethods colorWithHexString:@"252525"];
    littleLab.font = [UIFont systemFontOfSize:18];
    [littleView addSubview:littleLab];
    
    //取消按钮
    selectlitBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 80, 19/2, 40, 25)];
    [selectlitBtn setImage:[UIImage imageNamed:@"付款勾选"] forState:UIControlStateNormal];
    //[selectlitBtn setTitle:@"取消" forState:UIControlStateNormal];
   // selectlitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
   // selectlitBtn.backgroundColor = [UIColor clearColor];
   // [selectlitBtn setTitleColor:[ConMethods colorWithHexString:@"999999"] forState:UIControlStateNormal];
    selectlitBtn.tag = 10003;
    [selectlitBtn addTarget:self action:@selector(quitMethods:) forControlEvents:UIControlEventTouchUpInside];
    [littleView addSubview:selectlitBtn];
    
    
    //求出总共多少行
    NSInteger less = littleClassList.count%3;
    NSInteger row = (littleClassList.count - less)/3 + 1;

    
    
    for (int i = 0; i < row; i++) {
        
        if (i == row - 1) {
          
            for (int j = 0; j < less; j++) {
                
                
                
                UIButton *selectBigBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + (ScreenWidth - 70)/3*j + 5*j,50 + 30*i, (ScreenWidth - 70)/3, 25)];
                [selectBigBtn setTitle:[[littleClassList objectAtIndex:i*3 + j] objectForKey:@"XMZLMC"] forState:UIControlStateNormal];
                selectBigBtn.backgroundColor = [ConMethods colorWithHexString:@"f5f5f5"];
                selectBigBtn.layer.masksToBounds = YES;
                selectBigBtn.layer.cornerRadius = 4;
                
                selectBigBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [selectBigBtn setTitleColor:[ConMethods colorWithHexString:@"888888"] forState:UIControlStateNormal];
                selectBigBtn.tag = i*3 + j;
                [selectBigBtn addTarget:self action:@selector(littleMethods:) forControlEvents:UIControlEventTouchUpInside];
                [littleView addSubview:selectBigBtn];
            }
            
        } else {
        
        
        for (int j = 0; j < 3; j++) {
            
       
        
        UIButton *selectBigBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + (ScreenWidth - 70)/3*j + 5*j, 50 + 30*i, (ScreenWidth - 70)/3, 25)];
        [selectBigBtn setTitle:[[littleClassList objectAtIndex:i*3 + j] objectForKey:@"XMZLMC"] forState:UIControlStateNormal];
        selectBigBtn.backgroundColor = [ConMethods colorWithHexString:@"f5f5f5"];
        selectBigBtn.layer.masksToBounds = YES;
        selectBigBtn.layer.cornerRadius = 4;
        
        selectBigBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [selectBigBtn setTitleColor:[ConMethods colorWithHexString:@"888888"] forState:UIControlStateNormal];
        selectBigBtn.tag = i*3 + j;
        [selectBigBtn addTarget:self action:@selector(littleMethods:) forControlEvents:UIControlEventTouchUpInside];
        [littleView addSubview:selectBigBtn];
    }
        }
     }
    

    lineViewLit = [[UIView alloc] initWithFrame:CGRectMake(0, 50 + row*30 + 14.5 , ScreenWidth - 40, 0.5)];
    lineViewLit.backgroundColor = [ConMethods colorWithHexString:@"c8c7cc"];
    [littleView addSubview:lineViewLit];
    
    littleView.frame = CGRectMake(0, bigView.frame.origin.y + bigView.frame.size.height, ScreenWidth - 40, 50 + row*30 + 15);
    littltHight = 50 + row*30 + 15;
    [backscrollView addSubview:littleView];
    

}



-(void)bigMehtods:(UIButton *)btn {

}

-(void)littleMehtods:(UIButton *)btn {
    
}


-(void)quitMethods:(UIButton *)btn {


    if (btn.tag == 10001) {
         [MyView removeFromSuperview];
    } else if(btn.tag == 10002){
        ++countBig;
        if (countBig % 2 == 0) {
            [btn setImage:[UIImage imageNamed:@"付款勾选"] forState:UIControlStateNormal];
            bigView.frame = CGRectMake(0, 10, ScreenWidth - 40, bigHight);
             littleView.frame = CGRectMake(0, bigView.frame.origin.y + bigView.frame.size.height, ScreenWidth - 40, 50 );
             lineViewBig.frame = CGRectMake(0, bigHight - 0.5 , ScreenWidth - 40, 0.5);
             lineViewLit.frame = CGRectMake(0, 50 - 0.5 , ScreenWidth - 40, 0.5);
            
            moneyView.frame = CGRectMake(0, littleView.frame.origin.y + littleView.frame.size.height, ScreenWidth - 40,ScreenHeight - 64 - littleView.frame.origin.y - littleView.frame.size.height - 50);
            
            
            
        } else {
        
        [btn setImage:[UIImage imageNamed:@"付款未勾选"] forState:UIControlStateNormal];
            bigView.frame = CGRectMake(0, 10, ScreenWidth - 40, 50 );
            
            littleView.frame = CGRectMake(0, bigView.frame.origin.y + bigView.frame.size.height, ScreenWidth - 40, 50 );
            lineViewBig.frame = CGRectMake(0, 50 - 0.5 , ScreenWidth - 40, 0.5);
             lineViewLit.frame = CGRectMake(0, 50 - 0.5 , ScreenWidth - 40, 0.5);
           
            [selectlitBtn setImage:[UIImage imageNamed:@"付款未勾选"] forState:UIControlStateNormal];
            countLittle = 1;
            
            
            
            moneyView.frame = CGRectMake(0, littleView.frame.origin.y + littleView.frame.size.height, ScreenWidth - 40,ScreenHeight - 64 - littleView.frame.origin.y - littleView.frame.size.height - 50);

            
        }
        
    
    
    } else if (btn.tag == 10003){
        
        ++countLittle ;
        if (countBig % 2 == 0) {
            
            if (countLittle % 2 == 0) {
              
                [btn setImage:[UIImage imageNamed:@"付款勾选"] forState:UIControlStateNormal];
                littleView.frame = CGRectMake(0, bigView.frame.origin.y + bigView.frame.size.height, ScreenWidth - 40, littltHight);
                 lineViewLit.frame = CGRectMake(0, littltHight - 0.5 , ScreenWidth - 40, 0.5);
                 moneyView.frame = CGRectMake(0, littleView.frame.origin.y + littleView.frame.size.height, ScreenWidth - 40,ScreenHeight - 64 - littleView.frame.origin.y - littleView.frame.size.height - 50);
                
            } else {
             littleView.frame = CGRectMake(0, bigView.frame.origin.y + bigView.frame.size.height, ScreenWidth - 40, 50 );
             lineViewLit.frame = CGRectMake(0, 49.5 , ScreenWidth - 40, 0.5);
            moneyView.frame = CGRectMake(0, littleView.frame.origin.y + littleView.frame.size.height, ScreenWidth - 40,ScreenHeight - 64 - littleView.frame.origin.y - littleView.frame.size.height - 50);
            }
            
        } else {
            
            [btn setImage:[UIImage imageNamed:@"付款未勾选"] forState:UIControlStateNormal];
           
            littleView.frame = CGRectMake(0, bigView.frame.origin.y + bigView.frame.size.height, ScreenWidth - 40, 50 );
             lineViewLit.frame = CGRectMake(0, 49.5 , ScreenWidth - 40, 0.5);
             moneyView.frame = CGRectMake(0, littleView.frame.origin.y + littleView.frame.size.height, ScreenWidth - 40,ScreenHeight - 64 - littleView.frame.origin.y - littleView.frame.size.height - 50);
            
        }
    
    }
}

#pragma mark - /***** 筛选处理 ******/



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
        
        //static NSString *ReCellIdentifier = @"cell";
        
        // cell = [tbleView dequeueReusableCellWithIdentifier:ReCellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[ConMethods colorWithHexString:@"f7f7f5"]];
            //添加背景View
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth - 10, 110)];
            [backView setBackgroundColor:[UIColor whiteColor]];
            backView.layer.cornerRadius = 2;
            backView.layer.masksToBounds = YES;
            backView.layer.borderWidth = 1;
            backView.layer.borderColor = [ConMethods colorWithHexString:@"d5d5d5"].CGColor;
            
            //专场列表
            UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 90, 90)];
            [image1 setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVERURL,[[dataList objectAtIndex:indexPath.row] objectForKey:@"F_XMLOGO"]]] placeholderImage:[UIImage imageNamed:@"logo"]];
            [backView addSubview:image1];
            
            
            if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"lp"]){
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(100 - 50, 105 - 35, 50, 35)];
                img.image = [UIImage imageNamed:@"end"];
                [backView addSubview:img];
            }
            
            
            
            
            //品牌
            UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, ScreenWidth - 110, 15)];
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
            dayLabelM.frame = CGRectMake(100, 28, [PublicMethod getStringWidth:dayLabelM.text font:dayLabelM.font], 14);
            
            [backView addSubview:dayLabelM];
            
            
            
            //最新价
            UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(dayLabelM.frame.origin.x + dayLabelM.frame.size.width, 28, ScreenWidth - 30, 14)];
            
            dayLabel.font = [UIFont systemFontOfSize:14];
            dayLabel.textColor = [ConMethods colorWithHexString:@"333333"];
            [backView addSubview:dayLabel];
            
            //竞拍中的时候 自由报价时期
            if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"jpz"]){
                
                
                
                UILabel *ziyouLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 105 - 40, ScreenWidth/2 - 30, 14)];
                
                ziyouLabel.font = [UIFont systemFontOfSize:14];
                ziyouLabel.text = [[dataList objectAtIndex:indexPath.row] objectForKey:@"JYZT_MC"];
                ziyouLabel.textColor = [ConMethods colorWithHexString:@"333333"];
                [backView addSubview:ziyouLabel];
                
                
                
                
                
            }
            
            //开始时间判定
            
            UILabel *starLab = [[UILabel alloc] init];
            starLab.textColor = [ConMethods colorWithHexString:@"333333"];
            if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"wks"]) {
                
                starLab.text = @"开始时间";
                
            } else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"jpz"]){
                
                
                starLab.text = @"剩余时间";
                
            }else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"cj"]){
                
                starLab.text= @"结束时间";
                
            }else if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"lp"]){
                
                starLab.text = @"已结束";
            }
            
            starLab.font = [UIFont systemFontOfSize:10];
            
            starLab.frame = CGRectMake(100, 105 - 20, [PublicMethod getStringWidth:starLab.text font:starLab.font], 12);
            
            [backView addSubview:starLab];
            
            
            //时间显示
            
            UILabel *timeYuLab = [[UILabel alloc] initWithFrame:CGRectMake(starLab.frame.origin.x   + starLab.frame.size.width, 105 - 20, ScreenWidth - starLab.frame.origin.x   + starLab.frame.size.width - 50, 12)];
            timeYuLab.backgroundColor = [UIColor clearColor];
            
            if ([[[dataList objectAtIndex:indexPath.row] objectForKey:@"style"] isEqualToString:@"jpz"]) {
                
                timeYuLab.tag = indexPath.row + 1000;
                NSDictionary *dic = @{@"indexPath":indexPath,@"lastTime": [[dataList objectAtIndex:indexPath.row] objectForKey:@"djs"]};
                [totalLastTime addObject:dic];
                
            }
            
            
            timeYuLab.textColor = [ConMethods colorWithHexString:@"999999"];
            
            timeYuLab.font = [UIFont systemFontOfSize:10];
            [backView addSubview:timeYuLab];
            
            
            UILabel *markLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 50,105 - 50, 50, 25)];
            
            markLab.font = [UIFont systemFontOfSize:15];
            markLab.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:markLab];
            
            //围观
            UILabel *dateLabelMore = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 20 - 50,105 - 50 + 25, 50, 25)];
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
                [self startTimer];
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
            
            
            
            
            // dayLabel 最新价
            //starLab 开始时间判定
            //timeYuLab 时间显示
            // markLab 围观头标];
            //dateLabelMore 围观次数
            
            
            
            
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

-(void)getStrFormStly:(NSString *)str withLab1:(UILabel *)_lab1 withLab2:(UILabel *)_lab2 withLab4:(UILabel *)_lab4 with:(NSDictionary *)_dic{
    if ([str isEqualToString:@"wks"]) {
        _lab1.text = [NSString stringWithFormat:@"￥%@",[_dic objectForKey:@"QPJ"]];
        _lab2.text =[NSString stringWithFormat:@"%@ %@", [_dic objectForKey:@"JJKSRQ"],[_dic objectForKey:@"JJKSSJ"]];
        
        // _lab3.text = @"开始时间";
        
        _lab4.text = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"WGCS"]];
        
    } else if ([str isEqualToString:@"jpz"]){
        _lab1.text = [NSString stringWithFormat:@"￥%@",[_dic objectForKey:@"ZXJG"]];
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



//开启定时器方法：
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
        UILabel *textLab = [cell viewWithTag:indexPath.row + 1000];
        
        
        textLab.text = [NSString stringWithFormat:@"%@",[self lessSecondToDay:time]];
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


#pragma mark - 消除键盘

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)even{
    [self.view endEditing:YES];
}







- (IBAction)callPhone:(UITouch *)sender
{
    
    UIView *view = [sender view];
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
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@",SERVERURL,USERsearchliappIndex] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
