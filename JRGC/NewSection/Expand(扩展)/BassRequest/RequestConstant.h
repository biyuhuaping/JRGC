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

static NSString *UserBaseMessVerifCodeApiURL = @"api/userBaseMess/v2/verifCode.json";// 注册--验证手机验证码

static NSString *UserBaseMessRegisterApiURL = @"api/userBaseMess/v2/register.json";//新的注册接口,老的不再使用

static NSString *GetRegisterInfoApiURL = @"api/register/v2/getRegisterInfo.json";//获取注册时token 防止重复提交

static NSString *RegisterSendCodeApiURL = @"api/sendMsgRegister/v2/sendCode.json"; //注册和找回密码发送验证码

static NSString *RetrievePwdApiURL = @"api/user/v2/retrievePwd.json";  //找回密码

static NSString *loginApiURL = @"api/user/v2/login.json"; //登录接口

static NSString *GetRetrievePwdInfoApiURL = @"api/user/v2/getRetrievePwdInfo.json";//找回密码验证手机号信息

#pragma mark --- 我的模块
static NSString *MyReceiptApiURL = @"api/accountCenter/v2/myReceipt.json";   //我的页面新接口---账户显隐及金额信息

static NSString *MySimpleInfoApiURL = @"api/accountCenter/v2/mySimpleInfo.json" ; //我的页面新接口---查询用户工豆,工分,等信息

static NSString *GetAccountBalanceListApiURL = @"/api/userAccount/v2/getAccountBalanceList.json"; //我的-->>充值接口

static NSString *NewSignApiURL = @"api/homePage/v2/newsign.json";//签到

static NSString *IntoCoinPageApiURL = @"api/coin/v2/intoCoinPage.json"; // 进入工力佳贝页

static NSString *GetWithdrawInfoApiURL = @"api/withdraw/v2/getWithdrawInfo.json";   //提现新接口

static NSString *IdnoCheckInfoApiURL = @"api/userInfo/v2/idnoCheckInfo.json";   //获取用户身份认证信息

static NSString *GetHSAccountInfoApiURL = @"api/homePage/v2/getHSAccountInfo.json";   //徽商银行存管账户信息查询

static NSString *UserAccountInfoApiURL = @"api/userAccount/v2/userAccountInfo.json"; //P2P或尊享账户信息

static NSString *GetHSAccountInfoBillApiURL = @"api/homePage/v2/getHSAccountInfoBill.json";  //徽商账户资金流水


static NSString *GetOpenAccountInfoApiURL = @"api/userInfo/v2/getOpenAccountInfo.json"; //获取徽商开户页面信息

static NSString *identifysendCodeApiURL = @"api/identifyCode/v2/sendCode.json";        //发送验证码

static NSString *OpenAccountApiURL = @"api/userInfo/v2/openAccount.json" ;        //徽商绑定银行卡

static NSString *ChangeBankCardApiURL = @"api/userInfo/v2/changeBankCard.json";  //更改绑定银行卡信息

static NSString *OpenAccountIntoBankApiURL = @"api/userInfo/v2/openAccountIntoBank.json"; //***新徽商绑定银行卡接口

static NSString *SetHsPwdReturnJsonApiURL = @"api/userAccount/v2/setHsPwdReturnJson.json";//设置、修改交易密码通用

static NSString *AccountBalancePageApiURL = @"/api/accountCenter/v2/accountBalancePage.json";//充值提现聚合页

static NSString *AccountCashWithDrawalApiURL = @"api/withdraw/v2/getWithdrawInfo.json";
#endif /* RequestConstant_h */
