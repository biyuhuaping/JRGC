//
//  UCFHomeAPIManager.m
//  JRGC
//
//  Created by njw on 2017/5/9.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeAPIManager.h"
#import "NetworkModule.h"
#import "JSONKit.h"
#import "UIDic+Safe.h"
#import "UCFHomeListGroup.h"
#import "UCFUserInfoModel.h"
#import "UCFHomeIconModel.h"
#import "UCFSignModel.h"
#import "UCFSession.h"
#import "MongoliaLayerCenter.h"
#import "UCFPicADModel.h"
#import "UCFNoticeModel.h"

#define HOMELIST @"homeList"
#define HOMEICON @"homeIcon"
#define USERINFOONE @"userInfoOne"
#define USERINFOTWO @"userInfoTwo"
#define SIGN @"sign"
#define PRODETAIL @"prodetail"
#define GOLDDETAIL @"goldDetail"
#define GOLDPROCLAIMDETAIL @"GoldProClaimDetail"
#define COLLECTIONDETAIL  @"CollectionDetail"
#define GOLDCURRENTPROCLAIMDETAIL @"GoldCurrentProClaimDetail"//黄金活期

@interface UCFHomeAPIManager () <NetworkModuleDelegate>
@property (strong, nonatomic) NSMutableDictionary *requestDict;
@end

@implementation UCFHomeAPIManager

- (NSMutableDictionary *)requestDict
{
    if (nil == _requestDict) {
        _requestDict = [[NSMutableDictionary alloc] init];
    }
    return _requestDict;
}

- (void)fetchHomeListWithUserId:(NSString *)userId completionHandler:(NetworkCompletionHandler)completionHandler
{
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagPrdClaimsNewVersion owner:self signature:YES Type:SelectAccoutDefault];
    [self.requestDict setObject:completionHandler forKey:HOMELIST];
}

- (void)fetchHomeIconListWithUserId:(NSString *)userId completionHandler:(NetworkCompletionHandler)completionHandler
{
    
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagHomeIconList owner:self signature:YES Type:SelectAccoutDefault];
    [self.requestDict setObject:completionHandler forKey:HOMEICON];
}

- (void)fetchUserInfoOneWithUserId:(NSString *)userId completionHandler:(NetworkCompletionHandler)completionHandler
{
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagMyReceipt owner:self signature:YES Type:SelectAccoutDefault];
    [self.requestDict setObject:completionHandler forKey:USERINFOONE];
}

- (void)fetchUserInfoTwoWithUserId:(NSString *)userId completionHandler:(NetworkCompletionHandler)completionHandler
{
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagMySimpleInfo owner:self signature:YES Type:SelectAccoutDefault];
    [self.requestDict setObject:completionHandler forKey:USERINFOTWO];
}

- (void)fetchSignInfo:(NSString *)userId token:(NSString *)token completionHandler:(NetworkCompletionHandler)completionHandler
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UUID]) {
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId, @"apptzticket":token} tag:kSXTagSingMenthod owner:self signature:YES Type:SelectAccoutDefault];
        [self.requestDict setObject:completionHandler forKey:SIGN];
    }
}

#pragma mark - 获取标的详情
- (void)fetchProDetailInfoWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHandler
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UUID]) {
        NSString *userId = [parameter objectForKey:@"userId"];
        NSString *Id = [parameter objectForKey:@"Id"];
        NSString *proType = [parameter objectForKey:@"proType"];
        NSString *type  = [parameter objectForKey:@"type"];
        switch ([type intValue]) {
            case 3://微金和尊享标详情请求
            {
                NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@",Id,userId];
                if ([proType isEqualToString:@"1"]) {
                    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self Type:SelectAccoutTypeP2P];
                }
                else if ([proType isEqualToString:@"2"]) {
                    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self Type:SelectAccoutTypeHoner];
                }
                [self.requestDict setObject:completionHandler forKey:PRODETAIL];
            }
                break;
            case 4://微金和尊享投资页面请求
            {
                NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@",Id,userId];
                if ([proType isEqualToString:@"1"]) {
                    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDealBid owner:self Type:SelectAccoutTypeP2P];
                }
                else if ([proType isEqualToString:@"2"]) {
                    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDealBid owner:self Type:SelectAccoutTypeHoner];
                }
                [self.requestDict setObject:completionHandler forKey:PRODETAIL];
            }
                break;
            case 5://黄金详情网络请求
            {
                
                [[NetworkModule sharedNetworkModule] newPostReq:parameter tag:kSXTagGetGoldPrdClaimDetail owner:self signature:YES Type:SelectAccoutTypeGold];
                [self.requestDict setObject:completionHandler forKey:GOLDDETAIL];
            }
                break;
            case 6://黄金投资页面请求
            {
                [[NetworkModule sharedNetworkModule] newPostReq:parameter tag:kSXTagGetGoldProClaimDetail owner:self signature:YES Type:SelectAccoutTypeGold];
                [self.requestDict setObject:completionHandler forKey:GOLDPROCLAIMDETAIL];
            }
                break;
            case 7://黄金活期标详情页面请求
            {
                [[NetworkModule sharedNetworkModule] newPostReq:parameter tag:kSXTagGoldCurrentPrdClaimInfo owner:self signature:YES Type:SelectAccoutTypeGold];
                [self.requestDict setObject:completionHandler forKey:GOLDCURRENTPROCLAIMDETAIL];
            }
                break;
            case 8://黄金活期投资页面请求
            {
                [[NetworkModule sharedNetworkModule] newPostReq:parameter tag:kSXTagGoldCurrentProClaimDetail owner:self signature:YES Type:SelectAccoutTypeGold];
                [self.requestDict setObject:completionHandler forKey:GOLDCURRENTPROCLAIMDETAIL];
            }
                break;

            default:
                break;
        }
    }
}
- (void)fetchCollectionDetailInfoWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHandler
{
    
     [[NetworkModule sharedNetworkModule] newPostReq:parameter tag:kSXTagColPrdclaimsDetail owner:self signature:YES Type:SelectAccoutTypeP2P];
    [self.requestDict setObject:completionHandler forKey:COLLECTIONDETAIL];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    DBLOG(@"UCFPersonAPIManager : %@",dic);
    
    if (tag.intValue == kSXTagPrdClaimsNewVersion) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:HOMELIST];
        if ([rstcode boolValue]) {
            NSDictionary *result = [dic objectSafeDictionaryForKey:@"data"];
            NSMutableDictionary *tempResult = [[NSMutableDictionary alloc] init];
            NSArray *group = [result objectSafeArrayForKey:@"group"];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in group) {
                UCFHomeListGroup * tempG = [UCFHomeListGroup homeListGroupWithDict:dict];
                [tempArray addObject:tempG];
            }
            [tempResult setObject:tempArray forKey:@"homelistContent"];
            
            [UserInfoSingle sharedManager].companyAgent = [[result objectSafeForKey:@"isCompanyAgent"] boolValue];
            [UserInfoSingle sharedManager].isRisk = [[result objectSafeForKey:@"isRisk"] boolValue];
            [UserInfoSingle sharedManager].isAutoBid = [[result objectSafeForKey:@"isAutoBid"] boolValue];
            [UserInfoSingle sharedManager].p2pAuthorization = [[result objectSafeForKey:@"p2pAuthorization"] boolValue];
            [UserInfoSingle sharedManager].zxAuthorization = [[result objectSafeForKey:@"zxAuthorization"] boolValue];
            [UserInfoSingle sharedManager].goldAuthorization = [[result objectSafeForKey:@"nmGoldAuthorization"] boolValue];
            [UserInfoSingle sharedManager].openStatus = [[result objectSafeForKey:@"openStatus"] integerValue];
            [UserInfoSingle sharedManager].enjoyOpenStatus = [[result objectSafeForKey:@"zxOpenStatus"] integerValue];
            
            UCFHomeListCellModel *homelistModel = [UCFHomeListCellModel homeListCellWithDict:result];
            [tempResult setObject:homelistModel forKey:@"listInfo"];
            [[UCFSession sharedManager] transformBackgroundWithUserInfo:@{} withState:UCFSessionStateUserRefresh];
            complete(nil, tempResult);
        }
        else {
            complete(nil, rsttext);
        }
        
        [self.requestDict removeObjectForKey:HOMELIST];
    }
    else if (tag.intValue == kSXTagHomeIconList) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:HOMEICON];
        if ([rstcode boolValue]) {
            NSMutableDictionary *tempResult = [[NSMutableDictionary alloc] init];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            NSDictionary *resultDict = [dic objectSafeDictionaryForKey:@"data"];
            if ([[resultDict objectSafeForKey:@"picAD"] count] > 0) {
                NSDictionary *adDic = [[resultDict objectSafeForKey:@"picAD"] objectAtIndex:0];
                if (adDic) {
                    [[NSUserDefaults standardUserDefaults] setValue:adDic forKey:@"AD_ACTIViTY_DIC"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            NSDictionary *siteNotice = [resultDict objectSafeDictionaryForKey:@"siteNoticeMap"];
       
            UCFNoticeModel *noticeModel = [UCFNoticeModel noticeWithDict:siteNotice];
//            UCFPicADModel *picADModel = [UCFPicADModel picADWithDict:adDic];
            [tempResult setObject:noticeModel forKey:@"siteNotice"];
            NSArray *productMap = [resultDict objectSafeArrayForKey:@"productMap"];
            for (NSDictionary *dict in productMap) {
                UCFHomeIconModel *iconModel = [UCFHomeIconModel homeIconListWithDict:dict];
                [tempArray addObject:iconModel];
            }
            [tempResult setObject:tempArray forKey:@"productMap"];
//            [tempResult setObject:picADModel forKey:@"picAD"];
            complete(nil, tempResult);
        }
        else {
            complete(nil, rsttext);
        }
        [self.requestDict removeObjectForKey:HOMEICON];
    }
    else if (tag.intValue == kSXTagMySimpleInfo) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:USERINFOTWO];
        if ([rstcode boolValue]) {
            NSDictionary *data = [dic objectForKey:@"data"];
            UCFUserInfoModel *userInfoTwo = [UCFUserInfoModel userInfomationWithDict:data];
            complete(nil, userInfoTwo);
        }
        else {
            complete(nil, rsttext);
        }
        [self.requestDict removeObjectForKey:USERINFOTWO];
    }
    else if (tag.intValue == kSXTagSingMenthod) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:SIGN];
        if ([rstcode boolValue]) {
            NSDictionary *data = [dic objectForKey:@"data"];
            UCFSignModel *signModel = [UCFSignModel signWithDict:data];
            complete(nil, signModel);
        }
        else {
            complete(nil, rsttext);
        }
        [self.requestDict removeObjectForKey:SIGN];
    }
    else if (tag.intValue == kSXTagPrdClaimsDetail) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:PRODETAIL];
        complete(nil, dic);
        [self.requestDict removeObjectForKey:PRODETAIL];
    }
    else if (tag.intValue == kSXTagPrdClaimsDealBid) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:PRODETAIL];
        complete(nil, dic);
        [self.requestDict removeObjectForKey:PRODETAIL];
    }else if (tag.intValue == kSXTagColPrdclaimsDetail) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:COLLECTIONDETAIL];
        complete(nil, dic);
        [self.requestDict removeObjectForKey:COLLECTIONDETAIL];
    }
    else if (tag.intValue == kSXTagGetGoldPrdClaimDetail) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:GOLDDETAIL];
        complete(nil, dic);
        [self.requestDict removeObjectForKey:GOLDDETAIL];
    }
    else if (tag.intValue == kSXTagGetGoldProClaimDetail) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:GOLDPROCLAIMDETAIL];
        complete(nil, dic);
        [self.requestDict removeObjectForKey:GOLDPROCLAIMDETAIL];
    }
    else if (tag.intValue == kSXTagGoldCurrentPrdClaimInfo) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:GOLDCURRENTPROCLAIMDETAIL];
        complete(nil, dic);
        [self.requestDict removeObjectForKey:GOLDCURRENTPROCLAIMDETAIL];
    }
    else if (tag.intValue == kSXTagGoldCurrentProClaimDetail) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:GOLDCURRENTPROCLAIMDETAIL];
        complete(nil, dic);
        [self.requestDict removeObjectForKey:GOLDCURRENTPROCLAIMDETAIL];
    }
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagPrdClaimsNewVersion) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:HOMELIST];
        complete(err, nil);
        [self.requestDict removeObjectForKey:HOMELIST];
    }
    else if (tag.intValue == kSXTagHomeIconList) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:HOMEICON];
        complete(err, nil);
        [self.requestDict removeObjectForKey:HOMEICON];
    }
//    else if (tag.intValue == kSXTagMySimpleInfo) {
//        NetworkCompletionHandler complete = [self.requestDict objectForKey:USERINFOTWO];
//        complete(err, nil);
//        [self.requestDict removeObjectForKey:USERINFOTWO];
//    }
    else if (tag.intValue == kSXTagSingMenthod) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:SIGN];
        complete(err, nil);
        [self.requestDict removeObjectForKey:SIGN];
    }
    else if (tag.intValue == kSXTagPrdClaimsDetail) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:PRODETAIL];
        complete(err, nil);
        [self.requestDict removeObjectForKey:PRODETAIL];
    }
    else if (tag.intValue == kSXTagPrdClaimsDealBid) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:PRODETAIL];
        complete(err, nil);
        [self.requestDict removeObjectForKey:PRODETAIL];
    }else if (tag.intValue == kSXTagColPrdclaimsDetail) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:COLLECTIONDETAIL];
        complete(err, nil);
        [self.requestDict removeObjectForKey:COLLECTIONDETAIL];
    }
    else if (tag.intValue == kSXTagGetGoldPrdClaimDetail) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:GOLDDETAIL];
        complete(err, nil);
        [self.requestDict removeObjectForKey:GOLDDETAIL];
    }
    else if (tag.intValue == kSXTagGetGoldProClaimDetail) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:GOLDPROCLAIMDETAIL];
         complete(err, nil);
        [self.requestDict removeObjectForKey:GOLDPROCLAIMDETAIL];
    }
    else if (tag.intValue == kSXTagGoldCurrentPrdClaimInfo) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:GOLDCURRENTPROCLAIMDETAIL];
        complete(err, nil);
        [self.requestDict removeObjectForKey:GOLDCURRENTPROCLAIMDETAIL];
    }
    else if (tag.intValue == kSXTagGoldCurrentProClaimDetail) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:GOLDCURRENTPROCLAIMDETAIL];
        complete(err, nil);
        [self.requestDict removeObjectForKey:GOLDCURRENTPROCLAIMDETAIL];
    }
}

@end
