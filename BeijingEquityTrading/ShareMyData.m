//
//  ShareMyData.m
//  现货交易
//
//  Created by mac on 15/7/31.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import "ShareMyData.h"

@implementation ShareMyData
@synthesize myDic;

+(id)sharedManager {
    
    static ShareMyData*sharedMyManager = nil;
    
    static dispatch_once_t tonceToken;
    
    dispatch_once(&tonceToken, ^{
        
        sharedMyManager = [[self alloc] init];
        
    });
    
    return sharedMyManager;
    
}


-(id)init {
    if (self = [super init]) {
        
        myDic = [[NSDictionary alloc] init];
    }
    return self;
    
}

-(void)dealloc {
    
    // Should never be called, but justhere for clarity really.
    
}


@end
