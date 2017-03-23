//
//  UCFHuiShangBankViewController.m
//  JRGC
//
//  Created by NJW on 16/8/8.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFHuiShangBankViewController.h"
#import "UCFHuiBuinessDetailViewController.h"
#import "UCFHuiBuinessBankView.h"
#import "FullWebViewController.h"
#import "UCFHuiBuinessListModel.h"
#import "MjAlertView.h"
#import "UCFTableCellOne.h"
#import "UCFTableCellTwo.h"
#import "UCFToolsMehod.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface UCFHuiShangBankViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 银行卡视图
@property (weak, nonatomic) UCFHuiBuinessBankView *huishangView;
// 弹窗
@property (weak, nonatomic) MjAlertView *helpView;
// 用户信息
@property (strong, nonatomic) NSDictionary *accountDic;
// 最近三次流水数据
@property (strong, nonatomic) NSArray *dataArray;
@end

@implementation UCFHuiShangBankViewController

- (NSDictionary *)accountDic
{
    if (!_accountDic) {
        _accountDic = [[NSDictionary alloc] init];
    }
    return _accountDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.rootVc) { //是否禁掉侧滑返回
      self.fd_interactivePopDisabled = YES;
    }else{
      self.fd_interactivePopDisabled = NO;
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.accoutType == SelectAccoutTypeHoner) {
        baseTitleLabel.text = @"尊享徽商银行存管账户";
    }else{
        baseTitleLabel.text = @"P2P徽商银行存管账户";
    }
    UCFHuiBuinessBankView *huishangView = [[[NSBundle mainBundle] loadNibNamed:@"UCFHuiBuinessBankView" owner:self options:nil] lastObject];
    huishangView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 182.0/320.0*SCREEN_WIDTH);
    UIView *headerBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 182.0/320.0*SCREEN_WIDTH)];
    [headerBackView addSubview:huishangView];
    self.huishangView = huishangView;
    self.tableView.tableHeaderView = headerBackView;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    self.navigationController.navigationBar.translucent = NO;
    [self addLeftButton];
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 35, 35);
    [rightbutton setImage:[UIImage imageNamed:@"icon_question"] forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self getHuiBuinessDataFromNet];
}
-(void)getToBack{
    if (self.rootVc) {
        [self.navigationController popToViewController:self.rootVc animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 获取徽商账户信息

- (void)getHuiBuinessDataFromNet
{
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagGetHSAccountInfo owner:self signature:YES];
}
//开始请求
- (void)beginPost:(kSXTag)tag
{
    //    [GiFHUD show];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    //    DBLOG(@"新用户开户：%@",data);
    
    id ret = dic[@"ret"];
    if (tag.intValue == kSXTagGetHSAccountInfo) {
        if ([ret boolValue]) {
//            DBLOG(@"%@",dic[@"data"]);
            NSDictionary *accountDic = [[dic objectSafeForKey:@"data"] objectSafeForKey:@"hsAccountInfo"];
            NSString *accountName = [accountDic objectSafeForKey:@"accountName"];
            if (accountName.length > 0) {
                self.huishangView.accountName.text = accountName;
            }
            
            NSString *accountNum = [accountDic objectSafeForKey:@"bankCardNo"];
            if (accountNum.length > 0) {
                self.huishangView.bankNum.text = accountNum;
            }
            
            NSString *bankAddr = [accountDic objectSafeForKey:@"bankBranch"];
            if (bankAddr.length > 0) {
                self.huishangView.bankName.text = bankAddr;
            }
            
            self.accountDic = accountDic;
            
            NSArray *assetList = [[[dic objectSafeForKey:@"data"] objectSafeForKey:@"pageData"] objectSafeForKey:@"result"];
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            if (assetList.count>0) {
                for (NSDictionary *dict in assetList) {
                    UCFHuiBuinessListModel *listModel = [UCFHuiBuinessListModel hsAssetBeanWithDict:dict];
                    [tempArr addObject:listModel];
                }
                self.dataArray = tempArr;
            }
            
            [self.tableView reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


#pragma mark - tableView数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    else
        return 37;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 37)];
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 100, 37)];
        nameLable.text = @"3个月内银行资金流水";
        nameLable.font = [UIFont systemFontOfSize:14];
        nameLable.textColor = UIColorWithRGB(0x333333);
        [view addSubview:nameLable];
        [view setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
        
        UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        [upLine setBackgroundColor:UIColorWithRGB(0xd8d8d8)];
        [view addSubview:upLine];
        
        UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame) - 0.5, ScreenWidth, 0.5)];
        [downLine setBackgroundColor:UIColorWithRGB(0xe3e5ea)];
        [view addSubview:downLine];
        
        UIButton *buton = [UIButton buttonWithType:UIButtonTypeCustom];
        [buton setFrame:CGRectMake(ScreenWidth-15-60, 0, 60, 37)];
        [buton setTitle:@"查看全部" forState:UIControlStateNormal];
        buton.titleLabel.font = [UIFont systemFontOfSize:14];
        [buton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
        [buton addTarget:self action:@selector(checkAllAsset:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:buton];
        
        return view;
    }
    else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
        return self.dataArray.count>0 ? self.dataArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId1 = @"HuishangOne";
    if (indexPath.section == 0) {
       UCFTableCellOne *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFTableCellOne" owner:self options:nil] lastObject];
        }
        cell.accountInfo = self.accountDic;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1) {
        UCFTableCellTwo *cell =  [UCFTableCellTwo cellWithTableView:tableView];
        cell.indexPath = indexPath;
        UCFHuiBuinessListModel *listmodel = [self.dataArray objectAtIndex:indexPath.row];
        cell.listModel = listmodel;
        cell.isHasData = self.dataArray.count>0 ? YES : NO;
        return cell;
    }
    else
        return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 121;
    }
    else {
        return self.dataArray.count>0 ? 50 : 150;
    }
    return 0;
}

#pragma mark - 按钮点击方法
// 查看徽商银行的资金流水详情
- (void)checkAllAsset:(UIButton *)button
{
    if (self.dataArray.count>0) {
        UCFHuiBuinessDetailViewController *buinessDetail = [[UCFHuiBuinessDetailViewController alloc] initWithNibName:@"UCFHuiBuinessDetailViewController" bundle:nil];
        buinessDetail.title = @"徽商资金流水";
        [self.navigationController pushViewController:buinessDetail animated:YES];
    }
    else {
        [AuxiliaryFunc showToastMessage:@"没有更多数据展示" withView:self.view];
    }
}

// 帮助按钮的点击方法
- (void)rightClicked:(UIButton *)button
{
    FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:HSAccountIllustrationURL title:@"说明"];
    webController.sourceVc = @"huishangAccout";
    webController.baseTitleType = @"specialUser";
    [self.navigationController pushViewController:webController animated:YES];
    
//    __weak typeof(self) weakSelf = self;
//    MjAlertView *alert = [[MjAlertView alloc] initCustomAlertViewWithBlock:^(id blockContent) {
//        UIView *view = (UIView *)blockContent;
//        [view setFrame:[UIScreen mainScreen].bounds];
//        [view setBackgroundColor:[UIColor clearColor]];
//        
//        UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
//        [view addSubview:close];
//        close.frame = CGRectMake(20,  ScreenHeight - 20 - 37, ScreenWidth-40, 37);
//        [close setBackgroundColor:[UIColor blackColor]];
//        [close setTitle:@"关闭" forState:UIControlStateNormal];
//        [close addTarget:weakSelf action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
//    }];
//    self.helpView = alert;
//    [alert show];
}

#pragma mark - 按钮点击方法

- (void)closeClick
{
    [self.helpView hide];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
