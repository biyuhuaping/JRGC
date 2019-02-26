//
//  RequestConstant.h
//  JIMEITicket
//
//  Created by kuangzhanzhidian on 2018/5/15.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#ifndef RequestConstant_h
#define RequestConstant_h

static NSString *SourceType = @"1"; //app来源1为ios

#pragma mark --- 注册登录模块
static NSString *VerificationMobileApiURL = @"api/user/v2/verificationMobile.json";   //注册--验证手机号

static NSString *GetRegisterInfoApiURL = @"api/register/v2/getRegisterInfo.json";//获取注册时token 防止重复提交

static NSString *RegisterSendCodeApiURL =@"api/sendMsgRegister/v2/sendCode.json"; //注册登录的验证码

static NSString *loginApiURL = @"api/user/v2/login.json"; //登录接口

#pragma mark --- 我的模块
static NSString *MyReceiptApiURL = @"api/accountCenter/v2/myReceipt.json";   //我的页面新接口---账户显隐及金额信息

static NSString *MySimpleInfoApiURL = @"api/accountCenter/v2/mySimpleInfo.json" ; //我的页面新接口---查询用户工豆,工分,等信息

static NSString *GetAccountBalanceListApiURL = @"/api/userAccount/v2/getAccountBalanceList.json"; //我的-->>充值接口

static NSString *NewSignApiURL = @"api/homePage/v2/newsign.json";//签到

static NSString *IntoCoinPageApiURL = @"api/coin/v2/intoCoinPage.json"; // 进入工力佳贝页

static NSString *GetWithdrawInfoApiURL = @"api/withdraw/v2/getWithdrawInfo.json";   //提现新接口

static NSString *IdnoCheckInfoApiURL = @"api/userInfo/v2/idnoCheckInfo.json";   //获取用户身份认证信息



#endif /* RequestConstant_h */
