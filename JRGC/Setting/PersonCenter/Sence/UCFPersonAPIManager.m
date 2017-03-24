//
//  UCFPersonAPIManager.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFPersonAPIManager.h"
#import "NetworkModule.h"
#import "JSONKit.h"

@interface UCFPersonAPIManager () <NetworkModuleDelegate>
@property (copy, nonatomic) NetworkCompletionHandler completionHandler;
@end

@implementation UCFPersonAPIManager
- (void)fetchUserInfoWithUserId:(NSString *)userId completionHandler:(NetworkCompletionHandler)completionHandler
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UUID]) {
        NSString *strParameters = [NSString stringWithFormat:@"userId=%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID]];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPersonCenter owner:self Type:SelectAccoutDefault];
        self.completionHandler = completionHandler;
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
    DBLOG(@"UCFSettingViewController : %@",dic);
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    int isSucess = [rstcode intValue];
    
    if (tag.intValue == kSXTagPersonCenter) {
        self.completionHandler(nil, dic);
        self.completionHandler = nil;
    }
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagPersonCenter) {
        self.completionHandler(err, nil);
        self.completionHandler = nil;
    }
}
@end
