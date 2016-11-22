//
//  UCFFeedBackViewController.m
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFFeedBackViewController.h"
#import "UCFModifyProportion.h"
#import "UCFMyRebateViewCtrl.h"
#import "NZLabel.h"
#import "UMSocialUIManager.h"

#import "UCFToolsMehod.h"
#import "FullWebViewController.h"
#import "UCFWebViewJavascriptBridgeLevel.h"

@interface UCFFeedBackViewController ()<UMSocialPlatformProvider>

@property (strong, nonatomic) IBOutlet UILabel *sumCommLab;//我的返利
@property (strong, nonatomic) IBOutlet NZLabel *friendCountLab;//邀请投资人数
@property (strong, nonatomic) IBOutlet NZLabel *recCountLab;//邀请注册人数
@property (strong, nonatomic) IBOutlet UILabel *gcmLab;//我的工场码
@property (strong, nonatomic) IBOutlet UILabel *adviserAnnualRateLab;//基础年化佣金
@property (strong, nonatomic) IBOutlet UILabel *yearRateLab;//奖励年化佣金
@property (strong, nonatomic) IBOutlet UILabel *ownRateLab;//我的奖励比例
@property (strong, nonatomic) IBOutlet UILabel *friendRateLab;//好友奖励比例
@property (strong, nonatomic) NSString *recCount;//邀请注册人数;

@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UIButton *copBtn;
@property (strong, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) NSString *shareTitle;
@property (strong, nonatomic) NSString *shareContent;
@property (strong, nonatomic) NSString *shareUrl;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightView;
@property (strong, nonatomic) IBOutlet UIView *lingView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *yearRateViewHeight; //奖励年化佣金view的高度
@property (strong, nonatomic) IBOutlet UILabel *myAnnualRateLab;//基础年化返利 标题 lab
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *yearRateAndShareHeight;//奖励年化佣金view与分享view的之间的距离

@property (strong, nonatomic) IBOutlet UILabel *yearLab1;//基础年化返利 标题 lab
@property (strong, nonatomic) IBOutlet UILabel *ownLab2;//我的奖励比例
@property (strong, nonatomic) IBOutlet UILabel *friendLab3;//好友奖励比例
@property (strong, nonatomic) IBOutlet UIButton *CheckInstructionBtn; //查看说明btn

//调整横线高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height3;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height4;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height5;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height6;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height7;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height8;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height9;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height10;

@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;//提示label
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tipsViewHeight;//提示View的身高
@property (strong, nonatomic) id recruitStatus;//值为3时，可以点击tipsview

@end

@implementation UCFFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLeftButton];
    baseTitleLabel.text = @"邀请返利";
    _height1.constant = 0.5;
    _height2.constant = 0.5;
    _height3.constant = 0.5;
    _height4.constant = 0.5;
    _height5.constant = 0.5;
    _height6.constant = 0.5;
    _height7.constant = 0.5;
    _height8.constant = 0.5;
    _height9.constant = 0.5;
    _height10.constant = 0.5;
    _yearRateViewHeight.constant = 0;
    _yearRateAndShareHeight.constant = 0;
    _yearLab1.hidden = YES;
    _ownLab2.hidden = YES;
    _friendLab3.hidden = YES;
     _myAnnualRateLab.text = @"";
    _CheckInstructionBtn.hidden = YES;
    
    [_shareBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_shareBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    [_copBtn setBackgroundImage:[[UIImage imageNamed:@"btn_bule"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_copBtn setBackgroundImage:[[UIImage imageNamed:@"btn_bule_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMyInvestDataList) name:@"getMyInvestDataList" object:nil];
    
    [self getMyInvestDataList];
    [self getAppSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//复制到剪切板
- (IBAction)copy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"http://passport.9888.cn/pp-web2/register/phone.do?gcm=%@",_gcmLab.text];
    [AuxiliaryFunc showToastMessage:@"已复制到剪切板" withView:self.view];
}

//分享到
- (IBAction)shareBtn:(id)sender{
    //分享
    //微信分享链接
    //    NSString *urlStr = @"http://fore.9888.cn/cms/ggk/";
    _shareUrl = [NSString stringWithFormat:@"http://passport.9888.cn/pp-web2/register/phone.do?gcm=%@",_gcmLab.text];
    
    __weak typeof(self) weakSelf = self;
    //显示分享面板 （自定义UI可以忽略）
    [[UMSocialManager defaultManager] addAddUserDefinePlatformProvider:self withUserDefinePlatformType:UMSocialPlatformType_Qzone];
    [[UMSocialManager defaultManager] addAddUserDefinePlatformProvider:self withUserDefinePlatformType:UMSocialPlatformType_QQ];
    [[UMSocialManager defaultManager] addAddUserDefinePlatformProvider:self withUserDefinePlatformType:UMSocialPlatformType_WechatFavorite];
    [[UMSocialManager defaultManager] addAddUserDefinePlatformProvider:self withUserDefinePlatformType:UMSocialPlatformType_WechatFavorite];
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMShareMenuSelectionView *shareSelectionView,UMSocialPlatformType platformType) {
        [weakSelf shareDataWithPlatform:platformType withObject:messageObject];
    }];
}
- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType withObject:(UMSocialMessageObject *)object
{
    UMSocialMessageObject *messageObject = object;
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_shareTitle descr:_shareContent thumImage:_shareImage];
    [shareObject setWebpageUrl:_shareUrl];
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        NSString *message = nil;
        if (!error) {
            message = [NSString stringWithFormat:@"分享成功"];
        }
        else{
            if (error) {
                message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
            }
            else{
                message = [NSString stringWithFormat:@"分享失败"];
            }
        }
    }];
}

//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
//{
//    if (platformName == UMShareToSina || platformName == UMShareToTencent) {
//        socialData.shareText = [NSString stringWithFormat:@"%@%@",_shareContent,_shareUrl];
//    }
//}

//进入我的返利列表
- (IBAction)toMyRebateView:(id)sender {
    //我的返利
    UCFMyRebateViewCtrl *mv = [[UCFMyRebateViewCtrl alloc]initWithNibName:@"UCFMyRebateViewCtrl" bundle:nil];
    __weak typeof(self) weakSelf = self;
    mv.headerInfoBlock = ^(NSDictionary *dic){
        weakSelf.sumCommLab.text = [NSString stringWithFormat:@"¥%@",dic[@"sumComm"]];//我的返利
        weakSelf.friendCountLab.text = [NSString stringWithFormat:@"邀请投资人数:%@人",dic[@"friendCount"]];//邀请投资人数
        weakSelf.recCountLab.text = [NSString stringWithFormat:@"邀请注册人数:%@人",dic[@"recCount"]];//邀请注册人数
    };
    [self.navigationController pushViewController:mv animated:YES];
}

//去设置 奖励年化佣金比例
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
        subVC.url      = @"http://m.9888.cn/static/wap/topic-recommender-recruitment/index.html";//请求地址;
        [self.navigationController pushViewController:subVC animated:YES];
    }
}

#pragma mark - 请求网络及回调
//获取我的投资列表
- (void)getMyInvestDataList
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@",userId];//5644
//     NSString *strParameters = [NSString stringWithFormat:@"userId=5644"];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXtagInviteRebate owner:self];
}

//获取分享各种信息
- (void)getAppSetting{
    NSString *strParameters = [NSString stringWithFormat:@"gcm=%@",_gcmLab.text];//5644
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGetAppSetting owner:self];
}

//开始请求
- (void)beginPost:(kSXTag)tag{
    if (tag == kSXtagInviteRebate)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    
//    _totalCountLab.text = [NSString stringWithFormat:@"共%@笔回款记录",dic[@"pageData"][@"pagination"][@"totalCount"]];
    DBLOG(@"邀请返利页：%@",dic);
    if (tag.intValue == kSXtagInviteRebate) {
        if ([rstcode intValue] == 1) {
            _recCount = dic[@"recCount"];//邀请注册人数
            _sumCommLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:dic[@"sumComm"]]];//我的返利
            _friendCountLab.text = [NSString stringWithFormat:@"邀请投资人数:%@人",dic[@"friendCount"]];//邀请投资人数
            _recCountLab.text = [NSString stringWithFormat:@"邀请注册人数:%@人",_recCount];//邀请注册人数
            _gcmLab.text = dic[@"gcm"];//我的工场码
            _recruitStatus = dic[@"recruitStatus"];
            NSString *tipsStr = dic[@"recruitDes"];
            if (tipsStr.length > 0) {
                _tipsLabel.text = tipsStr;
                _tipsViewHeight.constant = 35;
            }

            NSString *adviserAnnualRate = @"--";
            BOOL userSwith = [[dic objectSafeForKey:@"isOpen"] boolValue]; //大开关
            BOOL feeGateIsOpen = [[dic objectSafeForKey:@"feeGateIsOpen"] boolValue];//邀请返利A码用户 查看说明详情 开关
            if(userSwith)
            {   _myAnnualRateLab.text = @"我的年化佣金";
                _lingView.hidden = NO;
                if ([[dic allKeys] containsObject:@"annual_commission_proportion"] ) {
                    if ([dic[@"annual_commission_proportion"] floatValue] > 0)
                        _adviserAnnualRateLab.text = [NSString stringWithFormat:@"%@",dic[@"annual_commission_proportion"]];//我的年化佣金
                }else {
                    _adviserAnnualRateLab.text = adviserAnnualRate;
                }
                if ([_gcmLab.text hasPrefix:@"A"] && feeGateIsOpen ){
                    _CheckInstructionBtn.hidden = NO;
                }
            }else{
                _myAnnualRateLab.text = @"基础年化佣金";
            
                if ([[dic allKeys] containsObject:@"adviserAnnualRate"] ) {
                    if ([dic[@"adviserAnnualRate"] intValue] > 0)
                        _adviserAnnualRateLab.text = [NSString stringWithFormat:@"%@%%",dic[@"adviserAnnualRate"]];//基础年化佣金
                }else {
                    _adviserAnnualRateLab.text = adviserAnnualRate;
                } 
               NSString *yearRate = @"--";
               if ([[dic allKeys] containsObject:@"yearRate"]) {
                   if ([dic[@"yearRate"] length] > 0)
                       _yearRateLab.text = [NSString stringWithFormat:@"%@%%",dic[@"yearRate"]];//奖励年化佣金
               }else {
                   _yearRateLab.text = yearRate;
               }
               _yearRateViewHeight.constant = 100;
               _yearRateAndShareHeight.constant = 10;
               
               _ownRateLab.text = [NSString stringWithFormat:@"%@%%",dic[@"ownRate"]];//我的奖励比例
               _friendRateLab.text = [NSString stringWithFormat:@"%@%%",dic[@"friendRate"]];//好友奖励比例
               if ([_gcmLab.text hasPrefix:@"C"]){
                   _heightView.constant = 44;
                   _lingView.hidden = YES;
               }
                _yearLab1.hidden = NO;
                _ownLab2.hidden = NO;
                _friendLab3.hidden = NO;
            }
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:REDALERTISHIDE object:@"5"];
    }
    else if (tag.intValue == kSXTagGetAppSetting){
        NSArray *temArr = [NSArray arrayWithArray:dic[@"result"]];
        //1:红包URL   2：红包文字描述    3：工场码图片URL    4:工场码文字描述   5：红包标题  6：工场码标题
        for (NSDictionary *result in temArr) {
            if ([result[@"rank"] intValue] == 3) {//3：工场码图片URL
                _shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:result[@"desvalue"]]]];
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
    if (tag.intValue == kSXtagInviteRebate) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"getMyInvestDataList" object:nil];
}

- (IBAction)clickCheckInstructionBtn:(id)sender {
    FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:ANNUALCOMMOSIONURL title:@"年化佣金小贴士"];
    webController.baseTitleType = @"specialUser";
    webController.sourceVc = @"feedBackVC";
    [self.navigationController pushViewController:webController animated:YES];
}

@end
