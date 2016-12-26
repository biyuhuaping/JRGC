//
//  UCFCompleteBidViewCtrl.m
//  JRGC
//
//  Created by biyuhuaping on 15/5/14.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFCompleteBidViewCtrl.h"
#import "UCFInvestmentDetailViewController.h"//投资详情
#import "UCFMyFacBeanViewController.h"//我的工豆
#import "UCFCouponViewController.h"//我的返现券
#import "UCFRedEnvelopeViewController.h"//我的红包
#import "UCFPurchaseBidViewController.h"
#import "UCFInvestmentDetailViewController.h"
#import "UCFToolsMehod.h"
#import "RedAlertView.h"
#import "AppDelegate.h"
//#import "UMSocial.h"
#import "UIImageView+NetImageView.h"
#import "UCFWorkPointsViewController.h"
//#import "PraiseAlert.h"
//#import "UMFeedbackViewController.h"
@interface UCFCompleteBidViewCtrl ()<RedAlertViewDelegate>
{
    BOOL    isShowMemberAward; //是否显示会员奖励
    BOOL    isShowLevelInterest; //等级加息是否大于0；
}

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) IBOutlet UIImageView *imaView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *totalInvestAmtLab;//总投资额
@property (weak, nonatomic) IBOutlet UIView *investBaseView;
@property (strong, nonatomic) IBOutlet UILabel *taotalIntrestLab;//预期收益
@property (copy, nonatomic)NSString *redPackageUrl;
@property (copy, nonatomic)NSString *redPicAddress;
@property (copy, nonatomic)NSString *activityname;
@property (copy, nonatomic)NSString *redPackageTitle;
@property (copy, nonatomic)NSString *redPackageContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineHeight;

@end

@implementation UCFCompleteBidViewCtrl
- (void)getToBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;
    //进入投标页 检测一次tab的红点是否消失
    [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_RED_POINT object:nil];
}
- (void)changeBackActionMark
{
    _isBackWorkPointGotoShop = YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_GOOD_COMMENT object:[NSNumber numberWithBool:_isBackWorkPointGotoShop]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initerferUI];
    [self addLeftButton];
    if (_isTransid) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AssignmentUpdate" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
    }
    if ([_dataDict[@"isOpen"] integerValue] == 1) {
        isShowMemberAward = YES;
    } else {
        isShowMemberAward = NO;
    }
     baseTitleLabel.text = @"投标成功";
    _headerView.frame = CGRectMake(0, 0, ScreenWidth, (ScreenWidth * 21/40) + 10);
    _headerView.backgroundColor = UIColorWithRGB(0xebebeb);
    _tableView.tableHeaderView = _headerView;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = UIColorWithRGB(0xebebee);
    _totalInvestAmtLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:_dataDict[@"totalInvestAmt"]]];//总投资额
    _taotalIntrestLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:_dataDict[@"taotalIntrest"]]];//预期收益
    if ([_dataDict[@"vipGradeReward"][@"interestRatesReward"] doubleValue] < 0.001) {
        isShowLevelInterest = NO;
    } else {
        isShowLevelInterest = YES;
    }
    _imaView.image = [UIImage imageNamed:@"banner_default"];
    _imaView.contentMode = UIViewContentModeScaleToFill;
    [_imaView getBannerImageStyle:BidSuccess];
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -10, ScreenWidth, 10)];
    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    shadowView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
    [_investBaseView addSubview:shadowView];
    [self.view bringSubviewToFront:_investBaseView];
    self.view.backgroundColor = UIColorWithRGB(0xebebee);
    [self checkIsHasRedBag];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 30; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)initerferUI{
    self.verticalLineWidth.constant = 0.5;
    self.downLineHeight.constant = 0.5;
}
- (BOOL)checkIsHasRedBag
{
    NSArray *arr = _dataDict[@"activityBeans"];
    for (int i = 0; i < arr.count; i++) {
        int activityBeans = [_dataDict[@"activityBeans"][i][@"activetyunite"] intValue];
        if (activityBeans == 4) {
            self.redPackageUrl = [[[_dataDict objectForKey:@"activityBeans"] objectAtIndex:i] objectForKey:@"redPackageUrl"];
            self.redPicAddress = [[[_dataDict objectForKey:@"activityBeans"] objectAtIndex:i] objectForKey:@"redPicAddress"];
            self.activityname = [[[_dataDict objectForKey:@"activityBeans"] objectAtIndex:i] objectForKey:@"activityname"];
            self.redPackageTitle = [[[_dataDict objectForKey:@"activityBeans"] objectAtIndex:i] objectForKey:@"redPackageTitle"];
            self.redPackageContent = [[[_dataDict objectForKey:@"activityBeans"] objectAtIndex:i] objectForKey:@"redPackageContent"];
            RedAlertView *alertView = [[RedAlertView alloc] init];
            alertView.delegate = self;
            [alertView reloadViews:[arr objectAtIndex:i]];
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app.window addSubview:alertView];
            
            return YES;
        }
    }
    return NO;
}
//- (void)shareRedBag:(NSInteger)index
//{
//    if (index == 2000) {
//        NSURL *shareUrl = [NSURL URLWithString:self.redPicAddress];
//        UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareUrl]];
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.redPackageUrl;
//        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.redPackageTitle;
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.redPackageContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//            }
//        }];
//
//    } else if (index == 2001) {
//        NSURL *shareUrl = [NSURL URLWithString:self.redPicAddress];
//        UIImage *shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareUrl]];
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.redPackageUrl;
//        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.redPackageTitle;
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.redPackageContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//            }
//        }];
//    }
//
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//查看投资详情
- (IBAction)toInvestmentDetail:(id)sender {
    if (_isTransid) {
        UCFInvestmentDetailViewController *controller = [[UCFInvestmentDetailViewController alloc] init];
        controller.billId = [NSString stringWithFormat:@"%@",_dataDict[@"orderId"]];
        controller.detailType = @"2";
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        UCFInvestmentDetailViewController *controller = [[UCFInvestmentDetailViewController alloc] init];
        controller.billId = [NSString stringWithFormat:@"%@",_dataDict[@"orderId"]];
        controller.detailType = @"1";
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (isShowMemberAward) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        headView.backgroundColor = UIColorWithRGB(0xE6E6EA);
        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:headView isTop:NO];
        if (section) {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 29.5)];
            label1.backgroundColor = UIColorWithRGB(0xf9f9f9);
            label1.text = @"    投资奖励";
            label1.textColor = UIColorWithRGB(0x333333);
            label1.font = [UIFont systemFontOfSize:14.0f];
            [headView addSubview:label1];
        } else {
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 29.5)];
            label2.backgroundColor = UIColorWithRGB(0xf9f9f9);
            label2.text = @"    会员等级";
            label2.textColor = UIColorWithRGB(0x333333);
            label2.font = [UIFont systemFontOfSize:14.0f];
            [headView addSubview:label2];
        }
        return headView;
    } else {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        headView.backgroundColor = UIColorWithRGB(0xE6E6EA);
        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:headView isTop:NO];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 29.5)];
        label1.backgroundColor = UIColorWithRGB(0xf9f9f9);
        label1.text = @"    投资奖励";
        label1.textColor = UIColorWithRGB(0x333333);
        label1.font = [UIFont systemFontOfSize:14.0f];
        [headView addSubview:label1];
        return headView;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isShowMemberAward) {
        //债券转让不显示工分
        if (_isTransid && indexPath.section == 1 && indexPath.row == 1) {
            return 0;
        } else {
            return 44;
        }
    } else {
        if (indexPath.section == 0 && indexPath.row == 1) {
            return 0;
        } else {
            return 44;
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isShowMemberAward) {
        if (_isTransid) {
            return 1;
        } else {
            return 2;
        }
    } else {
        if (_isTransid) {
            return 0;
        } else {
            return 1;
        }
    }
}
// 每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isShowMemberAward) {
        if (section) {
            return 7;
        } else {
            if (isShowLevelInterest) {
                return 5;
            }
            return 2;
        }
    } else {
        
        return 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isShowMemberAward) {
        if (indexPath.section) {
            return [self getTableViewAwardCell:tableView cellForRowAtIndexPath:indexPath];
        }else {
            return [self getTableViewMemberCell:tableView cellForRowAtIndexPath:indexPath];
        }
    } else {
        return [self getTableViewAwardCell:tableView cellForRowAtIndexPath:indexPath];
    }
}
// 选中某cell时。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (isShowMemberAward) {
        if (indexPath.section) {
            [self traditionAwarduserDidSelectRowAtIndexPath:indexPath];
        } else {
            [self memberAwardUserDidSelectRowAtIndexPath:indexPath];
        }
    } else {
        [self traditionAwarduserDidSelectRowAtIndexPath:indexPath];
    }
}
//会员奖励区域的点击区域事件
- (void)memberAwardUserDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//传统用户奖励的点击区域事件
- (void)traditionAwarduserDidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:
        {
            UCFWorkPointsViewController *subVC = [[UCFWorkPointsViewController alloc]initWithNibName:@"UCFWorkPointsViewController" bundle:nil];
            subVC.title = @"我的工分";
            subVC.superView = self;
            [self.navigationController pushViewController:subVC animated:YES];
        }
            break;
        case 2:
        {
            UCFMyFacBeanViewController *vc = [[UCFMyFacBeanViewController alloc] init];
            vc.title = @"我的工豆";
//            vc.isGoBackShowNavBar = YES;
            [self.navigationController pushViewController:vc  animated:YES];
        }
            break;
        case 3:{
            UCFRedEnvelopeViewController *vc = [[UCFRedEnvelopeViewController alloc] init];
            vc.title = @"我的红包";
//            vc.isGoBackShowNavBar = YES;
            [self.navigationController pushViewController:vc  animated:YES];
            

        }
            break;
        case 4:{
            UCFCouponViewController *vc = [[UCFCouponViewController alloc] init];
            vc.segmentIndex = 0;
//            vc.isGoBackShowNavBar = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{
            UCFCouponViewController *vc = [[UCFCouponViewController alloc] init];
            vc.segmentIndex = 1;
//            vc.isGoBackShowNavBar = YES;
            [self.navigationController pushViewController:vc  animated:YES];
        }
            break;
        case 6:{

        }
            break;
    }
}

- (UITableViewCell *)getTableViewMemberCell:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *indentifier = @"CompleteBidCell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = UIColorWithRGB(0x555555);
        //自定义cell上的分割线
        UIView * cellLine =[[UIView alloc]initWithFrame:CGRectMake(15, 43.5,ScreenWidth-15, 0.5)];
        cellLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        if (isShowLevelInterest) {
            if (indexPath.row == 3) {
                cellLine.frame =CGRectMake(0, 43.5,ScreenWidth, 0.5);
                cellLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
            }
        } else {
            if (indexPath.row == 1) {
                cellLine.frame =CGRectMake(0, 43.5,ScreenWidth, 0.5);
                cellLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
            }
        }

        [cell addSubview:cellLine];
        
        UILabel *detaiLabel = [[UILabel alloc] init];
        detaiLabel.tag = 1000;
        detaiLabel.frame = CGRectMake(ScreenWidth - 205, 11, 190, 20);
        detaiLabel.backgroundColor = [UIColor clearColor];
        detaiLabel.font = [UIFont boldSystemFontOfSize:15];
        detaiLabel.textAlignment = NSTextAlignmentRight;
        detaiLabel.textColor = UIColorWithRGB(0x555555);
        [cell addSubview:detaiLabel];
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.tag = 1001;
        desLabel.frame = CGRectMake(CGRectGetMinX(cell.textLabel.frame), 0, ScreenWidth, 44);
        desLabel.backgroundColor = [UIColor clearColor];
        desLabel.font = [UIFont systemFontOfSize:12];
        desLabel.textAlignment = NSTextAlignmentLeft;
        desLabel.textColor = UIColorWithRGB(0x555555);
        desLabel.hidden = YES;
        desLabel.numberOfLines = 0;
        [cell addSubview:desLabel];
        
        UIImageView *levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 15 - 25, (44 - 25)/2.0f, 25, 25)];
        levelImageView.image = [UIImage imageNamed:@"no_vip_icon"];
        levelImageView.tag = 1002;
        levelImageView.hidden = YES;
        [cell addSubview:levelImageView];
    }
    UILabel *detaiLabel = (UILabel *)[cell viewWithTag:1000];
    UILabel *desLabel = (UILabel *)[cell viewWithTag:1001];
    UIImageView *levelImageView = (UIImageView *)[cell viewWithTag:1002];
    levelImageView.hidden = YES;
    desLabel.hidden = YES;
    NSString *leftShowStr = @"";
    NSString *valueShowStr = @"";
    if (indexPath.row == 0) {
        leftShowStr = @"获得贡献值";
        NSString *showStr = _dataDict[@"vipGradeReward"][@"contributionValue"];
        showStr = showStr.length == 0 ? @"0" : showStr;
        valueShowStr = [NSString stringWithFormat:@"+%@",showStr];
    } else if (indexPath.row == 1) {
        leftShowStr = @"当前会员等级";
        NSString *showStr = _dataDict[@"vipGradeReward"][@"currentVipLevel"];
        levelImageView.hidden = NO;
        if ([showStr intValue] == 1 || [[_dataDict objectForKey:@"organizationPrd"] integerValue] == 1) {
            levelImageView.image =[UIImage imageNamed:@"no_vip_icon.png"];
        }else{
            levelImageView.image =[UIImage imageNamed:[NSString stringWithFormat:@"vip%d_icon.png",[showStr intValue]-1]];
        }
//        levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"usercenter_vip%@_icon",showStr]];
    } else if (indexPath.row == 2) {
        leftShowStr = @"年化加息奖励";
        NSString *showStr = _dataDict[@"vipGradeReward"][@"interestRatesReward"];
        showStr = showStr.length == 0 ? @"0" : showStr;
        valueShowStr = [NSString stringWithFormat:@"%@%%",showStr];
    } else if (indexPath.row == 3) {
        leftShowStr = @"折合工豆";
        NSString *showStr = _dataDict[@"vipGradeReward"][@"beans"];
        showStr = showStr.length == 0 ? @"0.00" : showStr;
        valueShowStr = [NSString stringWithFormat:@"¥%@",showStr];
    } else if (indexPath.row == 4) {
        desLabel.hidden = NO;
        leftShowStr = @"年化加息奖励将在起息后以工豆形式发放,灵活期限标起息后只发放锁定期内工豆,其余将在回款时发放。";
    }
    if (indexPath.row == 4) {
        desLabel.frame = CGRectMake(15, 5, ScreenWidth - 2 * 15, 30);
        desLabel.text = leftShowStr;
        desLabel.textColor =  UIColorWithRGB(0x999999);
        detaiLabel.text = @"";
        desLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"";
        cell.backgroundColor = UIColorWithRGB(0xebebeb);
    } else {
        desLabel.textColor = UIColorWithRGB(0x555555);
        cell.textLabel.text = leftShowStr;
        detaiLabel.text = valueShowStr;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
    
}
- (UITableViewCell *)getTableViewAwardCell:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *indentifier = @"CompleteBidCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = UIColorWithRGB(0x555555);
        //自定义cell上的分割线
        UIView * cellLine =[[UIView alloc]initWithFrame:CGRectMake(15, 43.5,ScreenWidth-15, 0.5)];
        cellLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        if (indexPath.row == 6) {
            cellLine.frame =CGRectMake(0, 43.5,ScreenWidth, 0.5);
            cellLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        }
        [cell addSubview:cellLine];
        
        UILabel *detaiLabel = [[UILabel alloc] init];
        detaiLabel.tag = 1000;
        detaiLabel.frame = CGRectMake(ScreenWidth - 225, 11, 190, 20);
        detaiLabel.backgroundColor = [UIColor clearColor];
        detaiLabel.font = [UIFont boldSystemFontOfSize:15];
        detaiLabel.textAlignment = NSTextAlignmentRight;
        detaiLabel.textColor = UIColorWithRGB(0x555555);
        [cell addSubview:detaiLabel];
    }
    UILabel *detaiLabel = (UILabel *)[cell viewWithTag:1000];
    NSArray *arr = _dataDict[@"activityBeans"];
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"获得现金";
            detaiLabel.text = @"¥0.00";
            for (int i = 0; i < arr.count; i++) {
                int activityBeans = [_dataDict[@"activityBeans"][i][@"activetyunite"] intValue];
                if (activityBeans == 0) {
                    detaiLabel.text = [NSString stringWithFormat:@"¥%@",_dataDict[@"activityBeans"][i][@"activetyvalue"]];
                }
            }
        }
            break;
        case 1:
        {
            if(isShowMemberAward) {
                if (_isTransid) {
                    cell.textLabel.text = @"";
                    detaiLabel.text = @"";
                } else {
                    cell.textLabel.text = @"获得工分";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    NSString *showStr = _dataDict[@"vipGradeReward"][@"investCredit"];
                    showStr = showStr.length == 0 ? @"0" : showStr;
                    detaiLabel.text = [NSString stringWithFormat:@"+%@",showStr];
                }

            } else {
                cell.textLabel.text = @"";
                detaiLabel.text = @"";
            }
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"获得工豆";
            detaiLabel.text = @"¥0.00";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            for (int i = 0; i < arr.count; i++) {
                int activityBeans = [_dataDict[@"activityBeans"][i][@"activetyunite"] intValue];
//                NSString *investMultip = _dataDict[@"activityBeans"][i][@"investMultip"];
                if (activityBeans == 7) {
                    NSString *showStr = _dataDict[@"activityBeans"][i][@"activetyvalue"];
                    showStr = [showStr isEqualToString:@""] ? @"0.00" : showStr;
                    detaiLabel.text = [NSString stringWithFormat:@"¥%@",showStr];
                }
            }
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"获得红包";
            detaiLabel.text = @"0个";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            for (int i = 0; i < arr.count; i++) {
                int activityBeans = [_dataDict[@"activityBeans"][i][@"activetyunite"] intValue];
                if (activityBeans == 4) {
                    detaiLabel.text = @"1个";
                }
            }
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"获得返现券";
            detaiLabel.text = @"共0张  ¥0.00";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            for (int i = 0; i < arr.count; i++) {
                int activityBeans = [_dataDict[@"activityBeans"][i][@"activetyunite"] intValue];
                NSString *investMultip = _dataDict[@"activityBeans"][i][@"investMultip"];
                
                if (activityBeans == 1 && [investMultip doubleValue] > 0) {
                    NSString *activetyvalue = [NSString stringWithFormat:@"%@",_dataDict[@"activityBeans"][i][@"activetyvalue"]];
                    detaiLabel.text = [NSString stringWithFormat:@"共%@张  ¥%.2f",_dataDict[@"couponCount"],[activetyvalue doubleValue]/100.0f];
                }
            }
        }
            break;
        case 5:
        {
            cell.textLabel.text = @"获得返息券";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString *count = @"0";
            if (_dataDict[@"fanxiCount"]) {
                count = _dataDict[@"fanxiCount"];
            }
            detaiLabel.text = [NSString stringWithFormat:@"共%@张",count];
        }
            break;
        case 6:
        {
            cell.textLabel.text = @"获得抽奖机会";
            detaiLabel.text = @"0次";
            
            for (int i = 0; i < arr.count; i++) {
                int activityBeans = [_dataDict[@"activityBeans"][i][@"activetyunite"] intValue];
                if (activityBeans == 3) {
                    detaiLabel.text = [NSString stringWithFormat:@"%@次",_dataDict[@"activityBeans"][i][@"activetyvalue"]];
                }
            }
        }
            break;
    }
    return cell;
    
}

@end
