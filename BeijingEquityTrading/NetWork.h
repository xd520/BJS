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


//北交所客户外网
//#define SERVERURL @"http://111.205.25.78:8071"




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
#define USERappDetail @"/service/s/prj/appDetail"

/***标的详情委托***/
#define USERappWtList @"/service/s/prj/appWtList"
#define USERfocusPrj @"/service/s/prj/focusPrj"
#define USERcancelFocusPrj @"/service/s/prj/cancelFocusPrj"

#define USERsubmitBzj @"/service/s/prj/submitBzj"
#define USERsubmitWt @"/service/s/prj/submitWt"
//获取报价信息和提交报价 都是这个接口
#define USERbidInfo @"/service/s/prj/bidInfo"
//#define USERbidInfo @"/service/s/prj/bidInfo"

/*个人中心－账户中心*/
//baozhengjin
#define USERwdbzj @"/service/psncenter/wdzc/app_wdbzj"
#define USERwdjyjl @"/service/psncenter/wdzc/app_wdjyjl"

//jiaoyi
#define USERappbjz @"/service/psncenter/wdjy/app_bjz"
#define USERappwcj @"/service/psncenter/wdjy/app_wcj"
#define USERappycj @"/service/psncenter/wdjy/app_ycj"
//guanzhu
#define USERappguanzhu @"/service/psncenter/wdgz/app_wdgz"
//xiaoxizhongxin
#define USERinboxList @"/service/psncenter/message/inboxList"
//上传头像
#define USERappUploadPhotoSubmit @"/service/psncenter/grzl/appUploadPhotoSubmit"
//显示头像
#define USERinboxList @"/service/psncenter/message/inboxList"

/*寻宝模块*/
#define USERsearchappIndexli @"/service/s/search/app_index"
#define USERsearchliappIndex @"/service/s/search/app_search_li"

/**资讯模块***/
#define USERinfomenu @"/service/s/info/app_menu"
#define USERinfolist @"/service/s/info/app_list_li"
#define USERinfodetail @"/page/s/info/app_detail"


/**密保问题***/
#define USERsendVcode @"/service/psncenter/aqzxManage/szmb/sendVcode"
#define USERquestionsList @"/service/psncenter/aqzxManage/szmb/questionsList"
#define USERsubmit @"/service/psncenter/aqzxManage/szmb/submit"

#define USERxgmb @"/service/psncenter/aqzxManage/xgmb/questionsList"
#define USERcheckAnswer @"/service/psncenter/aqzxManage/xgmb/checkAnswer"
#define USERmodify @"/service/psncenter/aqzxManage/xgmb/modify"
#define USERfindmb @"/service/psncenter/aqzxManage/findmb/sendVcode"
#define USERfindmbquestionsList @"/service/psncenter/aqzxManage/findmb/questionsList"
#define USERfindmbreset @"/service/psncenter/aqzxManage/findmb/reset"

/**修改手机号***/
#define USERgrzlsendVcode @"/service/psncenter/grzl/sendVcode"
#define USERgrzlcheckVcode @"/service/psncenter/grzl/checkVcode"
//保存新手机号码
#define USERsaveMobilePhone @"/service/psncenter/grzl/saveMobilePhone"
//完善个人资料
#define USERsaveEmail @"/service/psncenter/grzl/saveEmail"
/**修改登录密码***/
#define USERpwdManagesendVcode @"/service/psncenter/pwdManage/modifyLoginPwd/sendVcode"
//修改登录密码
#define USERpwdManageappModify @"/service/psncenter/pwdManage/modifyLoginPwd/appModify"
//修改交易密码
#define USERpwdManageappSendVcode @"/service/psncenter/pwdManage/modifyTranPwd/appSendVcode"
#define USERpwdManageModify @"/service/psncenter/pwdManage/modifyTranPwd/appModify"

/***认证中心***/
#define USERpwdManageappappIndex @"/service/psncenter/aqzx/appIndex"
#define USERpwdManagequeryProvince @"/service/psncenter/kh/queryProvince"
#define USERpwdManagequeryCity @"/service/psncenter/kh/queryCity"
#define USERpwdManageappVcode @"/service/psncenter/kh/appSendVcode"
#define USERpwdManageappKh @"/service/psncenter/kh/appKh"



#endif /* NetWork_h */
