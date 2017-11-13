


//
//  NetworkModule.m
//  test
//
//  Created by JasonWong on 13-12-21.
//  Copyright (c) 2013年 Maxitech Ltd. All rights reserved.
//

#import "NetworkModule.h"
#import "GetRequest.h"
#import "Common.h"
#import "Reachability.h"
#import "BaseAlertView.h"
#import "UCFToolsMehod.h"
#import "AuxiliaryFunc.h"
#import "ToolSingleTon.h"
#import "AppDelegate.h"
#import "UITabBar+TabBarBadge.h"
#import "AuxiliaryFunc.h"
#import "JSONKit.h"
#import "UCFLoginViewController.h"
@interface NetworkModule () <UIAlertViewDelegate>
@property (nonatomic, assign) BOOL isShowAlert;
@property (nonatomic, assign) BOOL isShowSingleAlert; //是否已经弹出单设备警告框
@property (nonatomic, assign) kSXTag loseTag;         //失效的接口标示
@end

@implementation NetworkModule

static NetworkModule *gInstance = NULL;

- (id)init
{
    self = [super init];
    if (self) {
        queue = [[NSMutableDictionary alloc] init];
        self.isShowAlert = YES;
        self.isShowSingleAlert = YES;
        
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isReloadNetQuest) name:IS_RELOADE_REQUEST object:nil];

    }
    return self;
}

+ (NetworkModule *)sharedNetworkModule
{
    @synchronized(self)
    {
        if (!gInstance)
            gInstance = [self new];
    }
    return(gInstance);
}

- (BOOL)netReachable
{
    return [UCFToolsMehod connectedToNetwork];
}

- (void)postReq:(NSString*)data tag:(kSXTag)tag owner:(id<NetworkModuleDelegate>)owner Type:(SelectAccoutType)type
{
    NSString *serverIP = P2P_SERVER_IP;
    if (type == SelectAccoutTypeHoner) {
        serverIP = ZX_SERVER_IP;
    }
    NSString *parameter = nil;
    switch ((int)tag) {
        case kSXTagValidLogin:
            parameter = [serverIP stringByAppendingString:VALIDLOGIN];
            break;
        case kSXTagGuaGuaPost:
            parameter = [serverIP stringByAppendingString:GUAGUAPOST];
            break;
        case kSXTagPrdMyTransferDetail:
            parameter = [serverIP stringByAppendingString:MYTRANSFER_DETAIL];
            break;
        case kSXTagGetBanner:
            parameter = [serverIP stringByAppendingString:GET_BARNERREG];
            break;
        case kSXTagValidpomoCode:
            parameter = [serverIP stringByAppendingString:VALIDPOMOCODE];
            break;
        case kSXTagPrdTransfer:  //是否在用 老接口的债转列表
            parameter = [serverIP stringByAppendingString:PRDTRANSFER_LIST];
            break;
        case kSXTagPrdClaimsDetail:
            parameter = [serverIP stringByAppendingString:PRDCLAIMS_DETAIL];
            break;
        case kSXTagPrdTransferDetail:
            parameter = [serverIP stringByAppendingString:PRDTRANSFER_DETAIL];
            break;
        case kSXTagPrdClaimsDealBid:
            parameter = [serverIP stringByAppendingString:PRDCLAIMS_DEALBID];
            break;

        case kSXTagPersonCenter:
            parameter = [serverIP stringByAppendingString:PERSON_CENTER];
            break;
        case kSXTagMoneyOverview:
            parameter = [serverIP stringByAppendingString:MONEY_OVERVIEW];
            break;
        case kSXTagFundsDetail:
            parameter = [serverIP stringByAppendingString:FUNDS_DETAIL];
            break;
        case kSXTagAccountSafe:
            parameter = [serverIP stringByAppendingString:ACCOUNT_SAFE];
            break;
        case kSXTagSendMessageforTicket:
            parameter = [serverIP stringByAppendingString:GET_MESSAGE_TICKET];
            break;
        case kSXTagDealTransferBid:
            parameter = [serverIP stringByAppendingString:DEALTRANSFERBID];
            break;
        case kSXTagKicItemList:
            parameter = [serverIP stringByAppendingString:DICITEMLIST];
            break;
        case kSXTagWorkshopCode:
            parameter = [serverIP stringByAppendingString:WORK_SHOP_CODE];
            break;
        case kSXTagPrdOrderUinvest:
            parameter = [serverIP stringByAppendingString:PRDORDERUINVEST];
            break;
        case kSXTagPrdOrderInvestDetail:
            parameter = [serverIP stringByAppendingString:PRDORDERUINVESTDETAIL];
            break;
        case kSXTagPrdOrderRefundLsit:
            parameter = [serverIP stringByAppendingString:PRDORDERREFUNDLSIT];
            break;
        case kSXTagFriendsList:
            parameter = [serverIP stringByAppendingString:FRIENDS_LIST];
            break;
        case kSXTagPrdClaimsComputeIntrest:
            parameter = [serverIP stringByAppendingString:COMPUTEINTREST];
            break;
        case kSXTagNormalBidComputeIntrest:
            parameter = [serverIP stringByAppendingString:NORMALCOMPUTEINTREST];
            break;
        case kSXTagFactoryCodeSaveRate:
            parameter = [serverIP stringByAppendingString:FACTORYCODESAVERATE];
            break;
        
        case kSXTagCalulateInstallNum:
            parameter = [serverIP stringByAppendingString:CAULATENUM];
            break;
        case kSxTagRegistNameCheck: //检验用户命是否可用 暂时没用
            parameter = [serverIP stringByAppendingString:RIGISTCHECK];
            break;
        case KSxtagFriendsRegisterList:
            parameter = [serverIP stringByAppendingString:FRIENDREGISTERLIST];
            break;
        case kSxTagGongDouInCome:
            parameter = [serverIP stringByAppendingString:GongDouInCome];
            break;
        case kSxTagGongDouExpend:
            parameter = [serverIP stringByAppendingString:GongDouExpend];
            break;
        case kSxTagGongDouOverDue:
            parameter = [serverIP stringByAppendingString:GongDouOverDue];
            break;
        case kSXTagGongDouOverDuing:
            parameter = [serverIP stringByAppendingString:GongDouOverduing];
            break;
        case kSXTagCheckPomoCode:
            parameter = [serverIP stringByAppendingString:CheckPomoCode];
            break;
        case kSxTagMyRedPackage:
            parameter = [serverIP stringByAppendingString:MyRedPackage];
            break;
        case kSXTagKicItemList01:
            parameter = [serverIP stringByAppendingString:DICITEMLIST];
            break;
        case ksxTagPayRecord:
            parameter = [serverIP stringByAppendingString:PAYRECORD];
            break;
        case kSXtagSelectBeanRecord:
            parameter = [serverIP stringByAppendingString:COUPSELECTBYOWER];
            break;
        case kSXtagSelectBeansInterest:
            parameter = [serverIP stringByAppendingString:BEANSINTEREST];
            break;
        case kSXtagHuoQuAllYOUHuiQuan:
            parameter = [serverIP stringByAppendingString:ALLYOUHUIQUANLIST];
            break;
        case kSXTagSingMenthod:
            parameter = [serverIP stringByAppendingString:SingMenthod];
            break;
        case kSXTagCheckMyMoney:
            parameter = [serverIP stringByAppendingString:CHECKMYMONEY];
            break;
        case kSXTagGetAppSetting:
            parameter = [serverIP stringByAppendingString:GetAppSetting];
            break;
        case kSXTagTransfersOrder:
            parameter = [serverIP stringByAppendingString:TransfersOrder];
            break;
        case kSXTagSignDaysAndIsSign:
            parameter = [serverIP stringByAppendingString:SignDaysAndIsSign];
            break;
        case kSRecommendRefund:
            parameter = [serverIP stringByAppendingString:RecommendRefund];
            break;

        case kAppQueryByManyList:
            parameter = [serverIP stringByAppendingString:GETAppQueryByManyList];
            break;
        case kSXTagRedPointCheck:
            parameter = [serverIP stringByAppendingString:CHECKREDPOINTHIDE];
            break;
        case kSXTagCheckPersonRedPoint:
            parameter = [serverIP stringByAppendingString:CHECKPERSONCENTERREDALERT];
            break;
        case kSXTagGetMSGDetail:
            parameter = [serverIP stringByAppendingString:MSGCENTERDETAIL];
            break;
        case kSXTagUserDisPermissionIsOpen:
            parameter = [serverIP stringByAppendingString:USERDISPERMISSIONISOPEN];
            break;
        case kSXTagUpdateUserDisPermission:
            parameter = [serverIP stringByAppendingString:UPDATEUSERDISPERMISSION];
            break;
        case KSXTagMsgListSignRead:
            parameter = [serverIP stringByAppendingString:MSGSIGNREAD];
            break;
        case kSXTagFaceInfoCollection:
            parameter = [serverIP stringByAppendingString:FACEINFOCOLLECTION];
            break;
        case kSXTagFaceSwitchStatus:
            parameter = [serverIP stringByAppendingString:FACESWITCHSTAUS];
            break;
        case kSXTagFaceSwitchSwip:
            parameter = [serverIP stringByAppendingString:FACEUPDATESWITCHSWIP];
            break;
        case kSXTagFaceInfoLanding:
            parameter = [serverIP stringByAppendingString:FACEINFOLANDING];
            break;
        case kSXTagFaceInfoStore:
            parameter = [serverIP stringByAppendingString:FACEINFOSTORE];
            break;
        case kSXTagRegistResult:
            parameter = [serverIP stringByAppendingString:REGISTRESULT];
            break;
        case kSXTagGetContractMsg:
            parameter = [serverIP stringByAppendingString:GETCONTRACTMSG];
            break;
        case kSXTagGetBatchContractMsg:
            parameter = [serverIP stringByAppendingString:GetBatchContractMsg];
            break;
        case kSXTagMyInvestHeaderInfo:
            parameter = [serverIP stringByAppendingString:MYINVESTHEADERINFO];
            break;
        case kSXTagRegistCheckQUDAO:
            parameter = [serverIP stringByAppendingString:RegistCheckQdIsLimit];
            break;
        case kSXTagContractDownLoad:
            parameter = [serverIP stringByAppendingString:DOWNLOADCONTRACT];
            break;

    }

    NSArray * array = [NSArray arrayWithObjects:@"newPrdClaims/dataList",@"newaccount/userLevelIsOpen",@"newprdTransfer/dataList",@"newPrdTransfer/getDetail",@"newuser/login",@"newsendmessage",@"newuserregist/isexitpomocode",@"newuserregist/regist",@"userregist/verification",@"newgetSendMessageTicket",@"bankCard/baseBankMess",@"personalSettings/getTRegionList",@"sysDataDicItem/dicItemList",@"sysDataDicItem/allDicItemList",@"scratchCard/isExist",@"newuserregist/modifyUserpwd",@"newprdTransfer/newCompensateInterest",@"appInstallCount/save",@"newuserregist/checkQdIslimit", nil];

    NSArray * strArray = [parameter componentsSeparatedByString:serverIP];
    NSString *par = [strArray objectAtIndex:1];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        if (data.length > 0) {
            data = [data stringByAppendingString:[NSString stringWithFormat:@"&jg_nyscclnjsygjr=%@",[UserInfoSingle sharedManager].jg_ckie]];
        } else {
            data = [data stringByAppendingString:[NSString stringWithFormat:@"jg_nyscclnjsygjr=%@",[UserInfoSingle sharedManager].jg_ckie]];
        }
    }
    if([array containsObject:par])
    {
        if (tag == kSXTagUserRegist) {
            //不需要验签，需要AES 加密
            NSString * encryptParam = [Common  AESWithKey:[Common getKeychain] WithData:data];
            data = [NSString stringWithFormat:@"encryptParam=%@",encryptParam];
        }
        //不需要验签，AES 加密
        data = [data stringByAppendingString:[NSString stringWithFormat:@"&imei=%@&version=%@",[Common getKeychain],[Common getIOSVersion]]];
        data = [data stringByAppendingString:@"&source_type=1"];
        [self postData:data tag:tag owner:owner url:parameter];
    }
    else
    {
        if (tag == kSXTagValidLogin) {
            //需要验签 需要AES
            NSString * encryptParam  = [Common  AESWithKey:[Common getKeychain] WithData:data];
            NSString * encryptParam1 = [Common AESWithKeyWithNoTranscode:[Common getKeychain] WithData:data];
            data = [NSString stringWithFormat:@"encryptParam=%@",encryptParam1];
            data = [data stringByAppendingString:[NSString stringWithFormat:@"&imei=%@&version=%@",[Common getKeychain],[Common getIOSVersion]]];
            data = [data stringByAppendingString:@"&source_type=1"];
            data = [data stringByAppendingString:[NSString stringWithFormat:@"&userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]]];
            NSString *signature = [self getSinatureWithPar:[self getParStr:data]];
            data = [NSString stringWithFormat:@"encryptParam=%@",encryptParam];
            data = [data stringByAppendingString:[NSString stringWithFormat:@"&imei=%@&version=%@",[Common getKeychain],[Common getIOSVersion]]];
            data = [data stringByAppendingString:@"&source_type=1"];
            data = [data stringByAppendingString:[NSString stringWithFormat:@"&userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]]];
            data = [data stringByAppendingString:[NSString stringWithFormat:@"&signature=%@",signature]];
        }
        else {
             //需要验签 不需要AES
            data = [data stringByAppendingString:@"&source_type=1"];
            data = [data stringByAppendingString:[NSString stringWithFormat:@"&imei=%@&version=%@",[Common getKeychain],[Common getIOSVersion]]];
            NSString *signature = [self getSinatureWithPar:[self getParStr:data]];
            data = [data stringByAppendingString:[NSString stringWithFormat:@"&signature=%@",signature]];
        }
        [self postData:data tag:tag owner:owner url:parameter];
    }
}

- (void)postData:(NSString*)data tag:(kSXTag)tag owner:(id<NetworkModuleDelegate>)owner url:(NSString*)url
{
    PostRequest *req = (PostRequest*)[queue objectForKey:[NSNumber numberWithInt:tag]];
    if (tag == kSXTagPersonCenter || tag == kSXTagGetInfoForOnOff) {
        if (req.postStatus == kPostStatusBeging) {
            return;
        }
    }
    if (req == nil) {
        req = [[PostRequest alloc] init];
    }
  
    req.sxTag = tag;
    req.postStatus = kPostStatusNone;
    [queue setObject:req forKey:[NSNumber numberWithInt:tag]];
    req.enc = NSUTF8StringEncoding;
    req.owner = owner;
    req.url = url;
    req.parmData = data;
    DBLOG(@"%@",url);

    [req postData:data delegate:self];

}

- (void)cancel:(kSXTag)tag
{
    PostRequest* req = (PostRequest*)[queue objectForKey:[NSNumber numberWithInt:tag]];
    if (req && [req isKindOfClass:[PostRequest class]]) {
        req.owner = nil;
        [req cancel];
    }
}


//zhangrc 添加GET请求
- (void)getReqData:(NSDictionary *)dataDict tag:(kSXTag)tag owner:(id<NetworkModuleDelegate>)owner
{
    NSString *url = nil;
    switch (tag) {
        case kSxTagHomeTopScrollView:
            url = @"http://fore.9888.cn/cms/api/appbanner.php";
            break;
        default:
            break;
    }
    [self getReqData:dataDict tag:tag owner:owner url:url];
}
- (void)getReqData:(NSDictionary *)dataDict tag:(kSXTag)tag owner:(id<NetworkModuleDelegate>)owner url:(NSString *)url
{
    GetRequest *req = (GetRequest*)[queue objectForKey:[NSNumber numberWithInt:tag]];
    if (req == nil) {
        req = [[GetRequest alloc] init];
    }
    [queue setObject:req forKey:[NSNumber numberWithInt:tag]];
    req.owner = owner;
    req.sxTag = tag;
    if (dataDict) {
        url = [NSString stringWithFormat:@"%@?",url];
        url = [url stringByAppendingString:[self dictTransToString:dataDict]];
    }
    [req getData:url delegate:self];
}
- (NSString *)dictTransToString:(NSDictionary *)dict
{
    if (dict) {
        NSArray *allKeys = [dict allKeys];
        NSMutableString *urlString = [[[NSMutableString alloc] initWithString:@""] autorelease];
        for (int i=0; i<allKeys.count;i++) {
            NSString *keyStr = [allKeys objectAtIndex:i];
            if (allKeys.count == 1) {
                NSString *tmpString = [NSString stringWithFormat:@"%@=%@",keyStr,[dict objectForKey:keyStr]];
                return tmpString;
            } else {
                if (i != allKeys.count-1) {
                    NSString *tmpString = [NSString stringWithFormat:@"%@=%@&",keyStr,[dict objectForKey:keyStr]];
                    [urlString stringByAppendingString:tmpString];
                } else {
                    NSString *tmpString = [NSString stringWithFormat:@"%@=%@&",keyStr,[dict objectForKey:keyStr]];
                    [urlString stringByAppendingString:tmpString];
                }
            }
            
        }
        return urlString;
    }
    return @"";
}
- (void)getReqCancle:(kSXTag)tag
{
    GetRequest * req = (GetRequest*)[queue objectForKey:[NSNumber numberWithInt:tag]];
    if (req && [req isKindOfClass:[GetRequest class]]) {
        req.owner = nil;
        [req cancel];
    }
    
}
// 请求结束，获取 Response 数据
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if ([request.requestMethod isEqualToString:@"GET"]) {
        GetRequest *req = (GetRequest*)[queue objectForKey:[NSNumber numberWithInteger:request.tag]];
        SEL sel = @selector(endPost:tag:);
        NSData *data = [request responseData];
        NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        [req.owner performSelector:sel withObject:string withObject:[NSNumber numberWithInt: req.sxTag]];
        req.owner = nil;
    }
    else
    {
        PostRequest *req = (PostRequest*)[queue objectForKey:[NSNumber numberWithInteger:request.tag]];
        req.postStatus = kPostStatusEnded;
        if (req.owner != nil) {
            SEL sel = @selector(endPost:tag:);
            if ([req.owner respondsToSelector:sel]) {
                NSString *data = req.result;
//                if (data.length == 0) {
//                    [MBProgressHUD displayHudError:@"网络异常"];
//                }
                NSMutableDictionary *dic = [data objectFromJSONString];
                //新格式接口
                if ([[dic allKeys] containsObject:@"ret"]) {
                    [self skipToNewApiResponseData:req withDataDic:dic];
                } else {
                    [self skipToOldApiResponseData:req withDataDic:dic];
                }
            }
        }
    }
}
// 新接口数据处理方式
-(void)skipToNewApiResponseData:(PostRequest *)req withDataDic:(NSDictionary *)dic
{
    SEL sel = @selector(endPost:tag:);
    if ([[dic valueForKey:@"ret"] boolValue]) {
        [req.owner performSelector:sel withObject:req.result withObject:[NSNumber numberWithInt: req.sxTag]];
        req.owner = nil;
    } else {
        _loseTag = req.sxTag;
        NSInteger rstcode = [dic[@"code"] integerValue];
        if (rstcode == -1) {
            SEL sel = @selector(errorPost:tag:);
            if ([req.owner respondsToSelector:sel]) {
                [req.owner performSelector:sel withObject:nil withObject:[NSNumber numberWithInt: req.sxTag]];
                req.owner = nil;
                req.parmData = nil;
                if (req.sxTag == kSXTagGetBanner) {
                    
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"message"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        } else if (rstcode == -2 || rstcode == -3 || rstcode == -4) {
            SEL sel = @selector(errorPost:tag:);
            if ([req.owner respondsToSelector:sel]) {
                [req.owner performSelector:sel withObject:nil withObject:[NSNumber numberWithInt: req.sxTag]];
                req.owner = nil;
            }
            //清空数据
            [self cleanData];
            if (self.isShowSingleAlert) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"message"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
                alertView.tag = 0x100;
                [alertView show];
            }
            self.isShowSingleAlert = NO;
        } else if (rstcode == -5) {
            //强制更新
            if (self.isShowAlert) {
                self.isShowAlert = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_NEW_VERSION object:nil];
            }
            else return;
        } else if (rstcode == -6) {
            SEL sel = @selector(errorPost:tag:);
            if ([req.owner respondsToSelector:sel]) {
                [req.owner performSelector:sel withObject:nil withObject:[NSNumber numberWithInt: req.sxTag]];
                req.owner = nil;
            }
            //清空数据
            [self cleanData];
            if (self.isShowSingleAlert) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"message"] delegate:self cancelButtonTitle:@"联系客服" otherButtonTitles:@"重新登录", nil];
                alertView.tag = 0x101;
                [alertView show];
            }
            self.isShowSingleAlert = NO;
        }  else {
            [req.owner performSelector:sel withObject:req.result withObject:[NSNumber numberWithInt: req.sxTag]];
            req.owner = nil;
        }
    }
}
//旧接口数据处理方式
- (void)skipToOldApiResponseData:(PostRequest *)req withDataDic:(NSDictionary *)dic
{
    SEL sel = @selector(endPost:tag:);
    NSInteger rstcode = [dic[@"status"] integerValue];
    if (rstcode  == 1 || req.sxTag == kSXTagUserLogout) {
        [req.owner performSelector:sel withObject:req.result withObject:[NSNumber numberWithInt: req.sxTag]];
        req.owner = nil;
        req.parmData = nil;
        
    } else if (rstcode == -1) {
        _loseTag = req.sxTag;
        SEL sel = @selector(errorPost:tag:);
        if ([req.owner respondsToSelector:sel]) {
            [req.owner performSelector:sel withObject:nil withObject:[NSNumber numberWithInt: req.sxTag]];
            req.owner = nil;
            if (req.sxTag == kSXTagGetBanner) {
                
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    } else if (rstcode == -2 || rstcode == -3 || rstcode == -4) {
        _loseTag = req.sxTag;
        SEL sel = @selector(errorPost:tag:);
        if ([req.owner respondsToSelector:sel]) {
            [req.owner performSelector:sel withObject:nil withObject:[NSNumber numberWithInt: req.sxTag]];
            req.owner = nil;
        }
        //清空数据
        [self cleanData];
        if (self.isShowSingleAlert) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
            alertView.tag = 0x100;
            [alertView show];
        }
        self.isShowSingleAlert = NO;
    }  else if (rstcode == -5) {
        //强制更新
        if (self.isShowAlert) {
            self.isShowAlert = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_NEW_VERSION object:nil];
        }
        else return;
    } else if (rstcode == -6) {
        _loseTag = req.sxTag;
        SEL sel = @selector(errorPost:tag:);
        if ([req.owner respondsToSelector:sel]) {
            [req.owner performSelector:sel withObject:nil withObject:[NSNumber numberWithInt: req.sxTag]];
            req.owner = nil;
        }
        //清空数据
        [self cleanData];
        if (self.isShowSingleAlert) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:dic[@"statusdes"] delegate:self cancelButtonTitle:@"联系客服" otherButtonTitles:@"重新登录", nil];
            alertView.tag = 0x101;
            [alertView show];
        }
        self.isShowSingleAlert = NO;
    }
    else {
//        [MBProgressHUD displayHudError:req.result];
        [req.owner performSelector:sel withObject:req.result withObject:[NSNumber numberWithInt: req.sxTag]];
        req.owner = nil;
    }
}

//清空数据
- (void)cleanData{
    //退出时清cookis
    
    [Common deleteCookies];
    [[UserInfoSingle sharedManager] removeUserInfo];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:UUID];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:TIME];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:IDCARD_STATE];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:BANKCARD_STATE];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FACESWITCHSTATUS];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"changScale"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:REGIST_JPUSH object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setDefaultViewData" object:nil];
}

// 请求失败，获取 error
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if ([request.requestMethod isEqualToString:@"GET"]) {
          GetRequest *req = (GetRequest*)[queue objectForKey:[NSNumber numberWithInteger:request.tag]];
          NSError *error = [request error];
          if (req.owner != nil) {
              SEL sel = @selector(errorPost:tag:);
              if ([req.owner respondsToSelector:sel]) {
                  [req.owner performSelector:sel withObject:error withObject:[NSNumber numberWithInt: req.sxTag]];
                  req.owner = nil;
              }
          }
    } else {
        PostRequest *req = (PostRequest*)[queue objectForKey:[NSNumber numberWithInteger:request.tag]];
        NSError *error = [request error];
        req.postStatus = kPostStatusError;
        if (req.owner != nil) {
            SEL sel = @selector(errorPost:tag:);
            if ([req.owner respondsToSelector:sel]) {
                [req.owner performSelector:sel withObject:error withObject:[NSNumber numberWithInt: req.sxTag]];
                req.owner = nil;
            }
        }
    }

}
//新版通过字典获取值拼成的字符串
- (NSString *)newGetParStr:(NSDictionary *)dataDict
{
    NSArray *valuesArr = [dataDict allValues];
    NSString *lastStr = @"";
    if (!valuesArr || valuesArr.count > 0) {
        for (int i = 0; i< valuesArr.count; i++) {
            lastStr = [lastStr stringByAppendingString:[valuesArr objectAtIndex:i]];
        }
    }
    return lastStr;
}
//老版通过字符串获取值拼成的字符串，有隐患，如果参数出现& 就会报错，所以用新的newGetParStr
-(NSString *) getParStr:(NSString *) str
{
    NSArray * array = [str componentsSeparatedByString:@"&"];
    if(array.count == 1)
    {
        NSArray * lastArray = [[array objectAtIndex:0] componentsSeparatedByString:@"="];
        return [lastArray objectAtIndex:1];
    }
    else
    {
        NSString *lastStr = @"";
        for(NSString * str in array)
        {
            if (str.length > 0) {
                if ([str rangeOfString:@"="].location !=NSNotFound) {
                    NSRange range = [str rangeOfString:@"="];
                    str = [str substringWithRange:NSMakeRange(range.location + 1, str.length-range.location-1)];
                    lastStr =[lastStr stringByAppendingString:str];
                }
            }
        }
        
        return lastStr;
    }
}
-(NSString *) getSinatureWithPar:(NSString *) par
{
    NSString *lastStr = [NSString stringWithFormat:@"%@%@",par,[[NSUserDefaults standardUserDefaults] valueForKey:SIGNATUREAPP]];
//    NSString *stttt  = [[NSUserDefaults standardUserDefaults] valueForKey:SIGNATUREAPP];
    //遍历字符串中的每一个字符
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<[lastStr length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [lastStr substringWithRange:NSMakeRange(i, 1)];
        [array addObject:[NSString stringWithFormat:@"%@",s]];
    }
    NSArray *lastArray =[array sortedArrayUsingSelector:@selector(compare:)];
    NSString * str55 = [lastArray componentsJoinedByString:@","];
    NSString *str66 = @"[";
    NSString *str77 = @"]";
    NSString *str88 = [[str66 stringByAppendingString:str55] stringByAppendingString:str77];
    
    return [UCFToolsMehod md5:str88];
}



-(void)dealloc{
    [queue release];
    [super dealloc];
}

- (void)postReq2:(NSDictionary*)data tag:(kSXTag)tag owner:(id<NetworkModuleDelegate>)owner
{
    NSString *dataStr;
    NSString *parameter = nil;
    switch ((int)tag) {
        case kSXTagValidBindedPhone:
            parameter = [P2P_SERVER_IP stringByAppendingString:VALID_BINDED_PHONE];
            break;
    }
    
    NSArray * array = [NSArray arrayWithObjects:@"prdClaims/dataList",@"prdTransfer/dataList",@"newPrdTransfer/getDetail",@"newuser/login",@"newsendmessage",@"newuserregist/isexitpomocode",@"newuserregist/regist",@"userregist/verification",@"newgetSendMessageTicket",@"bankCard/baseBankMess",@"personalSettings/getTRegionList",@"sysDataDicItem/dicItemList",@"sysDataDicItem/allDicItemList",@"scratchCard/isExist",@"newuserregist/modifyUserpwd",@"newprdTransfer/newCompensateInterest", nil];
    
    NSArray * strArray = [parameter componentsSeparatedByString:P2P_SERVER_IP];
    NSString *par = [strArray objectAtIndex:1];
    
    if([array containsObject:par])
    {
        dataStr = [dataStr stringByAppendingString:[NSString stringWithFormat:@"&imei=%@&version=%@",[Common getKeychain],[Common getIOSVersion]]];
        dataStr = [dataStr stringByAppendingString:@"&source_type=1"];
        [self postData:dataStr tag:tag owner:owner url:parameter];
    }
    else
    {
        if (tag == kSXTagValidBindedPhone) {
            //空格转换成%2B
            NSString * encryptParam  = [Common  AESWithKey2:[Common getKeychain] WithDic:data];
            //空格转换成+
            NSString * encryptParam1 = [Common AESWithKeyWithNoTranscode2:[Common getKeychain] WithData:data];
            dataStr = [NSString stringWithFormat:@"encryptParam=%@",encryptParam1];
            dataStr = [dataStr stringByAppendingString:[NSString stringWithFormat:@"&imei=%@&version=%@",[Common getKeychain],[Common getIOSVersion]]];
            dataStr = [dataStr stringByAppendingString:@"&source_type=1"];
            dataStr = [dataStr stringByAppendingString:[NSString stringWithFormat:@"&userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]]];
            NSString *signature = [self getSinatureWithPar:[self getParStr:dataStr]];
            dataStr = [NSString stringWithFormat:@"encryptParam=%@",encryptParam];
            dataStr = [dataStr stringByAppendingString:[NSString stringWithFormat:@"&imei=%@&version=%@",[Common getKeychain],[Common getIOSVersion]]];
            dataStr = [dataStr stringByAppendingString:@"&source_type=1"];
            dataStr = [dataStr stringByAppendingString:[NSString stringWithFormat:@"&userId=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID]]];
            dataStr = [dataStr stringByAppendingString:[NSString stringWithFormat:@"&signature=%@",signature]];
        }
        [self postData:dataStr tag:tag owner:owner url:parameter];
    }
}
//唤起登陆框
- (void)shouLoginView
{
    [MBProgressHUD hideAllHUDsForView:nil animated:NO];
    UCFLoginViewController *loginViewController = [[[UCFLoginViewController alloc] init] autorelease];
    loginViewController.isForce = YES;
    UINavigationController *loginNaviController = [[[UINavigationController alloc] initWithRootViewController:loginViewController] autorelease];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = app.tabBarController.selectedViewController ;
    if (app.tabBarController.presentedViewController)
    {
        NSString *className =  [NSString stringWithUTF8String:object_getClassName(app.tabBarController.presentedViewController)];
        if ([className hasSuffix:@"UINavigationController"]) {
            [app.tabBarController dismissViewControllerAnimated:NO completion:^{
                [nav popToRootViewControllerAnimated:NO];
                [app.tabBarController setSelectedIndex:0];
            }];
        }
    }
    else
    {
        [nav popToRootViewControllerAnimated:NO];
        [app.tabBarController setSelectedIndex:0];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [app.tabBarController presentViewController:loginNaviController animated:YES completion:nil];

    });
}

// 提示框的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0x100) {
        if(buttonIndex == 0){//取消
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            NSUInteger selectedIndex = appDelegate.tabBarController.selectedIndex;
            UINavigationController *nav = [appDelegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
            [nav popToRootViewControllerAnimated:NO];
            [appDelegate.tabBarController setSelectedIndex:0];
        } else {//重新登录
            [self shouLoginView];
        }
        self.isShowSingleAlert = YES;
    } else if (alertView.tag == 0x101) {
        if (buttonIndex == 0) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000322988"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            NSUInteger selectedIndex = app.tabBarController.selectedIndex;
            UINavigationController *nav = [app.tabBarController.viewControllers objectAtIndex:selectedIndex];
            if (app.tabBarController.presentedViewController)
            {
                NSString *className =  [NSString stringWithUTF8String:object_getClassName(app.tabBarController.presentedViewController)];
                if ([className hasSuffix:@"UINavigationController"]) {
                    [app.tabBarController dismissViewControllerAnimated:NO completion:^{
                        [nav popToRootViewControllerAnimated:NO];
                        [app.tabBarController setSelectedIndex:0];
                    }];
                }
            }
            else
            {
                [nav popToRootViewControllerAnimated:NO];
                [app.tabBarController setSelectedIndex:0];
            }
        }
        else {
            [self shouLoginView];
        }
        self.isShowSingleAlert = YES;
    } else {
        // 升级新版本 退出应用
        NSURL *url = [NSURL URLWithString:APP_RATING_URL];
        [[UIApplication sharedApplication] openURL:url];
        AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [dele exitApplication];
    }
}

#pragma mark - V3_NewPostMethod
- (void)newPostReq:(NSDictionary*)data tag:(kSXTag)tag owner:(id<NetworkModuleDelegate>)owner signature:(BOOL)isSignature Type:(SelectAccoutType)type
{
    NSString *parameter = nil;
    switch ((int)tag) {
        case kSXTagUserRegist:
            parameter = [NEW_SERVER_IP stringByAppendingString:USER_REGIST];
            break;
        case kSXTagCashAdvance:
            parameter = [NEW_SERVER_IP stringByAppendingString:ACT_WITHDRAW];
            break;
        case kSXTagChooseBankList:
            parameter = [NEW_SERVER_IP stringByAppendingString:CHOOSEBANKLIST];
            break;
        case kSXTagLogin:
            parameter = [NEW_SERVER_IP stringByAppendingString:LOGIn_ARGU];
            break;
        case kSXTagGetHSAccountInfo:
            
            parameter = [NEW_SERVER_IP stringByAppendingString:GETHSACCOUNTINfO];
            break;
        case kSXTagGetOpenAccountInfo:
            parameter = [NEW_SERVER_IP stringByAppendingString:GETOPENACCOUNTINfO];
            break;
        case kSXTagOpenAccount:
            parameter = [NEW_SERVER_IP stringByAppendingString:OPENACCOUNT];
            break;
        case kSXTagSetHSPwd:
            parameter = [NEW_SERVER_IP stringByAppendingString:SETHSPWD];
            break;
        case kSXTagChoseBranchBank:
            parameter = [NEW_SERVER_IP stringByAppendingString:CHOSEBRANCHBANK];
            break;
        case kSXTagBankTopInfo:
            parameter = [NEW_SERVER_IP stringByAppendingString:BANK_TOP_INFO];
            break;
        case kSXTagWithdrawalsSendPhone:
            parameter = [NEW_SERVER_IP stringByAppendingString:DrawalsSendPhone];
            break;
        case kSXTagGetHSAccountList:
            parameter = [NEW_SERVER_IP stringByAppendingString:GETHSACCOUNTLIST];
            break;
        case kSXTagIdentifyCode:
            parameter = [NEW_SERVER_IP stringByAppendingString:IDENTIFYCODE];
            break;
        case kSxTagHSPayMobile:
            parameter = [NEW_SERVER_IP stringByAppendingString:HSPayMobile];
            break;
        case kSXTagChosenBranchBank:
            parameter = [NEW_SERVER_IP stringByAppendingString:CHOSENBRANCHBANK];
            break;
        case kSXTagPrdClaimsSaveDeals:
            parameter = [NEW_SERVER_IP stringByAppendingString:PRDCLAIMS_SAVEDEALS];
            break;
        case kSXTagReplaceBankCardInformation:
            parameter = [NEW_SERVER_IP stringByAppendingString:REPLACEBANKCARDINFORMATION];
            break;
        case kSXTagCashRecordList:
            parameter = [NEW_SERVER_IP stringByAppendingString:CASHRECODLIST];
            break;
        case kSXTagBankInfoNew:
            parameter = [NEW_SERVER_IP stringByAppendingString:BANK_INFO_New];
            break;
        case kSXTagRegisterSendCodeAndFindPwd:
            parameter = [NEW_SERVER_IP stringByAppendingString:REGISTERSENDCODE];
            break;
        case kSXTagChangeReserveMobileNumber:
            parameter = [NEW_SERVER_IP stringByAppendingString:MODIYRESERVEMOBILE];
            break;
        case kSXTagWithdrawSub:
            parameter = [NEW_SERVER_IP stringByAppendingString:WITHDRAWSUB];
            break;
        case kSXTagInvestSubmit:
            parameter = [NEW_SERVER_IP stringByAppendingString:INVESTSUBMIT];
            break;
        case kSXTagTraClaimsSubmit:
            parameter = [NEW_SERVER_IP stringByAppendingString:TRACLAIMSSUBMIT];
            break;
        case kSXTagSetHsPwdReturnJson:
            parameter = [NEW_SERVER_IP stringByAppendingString:SETHSPWDRETNRNJSON];
            break;
        case kSXTagWithdrawMoneyValidate:
            parameter = [NEW_SERVER_IP stringByAppendingString:WITHDRAWMONEYVALIDATE];
            break;
        case kSXTagGetRegisterToken:
            parameter = [NEW_SERVER_IP stringByAppendingString:GETREGISTERTOKEN];
            break;
        case kSXTagUpdatePwd:
            parameter = [NEW_SERVER_IP stringByAppendingString:CHANGE_PWD];
            break;
        case KSXTAGVERFIUSERNAMEANDPHONE:
            parameter = [NEW_SERVER_IP stringByAppendingString:VERIFINAMEANDPASS];
            break;
        case kSXTagChangedPwd:
            parameter = [NEW_SERVER_IP stringByAppendingString:MODIFI_PWD];
            break;
        case kSXTagReturnCouponList:
            parameter = [NEW_SERVER_IP stringByAppendingString:REURNCOUPONLIST];
            break;
        case kSXTagReturnCouponList2:
            parameter = [NEW_SERVER_IP stringByAppendingString:REURNCOUPONLIST];
            break;
        case kSXTagCouponCertificateList:
            parameter = [NEW_SERVER_IP stringByAppendingString:COUPONCERTIFICATE];
            break;
        case kSXTagPresentFriend:
            parameter = [NEW_SERVER_IP stringByAppendingString:PRESENTFRIEND];
            break;
        case kSXTagPresentCoupon:
            parameter = [NEW_SERVER_IP stringByAppendingString:PRESENTCOUPON];
            break;
        case kSXTagPrdClaimsNewVersion:
            parameter = [NEW_SERVER_IP stringByAppendingString:PRDCLAIMS_LISTNEWVERSION];
            break;
        case kSXTagProjectList:
            parameter = [NEW_SERVER_IP stringByAppendingString:PROJECTLIST];
            break;
        case kSXTagProjectHonerPlanList:
            parameter = [NEW_SERVER_IP stringByAppendingString:PROJECTLIST];
            break;
        case kSXTagTransferList:
            parameter = [NEW_SERVER_IP stringByAppendingString:TRANSFERLIST];
            break;
        case kSXTagHornerTransferList:
            parameter = [NEW_SERVER_IP stringByAppendingString:TRANSFERLIST];
            break;
        case kSXtagInviteRebate:
            parameter = [NEW_SERVER_IP stringByAppendingString:INVITEREBATE];
            break;
        case kSXTagIsShowHornor: {
            parameter = [NEW_SERVER_IP stringByAppendingString:ISSHOWHORNOR];
        }
            break;
        case kSXTagValidateOldPhoneNo: {
            parameter = [NEW_SERVER_IP stringByAppendingString:VALIDATEOLDPHONENO];
        }
            break;
        case kSXTagDataStatics: {
            parameter = [NEW_SERVER_IP stringByAppendingString:DATASTATICS];
        }
            break;
        case kSXTagRedBagRainSwitch: {
            parameter = [NEW_SERVER_IP stringByAppendingString:REDBAGRAIN];
        }
            break;
        case kSXTagUpdateMobile: {
            parameter = [NEW_SERVER_IP stringByAppendingString:UPDATE_TEL];
        }
            break;
        case kSXTagGetWorkPoint: {
            parameter = [NEW_SERVER_IP stringByAppendingString:GETWORKPOINT];
        }
            break;
        case kSXTagBatchNumList: {
            parameter = [NEW_SERVER_IP stringByAppendingString:GetBatchInvestLimit];
        }
            break;
        case kSXTagSetBatchNum: {
            parameter = [NEW_SERVER_IP stringByAppendingString:SetBatchInvestNum];
        }
            break;
        case kSXTagProjectListBatchBid: {
            parameter = [NEW_SERVER_IP stringByAppendingString:PROJECTLISTBATCHBID];
        }
            break;
        case kSXTagMyInvestBatchBid: {
            parameter = [NEW_SERVER_IP stringByAppendingString:MYINVESTBATCHBID];
        }
            break;
        case kSXTagChildPrdclaimsList: {
            parameter = [NEW_SERVER_IP stringByAppendingString:CHILDPRDCLAIMSLIST];
        }
            break;
        case kSXTagColPrdclaimsDetail: {
            parameter = [NEW_SERVER_IP stringByAppendingString:COLPRDCLAIMSDETAIL];
        }
            break;
        case kSXTagColPrdclaimsList: {
            parameter = [NEW_SERVER_IP stringByAppendingString:COLPRDCLAIMSLIST];
        }
            break;
        case kSXTagMyBatchInvestDetail: {
            parameter = [NEW_SERVER_IP stringByAppendingString:MYBATCHINVESTDETAIL];
        }
            break;
        case kSXTagColIntoDealBatch: {
            parameter = [NEW_SERVER_IP stringByAppendingString:INTODEALBATCH];
        }
            break;
        case kSXTagColBatchInvestUrl: {
            parameter = [NEW_SERVER_IP stringByAppendingString:BATCHINVESTURL];
        }
            break;
        case kSXTagGetInfoForOnOff: {
            parameter = [NEW_SERVER_IP stringByAppendingString:GETINFOFORONOFF];
        }
            break;
        case kSXTagGetShareMessage: {
            parameter = [NEW_SERVER_IP stringByAppendingString:GETSHAREMESSAGE];
        }
            break;
        case kSXTagGetTokenId: {
            parameter = [NEW_SERVER_IP stringByAppendingString:GETTOKENID];
        }
            break;
        case kSXTagRegistResult: {
            parameter = [NEW_SERVER_IP stringByAppendingString:REGISTRESULT];
        }
            break;
        case kSXTagPersonCenter: {
            parameter = [NEW_SERVER_IP stringByAppendingString:PERSON_CENTER];
        }
            break;
        case kSXTagUserAccountInfo: {
            parameter = [NEW_SERVER_IP stringByAppendingString:USERACOUNTINFOURL];
        }
            break;
        case kSXTagContributionValueInvot:
            parameter = [NEW_SERVER_IP stringByAppendingString:GETCONTRIBUTIONVALUEINVOT];
            break;
        case kSXTagAccountSafe:{
            parameter = [NEW_SERVER_IP stringByAppendingString:ACCOUNT_SAFE];
        }
            break;
        case KSXTagMsgListSignAllRead:
            parameter = [NEW_SERVER_IP stringByAppendingString:MSGSIGNALLREAD];
            break;
        case KSXTagMsgListSignRead:
            parameter = [NEW_SERVER_IP stringByAppendingString:MSGSIGNREAD];
            break;
        case KSXTagMsgListRemoveTMsg:
            parameter = [NEW_SERVER_IP stringByAppendingString:MSGREOMETMSG];
            break;
        case kSXTagGetMSGCenter:
            parameter = [NEW_SERVER_IP stringByAppendingString:MSGCENTER];
            break;
        case kSXTagIdentifyCard:
            parameter = [NEW_SERVER_IP stringByAppendingString:IDNO_CHECKINFO];
            break;
            
        case kSXTagSingMenthod: {
//            NSString *url = @"http://10.105.6.203:8080/mpapp/";
            parameter = [NEW_SERVER_IP stringByAppendingString:SingMenthod];
        }
            break;
            
        case kSXTagUserLogout:
            parameter = [NEW_SERVER_IP stringByAppendingString:USER_LOGOUT];
            break;
        case kSXTagGetUserAgree:
            parameter = [NEW_SERVER_IP stringByAppendingString:USERGETZUNXIANGAGREE];
            break;
        case kSXTagGetUserAgreeState:
            parameter = [NEW_SERVER_IP stringByAppendingString:USERZUNXIANGSTATE];
            break;
        case kSXTagCheckPersonRedPoint:
            parameter = [NEW_SERVER_IP stringByAppendingString:CHECKPERSONCENTERREDALERT];
            break;
        case kSXTagProductList:
            parameter = [NEW_SERVER_IP stringByAppendingString:USERPRODUTLIST];
            break;
        case kSXTagMySimpleInfo:
            parameter = [NEW_SERVER_IP stringByAppendingString:MYSIMLEINFOURL];
            break;
        case kSXTagMyReceipt:
            parameter = [NEW_SERVER_IP stringByAppendingString:MYRECEIPTURL];
            break;
        case KSXTagADJustMent:
            parameter = [NEW_SERVER_IP stringByAppendingString:USERINFOADJUSTMENT];
            break;

        case KSXTagWalletShowMsg:
            parameter = [NEW_SERVER_IP stringByAppendingString:WALLETSHOW];
            break;
        case kSXTagWalletSelectBankCar:
            parameter = [NEW_SERVER_IP stringByAppendingString:WALLETSELECTBANKCARD];
            break;
        case KSXTagMyInviteRebateinfo:
            parameter = [NEW_SERVER_IP stringByAppendingString:MYINVITEREBATEINFOURL];
            break;
        case kSXTagGoldMyInviteRebateinfo:
            parameter = [NEW_SERVER_IP stringByAppendingString:MYGOLDINVITEREBATEINFOURL];
            break;
        case KSXTagMyInviteRewardinfo:
            parameter = [NEW_SERVER_IP stringByAppendingString:MYINVITEREWARDINFOURL];
            break;
        case KSXTagP2pISAuthorization:
            parameter = [NEW_SERVER_IP stringByAppendingString:P2PISAUTHORIZATIONURL];
            break;
        case KSXTagP2pAuthorization:
            parameter = [NEW_SERVER_IP stringByAppendingString:P2PAUTHORIZATIONURL];

            break;
        case kSXTagRecFriendList:
            parameter = [NEW_SERVER_IP stringByAppendingString:RECFRIENDLISTURL];
            break;
        case kSXTagCheckConponCenter:
            parameter = [NEW_SERVER_IP stringByAppendingString:GetCouponNum];
            break;
        case kSXTagPrdClaimsWJShow:
            parameter = [NEW_SERVER_IP stringByAppendingString:PRDCLAIMSWJSHOWURL];
            break;
        case kSXTagPrdTransferList:
            parameter = [NEW_SERVER_IP stringByAppendingString:PRDTRANSEFERLIST];
            break;
        case kSXTagCalendarHeader:
            parameter = [NEW_SERVER_IP stringByAppendingString:CALENDARHEADER];
            break;
        case kSXTagOldCalendarHeader:
            parameter = [NEW_SERVER_IP stringByAppendingString:CALENDARHEADER_OLD];
            break;
        case kSXTagCalendarInfo:
            parameter = [NEW_SERVER_IP stringByAppendingString:CALENDARINFO];
            break;
        case kSXTagOldCalendarInfo:
            parameter = [NEW_SERVER_IP stringByAppendingString:CALENDARINFO_OLD];
            break;
        case kSXTagCurrentDayInfo:
            parameter = [NEW_SERVER_IP stringByAppendingString:CURRENTDAYINFO];
            break;
        case kSXTagGoldAccount:
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDACCOUNT];
            break;
        case ksxTagGoldCurrentPrice:
            parameter = [NEW_SERVER_IP stringByAppendingString:CURRENTGOLDPRICE];
            break;
            
        case kSXTagGoldTradeFlowList:
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDTRADELIST];
            break;
        case kSXTagGetGoldPrdClaimList:   // 获取黄金列表
            parameter = [NEW_SERVER_IP stringByAppendingString:GETGOlDPRDCLAIMLIST];
            break;
        case kSXTagGetGoldPrdClaimDetail: //黄金标详情页
            parameter = [NEW_SERVER_IP stringByAppendingString:GETGOlDPRDCLAIMDETAILINFO];
            break;
        case kSXTagGoldCalculateAmount:    //黄金计算器
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDCALCULATEAOUNTURL];
            break;
        case kSXTagGetGoldProClaimDetail: //购买输入金额页信息查询
            parameter = [NEW_SERVER_IP stringByAppendingString:GETGOLDPROCLAIMDETAILIL];
            break;
        case  kSXTagGoldAuthorizedOpenAccount: //黄金授权
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDAUTHORIZOPENACCOUT];
            break;
        case kSXTagGoldList:
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDENLIST];
            break;
        case kSXTagGetPurchaseGold:
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDPURCHASEURL];
            break;
        case kSXTagGetGoldContractInfo:   //查询合同详情
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDCONTRACTINFOURL];
            break;
        case kSXTagGetGoldTradeRecordList: //已购黄金列表
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDTRADERECORDLISTURL];
            break;
        case kSXTagGetGoldTradeDetail:     //已购黄金详情
            parameter = [NEW_SERVER_IP stringByAppendingString:GETGOLDTRADEDETAILURL];
            break;
        case kSXTagGoldRecharge:            //黄金充值
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDRECHARGE];
            break;
        case kSXTagGoldRechargeHistory:     //黄金充值记录
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDRECHARGEHISTORY];
            break;
        case kSXTagGoldCash:
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDCASH];
            break;
        case kSXTagGoldCashHistory:
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDCASHHISTORY];
            break;
        case kSXTagGoldRechargeInfo:
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDRECHARGEINFO];
            break;
        case kSXTagGoldCashPageInfo://黄金提现页面信息
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDCHASEAGEINFOURL];
            break;
        case kSXTagGetGoldCouponList://黄金提现页面信息
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDCOUPONLISTURL];
            break;
        case kSXTagGelectALLGoldCoupon://黄金返金券全选
            parameter = [NEW_SERVER_IP stringByAppendingString:GOlDOUPONSELEALLURL];
            break;
        case kSXTagGoldFriendList:
//            //@"http://10.105.6.54:8080/"
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLD_FRIENDS_LIST];
//            parameter = @"http://10.10.100.112/mockjsdata/13/invite_rebate_detail.json?";
            break;
        case kSXTagGoldRecommendRefund:
            parameter = [SERVER_IP stringByAppendingString:GOLD_RecommendRefund];
//            parameter = @"http://10.10.100.112/mockjsdata/13/friendslist.json?";
            break;
        case kSXTagGoldLimitedBankList://黄金充值受限的银行列表
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDLIMITEDBANKLIST];
            break;
        case kSxTagRegistMobileCheck:
            parameter = [NEW_SERVER_IP stringByAppendingString:RIGISTCHECK];
            break;
        case kSXTagGoldIncrease:
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDINCREASE];
            break;
        case kSXTagGoldCurrentPrdClaimInfo://黄金活期详情
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDCURRENPRDCLAIMINFO];
            break;
        case kSXTagGoldCurrentProClaimDetail: //黄金活期投资页面数据
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDCURRENPROClAIMDEAIL];
            break;
        case kSXTagGoldCurrentPurchase: //黄金活期购买接口
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDCURRENPURCHASEGOLD];
            break;
        case kSXTagGoldChangeCashInfo: //黄金活期购买接口
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDCHANGECASHINFO];
            break;
        case kSXTagGoldChangeCash:
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDCHANGECASH];
            break;
        case kSXTagGoldIncreaseList:
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDINCREASELIST];
            break;
        case kSXTagGoldIncreTransList:
            parameter = [NEW_SERVER_IP stringByAppendingString:GOLDINCRETRANSLIST];
            break;
        case kSXTagGlixedGoldConstract:
            parameter = [NEW_SERVER_IP stringByAppendingString:FLIXEDGOLDCONSTRACT];
            break;
        case kSXTagHonerRechangeShowContract:
            parameter = [NEW_SERVER_IP stringByAppendingString:HONERRECHANGESHOWCONT];
            break;
        case kSXTagUserStatusInfo:
            parameter = [NEW_SERVER_IP stringByAppendingString:USERSTATUSINFO];
            break;
        case kSXTagHomeIconList:
            parameter = [NEW_SERVER_IP stringByAppendingString:HOMEICONLIST];
            break;
        case kSXTagTotalAssetsOverView://总资产
            parameter = [NEW_SERVER_IP stringByAppendingString:TOTALASSTSOVERVIEWURL];
            break;
        case kSXTagTotalEarningsOverview://总资产
            parameter = [NEW_SERVER_IP stringByAppendingString:TOTALEARINGSOVERVIEW];
            break;
        case kSXTagGetBindingBankCardList: //我的-->>充值接口
            parameter = [NEW_SERVER_IP stringByAppendingString:MYACCOUNTBINFINGBANKCARD];
            break;
        case kSXTagGetAccountBalanceList: //我的-->>提现接口
            parameter = [NEW_SERVER_IP stringByAppendingString:MYACCOUNTBlANCELIST];
            break;
        case kSXTagExtractGoldList:
            parameter = [NEW_SERVER_IP stringByAppendingString:EXTRACTGOLDLIST];
            break;
        case kSXTagExtractGoldDetail:
            parameter = [NEW_SERVER_IP stringByAppendingString:EXTRACTGOLDDETAIL];
            break;
    }
    //给原有参数字典添加公共参数
    if (!data) {
        data = [NSDictionary dictionary];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:data];
    [dict setValue:@"1" forKey:@"sourceType"];
    [dict setValue:[Common getKeychain] forKey:@"imei"];
    [dict setValue:[Common getIOSVersion] forKey:@"version"];
    switch (type) {
        case SelectAccoutTypeP2P:
             [dict setValue:@"1" forKey:@"fromSite"];
            break;
        case SelectAccoutTypeHoner:
             [dict setValue:@"2" forKey:@"fromSite"];
            break;
        case SelectAccoutDefault:
            break;
        default:
            break;
    }
    if([[NSUserDefaults standardUserDefaults] valueForKey:UUID]){
        [dict setValue:[UserInfoSingle sharedManager].jg_ckie forKey:@"jg_nyscclnjsygjr"];
    }
    DLog(@"%@类新接口请求参数%@",owner,dict);
    if(isSignature) //是否需要验签
    {
        NSString *signature = [self getSinatureWithPar:[self newGetParStr:dict]];
        [dict setValue:signature forKey:@"signature"];
    }
    
    //对整体参数加密
    NSString *encryptParam  = [Common AESWithKey2:AES_TESTKEY WithDic:dict];
    NSString *dataStr = [NSString stringWithFormat:@"encryptParam=%@",encryptParam];
    [self postData:dataStr tag:tag owner:owner url:parameter];
}
- (void)isReloadNetQuest
{
    PostRequest *req = (PostRequest*)[queue objectForKey:[NSNumber numberWithInteger:_loseTag]];
    if (req) {
        req.postStatus = kPostStatusNone;
        req.enc = NSUTF8StringEncoding;
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        NSUInteger selectedIndex = appDelegate.tabBarController.selectedIndex;
        UINavigationController *nav = [appDelegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
        req.owner =(id<NetworkModuleDelegate>)nav.visibleViewController;
        [req postData:req.parmData delegate:self];
    }
}

@end
