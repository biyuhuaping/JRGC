//
//  UCFGoldBidSuccessViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldBidSuccessViewController.h"
#import "UCFGoldBidSuccessHeaderView.h"
#import "AppDelegate.h"
#import "UCFInvestViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UCFSettingItem.h"
#import "MjAlertView.h"
#import "UCFNoticeViewController.h"
#import "UCFGoldRewardTableViewCell.h"
@interface UCFGoldBidSuccessViewController ()<UITableViewDelegate,UITableViewDataSource,MjAlertViewDelegate,UCFGoldRewardTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic)NSArray *rewardsArray;
@end

@implementation UCFGoldBidSuccessViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //    if ([_sourceVc isEqualToString:@"collection"]) {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //    } else {
    //        [self.navigationController setNavigationBarHidden:YES animated:animated];
    //    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
//    self.tableView.tableHeaderView = [self createHeaderView];
//    self.tableView.tableFooterView = [self cretateFooterView];
    self.tableView.separatorColor = UIColorWithRGB(0xe3e5ea);
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self infoDataArray];
}
-(void)infoDataArray{
    
    NSString *nmPrdClaimNameStr = [_dataDict objectSafeForKey:@"nmPrdClaimName"];
    UCFSettingItem *item1 = [UCFSettingItem itemWithTitle:@"产品名称" withSubtitle:nmPrdClaimNameStr];
    NSString *purchaseGoldAmountStr = [NSString stringWithFormat:@"%@克",[_dataDict objectSafeForKey:@"purchaseGoldAmount"]];
    UCFSettingItem *item2 = [UCFSettingItem itemWithTitle:@"买入克重" withSubtitle:purchaseGoldAmountStr];
     NSString *dealGoldPriceStr = [NSString stringWithFormat:@"¥%@",[_dataDict objectSafeForKey:@"dealGoldPrice"]];
    UCFSettingItem *item3 = [UCFSettingItem itemWithTitle:@"成交金价(元/克)" withSubtitle:dealGoldPriceStr];
     NSString *poundageStr =[NSString stringWithFormat:@"¥%@", [_dataDict objectSafeForKey:@"poundage"]];
    UCFSettingItem *item4 = [UCFSettingItem itemWithTitle:@"手续费" withSubtitle:poundageStr];
     NSString *purchaseMoneyStr = [NSString stringWithFormat:@"¥%@",[_dataDict objectSafeForKey:@"purchaseMoney"]];
    UCFSettingItem *item5 = [UCFSettingItem itemWithTitle:@"支付金额" withSubtitle:purchaseMoneyStr];
    

    
    NSString *returnGoldStr = [NSString stringWithFormat:@"%@克",[_dataDict objectSafeForKey:@"returnGold"]];
    if([returnGoldStr doubleValue] > 0)
    {
         UCFSettingItem *item6 = [UCFSettingItem itemWithTitle:@"获得返金" withSubtitle:returnGoldStr];
         self.dataArray = [NSMutableArray arrayWithArray:@[item1,item2,item3,item4,item5,item6]];
    }
    else
    {
       self.dataArray = [NSMutableArray arrayWithArray:@[item1,item2,item3,item4,item5]];
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:[_dataDict objectSafeArrayForKey:@"rewards"]];
    //rewardValue == 0的对象 不展示
    for( int i = 0 ;i < array.count ;i ++)
    {
        NSDictionary * rewardDict = [array objectAtIndex:i];
        int  rewardValue = [[rewardDict objectSafeForKey:@"rewardValue"] intValue];
        if (rewardValue == 0)
        {
            [array removeObject:rewardDict];
            i--;
        }
    }
    self.rewardsArray = [NSArray arrayWithArray:array];
    if (self.rewardsArray.count != 0)
    {
        UCFSettingItem *item7 = [UCFSettingItem itemWithTitle:@"获取抽奖次数" withSubtitle:@""];
        item7.isSelect = YES;//这个标识 重要，代表 抽奖次数一栏是否显示的条件 yes 为显示 默认不显示
        [self.dataArray addObject:item7];
    }
    

    if (_isPurchaseSuccess)
    {
        MjAlertView *alertView = [[MjAlertView alloc] initInvestmentSuccesseViewAlertWithDelegate:self];
        alertView.tag = 2001;
        [alertView show];
    }
    
}

- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index
{
    if (index == 1001) //点击邀请
    {
        UCFNoticeViewController *noticeWeb = [[UCFNoticeViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
        noticeWeb.url      = @"https://m.9888.cn/static/wap/invest/index.html#/topic/invite";//请求地址;
        noticeWeb.navTitle = @"邀请好友";
        [self.navigationController pushViewController:noticeWeb animated:YES];
    }else{
        
    }
}
-(UIView *)createHeaderView{
    UCFGoldBidSuccessHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldBidSuccessHeaderView" owner:nil options:nil]firstObject];
    headerView.frame =  CGRectMake(0, 0, ScreenWidth, 207);
    headerView.backgroundColor = [UIColor clearColor];
    
    if(_isPurchaseSuccess){
        headerView.headerImageView.image = [UIImage imageNamed:@"gold_SuccessfulPurchase_icon"];
        headerView.headerTitleLabel.text = @"购买成功";
    }else{
        headerView.headerImageView.image = [UIImage imageNamed:@"gold_FailurePurchase_icon"];
        headerView.headerTitleLabel.text = @"购买失败";
    }
    return headerView;
}
- (UIView *)cretateFooterView
{
    UIView *investBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15+37)];
    investBaseView.backgroundColor = [UIColor clearColor];
    investBaseView.tag = 9000;
    
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:investBaseView isTop:YES];
    UIButton *investmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    investmentButton.frame = CGRectMake(XPOS, 15,ScreenWidth - XPOS*2, 37);
    investmentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    investmentButton.backgroundColor = UIColorWithRGB(0xffc027);
    investmentButton.layer.cornerRadius = 2.0;
    investmentButton.layer.masksToBounds = YES;
    
    NSString *buttonTitle = _isPurchaseSuccess ? @"完成" :@"重新购买";
    [investmentButton setTitle:buttonTitle forState:UIControlStateNormal];
    [investmentButton addTarget:self action:@selector(gotoMainView) forControlEvents:UIControlEventTouchUpInside];
    [investBaseView addSubview:investmentButton];
    
    return investBaseView;
//    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 10)];
//    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
//    shadowView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
//    [investBaseView addSubview:shadowView];
}
-(void)gotoMainView{
//    if(_isPurchaseSuccess){//购买成功返回主页面
      [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else{//购买失败返回上一级页面
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self createHeaderView];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self cretateFooterView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15+37;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 207;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isPurchaseSuccess)
    {
        UCFSettingItem *item = self.dataArray[indexPath.row];
        
        return item.isSelect ? 120.0f : 44.0f;
    }else{
        CGSize size =  [Common getStrHeightWithStr:self.errorMessageStr AndStrFont:12 AndWidth:ScreenWidth - 30 AndlineSpacing:2];
        return size.height + 20;
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _isPurchaseSuccess ? self.dataArray.count : 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellindifier = @"secondIndexPath";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellindifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = UIColorWithRGB(0x555555);
        cell.detailTextLabel.textColor = UIColorWithRGB(0x555555);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    if (_isPurchaseSuccess) {
     
        if (indexPath.row < self.dataArray.count)
        {
             UCFSettingItem *item = self.dataArray[indexPath.row];
            if (item.isSelect)
            {
                NSString *cellindifier = @"UCFGoldRewardTableViewCell";
                UCFGoldRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldRewardTableViewCell" owner:nil options:nil]firstObject];
                }
                cell.delegate = self;
                cell.rewardsArray  = self.rewardsArray;
                return cell;
            }else{
                cell.textLabel.text = item.title;
                cell.detailTextLabel.text = item.subtitle;
            }
        }
    }else{
        CGSize size =  [Common getStrHeightWithStr:self.errorMessageStr AndStrFont:12 AndWidth:ScreenWidth - 30 AndlineSpacing:2];
        UILabel *errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, ScreenWidth-30, size.height)];
        errorLabel.textColor = UIColorWithRGB(0x555555);
        errorLabel.font = [UIFont systemFontOfSize:12];
        errorLabel.numberOfLines = 0;
        errorLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:errorLabel];
        errorLabel.text = self.errorMessageStr;//购买错误信息
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if ([cell.textLabel.text isEqualToString:@"获取抽奖次数"]) {
//
//    }
}
-(void)clickGoldRewardCellWithButton:(NSInteger)tag
{
    NSString *rewardUrlSrr = [[self.rewardsArray objectAtIndex:tag] objectSafeForKey:@"rewardUrl"];
    if (rewardUrlSrr.length != 0) //链接不能为空
    {
        UCFNoticeViewController *noticeWeb = [[UCFNoticeViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
        noticeWeb.url      = rewardUrlSrr;//请求地址;
//        noticeWeb.navTitle = @"邀请好友";
        [self.navigationController pushViewController:noticeWeb animated:YES];
    }
}
@end
