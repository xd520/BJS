//
//  ListData.h
//  BeijingEquityTrading
//
//  Created by mac on 15/11/18.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ListData : NSObject

@property (strong, nonatomic)  NSString *image;
@property (strong, nonatomic)  NSString *nameLab;
@property (strong, nonatomic)  NSString *moneyNameL;
@property (strong, nonatomic)  NSString *moneyLab;
@property (strong, nonatomic)  NSString *timeNmaeL;
@property (strong, nonatomic)  NSString *timeLab;
@property (strong, nonatomic)  NSString *classMark;
@property (strong, nonatomic)  NSString *classLab;
@property(strong,nonatomic) NSString *timeEndtime;
@property (assign, nonatomic)  BOOL isDJS;



-(id)initWithListData:(NSDictionary *)_dic;





@end
