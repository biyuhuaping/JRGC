//
//  UCFBidDetailAndInvestPageLogic.m
//  JRGC
//
//  Created by zrc on 2019/2/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBidDetailAndInvestPageLogic.h"
#import "UCFNewHomeListModel.h"
#import "HSHelper.h"
#import "InvestPageInfoApi.h"
#import "UCFBidModel.h"
#import "UCFBatchInvestmentViewController.h"
#import "UCFFacReservedViewController.h"
#import "UCFBidDetailRequest.h"
#import "UCFBidDetailModel.h"
#import "UCFNewProjectDetailViewController.h"
#import "NewPurchaseBidController.h"
#import "RiskAssessmentViewController.h"
#import "UCFBatchBidRequest.h"
#import "UCFCollectionDetailViewController.h"
#import "UCFNewCollectionDetailViewController.h"
@implementation UCFBidDetailAndInvestPageLogic
+ (void)bidDetailAndInvestPageLogicUseDataModel:(id)bidmodel detail:(BOOL)isDetail rootViewController:(UIViewController *)controler
{
   if (isDetail) {
        if ([bidmodel isKindOfClass:[UCFNewHomeListPrdlist class]]) {
            if (!SingleUserInfo.loginData.userInfo.userId) {
                [SingleUserInfo loadLoginViewController];
                return;
            }
            
            UCFNewHomeListPrdlist *model = bidmodel;
            NSInteger type = [model.type integerValue];
            if (type == 1 || type == 14) {
                HSHelper *helper = [HSHelper new];
                NSString *messageStr =  [helper checkCompanyIsOpen:SelectAccoutTypeP2P];
                if (![messageStr isEqualToString:@""]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                if(type == 14)
                { //集合标详情
                    [self gotoCollectionDetailViewContoller:model controller:controler];
                }
                else
                {
                    NSInteger step = [SingleUserInfo.loginData.userInfo.openStatus integerValue];
                    if (step == 1 || step == 2) {
                        BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:P2PTIP1 cancelButtonTitle:@"取消" clickButton:^(NSInteger index){
                            if (index == 1) {
                                HSHelper *helper = [HSHelper new];
                                
                                [helper pushOpenHSType:SelectAccoutTypeP2P Step:step nav:controler.navigationController];
                            }
                        } otherButtonTitles:@"确认"];
                        [alert show];
                        return;
                    }
                    //                    查看标详情
                    UCFBidDetailRequest *api = [[UCFBidDetailRequest alloc] initWithProjectId:model.ID bidState:model.status];
                    api.animatingView = controler.view;
                    
                    [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        UCFBidDetailModel *model =  request.responseJSONModel;
                        NSString *message = model.message;
                        if (model.ret) {
                            UCFNewProjectDetailViewController *vc = [[UCFNewProjectDetailViewController alloc] init];
                            vc.model = model;
                            vc.accoutType = SelectAccoutTypeP2P;
                            vc.hidesBottomBarWhenPushed = YES;
                            [controler.navigationController pushViewController:vc animated:YES];
                        } else {
                            [AuxiliaryFunc showAlertViewWithMessage:message];
                        }
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        
                    }];
                    [api start];
                }
                
                
            } else if (type == 0 || type == 3) { //0预约宝 3智存宝
                BOOL b = [self checkUserCanInvestIsDetail:NO type:SelectAccoutTypeP2P control:controler];
                if (!b) {
                    return;
                }
                if (!SingleUserInfo.loginData.userInfo.isAutoBid) {
                    UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
                    batchInvestment.isStep = 1;
                    batchInvestment.accoutType = SelectAccoutTypeP2P;
                    batchInvestment.hidesBottomBarWhenPushed = YES;
                    [controler.navigationController pushViewController:batchInvestment animated:YES];
                    return;
                }
                if (!SingleUserInfo.loginData.userInfo.isRisk) {
    
                    BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:@"您还没进行风险评估" cancelButtonTitle:@"取消" clickButton:^(NSInteger index){
                        if (index == 1) {
                            RiskAssessmentViewController *vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
                            vc.accoutType = SelectAccoutTypeP2P;
                            vc.hidesBottomBarWhenPushed = YES;
                            [controler.navigationController pushViewController:vc animated:YES];
                        }
                    } otherButtonTitles:@"测试"];
                    [alert show];
                    return;
                    
                }
                UCFFacReservedViewController *facReservedWeb = [[UCFFacReservedViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
                if ([model.groupType  isEqualToString:@"1"]) {
                    facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@&status=%@", NEWUSER_PRODUCTS_URL, model.ID,model.status];
                }
                else if (type == 0) {//预约宝
                    facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@&status=%@", RESERVEDETAIL_APPLY_URL, model.ID,model.status];
                }else if(type == 3) {//智存宝
                    facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@&status=%@", INTELLIGENTDETAIL_APPLY_URL, model.ID,model.status];
                }
                facReservedWeb.hidesBottomBarWhenPushed = YES;
                [controler.navigationController pushViewController:facReservedWeb animated:YES];
            }
        }
    } else {
        if ([bidmodel isKindOfClass:[UCFNewHomeListPrdlist class]]) {
            if (!SingleUserInfo.loginData.userInfo.userId) {
                [SingleUserInfo loadLoginViewController];
                return;
            }
            UCFNewHomeListPrdlist *tmpModel =  (UCFNewHomeListPrdlist *)bidmodel;
            NSInteger type = [tmpModel.type integerValue];
            if (type  == 1 || type == 14) { //14 集合标  1 p2p散标
                
                HSHelper *helper = [HSHelper new];
                NSString *messageStr =  [helper checkCompanyIsOpen:SelectAccoutTypeP2P];
                if (![messageStr isEqualToString:@""]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                if (type == 14) {
                    [self gotoCollectionDetailViewContoller:tmpModel controller:controler];
                } else {
                    if ([tmpModel.status intValue ] != 2){
                        return;
                    }
                    if([self checkUserCanInvestIsDetail:NO type:SelectAccoutTypeP2P control:controler]){//
                        @PGWeakObj(self);
                        
                        InvestPageInfoApi *api = [[InvestPageInfoApi alloc] initWithProjectId:tmpModel.ID bidStatue:tmpModel.status type:SelectAccoutTypeP2P];
                        api.animatingView = controler.view;
                        [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                            [selfWeak dealInvestInfoData:request.responseJSONModel andControl:controler];
                            
                        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                            
                        }];
                        [api start];
                    }
                }
            }else if (type == 0 || type == 3) {   // 0 预约宝 3智存宝
                BOOL b = [self checkUserCanInvestIsDetail:NO type:SelectAccoutTypeP2P control:controler];
                if (!b) {
                    return;
                }
                if (!SingleUserInfo.loginData.userInfo.isRisk) {
                    BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:@"您还没进行风险评估" cancelButtonTitle:@"取消" clickButton:^(NSInteger index){
                        if (index == 1) {
                            RiskAssessmentViewController *vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
                            vc.accoutType = SelectAccoutTypeP2P;
                            vc.hidesBottomBarWhenPushed = YES;
                            [controler.navigationController pushViewController:vc animated:YES];
                        }
                    } otherButtonTitles:@"测试"];
                    [alert show];
                    return;
                }
                if (!SingleUserInfo.loginData.userInfo.isAutoBid) {
                    UCFBatchInvestmentViewController *batchInvestment = [[UCFBatchInvestmentViewController alloc] init];
                    batchInvestment.isStep = 1;
                    batchInvestment.accoutType = SelectAccoutTypeP2P;
                    batchInvestment.hidesBottomBarWhenPushed = YES;
                    [controler.navigationController pushViewController:batchInvestment animated:YES];
                    return;
                }
                UCFFacReservedViewController *facReservedWeb = [[UCFFacReservedViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
                if ([tmpModel.groupType isEqualToString:@"1"]) {
                    facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@&status=%@", NEWUSER_APPLY_URL, tmpModel.ID,tmpModel.status];
                } else {
//                    facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@&status=%@", PRERESERVE_APPLY_URL, tmpModel.ID,tmpModel.status];
                    if (type == 0) {
                        facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@&status=%@", RESERVEINVEST_APPLY_URL, tmpModel.ID,tmpModel.status];
                    } else {
                        facReservedWeb.url = [NSString stringWithFormat:@"%@?applyInvestClaimId=%@&status=%@", INTELLIGENTLOAN_APPLY_URL, tmpModel.ID,tmpModel.status];
                    }
                }
                facReservedWeb.hidesBottomBarWhenPushed = YES;
                [controler.navigationController pushViewController:facReservedWeb animated:YES];
            }
        }
    }
}
+(void)gotoCollectionDetailViewContoller:(UCFNewHomeListPrdlist *)model controller:(UIViewController *)controller{
    
    
//     NSString *uuid = SingleUserInfo.loginData.userInfo.userId;
//     __weak typeof(self) weakSelf = self;
     if ([self checkUserCanInvestIsDetail:YES type:SelectAccoutTypeP2P control:controller]) {

        UCFBatchBidRequest *api = [[UCFBatchBidRequest alloc] initWithProjectId:model.ID bidState:model.status];
    
         [api setCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
             DDLogDebug(@"%@",request.responseString);
             
             UCFNewCollectionDetailViewController *vc = [[UCFNewCollectionDetailViewController alloc] init];
             vc.model = request.responseJSONModel;
             vc.hidesBottomBarWhenPushed = YES;
             [controller.navigationController pushViewController:vc  animated:YES];
             
         } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
             
         }];
         
         [api start];
     }
         
         
//    [self.cycleImageVC.presenter fetchCollectionDetailDataWithParameter:parameter completionHandler:^(NSError *error, id result) {
//     [MBProgressHUD hideOriginAllHUDsForView:weakSelf.view animated:YES];
//     NSDictionary *dic = (NSDictionary *)result;
//     NSString *rstcode = dic[@"ret"];
//     NSString *rsttext = dic[@"message"];
//     if ([rstcode intValue] == 1) {
//
//     UCFCollectionDetailViewController *collectionDetailVC = [[UCFCollectionDetailViewController alloc]initWithNibName:@"UCFCollectionDetailViewController" bundle:nil];
//     collectionDetailVC.souceVC = @"P2PVC";
//     collectionDetailVC.colPrdClaimId = colPrdClaimIdStr;
//     collectionDetailVC.detailDataDict = [dic objectSafeDictionaryForKey:@"data"];
//     collectionDetailVC.accoutType = SelectAccoutTypeP2P;
//     [self.navigationController pushViewController:collectionDetailVC  animated:YES];
//     }else {
//     [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
//     }
//     }];
//     }

}
+ (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail type:(SelectAccoutType)accout control:(UIViewController *)control;
{
    
    NSString *tipStr1 = P2PTIP1;
    NSString *tipStr2 = P2PTIP2;
    
    NSInteger openStatus = [SingleUserInfo.loginData.userInfo.openStatus integerValue];
    
    switch (openStatus)
    {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            [self showHSAlert:tipStr1 control:control];
            return NO;
            break;
        }
        case 3://已绑卡-->>>去设置交易密码页面
        {
            if (isDetail) {
                return YES;
            }else
            {
                [self showHSAlert:tipStr2 control:control];
                return NO;
            }
        }
            break;
        default:
            return YES;
            break;
    }
}
+ (void)showHSAlert:(NSString *)alertMessage control:(UIViewController *)control
{
    BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:alertMessage cancelButtonTitle:@"取消" clickButton:^(NSInteger index){
        if (index == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeP2P Step:[SingleUserInfo.loginData.userInfo.openStatus integerValue] nav:control.navigationController];
        }
    } otherButtonTitles:@"确定"];
    [alert show];
}
+ (void)dealInvestInfoData:(UCFBidModel *)model andControl:(UIViewController *)controller
{
    NSInteger code = model.code;
    NSString *message = model.message;
    if (model.ret) {
        NewPurchaseBidController *vc = [[NewPurchaseBidController alloc] init];
        vc.bidDetaiModel = model;
        vc.hidesBottomBarWhenPushed = YES;
        [controller.navigationController pushViewController:vc animated:YES];
    } else if (code == 21 || code == 22){
        //        [self checkUserCanInvest];
    } else if (code == 15) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } else if (code == 19) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles: nil];
        alert.tag =7000;
        [alert show];
    } else if (code == 30) {
        BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:message cancelButtonTitle:@"取消" clickButton:^(NSInteger index){
            if (index == 1) {
                RiskAssessmentViewController *vc = [[RiskAssessmentViewController alloc] initWithNibName:@"RiskAssessmentViewController" bundle:nil];
                vc.accoutType = SelectAccoutTypeP2P;
                vc.hidesBottomBarWhenPushed = YES;
                [controller.navigationController pushViewController:vc animated:YES];
            }
        } otherButtonTitles:@"测试"];
        [alert show];
        return;
    }else if (code == 40) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服",nil];
        alert.tag = 9001;
        [alert show];
    } else {
        [MBProgressHUD displayHudError:model.message withShowTimes:3];
    }
}

@end
