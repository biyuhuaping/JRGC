//
//  Type/Users/jinronggongchang/Documents/JRGC_2.2.00/JRGC/JRGC.xcodeprojDefine.h
//
//
//  Created by JasonWong on 13-12-21.
//  Copyright (c) 2013年 sxzh Ltd. All rights reserved.
//
//      http://app.9888.cn/
//      http://10.10.100.40:8090/mpapp/




#define SENDSOUNDMESSAGE @""
#define VALIDPOMOCODE       @"newuserregist/isexitpomocode"       //校验工场码
#define VERIFINAMEANDPASS   @"api/user/v2/getRetrievePwdInfo.json"//获取找回密码的请求信息
#define LOGIn_ARGU          @"api/user/v2/login.json"
#define USER_REGIST         @"api/register/v2/register.json"
#define PRDCLAIMS_LIST      @"newPrdClaims/dataList"//债券(最新项目)列表
#define PRDCLAIMS_LISTNEWVERSION   @"api/prdClaims/v2/dataList.json"//首页数据列表
#define PRDTRANSFER_LIST    @"newprdTransfer/dataList"//债券转让列表
#define PRDCLAIMS_DETAIL    @"newPrdClaims/getDetailTwo"//普通标详情
#define PRDTRANSFER_DETAIL  @"newprdTransfer/showDetailTwo"//转让标详情
#define PRDCLAIMS_DEALBID   @"newPrdClaims/dealBidTwo"
#define PRDCLAIMS_SAVEDEALS @"api/invest/v2/submitTender.json"
#define PERSON_CENTER       @"api/homePage/v2/userCenter.json"  // @"newaccount/center" 个人中心
#define MONEY_OVERVIEW      @"newaccount/overview"
#define FUNDS_DETAIL        @"newaccount/funds"
#define ACCOUNT_SAFE        @"api/userInfo/v2/personalInfo.json" //个人信息页面
#define VALID_BINDED_PHONE  @"newuserregist/bindNewPhone" //修改绑定手机号验证一绑定号码
//#define IDNO_CHECKINFO      @"newsafe/idnoCheckInfo"   // 个人身份证信息
#define IDNO_CHECKINFO      @"api/userInfo/v2/idnoCheckInfo.json"// 个人身份证信息


#define CHANGE_PWD          @"api/userInfo/v2/updatePwd.json" //修改登录密码
#define MYTRANSFER_DETAIL   @"newPrdTransferOrder/transferOrderDetail"
#define GET_BARNERREG       @"newuserregist/getBannerRegist"
#define GET_BARNERMORE      @"newuserregist/getBannerMore"
#define MODIFI_PWD          @"api/user/v2/retrievePwd.json"  //找回密码
//#define SEND_MESSAGE        @"newsendmessage"
#define GET_MESSAGE_TICKET  @"newgetSendMessageTicket"  
//#define USER_LOGOUT         @"user/loginoutForCheck"
//#define USER_LOGOUT         @"user/loginout"
#define USER_LOGOUT  @"api/userInfo/v2/loginOut.json"
#define DEALTRANSFERBID     @"newprdTransfer/dealTransferBidTwo"
//#define SAVETRANSFERDEALS   @"api/investTraClaims/v2/submitTender.json" //债权转让投资请求
//#define UPDATE_TEL          @"userInfor/updatetele"
#define UPDATE_TEL          @"api/userInfo/v2/registMobileChange.json"
#define DICITEMLIST         @"sysDataDicItem/allDicItemList"
#define BANK_TOP_INFO       @"api/recharge/v2/getRechargeInfo.json"
#define DrawalsSendPhone    @"api/recharge/v2/getRechargeCode.json"
#define MY_RECOMMENT        @"prdClaimsFore/recommendBorrows"
//#define TRADED_LOG          @"prdClaimsFore/dealRecordList"
//#define MY_CONTRACT_LIST    @"contractParty/list"
//#define MY_GUARANTEE        @"prdClaimsFore/debtorsForeList"
#define WORK_SHOP_CODE      @"newfactoryCodeController/DimensionCode"//我的工场码
//#define MY_COMMEND          @"prdClaimsFore/recommendBorrows"
#define ACT_WITHDRAW        @"api/withdraw/v2/getWithdrawInfo.json"   //提现新接口 zrc fixed
#define PRDORDERUINVEST     @"newprdOrder/uinvest"//我的投资
#define PRDORDERUINVESTDETAIL     @"newprdOrder/detail"//我的投资详情
#define PRDORDERREFUNDLSIT  @"NewRefund/refundLsit"//回款明细
//#define PRDCLAIMSFOREALLBORROWS @"prdClaimsFore/allBorrows"
//#define PRDCLAIMSFORCEBORROWS   @"prdClaimsFore/borrows"
//#define PRDCLAIMSFOREDEBTBORROWS @"prdClaimsFore/debtBorrows"
#define FRIENDS_LIST        @"newfactoryCodeController/investFriendsList"//邀请返利-邀请投资明细
//#define CONTRACTSIGN        @"contractParty/contractSign"
//#define CONTRACTCONTENT     @"contractParty/getContent"
//#define BASEBANKMESS        @"newbankCard/baseBankMess"  // 银行卡列表
#define GETTREGIONLIST      @"personalSettings/getTRegionList"
//#define BANKCARDSUBMITAPPLY @"newsafe/submitApply"
//#define SENDPHONeVERIFYCODE @"actWithdraw/sendPhoneVerifyCode"
//#define ACTWITHDRAWAPPLY   @"api/withdraw/v2/withdraw.json" // @"actWithdraw/apply" 提现
//#define PICKUPINTEREST      @"actWithdraw/pickUpInterest"
//#define ACCOUNTFUNDS        @"account/funds"
#define COMPUTEINTREST      @"newprdTransfer/newCompensateInterest"
#define NORMALCOMPUTEINTREST @"newPrdClaims/computeIntrest"
//#define TRANSFERCOMPUTEINTREST @"prdTransfer/computeIntrest"
//#define PRDCLAIMSFOREGUARANTORBORROWS @"prdClaimsFore/guarantorBorrows"
//#define PRDALLSUBROGATION             @"prdClaimsFore/allSubrogation"
//#define PRDTRANSFERPAY                @"prdClaimsFore/transferPay"
//#define PRDBUYBACK                    @"prdClaimsFore/buyBack"
#define PRDBORROWSINFO                @"prdClaimsFore/borrowsInfo"
#define FACTORYCODESAVERATE           @"factoryCode/saveRate"//修改佣金比例
#define CAULATENUM                    @"appInstallCount/save"
//#define GETGUAGUAKA                   @"scratchCard/toExchange"
//#define CHECKGUACARD                  @"scratchCard/exchange"
//#define USERBEHAVIOR                  @"userBehavior/writeBehavior"
#define EXCAHGELIST                   @"scratchCard/exchangeList"
//#define APPLYCARD                     @"scratchCard/applyCard"
#define RIGISTCHECK                   @"newuserregist/verification"
//#define INVITEREBATE                  @"newfactoryCodeController/info"          //邀请返利
#define INVITEREBATE                  @"api/inviteRebate/v2/info.json"          //邀请返利
#define FRIENDREGISTERLIST            @"newfactoryCodeController/recFriendList" //邀请注册记录
//#define AllInverstMoney               @"top/index"
#define YouHuiTickt                   @"NewBeans/returnMoneyList" //优惠券列表
#define GongDouInCome                 @"newBeanRecordCon/incomeBorrows" //工豆收入
#define GongDouExpend                 @"newBeanRecordCon/expendBorrows" //工豆支出
#define GongDouOverDue                @"newBeanRecordCon/overdueBorrows" //工豆过期
#define CheckPomoCode                 @"newuserregist/isexitpomocode"
//#define ChatFriendList                @"accountyouyun/getyouyunfriends"
//#define CheckChatId                   @"accountyouyun/checkRegYouyun"
//#define RegistyouYun                  @"accountyouyun/regyouyun"
//#define GetRedBag                     @"scratchCard/applyByRedBag"
//#define IsExistSpring                 @"scratchCard/isExist"
//#define RedPackage                    @"NewBeans/SmallRedList"  /// 抢到的红包
#define MyRedPackage                  @"NewBeans/redPackageList"    /// 我的红包
//#define ZiJinTuoGuan                  @"sysDataDicItem/dicItemList"
#define HSPayMobile                  @"api/recharge/v2/recharge.json"
//#define QueryYeePay                   @"yjpay/queryPay"
#define PAYRECORD                     @"newactWithdraw/querySevenDayByList"
//#define PAYSWITCH                     @"yeepay/getyeepayflag"
//#define QUERYBEANCOUPON               @"beanRecordCon/quereyBeanCouponByUserId"
#define COUPSELECTBYOWER              @"newBeanRecordCon/CouponSelectedByuser"
#define BEANSINTEREST                 @"newBeanRecordCon/unUsedFx"
//#define SELECTINVENTAMYT              @"newBeanRecordCon/CouponSelectedByInventAmt"
//#define GONDDOUALLBORROW              @"beanRecordCon/allBorrows"
//#define GOUNGDOISHOURU                @"beanRecordCon/incomeBorrows"
#define GONGDOUZHICHU                 @"beanRecordCon/expendBorrows"
//#define GONGDOUGUOQI                  @"beanRecordCon/overdueBorrows"
#define ALLYOUHUIQUANLIST             @"beanRecordCon/quereyBeanRecordIds"
//#define YIBAOCHECKBANKSTATE           @"yeepay/bankCardCheck"   //易付宝判断银行卡号是否通过
//#define SingMenthod                   @"singmethod/newsign"//签到
#define SingMenthod                   @"api/homePage/v2/newsign.json"//签到
//#define MODIFYBANKCARDZONE            @"newbankCard/updateBankZone"  //修改银行卡网点
//#define REDBAG_ADDRESS                @"NewBeans/redPackageUrl"     //红包地址
#define CHECKMYMONEY                  @"newaccount/getAvailable"    //选择反息券列表查询余额
#define GetAppSetting                 @"sysDataDicItem/getAppSetting"//获取分享各种信息
#define TransfersOrder                @"newPrdTransferOrder/transfersOrder"//我的债券列表
//#define CHECKBETAVER                  @"newPrdCheckBeta/newCheck"       //检测用户是不是beta
#define SignDaysAndIsSign             @"singmethod/newsignday"     //检测签到天数和是否签到
#define GUAGUAPOST                    @"happyCard/exchange"//刮刮卡
#define GongDouOverduing              @"newBeanRecordCon/AppqueryOverDetail"     //即将过期的工豆
#define RecommendRefund               @"/factoryCode/recommendRefundDataApp"//好友回款
//#define CheckCardBelongToBank         @"newbankCard/bankCardCheck" //判断行别

#define GETAppQueryByManyList         @"/newfactoryCodeController/appQueryByManyList"//多期回款明细
#define CHECKREDPOINTHIDE             @"newaccount/updatePointUpdTime"  //检测工豆 返现券 红包 回款明细
#define CHECKPERSONCENTERREDALERT     @"newaccount/isHasPoint"
//#define GETIGNORGELOGINTOKEN          @"newWapActivity/wapActGetToken"
//#define MSGCENTER                     @"tMsgList/queryAllTMsgList"    //消息中心列表
#define MSGCENTER                     @"api/messageCenter/v2/queryAllTMsgList.json"    //消息中心列表
#define MSGCENTERDETAIL               @"tMsgList/readInms"           //消息详情
#define USERDISPERMISSIONISOPEN       @"newUserDisPermission/userDisPermissionIsOpen" //消息设置-- 用户是否接收短信通知
#define VALIDLOGIN                    @"safeCenter/validLogin"
#define UPDATEUSERDISPERMISSION       @"newUserDisPermission/userDisPermission"//消息设置-- 更新用户是否接收短信通知
//#define USERCOUPONFXCOUNT             @"newBeanRecordCon/quereyCouponFxCount"
#define MSGSIGNALLREAD              @"api/messageCenter/v2/signAllRead.json"// 全部设置为已读 @"tMsgList/signAllRead"
//#define MSGREOMETMSG                  @"tMsgList/removeTMsg" //删除消息
#define MSGREOMETMSG                  @"api/messageCenter/v2/removeTMsg.json" //删除消息
//#define MSGSIGNREAD                   @"tMsgList/signRead" //单条消息标记为已读
#define MSGSIGNREAD                   @"api/messageCenter/v2/signRead.json" //单条消息标记为已读
//#define GETREDPOINTMDSSAGE            @"newaccount/getRedPointMessage"  //获取所有红点状态
//#define GETWORKPOINT                  @"userScore/queryScoreList"       //工分请求
#define GETWORKPOINT                  @"api/userScore/v2/queryScoreList.json"       //工分请求
#define COUPONLIST                    @"beansMall/couponList"           //兑换券列表

#define GETCONTRIBUTIONVALUEINVOT     @"api/userLevel/v2/contributeSource.json"//投资贡献值

#define FACEINFOCOLLECTION  @"faceRecordInfo/collectFaceMess"//人脸识别-人脸信息录入
#define FACESWITCHSTAUS               @"faceRecordInfo/showFaceSwitchStatus"//人脸识别开关状态查询
#define FACEUPDATESWITCHSWIP           @"faceRecordInfo/switchFaceSwip" //人脸开关操作（需要验签）
#define FACEINFOLANDING     @"faceRecordInfo/faceSwipLogin"//人脸识别-登录
#define FACEINFOSTORE     @"faceRecordInfo/checkLoginName"//人脸识别-人脸信息是否存在
#define CHOSEBRANCHBANK    @"api/withdraw/v2/getBankList.json"//选择支行

#define CHOOSEBANKLIST      @"api/userInfo/v2/getBankList.json"         //查询银行卡银行列表
#define GETHSACCOUNTINfO    @"api/homePage/v2/getHSAccountInfo.json"    //徽商银行存管账户信息查询
#define GETHSACCOUNTLIST    @"api/homePage/v2/getHSAccountInfoBill.json"  //徽商账户资金流水

#define GETOPENACCOUNTINfO  @"api/userInfo/v2/getOpenAccountInfo.json"  //获取徽商开户页面信息
#define OPENACCOUNT         @"api/userInfo/v2/openAccount.json"         //徽商绑定银行卡
#define SETHSPWD            @"api/userAccount/v2/setHsPwd.shtml"        //设置交易密码
#define IDENTIFYCODE        @"api/identifyCode/v2/sendCode.json"        //发送验证码
#define CHOSENBRANCHBANK    @"api/userInfo/v2/updateBankZone.json"      //更改支行信息
#define SETHSPWD            @"api/userAccount/v2/setHsPwd.shtml"        //设置徽商交易密码
#define REPLACEBANKCARDINFORMATION  @"api/userInfo/v2/changeBankCard.json"  //更改绑定银行卡信息
#define CASHRECODLIST       @"api/homePage/v2/getWithdrawBill.json"   //提现记录
#define BANK_INFO_New       @"api/userInfo/v2/showBankCardMess.json"  //获取银行卡信息（新）
#define CASHCODEVALIDATE    @"api/withdraw/v2/validate.json" //提现页面校验验证码
#define REGISTERSENDCODE    @"api/sendMsgRegister/v2/sendCode.json" //注册发送验证码
#define MODIYRESERVEMOBILE  @"api/userInfo/v2/reserveMobileChange2.json" //修改充值预留手机号码
#define WITHDRAWSUB         @"api/withdraw/v2/withdrawSub.json"   //提现webView确认接口
#define INVESTSUBMIT        @"api/invest/v2/submit.json"          //投资webView确认接口
#define TRACLAIMSSUBMIT     @"api/investTraClaims/v2/submit.json" //债转webView确认接口
#define SETHSPWDRETNRNJSON  @"api/userAccount/v2/setHsPwdReturnJson.json"//设置、修改交易密码通用
#define WITHDRAWMONEYVALIDATE @"api/withdraw/v2/validate.json" //提现金额是否超额接口
#define REGISTRESULT        @"api/register/v2/registResult.json"            //注册成功活动反的数据
#define GETREGISTERTOKEN    @"api/register/v2/getRegisterInfo.json"  //获取注册token
#define REURNCOUPONLIST     @"api/discountCoupon/v2/returnCouponList.json"      //返现券&返息券列表
#define COUPONCERTIFICATE   @"api/discountCoupon/v2/couponCertificateList.json" //兑换券列表
#define PRESENTFRIEND       @"api/discountCoupon/v2/presentFriendList.json"     //优惠券赠送好友列表
#define PRESENTCOUPON       @"api/discountCoupon/v2/presentCoupon.json"         //赠送好友券
#define DATASTATICS         @"api/inviteRebate/v2/rebateStatistic.json"         // 数据统计
#define REDBAGRAIN          @"api/homePage/v2/getRedBagRainInfo.json"
#define PROJECTLISTBATCHBID @"api/prdClaims/v2/colPrdclaimsList.json"  //项目列表中的批量列表
#define MYINVESTBATCHBID    @"api/myInvest/v2/myBatchInvest.json"     //我的投资的批量投资列表
#define MYINVESTHEADERINFO  @"newprdOrder/incomeInterest"             //我的投资头部信息

#define PROJECTLIST         @"api/prdClaims/v2/more.json"     //项目标列表
#define TRANSFERLIST        @"api/prdTransfer/v2/getTranPageList.json"     //转让列表
#define GETCONTRACTMSG      @"newPrdClaims/getContractMsg" //查看合同详情
#define GetBatchContractMsg @"newsafe/getAutoInvestRight"
#define ISSHOWHORNOR        @"api/prdClaims/v2/zxSwitch.json"   //是否显示尊享
#define VALIDATEOLDPHONENO   @"/api/userInfo/v2/validateOldPhoneNo.json"//校验注册手机号

#define GetBatchInvestLimit  @"api/userAccount/v2/getBatchInvestLimit.json" //查询批量投标最大额
#define SetBatchInvestNum    @"api/userAccount/v2/openBatchInvest.json"  //设置批量投标最大额


#define CHILDPRDCLAIMSLIST   @"api/prdClaims/v2/childPrdclaimsList.json"  //集合标子标列表
#define COLPRDCLAIMSDETAIL   @"api/prdClaims/v2/colPrdclaimsDetail.json" //集合标详情
#define COLPRDCLAIMSLIST     @"api/prdClaims/v2/colPrdclaimsList.json"   //集合标列表

#define MYBATCHINVESTDETAIL   @"api/myInvest/v2/myBatchInvestDetail.json" //我的投资-集合标明细

#define  INTODEALBATCH    @"api/invest/v2/intoDealBatch.json" //进入一键投资页面
#define  BATCHINVESTURL       @"api/invest/v2/batchInvest.json"   //一键投标
#define GETTOKENID          @"api/userInfo/v2/getIdentityTokenId.json" //获取放心花的tokenId

#define BATCHINVESTSTATUS    @"api/invest/v2/getBatchInvestStatus.json"//一键投资结果页面
#define GETBACHINVESTAWARD    @"api/invest/v2/getBatchInvestAward.json" //查看批量投资奖励
#define GETINFOFORONOFF @"api/dataDicItem/v2/getInfoForOnOff.json"    // 新手政策开关（0：关，1：开）
#define GETSHAREMESSAGE  @"api/dataDicItem/v2/getShareMess.json" //首页2017新手政策分享注册链接

#define DISCOVERYURL    @"https://m.9888.cn/static/wap/fa-xian/index.html"     //发现
#define RegistCheckQdIsLimit @"newuserregist/checkQdIslimit"
#define EASYLOAN_URL    @"https://m.easyloan888.com/static/loan/user-jrgc-login/index.html" //借款URL

#define USERACOUNTINFOURL  @"api/userAccount/v2/userAccountInfo.json" //P2P或尊享账户信息



enum kPostStatus{
    kPostStatusNone=0,
    kPostStatusBeging=1,
    kPostStatusEnded=2,
    kPostStatusError=3,
};

typedef enum kPostStatus kPostStatus;
enum kSXTag
{
    kSXTagLogin = 0,//登录
//    kSXTagPrdClaims = 1,//债券列表
    kSXTagPrdTransfer = 2,//债券转让列表
    kSXTagPrdClaimsDetail = 3,//债券产品(普通和权益类)详情
    kSXTagPrdTransferDetail = 4,//债券转让详情
    kSXTagPrdClaimsDealBid = 5,//投资界面
    kSXTagPrdClaimsSaveDeals = 6,//投资
    kSXTagPersonCenter,//个人中心
    kSXTagMoneyOverview,//资金总览
    kSXTagFundsDetail,//资金流水
    kSXTagAccountSafe,//账户与安全
    kSXTagIdentifyCard,//身份认证
    kSXTagChangedPwd,//忘记密码
    kSXTagUpdatePwd,//修改密码
    KSXTAGVERFIUSERNAMEANDPHONE,//效验用户名和手机号
//    kSXTagSendMessage,//发送手机验证码
    kSXTagSendSoundMessage,//发送语音验证码
    kSXTagSendMessageforTicket,//发送获取验证码的ticket！
    kSXTagUserRegist,// 注册
    kSXTagUserLogout,//登出
    kSXTagDealTransferBid,//转让标投资界面
//    kSXTagSaveTransferDeals,//转让标投资动作
    kSXTagValidBindedPhone,//更改绑定手机号码验证原手机号
    kSXTagUpdateMobile,//更改绑定手机号码
    kSXTagKicItemList,//数据字典
    kSXTagBankTopInfo,//获取充值页面银行卡信息
//    kSXTagMyCompact,//我的合同
//    kSXTagMyGuarantee,//我的担保
    kSXTagWorkshopCode,//我的工场码
//    kSXTagMyRecommend,//我的推荐
    kSXTagCashAdvance,//提现
    kSXTagPrdOrderUinvest,//我的投资
    kSXTagPrdOrderInvestDetail,//投资详情
    kSXTagPrdMyTransferDetail,//我的债权详情
    kSXTagPrdOrderRefundLsit,//回款明细
//    kSXTagPrdClaimsForeAllBorrows,//借款列表
//    kSXTagPrdClaimsForeBorrows,//还款列表
//    kSXTagPrdClaimsForeDebtBorrows,//欠款单
    kSXTagFriendsList,//好友列表
//    kSXTagContractPartyContractSign,//签署合同
//    kSXTagContractPartyGetContent,//合同详情
//    kSXTagBankCardBaseBankMess,//银行信息
//    kSXTagPersonalSettingsGetTRegionList,//区域信息
//    kSXTagBankCardSubmitApply,//绑定银行卡
//    kSXTagActWithdrawSendPhoneVerifyCode,//提现银行卡
    kSXTagWithdrawalsSendPhone,//获取充值验证码
//    kSXTagActWithdrawApply,//确认提现
//    kSXTagActWithdrawPickUpInterest,//提取利息
//    kSXTagAccountFunds,//资金情况
    kSXTagPrdClaimsComputeIntrest,//计算预期收益
    kSXTagNormalBidComputeIntrest,//计算普通标的预期收益
//    kSXTagPrdTransferComputeIntrest,//债券转让预期收益
//    kSXTagPRDCLAIMSFOREGUARANTORBORROWS,//逾期欠款单
//    kSXTagPrdClaimsForeAllSubrogation,//权益列表
//    kSXTagPrdClaimsForeTransferPay,//转付列表
//    kSXTagPrdClaimsForeBuyBack,//延期回购单
    kSXTagPrdClaimsForeBorrowsInfo,
    kSXTagFactoryCodeSaveRate,//修改佣金比例
    kSXTagCalulateInstallNum, //统计装机量
//    kSXTagGetGuaGuaKa,//获取刮刮卡
//    kSXTagCheckGuaCard,//查看自己的刮刮卡
//    kSXTagBehavior,//用户行为
//    kSXTagExchangeList,//刮刮卡列表
//    kSxTagApplyCard,//申请刮刮卡
    kSxTagRegistMobileCheck,//验证手机号
    kSXTagGetBanner,//获取banner图
    kSxTagRegistNameCheck,//验证用户名
    kSXTagValidpomoCode,//校验工厂码
    KSxtagFriendsRegisterList,  // 好友注册列表
//    kSxTagAllInverstMoney,      // 累计总投资额
//    kSxTagChatFriendList,      // 聊天好友
    kSxTagGongDouInCome, // 工豆收入
    kSxTagGongDouExpend, // 工豆支出
    kSxTagGongDouOverDue, // 工豆过期
    kSXTagGongDouOverDuing,  //即将过期的工豆
    kSxTagHomeTopScrollView,     //首页滚动视图
    kSXTagCheckPomoCode,
//    kSxTagCheckChatYouYunId ,    //检查是否有聊天id
//    kSxTagRegistyouYun,         //注册有云
//    kSxTagGetRedBag,            // 讨红包
//    kSxTagCratchCardisExist,     //判断新春红包
//    kSxTagSmallRedPackage,            //小红包
//    kSxTagKnockedRedPackage,            //抢到的红包
//    kSxTagBigRedPackage,              //大红包
    kSxTagMyRedPackage,               //我的红包
//    kSxTagZiJinTuoGuan,               //资金托管
    kSxTagHSPayMobile,               //易宝支付
//    kSxTagYeePayState,                //易宝订单查询是否成功
    kSXTagKicItemList01,              //获取支付方式字典
    ksxTagPayRecord,                  // 充值记录
//    kSXTagPaySwitch,                  // 充值开关
//    kSXtagBeanRecord,                 // 优惠券
    kSXtagSelectBeansInterest,        // 反息券
    kSXtagSelectBeanRecord,           // 投资选择优惠券
//    kSXtagInventAmt,                  // 根据投资金额取优惠券个数
//    kSXtagBeanAllBorrows,             // 工豆流水
//    kSXtagBeanInCome,                 // 工豆收入
//    kSXtagBeanExpendBorrows,          // 工豆支出
//    kSXtagBeanOverdueBorrows,         // 工豆过期
    kSXtagInviteRebate,               //邀请返利
    kSXtagHuoQuAllYOUHuiQuan,         //获取全部优惠券
//    kSXTagYeeBaoCheckBankNumPass,     //易宝判断银行卡是否通过
    kSXTagSingMenthod,                  //签到
//    kSXTagModifyBankCardZone,           //修改银行卡网点
//    kSXTagRedBagAddress,                // 红包地址
    kSXTagCheckMyMoney,                 //查看我的资金
    kSXTagGetAppSetting,                //获取分享各种信息
    kSXTagTransfersOrder,               //我的债券列表
//    kSXTagIsBetaVerSion,                //校验当前版本是不是beta版
    kSXTagSignDaysAndIsSign,             //签到天数和是否签到
    kSXTagRedBagRainSwitch,             //红包雨开关
    kSXTagGuaGuaPost,                   //刮刮卡
    kSRecommendRefund,                  //好友回款
//    kSXTagCheckCardBelongToBank,        //判断银行卡所属行别
    kAppQueryByManyList,               //多期回款明细
    kSXTagRedPointCheck,                //检测红点状态
    kSXTagCheckPersonRedPoint,          //检测tabbar是否有红点
//    kSXTagGetIgnorgeLogin,             //获取app到wap免登录token
    kSXTagGetMSGCenter,                //获取消息中心列表
    kSXTagGetMSGDetail,                //消息详情
    kSXTagUserDisPermissionIsOpen,     //消息设置-- 用户是否接收短信通知
    kSXTagValidLogin,
    kSXTagUpdateUserDisPermission,     //消息设置-- 更新用户是否接收短信通知
//    kSXTagGetUserCouponFxCount,        //投标获取用户返现和反息券信息
    KSXTagMsgListSignAllRead,          //全部设置为已读
    KSXTagMsgListRemoveTMsg,           //删除消息
    KSXTagMsgListSignRead,             //单条消息标记为已读
//    kSXTagGetRedPointMessage,          //获取所有红点状态
    kSXTagGetWorkPoint,                //获取工豆积分页面信息
    kSXTagContributionValueInvot,      //贡献值
    kSXTagFaceInfoCollection,          //人脸识别录入信息
    kSXTagFaceSwitchStatus,            //人脸识别开关状态查询
    kSXTagFaceSwitchSwip,              //人脸开关操作（需要验签）
    kSXTagFaceInfoLanding,             //人脸识登陆
    kSXTagFaceInfoStore,               //人脸信息是否存在

    kSXTagChoseBranchBank,             //选择支行

    kSXTagChooseBankList,               //获取银行卡列表
    kSXTagGetHSAccountInfo,             //徽商银行存管账户信息查询
    kSXTagGetHSAccountList,             //徽商银行帐户流水
    kSXTagGetOpenAccountInfo,           //获取徽商开户页面信息
    kSXTagOpenAccount,                  //徽商绑定银行卡
    kSXTagSetHSPwd,                     //设置交易密码
    kSXTagIdentifyCode,                 //发送验证码
    kSXTagChosenBranchBank,             //更改支行信息
    kSXTagReplaceBankCardInformation,   //更改绑定银行卡信息
    kSXTagCashRecordList,               //提现记录
    kSXTagBankInfoNew ,                 //获取银行卡信息(新)
    kSXTagRegisterSendCodeAndFindPwd,   //注册和找回密码发送验证码
    kSXTagChangeReserveMobileNumber,    //修改充值预留手机号码
    kSXTagWithdrawSub,                  //提现webView确认
    kSXTagInvestSubmit,                 //投资webView确认
    kSXTagTraClaimsSubmit,              //债转webView确认
    kSXTagSetHsPwdReturnJson,           //设置、修改交易密码通用
    kSXTagWithdrawMoneyValidate,        //提现金额是否超额接口
    kSXTagRegistResult,                 //注册成功活动反的数据
    kSXTagGetRegisterToken,             //获取注册时token 防止重复提交
    kSXTagReturnCouponList,             //返现券列表
    kSXTagReturnCouponList2,            //返息券列表
    kSXTagCouponCertificateList,        //获取兑换券列表
    kSXTagPresentFriend,                //优惠券赠送好友列表
    kSXTagPresentCoupon,                //赠送好友券
    kSXTagPrdClaimsNewVersion,          //首页数据新接口
    kSXTagProjectList,                  //项目列表
    kSXTagTransferList,                 //转让列表
    kSXTagGetContractMsg,               //查看合同详情
    kSXTagGetBatchContractMsg,          //获取批零投标协议
    kSXTagIsShowHornor,                 //是否显示尊享
    kSXTagValidateOldPhoneNo,            //校验注册手机号
    kSXTagDataStatics,                  //数据统计
    kSXTagBatchNumList,                  //查询批量投标最大值额度列表
    kSXTagSetBatchNum,                   //设置投标最大值额度
    kSXTagProjectListBatchBid,          //项目列表中的批量投资列表
    kSXTagMyInvestBatchBid,             //我的投资中的批量投资列表
    kSXTagChildPrdclaimsList,           //集合标子标列表
    kSXTagColPrdclaimsDetail,           //集合标详情
    kSXTagColPrdclaimsList,             //集合标列表
    kSXTagMyBatchInvestDetail,          //我的投资-集合标明细
    kSXTagColIntoDealBatch,              //进入一键投资页面
    kSXTagColBatchInvestUrl,                //一键投标
    kSXTagMyInvestHeaderInfo,            //我的投资头部数据
    kSXTagGetInfoForOnOff,                 // 新手政策开关（0：关，1：开）
    kSXTagProjectHonerPlanList,            //项目列表--尊享计划
    kSXTagHornerTransferList,               //转让列表--尊享转让
    kSXTagGetShareMessage,                  //首页2017新手政策分享注册链接
    kSXTagRegistCheckQUDAO,                 //检查该渠道是否用工场码
    kSXTagGetTokenId,                       //获取放心花界面的token
    kSXTagUserAccountInfo                   //P2P或尊享账户信息
};

typedef enum kSXTag kSXTag;


typedef NS_ENUM(NSInteger, PayType) {  //由哪些界面进入支付流程
    //以下是枚举成员
    NormalType = 0,        //项目及其它
    PayNowTpye = 1,        //立即购买
    ShoppingCartType = 2,  //购物车
    OrderTpye = 3,         //订单
};

@protocol NetworkModuleDelegate<NSObject>

@optional

-(void)beginPost:(kSXTag)tag;
-(void)endPost:(id)result tag:(NSNumber*)tag;
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag;

@end
