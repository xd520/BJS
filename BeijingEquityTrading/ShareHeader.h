//
//  ShareHeader.h
//  常用方法集合
//
//  Created by mac on 15/9/11.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#ifndef _______ShareHeader_h
#define _______ShareHeader_h

typedef enum
{
    DOCUMENT_CACHE                     = 0,
    CACHESDIRECTORY                    = 1
} CACHE_PATH_TYPE;

typedef enum{
    NETTYPE_YIDONG    = 1,//移动
    NETTYPE_LIANTONG  = 2,//联通
    NETTYPE_DIANXIN   = 3//电信
} NETTYPE;

typedef enum
{
    ZHIYE_DATA_TYPE                     = 22,
    XUELI_DATA_TYPE                     = 23,
    ZJYXQ_DATA_TYPE                     = 24
} SELECT_DATA_TYPE;

//网络数据返回类型，默认是json格式
typedef enum
{
    JSON_RESPONSE_TYPE                  = 1,
    XML_RESPONSE_TYPE                   = 2,
    PROPERTYLIST_RESPONSE_TYPE          = 3,
    IMAGE_RESPONSE_TYPE                 = 4,
    COMPOUND_RESPONSE_TYPE              = 5
} RESPONSE_TYPE;




#endif
