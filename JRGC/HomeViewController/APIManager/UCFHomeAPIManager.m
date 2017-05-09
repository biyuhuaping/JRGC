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

#define HOMELIST @"homeList"

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
        if ([rstcode boolValue]) {
            NSDictionary *result = [dic objectSafeDictionaryForKey:@"data"];
//            UCFPersonCenterModel *personCenterModel = [UCFPersonCenterModel personCenterWithDict:result];
//            [[UCFSession sharedManager] transformBackgroundWithUserInfo:@{} withState:UCFSessionStateUserRefresh];
//            [UserInfoSingle sharedManager].enjoyOpenStatus = [personCenterModel.enjoyOpenStatus integerValue];
//            [UserInfoSingle sharedManager].openStatus = [personCenterModel.p2pOpenStatus integerValue];
//            self.completionHandler(nil, personCenterModel);
        }
        else {
//            self.completionHandler(nil, rsttext);
        }
        
        [self.requestDict removeObjectForKey:HOMELIST];
    }
    else if (tag.intValue == kSXTagSingMenthod) {
        if ([rstcode boolValue]) {
            
        }
        else {
            
        }
    }
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagPrdClaimsNewVersion) {
//        self.completionHandler(err, nil);
        [self.requestDict removeObjectForKey:HOMELIST];
    }
}

@end
