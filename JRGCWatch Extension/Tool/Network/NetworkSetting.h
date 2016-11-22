//
//  NetworkSetting.h
//  Test01
//
//  Created by NJW on 16/10/19.
//  Copyright © 2016年 NJW. All rights reserved.
//

#ifndef NetworkSetting_h
#define NetworkSetting_h

#define EnvironmentConfiguration  1// 0测试 1正式

#define AES_TESTKEY @"awejfij124321aweg@##$!*&+=-13123j24325"

#if EnvironmentConfiguration == 1
#define SERVER_IP   @"http://app.9888.cn/"      //正式网
#define JPUSHKEY    @"d3fa655cc616a27b694fa9cb" //极光推送正式key
#else
// 老接口下的服务器IP
//#define SERVER_IP   @"http://app.9888.cn/"              //TestA
#define SERVER_IP   @"http://10.105.6.219:8089/mpapp/"  //刘丹

#endif
//老接口
#define SingMenthod          @"singmethod/newsign"    //签到
#define REDUNDLIST          @"NewRefund/refundLsit"   //回款明细
#define PERSONCEMTRER        @"newaccount/center"     //个人中心接口
#define SignDaysAndIsSign    @"singmethod/newsignday"     //检测签到天数和是否签到
//新街口
#define GETHSACCOUNTLIST    @"api/homePage/v2/getHSAccountInfoBill.json"  //徽商账户资金流水

#endif /* NetworkSetting_h */
