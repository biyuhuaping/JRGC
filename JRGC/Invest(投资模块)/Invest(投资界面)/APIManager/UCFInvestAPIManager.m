//
//  UCFInvestAPIManager.m
//  JRGC
//
//  Created by njw on 2017/6/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFInvestAPIManager.h"
#import "NetworkModule.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "AuxiliaryFunc.h"
#import "UCFMicroMoneyGroup.h"
#import "UIDic+Safe.h"
#import "UCFMicroMoneyModel.h"
@interface UCFInvestAPIManager () <NetworkModuleDelegate>

@end

@implementation UCFInvestAPIManager

- (void)getMicroMoneyFromNet
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSDictionary *strParameters;
    if (!uuid) {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"userId", nil];
    }
    else {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid, @"userId", nil];
    }
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagPrdClaimsWJShow owner:self signature:YES Type:SelectAccoutTypeP2P];
}
- (void)getNewMicroMoneyFromNet
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSDictionary *strParameters;
    if (!uuid) {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"userId", nil];
    }
    else {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid, @"userId", nil];
    }
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagP2PAiInvestModule owner:self signature:YES Type:SelectAccoutTypeP2P];
}

- (void)beginPost:(kSXTag)tag
{
    
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.intValue == kSXTagPrdClaimsWJShow) {
        UIViewController *vc = (UIViewController *)self.microMoneyDelegate;
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        if ([rstcode intValue] == 1) {
            
            NSDictionary *resultData = [dic objectSafeDictionaryForKey:@"data"];
            NSArray *resultArr = [resultData objectSafeArrayForKey:@"group"];
            
            
            if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
                NSString *oepnState =  [resultData objectSafeForKey:@"openStatus"];
                [UserInfoSingle sharedManager].openStatus = [oepnState integerValue];
            }
            
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in resultArr) {
                UCFMicroMoneyGroup *microMoneyGroup = [UCFMicroMoneyGroup microMoneyGroupWithDict:dict];
                if ([microMoneyGroup.type isEqualToString:@"13"]) {
                    microMoneyGroup.showMore = NO;
                }
                else {
                    microMoneyGroup.showMore = YES;
                }
                [temp addObject:microMoneyGroup];
            }
            
            if ([self.microMoneyDelegate respondsToSelector:@selector(investApiManager:didSuccessedReturnMicroMoneyResult:withTag:)] && temp.count>0) {
                [self.microMoneyDelegate investApiManager:self didSuccessedReturnMicroMoneyResult:temp withTag:kSXTagPrdClaimsWJShow];
            }
        }else {
            
            [AuxiliaryFunc showToastMessage:rsttext withView:vc.view];
        }
    }
    else if (tag.intValue == kSXTagP2PAiInvestModule) {
        UIViewController *vc = (UIViewController *)self.microMoneyDelegate;
        [MBProgressHUD hideAllHUDsForView:vc.view animated:YES];
        if ([rstcode intValue] == 1) {
            
            NSDictionary *resultData = [dic objectSafeDictionaryForKey:@"data"];
            NSArray *resultArr = [resultData objectSafeArrayForKey:@"prdClaimModels"];
            
            
//            if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
//                NSString *oepnState =  [resultData objectSafeForKey:@"openStatus"];
//                [UserInfoSingle sharedManager].openStatus = [oepnState integerValue];
//            }
            
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in resultArr) {
                UCFMicroMoneyModel *microMoneyModel = [UCFMicroMoneyModel microMoneyModelWithDict:dict];
//                if ([microMoneyModel.type isEqualToString:@"13"])
//                {
//                    microMoneyGroup.showMore = NO;
//                }
//                else {
//                    microMoneyGroup.showMore = YES;
//                }
                [temp addObject:microMoneyModel];
            }
            
            if ([self.microMoneyDelegate respondsToSelector:@selector(investApiManager:didSuccessedReturnMicroMoneyResult:withTag:)] ) {
                [self.microMoneyDelegate investApiManager:self didSuccessedReturnMicroMoneyResult:temp withTag:kSXTagP2PAiInvestModule];
            }
        }else {

            [AuxiliaryFunc showToastMessage:rsttext withView:vc.view];
            if ([self.microMoneyDelegate respondsToSelector:@selector(investApiManager:didFailedReturnMicroMoneyResult:withTag:)] ) {
                [self.microMoneyDelegate investApiManager:self didFailedReturnMicroMoneyResult:@[] withTag:kSXTagP2PAiInvestModule];
            }
        }
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    if (tag.intValue == kSXTagP2PAiInvestModule)
    {
        if ([self.microMoneyDelegate respondsToSelector:@selector(investApiManager:didFailedReturnMicroMoneyResult:withTag:)] ) {
            [self.microMoneyDelegate investApiManager:self didFailedReturnMicroMoneyResult:@[] withTag:kSXTagP2PAiInvestModule];
        }
    }
    
   
}

@end
