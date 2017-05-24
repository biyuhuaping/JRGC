//
//  UCFFeedBackViewController.m
//  JRGC
//  qinyangyue
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 秦洋月. All rights reserved.
//

#import "UCFFeedBackViewController.h"
#import "UCFModifyProportion.h"
#import "UCFProfitBackViewController.h"
#import "NZLabel.h"
#import <UShareUI/UShareUI.h>

#import "UCFToolsMehod.h"
#import "FullWebViewController.h"
#import "UCFWebViewJavascriptBridgeLevel.h"
#import "UCFRegistrationRecord.h"

@interface UCFFeedBackViewController ()<UMSocialPlatformProvider>

@property (strong, nonatomic) IBOutlet UILabel *sumCommLab;//我的返利
@property (strong, nonatomic) IBOutlet NZLabel *userRecommendCountLab;//邀请投资人数
@property (strong, nonatomic) IBOutlet NZLabel *zxInviteFriendsCountLab;//尊享注册人数
@property (strong, nonatomic) IBOutlet NZLabel *p2pInviteFriendsCountLab;//微金注册人数
@property (strong, nonatomic) IBOutlet UILabel *gcmLab;//我的工场码
@property (strong, nonatomic) IBOutlet UILabel *p2pRebateAmtLab; //微金返利
@property (strong, nonatomic) IBOutlet UILabel * zxRebateAmtLab;  //尊享返利
//*********qyy
@property (strong, nonatomic) IBOutlet UILabel *adviserAnnualRateLab;//基础年化佣金
@property (strong, nonatomic) IBOutlet NZLabel *ownRateLab;//我的奖励比例
@property (strong, nonatomic) IBOutlet NZLabel *friendRateLab;//好友奖励比例
@property (strong, nonatomic) NSString *recCount;//邀请注册人数;
//*********qyy
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UIButton *copBtn;
@property (strong, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) NSString *shareTitle;
@property (strong, nonatomic) NSString *shareContent;
@property (strong, nonatomic) NSString *shareUrl;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightView;
@property (strong, nonatomic) IBOutlet UIView *lingView;

//***************qyy
@property (strong, nonatomic) IBOutlet UILabel *yearLab1;//基础年化返利 标题 lab
@property (strong, nonatomic) IBOutlet UILabel *friendLab3;//好友奖励比例
@property (strong, nonatomic) IBOutlet UIButton *CheckInstructionBtn; //佣金说明btn
//***************qyy

//调整横线高度
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;//提示label
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tipsViewHeight;//提示View的身高
@property (strong, nonatomic) id recruitStatus;//值为3时，可以点击tipsview

@property (strong, nonatomic) IBOutlet UILabel *label_moutheMoney;
@property (strong, nonatomic) IBOutlet UILabel *label_p2pMoney;

@property (strong, nonatomic) IBOutlet UILabel *label_titleone;//上月您和好友投尊享标年化额
@property (strong, nonatomic) IBOutlet NZLabel *label_titletow;//本月尊享标年化佣金

@property (strong, nonatomic) IBOutlet NZLabel *label_titlethree;//P2P标年化佣金

@property (strong, nonatomic) IBOutlet UIView *view_Up;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view_secondHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *view_upHeight;
- (IBAction)gotoWeiJinRebateAmtVC:(id)sender;//去微金返利页面
- (IBAction)gotoHonerRebateAmtVC:(id)sender;//去尊享返利页面

@end

@implementation UCFFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLeftButton];
    
    if (self.accoutType == SelectAccoutTypeHoner) {
        baseTitleLabel.text = @"尊享邀请返利";
    }else{
        baseTitleLabel.text = @"微金邀请返利";
    }
   
    
    [_shareBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_shareBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    [_copBtn setBackgroundImage:[[UIImage imageNamed:@"btn_bule"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_copBtn setBackgroundImage:[[UIImage imageNamed:@"btn_bule_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMyInvestDataList) name:@"getMyInvestDataList" object:nil];
    _CheckInstructionBtn.hidden = YES;
    [self getMyInvestDataList];
    [self getAppSetting];
}

//复制到剪切板
- (IBAction)copy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _shareUrl;
    [AuxiliaryFunc showToastMessage:@"已复制到剪切板" withView:self.view];
}

//分享到
- (IBAction)shareBtn:(id)sender{
    //分享
    //微信分享链接
    //    NSString *urlStr = @"http://fore.9888.cn/cms/ggk/";
//    _shareUrl = [NSString stringWithFormat:@"http://passport.9888.cn/pp-web2/register/phone.do?gcm=%@",_gcmLab.text];
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    __weak typeof(self) weakSelf = self;
    //显示分享面板 （自定义UI可以忽略）
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [weakSelf shareDataWithPlatform:platformType withObject:messageObject];
    }];
}

- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType withObject:(UMSocialMessageObject *)object {
    UMSocialMessageObject *messageObject = object;
    if (platformType == UMSocialPlatformType_Sina) {
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:_shareTitle descr:_shareContent thumImage:[UIImage imageNamed:@"AppIcon"]];
        [shareObject setShareImage:_shareImage];
        messageObject.shareObject = shareObject;
        messageObject.text = [NSString stringWithFormat:@"%@%@%@",_shareTitle,_shareContent,_shareUrl];
    } else {
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_shareTitle descr:_shareContent thumImage:_shareImage];
        [shareObject setWebpageUrl:_shareUrl];
        messageObject.shareObject = shareObject;
    }
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        NSString *message = nil;
        if (!error) {
            message = [NSString stringWithFormat:@"分享成功"];
            [MBProgressHUD displayHudError:message];
        }
        else{
            [MBProgressHUD displayHudError:@"分享失败"];
            if (error) {
                message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
            }
            else{
                message = [NSString stringWithFormat:@"分享失败"];
            }
        }
    }];
}

//进入邀请记录页面
- (IBAction)toMyRebateView:(id)sender {
    //邀请记录
    UCFRegistrationRecord *vc = [[UCFRegistrationRecord alloc]initWithNibName:@"UCFRegistrationRecord" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];

}

//去设置 奖励年化佣金比例（废弃）
- (IBAction)toNextView:(id)sender {
    if ([_gcmLab.text hasPrefix:@"C"] && [_recCount intValue] == 0) {//无下线好友的C码客户
        [AuxiliaryFunc showToastMessage:@"您暂无好友，不可调整默认比例" withView:self.view];
        return;
    }
    
    //奖励年化返利
    UCFModifyProportion *modifyView = [[UCFModifyProportion alloc]initWithNibName:@"UCFModifyProportion" bundle:nil];
    [self.navigationController pushViewController:modifyView animated:YES];
}

//点击提示View调用方法
- (IBAction)touchTipsView:(id)sender{
    if ([_recruitStatus integerValue] == 3) {
        UCFWebViewJavascriptBridgeLevel *subVC = [[UCFWebViewJavascriptBridgeLevel alloc]initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
        //    subVC.navTitle = _actionArr[i][@"title"];
        subVC.url      = @"https://m.9888.cn/static/wap/topic-recommender-recruitment/index.html";//请求地址;
        [self.navigationController pushViewController:subVC animated:YES];
    }
}

//佣金说明
- (IBAction)clickCheckInstructionBtn:(id)sender {
    //FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:ANNUALCOMMOSIONURL title:@"年化佣金小贴士"];
    //webController.baseTitleType = @"specialUser";
    //webController.sourceVc = @"feedBackVC";
    //[self.navigationController pushViewController:webController animated:YES];
    
    UCFWebViewJavascriptBridgeLevel *subVC = [[UCFWebViewJavascriptBridgeLevel alloc]initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
//    subVC.navTitle = @"年化佣金小贴士"
    subVC.url      = ANNUALCOMMOSIONURL;//请求地址;
    [self.navigationController pushViewController:subVC animated:YES];
}

#pragma mark - 请求网络及回调
//获取我的投资列表
- (void)getMyInvestDataList
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",nil];
    //*******qinyy
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:KSXTagMyInviteRebateinfo owner:self signature:YES Type:self.accoutType];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//获取分享各种信息
- (void)getAppSetting{
    NSString *strParameters = [NSString stringWithFormat:@"gcm=%@",_gcmLab.text];//5644
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGetAppSetting owner:self Type:self.accoutType];
}

//开始请求
- (void)beginPost:(kSXTag)tag{
    if (tag == kSXtagInviteRebate){
//        [GiFHUD show];
    }
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [GiFHUD dismiss];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    //    _totalCountLab.text = [NSString stringWithFormat:@"共%@笔回款记录",dic[@"pageData"][@"pagination"][@"totalCount"]];
    DBLOG(@"邀请返利页：%@",dic);
    if (tag.intValue == KSXTagMyInviteRebateinfo) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        NSDictionary* dictemp = [dic objectSafeForKey:@"data"];
        if ([rstcode intValue] == 1) {
            _shareUrl = [dictemp objectSafeForKey:@"inviteUrl"];
            
            _sumCommLab.text = [NSString stringWithFormat:@"¥%@",dictemp[@"rebateAmt"]];//我的返利
            _userRecommendCountLab.text = [NSString stringWithFormat:@"邀请人数:%@人",dictemp[@"userRecommendCount"]];//邀请投资人数
            
            
            NSString *P2PCountStr1 = [NSString stringWithFormat:@"微金返利(%@人投资）",[dictemp objectSafeForKey:@"p2pInviteFriendsCount"]];//微金人数
            NSString *P2PCountStr2 = [NSString stringWithFormat:@"(%@人投资）",[dictemp objectSafeForKey:@"p2pInviteFriendsCount"]];//微金人数
            _p2pInviteFriendsCountLab.text = P2PCountStr1;
            [_p2pInviteFriendsCountLab setFont:[UIFont systemFontOfSize:10] string:P2PCountStr2];
            
            _p2pRebateAmtLab.text =  [NSString stringWithFormat:@"¥%@",dictemp[@"p2pRebateAmt"]];//微金返利

            P2PCountStr1 = [NSString stringWithFormat:@"尊享返利(%@人投资）",[dictemp objectSafeForKey:@"zxInviteFriendsCount"]];//尊享投资人数
            P2PCountStr2 = [NSString stringWithFormat:@"(%@人投资）",[dictemp objectSafeForKey:@"zxInviteFriendsCount"]];//尊享投资人数
            _zxInviteFriendsCountLab.text = P2PCountStr1;
            [_zxInviteFriendsCountLab setFont:[UIFont systemFontOfSize:10] string:P2PCountStr2];
            _zxRebateAmtLab.text =  [NSString stringWithFormat:@"¥%@",dictemp[@"zxRebateAmt"]];//尊享返利

            _gcmLab.text = dictemp[@"promotionCode"];//我的工场码
            _recruitStatus = dictemp[@"recruitStatus"];
            _label_titleone.text = dictemp[@"enjoyAnnualAmountText"];
            _label_titletow.text = dictemp[@"enjoyCommissionProportionText"];
            _label_titlethree.text = dictemp[@"p2pYearCommissionText"];
            
            NSString *tipsStr = dictemp[@"recruitDes"];
            if (tipsStr.length > 0) {
                _tipsLabel.text = tipsStr;
                _tipsViewHeight.constant = 35;
            }
            //**************************qyy**************
            NSString *adviserAnnualRate = @"¥0.00";
            
            if ([[dictemp allKeys] containsObject:@"enjoyAnnualAmount"] ) {
                if ([dictemp[@"enjoyAnnualAmount"] floatValue] > 0){
                    _adviserAnnualRateLab.text = [NSString stringWithFormat:@"¥%@",dictemp[@"enjoyAnnualAmount"]];//我的年化佣金
                }else{
                    _adviserAnnualRateLab.text = adviserAnnualRate;
                }
            }else {
                _adviserAnnualRateLab.text = adviserAnnualRate;
            }
            

            BOOL feeGateIsOpen = [[dictemp objectSafeForKey:@"feeGateIsOpen"] boolValue];//邀请返利A码用户 查看佣金说明 开:1 关:0
            _CheckInstructionBtn.hidden = !feeGateIsOpen;
            
            if ([_gcmLab.text hasPrefix:@"A"]){
                _view_secondHeight.constant = 55;
                [_label_titletow setFontColor:UIColorWithRGB(0xfd4d4c) string:@"非等额标"];
                [_label_titlethree setFontColor:UIColorWithRGB(0xfd4d4c) string:@"等额标"];

            }else{
//                if (kIS_IOS8) {
//                    _view_upHeight.active = YES;//因为需要根据文字多少，来控制view的高度，所以让约束复活，限制高度，调整高度。
//                    _view_upHeight.constant = 0;
//                }else{
//                    _view_upHeight.constant = 0;//为iOS8之前的版本临时适配。
                    
                    NSDictionary* views = NSDictionaryOfVariableBindings(_view_Up);
                    //设置高度
                    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_view_Up(0)]" options:0 metrics:nil views:views]];

//                }
            }
            
            _label_moutheMoney.text = dictemp[@"enjoyDescribe"];//***本月尊享标描述
            _label_p2pMoney.text = dictemp[@"p2pCommissionDescribe"];//***p2p尊享标描述
            _ownRateLab.text =  [NSString stringWithFormat:@"%@",[dictemp objectSafeForKey:@"enjoyCommissionProportion"]];//本月尊享标年化佣金;
            _friendRateLab.text = [NSString stringWithFormat:@"%@",[dictemp objectSafeForKey: @"p2pYearCommission"]];//P2P标年化佣金;
            [_ownRateLab setFont:[UIFont systemFontOfSize:15] string:@"%"];
            [_friendRateLab setFont:[UIFont systemFontOfSize:15] string:@"%"];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
//        [[NSNotificationCenter defaultCenter]postNotificationName:REDALERTISHIDE object:@"5"];
//        
//        [self getAppSetting];

    }
    else if (tag.intValue == kSXTagGetAppSetting){
        //        NSString *rstcode = dic[@"status"];
        //        NSString *rsttext = dic[@"statusdes"];
        NSArray *temArr = [NSArray arrayWithArray:dic[@"result"]];
        //1:红包URL   2：红包文字描述    3：工场码图片URL    4:工场码文字描述   5：红包标题  6：工场码标题
        for (NSDictionary *result in temArr) {
            if ([result[@"rank"] intValue] == 3) {//3：工场码图片URL
                _shareImage = [Common getImageFromURL:result[@"desvalue"]];
            }else if ([result[@"rank"] intValue] == 4) {//4：工场码文字描述
                _shareContent = result[@"desvalue"];
            }else if ([result[@"rank"] intValue] == 6) {//6：工场码标题
                _shareTitle = result[@"desvalue"];
            }
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [GiFHUD dismiss];
    if (tag.intValue == kSXtagInviteRebate) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)dealloc{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getMyInvestDataList" object:nil];
}



#pragma mark -微金返利页面
- (IBAction)gotoWeiJinRebateAmtVC:(id)sender {

    UCFProfitBackViewController *mv = [[UCFProfitBackViewController alloc]initWithNibName:@"UCFProfitBackViewController" bundle:nil];
    mv.accoutType = SelectAccoutTypeP2P;
    mv.index = 0;
    __weak typeof(self) weakSelf = self;
//    mv.headerInfoBlock = ^(NSDictionary *dic){
//        weakSelf.sumCommLab.text = [NSString stringWithFormat:@"¥%@",dic[@"sumComm"]];//微金返利
//        weakSelf.p2pInviteFriendsCountLab.text = [NSString stringWithFormat:@"邀请投资人数:%@人",dic[@"p2pInviteFriendsCount"]];//邀请投资人数
//        weakSelf.userRecommendCountLab.text = [NSString stringWithFormat:@"邀请注册人数:%@人",dic[@"userRecommendCount"]];//邀请注册人数
//    };
    [self.navigationController pushViewController:mv animated:YES];
    
}
#pragma mark -尊享返利页面
- (IBAction)gotoHonerRebateAmtVC:(id)sender{
    
    UCFProfitBackViewController *mv = [[UCFProfitBackViewController alloc]initWithNibName:@"UCFProfitBackViewController" bundle:nil];
    mv.accoutType = SelectAccoutTypeHoner;
    mv.index = 1;
    __weak typeof(self) weakSelf = self;
//    mv.headerInfoBlock = ^(NSDictionary *dic){
//        weakSelf.sumCommLab.text = [NSString stringWithFormat:@"¥%@",dic[@"sumComm"]];//尊享返利
//        weakSelf.zxInviteFriendsCountLab.text = [NSString stringWithFormat:@"邀请投资人数:%@人",dic[@"zxInviteFriendsCount"]];//邀请投资人数
//        weakSelf.userRecommendCountLab.text = [NSString stringWithFormat:@"邀请注册人数:%@人",dic[@"userRecommendCount"]];//邀请注册人数
//    };
    [self.navigationController pushViewController:mv animated:YES];
}
@end
