//
//  UserInfoSingle.m
//  JRGC
//
//  Created by 金融工场 on 16/8/25.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UserInfoSingle.h"
#import <objc/runtime.h>
#import "Growing.h"
#import "MongoliaLayerCenter.h"
#import "JSONKit.h"
#import "UIDic+Safe.h"
#import "UCFToolsMehod.h"
#import "FMDeviceManager.h"
#import "MD5Util.h"
#import "UCFNewLoginViewController.h"
#import "UCFUserAllStatueRequest.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UCFRegisterInputPhoneNumViewController.h"
@implementation UserInfoSingle

+ (UserInfoSingle *)sharedManager
{
    static UserInfoSingle *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
        
    });
    return sharedAccountManagerInstance;
}
- (instancetype)init
{
    if (self =[super init]) {
        _loginData = [UCFLoginData new];
    }
    return self;
}
- (void)setUserData:(UCFLoginData *)loginData withPassWord:(NSString *)passWord{

    //注册成功后，先清cookies，把老账户的清除掉，然后再用新账户的信息
    [self deleteOldUserData];
    
    //登录成功保存用户的资料
    //保存验签串
    NSString *pwd = [UCFToolsMehod md5:[MD5Util MD5Pwd:passWord]];
    [self generateSingature:loginData withPassWord:pwd];
    [self setUserData:loginData];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:5] forKey:@"nRetryTimesRemain"];
    [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:AWP];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //注册通知self.loginData.userInfo
    [[NSNotificationCenter defaultCenter] postNotificationName:REGIST_JPUSH object:nil];
}

- (void)setUserData:(UCFLoginData *) loginData
{
    self.loginData = [loginData copy];
    [[NSUserDefaults standardUserDefaults] setValue:[loginData yy_modelToJSONString] forKey:LOGINDATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)deleteOldUserData{
    [self removeUserData];
}
- (void)deleteUserData{
    [self removeUserData];
    self.loginData = [UCFLoginData new];
}

- (void)removeUserData
{
    self.signatureStr = @"";
    self.wapSingature = @"";
    //清空数据
    //退出时清cookis
    [self removeUserCookies];
    [self deleteUserDataUserDefaults];
}

- (void)removeUserCookies
{
    //    清cookis
    [Common deleteCookies];
}
- (void)deleteUserDataUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:LOGINDATA];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FACESWITCHSTATUS];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:TIMESTAMP];//弹框时间记录
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"changScale"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setDefaultViewData" object:nil];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:AWP];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:REGIST_JPUSH object:nil];
}
- (NSString *)getAwp
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:AWP];
}
- (void)generateSingature:(UCFLoginData *) loginData withPassWord:(NSString *)passWord
{
    //生成wap的登录加密串
    NSMutableDictionary *wapDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [wapDict setValue:@"1" forKey:@"sourceType"];
    [wapDict setValue:@"0" forKey:@"iswap"];
    [wapDict setValue:[Common getKeychain] forKey:@"imei"];
    [wapDict setValue:loginData.userInfo.userId forKey:@"userId"];
    NSString *encryptParam = [Common AESWithKeyWithNoTranscode2:AES_TESTKEY WithData:wapDict];
    self.wapSingature = encryptParam;
    
     //生成接口的登录加密串
    NSString *yanQian = [NSString stringWithFormat:@"%@%@%lld",[self getlastLoginName],passWord,loginData.userInfo.time];
    self.signatureStr  = [UCFToolsMehod md5:yanQian];
    
    [Common  setHTMLCookies:loginData.userInfo.jg_ckie andCookieName:@"jg_nyscclnjsygjr"];//html免登录的cookies
    [Common  setHTMLCookies:self.wapSingature andCookieName:@"encryptParam"];//html免登录的cookies
}
- (UCFLoginData *)getUserData
{
    NSString *userData = [[NSUserDefaults standardUserDefaults] valueForKey:LOGINDATA];
    if (nil != userData && ![userData isEqualToString:@""] ) {
        UCFLoginData *data = [UCFLoginData yy_modelWithJSON:userData];
        [self generateSingature:data withPassWord:[self getAwp]];
        _loginData = [data copy];
        return _loginData;
    }
    else
    {
        return nil;
    }
}
//- (void)updataCurrentUserStatue
//{
//   UCFLoginData *newUserData = [self.loginData mutableCopy];
//    self.loginData = newUserData;
//}
- (void)saveLoginAccount:(NSDictionary *)account;
{
    [[NSUserDefaults standardUserDefaults] setValue:account forKey:@"lastLoginName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)getLoginAccount
{
    return  [[NSUserDefaults standardUserDefaults] valueForKey:@"lastLoginName"];
}

- (NSString *)getlastLoginName
{
    NSDictionary *dic = [self getLoginAccount];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return [dic objectForKey:@"lastLoginName"];
    }
    else if ([dic isKindOfClass:[NSString class]]){
        return dic;
    }
    else
    {
        return @"";
    }
    
}

#pragma mark - 同盾
+ (NSString *) didReceiveDeviceBlackBox{
    
    // 获取设备管理器实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    //    manager->getDeviceInfoAsync(nil, self);
    //#warning 同盾修改
    NSString *blackBox = manager->getDeviceInfo();
    return blackBox;
}



//- (NSString *)signatureStr
//{
//    if (self.loginData.userInfo.userId.length > 0) {
//        if (!_signatureStr || [_signatureStr isEqualToString:@""] || _signatureStr.length <= 0) {
//            //更新验签串
//            NSString *yanQian = [NSString stringWithFormat:@"%@%@%lld",[self getlastLoginName],[self getAwp],self.loginData.userInfo.time];
//            NSString *signatureStr  = [UCFToolsMehod md5:yanQian];
//            _signatureStr = signatureStr;
//        }
//        return _signatureStr;
//    }
//    return @"";
//}




- (void)requestUserAllStatueWithView:(UIView *)view
{
    if (self.loginData.userInfo.userId.length > 0) {
        UCFUserAllStatueRequest *request1 = [[UCFUserAllStatueRequest alloc] initWithUserId:SingleUserInfo.loginData.userInfo.userId];
        if (view.window != nil) {
            request1.animatingView = view;
        }
        [request1 setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSDictionary *dic = request.responseObject;
            if ([dic[@"ret"] boolValue]) {
                NSDictionary *userDict = dic[@"data"][@"userSatus"];
                self.loginData.userInfo.zxOpenStatus = [NSString stringWithFormat:@"%@",userDict[@"zxOpenStatus"]];
                self.loginData.userInfo.openStatus = [NSString stringWithFormat:@"%@",userDict[@"openStatus"]];
                self.loginData.userInfo.nmAuthorization = [userDict[@"nmGoldAuthStatus"] boolValue];
                self.loginData.userInfo.isNewUser = [userDict[@"isNew"] boolValue];
                self.loginData.userInfo.isRisk = [userDict[@"isRisk"] boolValue];
                self.loginData.userInfo.isAutoBid = [userDict[@"isAutoBid"] boolValue];
                self.loginData.userInfo.zxAuthorization = [userDict[@"zxAuthorization"] boolValue];
                self.loginData.userInfo.isCompanyAgent = [userDict[@"company"] boolValue];
                [self updateUserData];
                if (self.requestUserbackBlock) {
                    self.requestUserbackBlock(YES);
                    self.requestUserbackBlock = nil;
                }

            }
            else
            {
//                ShowMessage(dic[@"message"]);
                if (self.requestUserbackBlock) {
                    self.requestUserbackBlock(NO);
                    self.requestUserbackBlock = nil;
                }
  
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
              if (self.requestUserbackBlock) {
                self.requestUserbackBlock(NO);
                self.requestUserbackBlock = nil;
              }
        }];
        [request1 start];
    }
}

- (void)updateUserData
{
    [[NSUserDefaults standardUserDefaults] setValue:[self.loginData yy_modelToJSONString] forKey:LOGINDATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)loadLoginViewController
{
    RTContainerController *controller = [SingGlobalView.rootNavController.viewControllers lastObject];
    if ([controller.contentViewController isKindOfClass:[UCFNewLoginViewController class]]) {
        return;
    }
    UCFNewLoginViewController *vc = [[UCFNewLoginViewController alloc] init];
    [SingGlobalView.rootNavController pushViewController:vc animated:YES];
}
- (void)loadRegistViewController
{
    UCFRegisterInputPhoneNumViewController *vc = [[UCFRegisterInputPhoneNumViewController alloc] init];
    [SingGlobalView.rootNavController pushViewController:vc animated:YES];
}

- (void)removeIsShare
{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"isShare"]];
    if (dic != nil && [dic isKindOfClass:[NSDictionary class]] && dic.count >0) {
        [self postPlatform:[dic objectSafeForKey:@"taskType"] andPlatformType:[[dic objectSafeForKey:@"platformType"] integerValue]];
    }
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isShare"];
}
-(void)postPlatform:(NSString *)taskType andPlatformType:(NSInteger )platformType
{
    if (self.loginData.userInfo.userId.length > 0) {
        NSString *sharePlatForm = @"";
        
        if (platformType == UMSocialPlatformType_WechatSession) {
            sharePlatForm = @"wechat";
        } else if (platformType == UMSocialPlatformType_WechatTimeLine) {
            sharePlatForm = @"wechatCF";
        } else if (platformType == UMSocialPlatformType_QQ) {
            sharePlatForm = @"qq";
        } else if (platformType == UMSocialPlatformType_Sina) {
            sharePlatForm = @"weibo";
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
        [dict setValue:self.loginData.userInfo.userId forKey:@"userId"];
        [dict setValue:taskType forKey:@"taskType"];
        [dict setValue:sharePlatForm forKey:@"sharePlatForm"];
        
        [[NetworkModule sharedNetworkModule] newPostReq:dict tag:kSXTagAppShareStyle owner:self signature:YES Type:SelectAccoutDefault];
    }
}
- (void)saveIsShare:(NSDictionary *)dic
{
    //    [[NSUserDefaults standardUserDefaults]setValue:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                                    self.taskType,@"taskType",
    //                                                    [NSString stringWithFormat:@"%zd",platformType],@"platformType",
    //                                                    nil] forKey:@"isShare"];
    [[NSUserDefaults standardUserDefaults]setValue:dic forKey:@"isShare"];
    [[NSUserDefaults standardUserDefaults] synchronize];    //用synchronize方法把数据持久化到standardUserDefaults数据库
}
//
//#pragma mark - set
//- (void)setOpenStatus:(NSInteger)states {
//    _openStatus = states;
//    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:states] forKey:OPENSTATUS];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (void)setRealName:(NSString *)realName {
//    _realName = realName;
//    [[NSUserDefaults standardUserDefaults] setValue:realName forKey:REALNAME];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//}
//
//- (void)setIsRisk:(BOOL)isRisk
//{
//    _isRisk = isRisk;
//    [[NSUserDefaults standardUserDefaults] setBool:isRisk forKey:@"isRisk"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (void)setIsAutoBid:(BOOL)isAutoBid
//{
//    _isAutoBid = isAutoBid;
//    [[NSUserDefaults standardUserDefaults] setBool:isAutoBid forKey:@"isAutoBid"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (void)setIsSpecial:(BOOL)isSpecial {
//    _isSpecial = isSpecial;
////    [[NSUserDefaults standardUserDefaults] setValue:isSpecial forKey:@"isSpecial"];
////    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//-(void)setCompanyAgent:(BOOL)companyAgent{
//    _companyAgent = companyAgent;
//}
//
//- (void)setMobile:(NSString *)mobile {
//    _mobile = mobile;
//    [[NSUserDefaults standardUserDefaults] setValue:mobile forKey:PHONENUM];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//}
//- (void)setEnjoyOpenStatus:(NSInteger)states
//{
//    _enjoyOpenStatus = states;
//    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:states] forKey:EnjoyState];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//}
//- (void)setUserData:(NSDictionary *)dict {
//    [self reflectDataFromOtherObject:dict];
//    [self storeUserCache:dict];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"userisloginandcheckgrade" object:@(YES)];
//}
//
//- (void)setGcm_code:(NSString *)gcm_code
//{
//    _gcm_code = gcm_code;
//    [[NSUserDefaults standardUserDefaults] setValue:gcm_code forKey:GCMCODE];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
////程序启动的时候 获取用户对象数据
//- (void)getUserData
//{
//    self.userId = SingleUserInfo.loginData.userInfo.userId;
//    self.time = [[[NSUserDefaults standardUserDefaults] valueForKey:TIME] integerValue];
//    self.jg_ckie = [[NSUserDefaults standardUserDefaults] valueForKey:DOPA];
//    self.loginName = [[NSUserDefaults standardUserDefaults] valueForKey:LOGINNAME];
//    self.headerUrl = [[NSUserDefaults standardUserDefaults] valueForKey:HEADURL];
//    _mobile = [[NSUserDefaults standardUserDefaults] valueForKey:PHONENUM];
//    _realName = [[NSUserDefaults standardUserDefaults] valueForKey:REALNAME];
//    _openStatus = [[[NSUserDefaults standardUserDefaults] valueForKey:OPENSTATUS] integerValue];
//    self.companyAgent = [[[NSUserDefaults standardUserDefaults] valueForKey:COMPANYAGENT] boolValue];
//    self.enjoyOpenStatus = [[[NSUserDefaults standardUserDefaults] valueForKey:EnjoyState] integerValue];
//    self.zxAuthorization = [[[NSUserDefaults standardUserDefaults]valueForKey:HONERAUTHORIZATION] boolValue];
//    self.goldAuthorization = [[[NSUserDefaults standardUserDefaults]valueForKey:GOldAUTHORIZATION] boolValue];
////    self.userLevel = [[NSUserDefaults standardUserDefaults] valueForKey:USER_LEVEL];
//    self.isRisk = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRisk"];
//    self.isAutoBid = [[NSUserDefaults standardUserDefaults] boolForKey:@"isAutoBid"];
//    self.gcm_code = [[NSUserDefaults standardUserDefaults]valueForKey:GCMCODE];
//}
//
//
//
////存储用户信息
//- (void)storeUserCache:(NSDictionary *)dict
//{
//    [[NSUserDefaults standardUserDefaults] setValue:dict[@"userId"] forKey:UUID];
//    [[NSUserDefaults standardUserDefaults] setValue:dict[@"time"] forKey:TIME];
//    [[NSUserDefaults standardUserDefaults] setValue:dict[@"jg_ckie"] forKey:DOPA];
//    [[NSUserDefaults standardUserDefaults] setValue:dict[@"loginName"] forKey:LOGINNAME];
//    [[NSUserDefaults standardUserDefaults] setValue:dict[@"headerUrl"] forKey:HEADURL];
//    [[NSUserDefaults standardUserDefaults] setValue:dict[@"mobile"] forKey:PHONENUM];
//    [[NSUserDefaults standardUserDefaults] setValue:dict[@"realName"] forKey:REALNAME];
//    [[NSUserDefaults standardUserDefaults] setValue:dict[@"openStatus"] forKey:OPENSTATUS];
//    [[NSUserDefaults standardUserDefaults] setValue:dict[@"isCompanyAgent"] forKey:COMPANYAGENT];
//    [[NSUserDefaults standardUserDefaults] setValue:dict[@"enjoyOpenStatus"] forKey:EnjoyState];
//    [[NSUserDefaults standardUserDefaults] setValue:dict[@"nmAuthorization"] forKey:GOldAUTHORIZATION];
//    [[NSUserDefaults standardUserDefaults] setValue:dict[@"zxAuthorization"] forKey:HONERAUTHORIZATION];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    //  GrowingIO添加字段
//    [Growing setCS1Value:dict[@"userId"] forKey:@"user_Id"];
//    [Growing setCS2Value:[[NSUserDefaults standardUserDefaults] objectForKey:GCMCODE] forKey:@"user_gcm"];
//    if (dict[@"realName"] == nil || [dict[@"realName"] isEqualToString:@""]) {
//        [Growing setCS3Value:@"" forKey:@"user_name"];
//    }
//    else {
//        [Growing setCS3Value:dict[@"realName"] forKey:@"user_name"];
//    }
//}
//
////- (void)setUserLevel:(NSString *)userLevel
////{
////    _userLevel = userLevel;
////    [[NSUserDefaults standardUserDefaults] setValue:userLevel forKey:USER_LEVEL];
////    [[NSUserDefaults standardUserDefaults] synchronize];
////}
//
//- (void)removeUserInfo
//{
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:UUID];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:TIME];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:DOPA];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:LOGINNAME];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:HEADURL];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:PHONENUM];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:REALNAME];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:OPENSTATUS];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:COMPANYAGENT];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USER_LEVEL];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:GOldAUTHORIZATION];
//    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:GCMCODE];
//    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:TIMESTAMP];//时间戳清空
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    //  GrowingIO删除字段
//    [Growing setCS1Value:nil forKey:@"user_Id"];
//    [Growing setCS2Value:nil forKey:@"user_gcm"];
//    [Growing setCS3Value:nil forKey:@"user_name"];
//    self.userId = nil;
//    self.time = -1;
//    self.jg_ckie = nil;
//    self.loginName = nil;
//    self.headerUrl = nil;
//    self.wjIsShow = YES;
//    self.transferIsShow = YES;
//    _mobile = nil;
//    _realName = nil;
//    _openStatus = -1;
//    self.companyAgent = NO;
//    self.isRisk = NO;
//    self.isAutoBid = NO;
//    self.zxAuthorization = NO;
////    self.userLevel = nil;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"userisloginandcheckgrade" object:@(NO)];
//}
//- (void)updateOpenStatus:(NSInteger)openStatus
//{
//    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:openStatus] forKey:OPENSTATUS];
//    self.openStatus = openStatus;
//}
//-(NSArray*)propertyKeys
//{
//    unsigned int outCount, i;
//    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
//    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
//    for (i = 0; i < outCount; i++) {
//        objc_property_t property = properties[i];
//        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//        [keys addObject:propertyName];
//    }
//    free(properties);
//    return keys;
//}
//
//-(BOOL)reflectDataFromOtherObject:(NSObject*)dataSource
//{
//    BOOL ret = NO;
//    for (NSString *key in [self propertyKeys]) {
//        if ([dataSource isKindOfClass:[NSDictionary class]]) {
//            ret = ([dataSource valueForKey:key]==nil)?NO:YES;
//        }
//        else {
//            ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
//        }
//        if (ret) {
//            id propertyValue = [dataSource valueForKey:key];
//
//            //该e值不为NSNULL，并且也不为nil
//           if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
//               if ([key isEqualToString:@"isSpecial"]) {
//                   [self setIsSpecial:[propertyValue boolValue]];
//               }
//               else
//                   [self setValue:propertyValue forKey:key];
//           }
//        }
//    }
//    return ret;
//}
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//#warning about supervise
//        self.superviseSwitch = YES;
//        self.level = 1;
//        self.goldIsNew = YES;
//        self.zxIsNew = YES;
//    }
//    return self;
//}
//
//#warning check userinfo on supervise
- (void)checkUserLevelOnSupervise {
    if (!self.loginData.userInfo.userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId": self.loginData.userInfo.userId} tag:kSXTagSuperviseUserInfo owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{

}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSMutableDictionary *dic = [result objectFromJSONString];
    if (tag.integerValue == kSXTagSuperviseUserInfo) {
        NSString *rstcode = dic[@"ret"];
//        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSDictionary *res = [dic objectSafeDictionaryForKey:@"data"];
            NSString *compliance = [res objectSafeForKey:@"compliance"];
            if ([compliance isEqualToString:@"1"]) {
                self.superviseSwitch = NO;
            }
            else if ([compliance isEqualToString:@"2"]) {
                self.superviseSwitch = YES;
            }
            else {
                self.superviseSwitch = YES;
            }
            
            self.loginData.userInfo.goldIsShow = [[res objectSafeForKey:@"goldIsShow"] boolValue];
            self.loginData.userInfo.transferIsShow = [[res objectSafeForKey:@"transferIsShow"] boolValue];
            self.loginData.userInfo.wjIsShow = [[res objectSafeForKey:@"wjIsShow"] boolValue];
            self.loginData.userInfo.zxIsShow = [[res objectSafeForKey:@"zxIsShow"] boolValue];
            self.loginData.userLevel = [res objectSafeForKey:@"level"] ;
            self.loginData.userInfo.goldIsNew = [[res objectSafeForKey:@"goldIsNew"] boolValue];
            self.loginData.userInfo.zxIsNew = [[res objectSafeForKey:@"zxIsNew"] boolValue];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSuperviseView" object:nil];

        }else {
            self.superviseSwitch = YES;
            self.loginData.userLevel = @"1";
            self.loginData.userInfo.goldIsNew = YES;
            self.loginData.userInfo.zxIsNew = YES;
        }
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    if (tag.integerValue == kSXTagSuperviseUserInfo) {
        self.superviseSwitch = YES;
        self.loginData.userLevel = @"1";
        self.loginData.userInfo.goldIsNew = YES;
        self.loginData.userInfo.zxIsNew = YES;
        
    }
}

@end
