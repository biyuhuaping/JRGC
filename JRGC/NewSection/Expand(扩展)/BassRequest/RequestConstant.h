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


#pragma mark --- 我的模块
static NSString *MyReceiptApiURL = @"api/prdClaims/v2/myReceipt.json";     //首页-用户余额,累计收益,总资产

static NSString *MySimpleInfoApiURL = @"api/prdClaims/v2/mySimpleInfo.json" ; //首页-查询用户工豆,工分,等信息

static NSString *GetAccountBalanceListApiURL = @"/api/userAccount/v2/getAccountBalanceList.json"; //我的-->>充值接口

static NSString *NewSignApiURL = @"api/homePage/v2/newsign.json";//签到

static NSString *IntoCoinPageApiURL = @"api/coin/v2/intoCoinPage.json"; // 进入工力佳贝页

#endif /* RequestConstant_h */
