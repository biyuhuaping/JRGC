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
#import "UCFSignModel.h"
#import "UCFSession.h"
#import "MongoliaLayerCenter.h"
#define HOMELIST @"homeList"
#define USERINFOONE @"userInfoOne"
#define USERINFOTWO @"userInfoTwo"
#define SIGN @"sign"
#define PRODETAIL @"prodetail"

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
            case 3:
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
            case 4:
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
            default:
                break;
        }
    }
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
            if ([[result allKeys] containsObject:@"authorization"]) {
                BOOL authorization =  [[result objectSafeForKey:@"authorization"] boolValue];
                if (authorization) {
                   [[MongoliaLayerCenter sharedManager].mongoliaLayerDic setValue:[NSNumber numberWithInt:1] forKey:@"authorization"];
                }else{
                   [[MongoliaLayerCenter sharedManager].mongoliaLayerDic setValue:[NSNumber numberWithInt:0] forKey:@"authorization"];
                }
            }
            UCFHomeListCellModel *homelistModel = [UCFHomeListCellModel homeListCellWithDict:result];
            [tempResult setObject:tempArray forKey:@"homelistContent"];
            [tempResult setObject:homelistModel forKey:@"listInfo"];
            [tempResult setObject:[result objectSafeForKey:@"siteNotice"] forKey:@"siteNotice"];
            [[UCFSession sharedManager] transformBackgroundWithUserInfo:@{} withState:UCFSessionStateUserRefresh];
            complete(nil, tempResult);
        }
        else {
            complete(nil, rsttext);
        }
        
        [self.requestDict removeObjectForKey:HOMELIST];
    }
    else if (tag.intValue == kSXTagMyReceipt) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:USERINFOONE];
        if ([rstcode boolValue]) {
            NSDictionary *userInfoOne = [dic objectSafeDictionaryForKey:@"data"];
            UCFUserInfoModel *userInfoModel = [UCFUserInfoModel userInfomationWithDict:userInfoOne];
            complete(nil, userInfoModel);
        }
        else {
            complete(nil, rsttext);
        }
        [self.requestDict removeObjectForKey:USERINFOONE];
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
    else if (tag.intValue == kSXTagMyReceipt) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:USERINFOONE];
        complete(err, nil);
        [self.requestDict removeObjectForKey:USERINFOONE];
    }
    else if (tag.intValue == kSXTagMySimpleInfo) {
        NetworkCompletionHandler complete = [self.requestDict objectForKey:USERINFOTWO];
        complete(err, nil);
        [self.requestDict removeObjectForKey:USERINFOTWO];
    }
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
    }
}

@end
