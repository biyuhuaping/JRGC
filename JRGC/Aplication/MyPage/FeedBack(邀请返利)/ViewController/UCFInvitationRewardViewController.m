//
//  UCFInvitationRewardViewController.m
//  JRGC
//
//  Created by njw on 2017/5/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFInvitationRewardViewController.h"
#import "UCFInvitationRewardHeaderView.h"
#import "UCFInvitationRewardCell.h"
#import "UCFInvitationRewardCell2.h"
#import <UShareUI/UShareUI.h>
#import "UCFToolsMehod.h"
#import "UCFRegistrationRecord.h"
#import "UCFSharePictureViewController.h"
@interface UCFInvitationRewardViewController () <UITableViewDelegate, UITableViewDataSource, UCFInvitationRewardCell2Delegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)IBOutlet UILabel *beansCountLabel;
@property (nonatomic,strong)IBOutlet UILabel *userRecommendLabel;
/*
 beansCount	奖励工豆金额	string
 inviteUrl	邀请链接	string
 promotionCode	邀请码	string
 userRecommendCount	邀友数	number
 */
@property (copy, nonatomic) NSString *facCode;
@property (strong, nonatomic) UIImage *shareImage;
@property (strong, nonatomic) NSString *shareTitle;
@property (strong, nonatomic) NSString *shareContent;
@property (strong, nonatomic) NSString *shareUrl;
@property (weak, nonatomic) IBOutlet UIImageView *baseimageView;

@property (strong, nonatomic) NSString *beansCount;	//奖励工豆金额	string
- (IBAction)gotoInvitationRecordVC:(UIControl *)sender;
@property (strong, nonatomic) NSString *userRecommendCount;//	邀友数	number

- (IBAction)gotoShareLinkBtn;
- (IBAction)gotoSharePictureBtn;
@end

@implementation UCFInvitationRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    UIImage *bgShadowImage= [UIImage imageNamed:@"tabbar_shadow.png"];
    self.baseimageView.image = [bgShadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeTile];
    [self getMyInvestDataList];
    [self getAppSetting];
}
#pragma mark - 请求网络及回调
- (void)getMyInvestDataList
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:userId,@"userId",nil];
    //*******qinyy
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:KSXTagMyInviteRewardinfo owner:self signature:YES Type:self.accoutType];
    [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
}
//获取分享各种信息
- (void)getAppSetting{
    NSString *strParameters = [NSString stringWithFormat:@"gcm=5644"];//5644//_gcmLab.text
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
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    //    _totalCountLab.text = [NSString stringWithFormat:@"共%@笔回款记录",dic[@"pageData"][@"pagination"][@"totalCount"]];
    DBLOG(@"邀请返利页：%@",dic);
    if (tag.intValue == KSXTagMyInviteRewardinfo) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        NSDictionary* dictemp = [dic objectSafeDictionaryForKey:@"data"];
        if ([rstcode intValue] == 1) {
            
            /*
             beansCount	奖励工豆金额	string
             inviteUrl	邀请链接	string
             promotionCode	邀请码	string
             userRecommendCount	邀友数	number
             */
             _shareUrl = [dictemp objectSafeForKey:@"inviteUrl"];
             _facCode = [dictemp objectSafeForKey:@"promotionCode"];
             _beansCount = [dictemp objectSafeForKey:@"beansCount"];
             _beansCountLabel.text =  [NSString stringWithFormat:@"¥%@", _beansCount];//我的返利
             _userRecommendCount = [NSString stringWithFormat:@"%@",[dictemp objectSafeForKey:@"userRecommendCount"]];
             _userRecommendLabel.text = [NSString stringWithFormat:@"邀请人数:%@人",_userRecommendCount];
            [self.tableview reloadData];
            
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
//        [[NSNotificationCenter defaultCenter]postNotificationName:REDALERTISHIDE object:@"5"];
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
    if (tag.intValue == kSXtagInviteRebate) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *cellId = @"invitationRewardCell1";
        UCFInvitationRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFInvitationRewardCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        NSString *cellId = @"invitationRewardCell2";
        UCFInvitationRewardCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFInvitationRewardCell2" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        CGFloat h = [self computeHeightWithContent:@"好友注册后30天内用户达到以下用户等级，被邀请人达到相应等级实时发放邀请奖励"];
        h += (60 + (ScreenWidth-20) / 1.25 + (ScreenWidth-20) / 2.4);
        return h + 1;
    }
    else if (indexPath.section == 1) {
        CGFloat h = [self computeHeightWithContent:@"邀请好友注册，两人同时获得奖励，奖励以网站活动详情为准"];
        h += 30;
        return h + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* viewId = @"invitationRewardHeader";
    UCFInvitationRewardHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (nil == view) {
        view = (UCFInvitationRewardHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFInvitationRewardHeaderView" owner:self options:nil] lastObject];
    }
    switch (section) {
        case 0: {
            view.headerTitleLabel.text = @"邀请好友成功标准";
            view.headerTitleLabel.textColor = UIColorWithRGB(0x555555);
            view.describeLabel1.hidden = NO;
            view.describeLabel2.hidden = NO;
            view.describeLabel2.text = self.facCode;
        }
            break;
            
        case 1: {
            view.headerTitleLabel.text = @"邀请注册 获得更多返利";
            view.headerTitleLabel.textColor = UIColorWithRGB(0xfd4d4c);
            view.describeLabel1.hidden = YES;
            view.describeLabel2.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) WithView:view isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xe3e5ea) WithView:view isTop:NO];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.001;
}

- (CGFloat)computeHeightWithContent:(NSString *)content
{
    CGSize stringSize = CGSizeZero;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGRect stringRect = [content boundingRectWithSize:CGSizeMake(ScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    stringSize = stringRect.size;
    return stringSize.height;
}
- (void)invitationRewardCell:(UCFInvitationRewardCell2 *)rewardCell didClickedCopyBtn:(UIButton *)button
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _shareUrl;
    [AuxiliaryFunc showToastMessage:@"已复制到剪切板" withView:self.view];

}
- (IBAction)gotoShareLinkBtn
{
    [self invitationRewardCell:nil didClickedShareBtn:nil];
}
- (IBAction)gotoSharePictureBtn
{
    UCFSharePictureViewController * sharePictrureVC= [UCFSharePictureViewController showSharePictureViewController];
    [self presentViewController:sharePictrureVC animated:YES completion:^{
        
    }];
}

- (void)invitationRewardCell:(UCFInvitationRewardCell2 *)rewardCell didClickedShareBtn:(UIButton *)button
{
    //分享
    //微信分享链接
    //    NSString *urlStr = @"http://fore.9888.cn/cms/ggk/";
    //    _shareUrl = [NSString stringWithFormat:@"http://passport.9888.cn/pp-web2/register/phone.do?gcm=%@",_gcmLab.text];
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    __weak typeof(self) weakSelf = self;
    //显示分享面板 （自定义UI可以忽略）
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ)]];
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


#pragma mark - 邀请记录
- (IBAction)gotoInvitationRecordVC:(UIControl *)sender {
    //邀请记录
    UCFRegistrationRecord *vc = [[UCFRegistrationRecord alloc]initWithNibName:@"UCFRegistrationRecord" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
