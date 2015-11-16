//
//  NetWork.h
//  GuizhouEquityTrading
//
//  Created by mac on 15/10/26.
//  Copyright © 2015年 ApexSoft. All rights reserved.
//

#ifndef NetWork_h
#define NetWork_h


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width

//北交所
#define SERVERURL @"http://192.168.1.84:8089"

//#define SERVERURL @"http://218.66.59.169:8400"


//天津投
//#define SERVERURL @"http://192.168.1.110:8805"




//连接失败提示语
#define notNetworkConnetTip @"网络不稳定，请检查网络是否连接；或者服务器是否开启。"
#define NUMBERS @"0123456789\n"




/*登录模块*/
#define USERLogin @"/service/appCheckLogin"
#define USERLogout @"/app/appLogout"
#define USERcaptcha @"/captcha"

/*注册模块*/
#define USERvalidateUsername @"/service/s/register/validateUsername"
#define USERvalidateMobilePhone @"/service/s/register/validateMobilePhone"
#define USERappSendVcode @"/service/s/register/appSendVcode"
#define USERpersonal @"/service/s/register/personal"

/*首页模块*/
#define USERappIndex @"/service/s/appIndex"

/*专场模块模块*/
#define USERzcappIndexzc @"/service/s/zc_list/appIndex"
#define USERprjsappIndex @"/service/s/zc_prjs/app_index"
#define USERprjsappIndexli @"/service/s/zc_prjs/app_prj_li"

/*寻宝模块*/
#define USERsearchappIndexli @"/service/s/search/app_index"
#define USERsearchliappIndex @"/service/s/search/app_search_li"






#endif /* NetWork_h */
