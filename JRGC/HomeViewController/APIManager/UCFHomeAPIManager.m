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
            
            NSString *siteNotice = [result objectSafeForKey:@"siteNotice"];
            // 债券转让
            NSString *p2pTransferNum = [result objectSafeForKey:@"p2pTransferNum"];
            // 批量转让
            NSString *totalCount = [result objectSafeForKey:@"totalCount"];
            // 尊享转让
            NSString *zxTransferNum = [result objectSafeForKey:@"zxTransferNum"];
            
            [tempResult setObject:tempArray forKey:@"homelistContent"];
            [tempResult setObject:siteNotice forKey:@"siteNotice"];
            [tempResult setObject:p2pTransferNum forKey:@"p2pTransferNum"];
            [tempResult setObject:totalCount forKey:@"totalCount"];
            [tempResult setObject:zxTransferNum forKey:@"zxTransferNum"];
            complete(nil, tempResult);
        }
        else {
            complete(nil, rsttext);
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
        NetworkCompletionHandler complete = [self.requestDict objectForKey:HOMELIST];
        complete(err, nil);
        [self.requestDict removeObjectForKey:HOMELIST];
    }
}

@end
