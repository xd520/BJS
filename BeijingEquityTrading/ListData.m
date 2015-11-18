//
//  ListData.m
//  BeijingEquityTrading
//
//  Created by mac on 15/11/18.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import "ListData.h"

@implementation ListData
@synthesize moneyLab,moneyNameL,timeLab,timeNmaeL,image,nameLab,timeEndtime;


-(id)initWithListData:(NSDictionary *)_dic{
    ListData *listData = [[ListData alloc] init];
    listData.nameLab = [_dic objectForKey:@"XMMC"];
    listData.image = [_dic objectForKey:@"F_XMLOGO"];
    listData.moneyNameL = [_dic objectForKey:@"bj"];
    
    if ([[_dic objectForKey:@"style"] isEqualToString:@"wks"]) {
        listData.moneyLab = [NSString stringWithFormat:@"￥%@",[_dic objectForKey:@"QPJ"]];
        listData.timeLab =[NSString stringWithFormat:@"%@ %@", [_dic objectForKey:@"JJKSRQ"],[_dic objectForKey:@"JJKSSJ"]];
        
        listData.classLab = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"WGCS"]];
        
        listData.timeNmaeL = @"开始时间";
        
    } else if ([[_dic objectForKey:@"style"] isEqualToString:@"jpz"]){
        listData.moneyLab = [NSString stringWithFormat:@"￥%@",[_dic objectForKey:@"ZXJG"]];
        listData.isDJS = YES;
        timeEndtime = [_dic objectForKey:@"djs"];
       
       listData.classLab = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"BJZCS"]];
        
       listData.timeNmaeL = @"剩余时间";
        
    }else if ([[_dic objectForKey:@"style"] isEqualToString:@"cj"]){
        listData.moneyLab = [NSString stringWithFormat:@"￥%@",[_dic objectForKey:@"ZGCJJ"]];
        listData.timeLab = [NSString stringWithFormat:@"%@ %@", [_dic objectForKey:@"SJSSRQ"],[_dic objectForKey:@"SJJSSJ"]];
        listData.classLab = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"BJZCS"]];
        listData.timeNmaeL = @"结束时间";
        
    }else if ([[_dic objectForKey:@"style"] isEqualToString:@"lp"]){
        listData.moneyLab = [NSString stringWithFormat:@"￥%@",[_dic objectForKey:@"QPJ"]];
        // _lab2.text = [NSString stringWithFormat:@"%@ %@", [_dic objectForKey:@"SJSSRQ"],[_dic objectForKey:@"SJJSSJ"]];
        listData.classLab = [NSString stringWithFormat:@"%@",[_dic objectForKey:@"BJZCS"]];
        listData.timeNmaeL = @"已结束";
    }
    

    return listData;
}







@end
