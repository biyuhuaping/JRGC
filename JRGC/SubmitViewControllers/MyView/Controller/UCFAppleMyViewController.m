//
//  UCFAppleMyViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2018/8/21.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFAppleMyViewController.h"
#import "UCFAppleMyViewHeaderView.h"
#import "UCFSettingArrowItem.h"
#import "UCFSettingGroup.h"
#import "UCFAppleMyViewCell.h"
#import "AppDelegate.h"
#import "FullWebViewController.h"
#import "UCFLoginBaseView.h"
#import "UCFUserAssetModel.h"
#import "MJRefresh.h"
@interface UCFAppleMyViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong,nonatomic)NSMutableArray *itemsDataArray;
@property (strong,nonatomic)UCFAppleMyViewHeaderView *myHeaderView;
@property (strong, nonatomic) UCFLoginBaseView  *loginView;
@property(strong ,nonatomic) UCFUserAssetModel *userAsset;

@end

@implementation UCFAppleMyViewController

- (UCFLoginBaseView *)loginView
{
    if (!_loginView) {
        _loginView = [[UCFLoginBaseView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    return _loginView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
        if (_loginView) {
            [_loginView removeFromSuperview];
            _loginView = nil;
        }
    } else {
        if (!_loginView) {
            [self.view addSubview:self.loginView];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self infoCreateView];
}

-(void)infoCreateView
{
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        
//        self.topConstraint.constant = -32;
    } else {
        self.topConstraint.constant = - 20;
    }
#endif
    
    UCFSettingItem *P2PAccout = [UCFSettingItem  itemWithIcon:@"uesr_icon_wj" WithTitle:@"微金账户" withSubtitle:@"0.00"];
    
    UCFSettingItem *contactUs = [UCFSettingArrowItem itemWithIcon:nil title:@"客服电话" destVcClass:nil];
    contactUs.subtitle = @"400-6766-988";
    contactUs.option = ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:@"呼叫400-6766-988" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即拨打", nil];
        [alert show];
    };
    UCFSettingItem *weixinNumber = [UCFSettingArrowItem itemWithIcon:nil title:@"微信公众号" destVcClass:nil];
    weixinNumber.subtitle = @"工场服务中心";
    UCFSettingItem *companyNet = [UCFSettingArrowItem itemWithIcon:nil title:@"公司网址" destVcClass:nil];
    companyNet.subtitle = @"www.9888keji.com";
    UCFSettingItem *aboutUs = [UCFSettingArrowItem itemWithIcon:nil title:@"关于我们" destStoryBoardStr:@"UCFMoreViewController" storyIdStr:@"aboutus"];
    
    UCFSettingGroup *group1 = [[UCFSettingGroup alloc] init];
    group1.items = [[NSMutableArray alloc]initWithArray: @[P2PAccout]];
    
    UCFSettingGroup *group2 = [[UCFSettingGroup alloc] init];
    group2.items = [[NSMutableArray alloc]initWithArray: @[contactUs,weixinNumber,companyNet,aboutUs]];
    _itemsDataArray= [[NSMutableArray alloc] initWithObjects:group1,group2,nil];
    
    
    [self.tableView reloadData];
    
    
   
    
    [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getAssetFromNet)];
    
    [self.tableView.header beginRefreshing];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return self.itemsDataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UCFSettingGroup *groupArray  = [self.itemsDataArray objectAtIndex:section];
    return groupArray.items.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 60.0f;
    }
    else
    {
        return 44.0f;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *firstFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        
        UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, ScreenWidth - 15* 2, 20)];
        tipLabel.text = @"更多信息请您到工场微金App中查看";
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:13];
        tipLabel.textColor = UIColorWithRGB(0x555555);
        
        [firstFootView addSubview:tipLabel];
        
        return firstFootView;
    }else {
        return [self createFootView];
    }
}
- (UIView *)createFootView
{
    UIView *footerBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 67)];
    footerBaseView.backgroundColor = [UIColor clearColor];
    
    UIButton *investmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    investmentButton.frame = CGRectMake(XPOS, 10, ScreenWidth - XPOS*2, 37);
    investmentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    investmentButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
    investmentButton.layer.cornerRadius = 2.0;
    investmentButton.layer.masksToBounds = YES;
    
    NSString *buttonTitle = @"退出登录";
    [investmentButton setTitle:buttonTitle forState:UIControlStateNormal];
    [investmentButton addTarget:self action:@selector(logOutClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerBaseView addSubview:investmentButton];
    return footerBaseView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return section == 0 ?  200 : 0.01f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UCFAppleMyViewHeaderView *myHeaderView = (UCFAppleMyViewHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFAppleMyViewHeaderView" owner:self options:nil] firstObject];
        //    self.tableView.tableHeaderView = myHeaderView;
        self.tableView.backgroundColor = UIColorWithRGB(0xebebee);
        self.myHeaderView = myHeaderView;
        myHeaderView.userAssetModel = self.userAsset;
        return myHeaderView;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 30;
    }
    else {
        return 67;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *ID = @"UCFAppleMyViewCell";
        UCFAppleMyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFAppleMyViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.tableview = self.tableView;
        cell.indexPath = indexPath;
        UCFSettingGroup *group = self.itemsDataArray[indexPath.section];
        UCFSettingItem *item = group.items[indexPath.row];
        cell.itemData = item;
        
        return cell;
    }else{
        static NSString *ID = @"moreIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            cell.contentView.backgroundColor = [UIColor clearColor];
            UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
            aView.backgroundColor = UIColorWithRGB(0xf5f5f5);
            cell.selectedBackgroundView = aView;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_arrow"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.textColor = UIColorWithRGB(0x555555);
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = UIColorWithRGB(0x999999);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
        UCFSettingGroup *group = self.itemsDataArray[indexPath.section];
        UCFSettingItem *item = group.items[indexPath.row];
        cell.textLabel.text =item.title;
        cell.detailTextLabel.text = item.subtitle;
        if (indexPath.row == 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
            line.backgroundColor = UIColorWithRGB(0xd8d8d8);
            [cell.contentView addSubview:line];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == [group.items count] - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(cell.frame) - 0.5, ScreenWidth, 0.5)];
            line.backgroundColor = UIColorWithRGB(0xd8d8d8);
            [cell.contentView addSubview:line];
        }
        return cell;
    }
}
//  选项表代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    UCFSettingGroup *group = self.itemsDataArray[indexPath.section];
    UCFSettingItem *item = group.items[indexPath.row];
    
    if (item.option) { // block有值(点击这个cell,.有特定的操作需要执行)
        item.option();
    } else if ([item isKindOfClass:[UCFSettingArrowItem class]]) { // 箭头
        UCFSettingArrowItem *arrowItem = (UCFSettingArrowItem *)item;
        if (indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 2)) {//微信公众号 和公司网址
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:item.subtitle];
            [AuxiliaryFunc showToastMessage:@"已复制到剪切板" withView:self.view];
            return;
        }
        // 如果没有需要跳转的控制器
        if (arrowItem.mainStoryBoardStr == nil) return;
        
        if([arrowItem.storyId isEqualToString:@"aboutus"])
        {
            FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:ABOUTUSURL title:@"关于我们"];
            webView.sourceVc = @"UCFMoreVC";
            webView.baseTitleType = @"specialUser";
            [self.navigationController pushViewController:webView animated:YES];
            return ;
        }
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:arrowItem.mainStoryBoardStr bundle:nil];
//        UCFBaseViewController *vc = [storyboard instantiateViewControllerWithIdentifier:arrowItem.storyId];
//        vc.title = arrowItem.title;
//        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//  退出登录按钮点击事件
- (void)logOutClicked:(UIButton *)btn
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"确定退出登录吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 10000;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {

            [[UserInfoSingle sharedManager] removeUserInfo];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"changScale"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isVisible"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //安全退出后去首页
            AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [delegate.tabBarController setSelectedIndex:0];
            if ([UserInfoSingle sharedManager].isSubmitTime) {
                [(UITabBarController *)delegate.window.rootViewController setSelectedIndex:0];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"personCenterClick"];
            
            //退出时清cookis
            [Common deleteCookies];
            [[NSNotificationCenter defaultCenter] postNotificationName:REGIST_JPUSH object:nil];
            //通知首页隐藏tipView
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setDefaultViewData" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_COUPON_CENTER object:nil];
        }
        
    }
}

- (void)getAssetFromNet
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (!userId) {
        if ([self.tableView.header isRefreshing])
        {
            [self.tableView.header endRefreshing];
        }
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId} tag:kSXTagMyReceipt owner:self signature:YES Type:SelectAccoutDefault];
}

-(void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{

    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.intValue == kSXTagMyReceipt) {
        
        if ([rstcode intValue] == 1) {
            
            NSDictionary *resultData = [dic objectSafeDictionaryForKey:@"data"];
            if ([[NSUserDefaults standardUserDefaults] valueForKey:UUID]) {
                NSString *oepnState =  [resultData objectSafeForKey:@"openStatus"];
                [UserInfoSingle sharedManager].openStatus = [oepnState integerValue];
                NSString *zxOpenState = [resultData objectSafeForKey:@"zxOpenStatus"];
                [UserInfoSingle sharedManager].enjoyOpenStatus = [zxOpenState integerValue];
                NSString *nmGoldAuthorization = [resultData objectSafeForKey:@"nmGoldAuthorization"];
                [UserInfoSingle sharedManager].goldAuthorization = [nmGoldAuthorization integerValue];
                BOOL isCompanyAgent = [[resultData objectSafeForKey:@"isCompanyAgent"] boolValue];
                [UserInfoSingle sharedManager].companyAgent = isCompanyAgent;
            }
            
            UCFUserAssetModel *userAsset = [UCFUserAssetModel userAssetWithDict:resultData];
            
            self.userAsset = userAsset;
            UCFSettingGroup *group = [self.itemsDataArray firstObject];
            UCFSettingItem *item = [group.items firstObject];
            item.subtitle = userAsset.p2pCashBalance;
            [self.tableView reloadData];
        }else {
            
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
    if ([self.tableView.header isRefreshing])
    {
        [self.tableView.header endRefreshing];
    }
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if ([self.tableView.header isRefreshing])
    {
        [self.tableView.header endRefreshing];
    }
}

@end
