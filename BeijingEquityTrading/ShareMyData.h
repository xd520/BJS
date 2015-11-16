//
//  ShareMyData.h
//  现货交易
//
//  Created by mac on 15/7/31.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareMyData : NSObject
{
    NSDictionary *myDic;
}

@property(nonatomic, readonly) NSDictionary *myDic;

+(id)sharedManager;


@end
