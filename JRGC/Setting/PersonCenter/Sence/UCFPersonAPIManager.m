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
#import "UCFPersonCenterModel.h"
#import "UIDic+Safe.h"

@interface UCFPersonAPIManager () <NetworkModuleDelegate>
@property (copy, nonatomic) NetworkCompletionHandler completionHandler;
@end

@implementation UCFPersonAPIManager
- (void)fetchUserInfoWithUserId:(NSString *)userId completionHandler:(NetworkCompletionHandler)completionHandler
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UUID]) {
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:UUID]} tag:kSXTagPersonCenter owner:self signature:YES Type:SelectAccoutDefault];
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
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    DBLOG(@"UCFSettingViewController : %@",dic);
    
    if (tag.intValue == kSXTagPersonCenter) {
        if ([rstcode boolValue]) {
            
            NSDictionary *result = [dic objectSafeDictionaryForKey:@"data"];
            UCFPersonCenterModel *personCenterModel = [UCFPersonCenterModel personCenterWithDict:result];
            self.completionHandler(nil, personCenterModel);
        }
        else {
            self.completionHandler(nil, rsttext);
        }
        
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
