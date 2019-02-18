//
//  UCFMessageSettingViewController.m
//  JRGC
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "UCFMessageSettingViewController.h"

@interface UCFMessageSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;

@property (assign,nonatomic) BOOL isReceiveMessage;//是否接收短信通知 YES 为接收 NO 为不接收

@property (strong,nonatomic)UISwitch *messageSwitch;//短信通知的开关

@end

@implementation UCFMessageSettingViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];//初始化页面
    [self addLeftButton];
    [self userDisPermissionIsOpenRequest];//查询用户是否接受短信通知网络请求
   
}
#pragma mark -初始化页面
-(void)createUI{
//    设置settingTableView的分割线
    baseTitleLabel.text = @"消息设置";
    self.settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.settingTableView.contentInset =UIEdgeInsetsMake(10, 0, 0, 0);
    
    _messageSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenWidth - 66, 7, 51, 30)];
    _messageSwitch.onTintColor = [UIColor redColor];
    [_messageSwitch addTarget:self action:@selector(messageSwitchChange:) forControlEvents:UIControlEventValueChanged];
    self.isReceiveMessage = YES;
    if (![Common isAllowedNotification]) {
        UIAlertView * alertView =  [[UIAlertView alloc]initWithTitle:@"提示" message:@"打开通知后您将在第一时间收到与您投资相关的推送" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alertView.tag = 1000;
        [alertView show];
    }
}
#pragma mark -查询用户是否开启短信通知请求
-(void)userDisPermissionIsOpenRequest{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@",SingleUserInfo.loginData.userInfo.userId];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagUserDisPermissionIsOpen owner:self Type:SelectAccoutDefault];
}
#pragma mark -更新用户是否开启短信通知请求
-(void)userUpdatePermissionIsOpenRequest:(BOOL)messageSwith{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&isOpen=%d",SingleUserInfo.loginData.userInfo.userId,messageSwith];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagUpdateUserDisPermission owner:self Type:SelectAccoutDefault];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -
#pragma mark tableView代理
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [self getFooterView:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        static NSString *cellID = @"messageSettingCell";
        
        UITableViewCell  *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = UIColorWithRGB(0x555555);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = UIColorWithRGB(0x999999);
    if (indexPath.section == 0) {
        cell.textLabel.text = @"接收新消息通知";
        if ([Common isAllowedNotification]) {
            cell.detailTextLabel.text = @"已开启";
        }else{
            cell.detailTextLabel.text = @"未开启";
        }
    }else if(indexPath.section == 1){
        cell.textLabel.text = @"接收短信通知";
        [cell addSubview:_messageSwitch];
    }
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        topLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [cell.contentView addSubview:topLine];
        UIView *downpLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cell.frame)-0.5, ScreenWidth, 0.5)];
        downpLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [cell.contentView addSubview:downpLine];
//    messagedetail
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark 创建footerView
-(UIView *)getFooterView :(NSInteger)section{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    footerView.backgroundColor = UIColorWithRGB(0xebebee);
    UILabel * footerLab =[[UILabel alloc]initWithFrame:CGRectMake(15, 5, ScreenWidth -30, 24)];
    footerLab.numberOfLines = 0;
    footerLab.font = [UIFont systemFontOfSize:10];
    footerLab.textColor = UIColorWithRGB(0x999999);
    if(section == 0){
        footerLab.text = @"如果你要关闭或打开消息通知，请在iPhone的“设置”-“通知”功能中找到应用程序“金融工场”更改。";
    }
//    else if(section == 1 && !self.isReceiveMessage){
//        footerLab.text = @"温馨提示：若要关闭短信通知，请确保您的设备已开启消息通知，否则将无法收到与你投资相关的重要信息。";
//        footerLab.textColor = UIColorWithRGB(0xfd4b4c);
//    }
    [footerView addSubview:footerLab];
    return footerView;
}
#pragma mark- 开始请求
- (void)beginPost:(kSXTag)tag{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
#pragma mark-  请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    DDLogDebug(@"dic ===>>>> %@",dic);
    NSString *rstcode = [dic objectSafeForKey:@"status"];
    NSString *rsttext = [dic objectSafeForKey:@"statusdes"];
  
    if (tag.intValue == kSXTagUserDisPermissionIsOpen) {
        if([rstcode intValue] == 1){
            if ([[dic objectSafeForKey:@"isopen"] intValue] == 0) { // 返回数据 isOpen  0 为开启，1 为关闭
                self.isReceiveMessage = YES;
            }else {
                self.isReceiveMessage = NO;
            }
        }else {
        [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        _messageSwitch.on = self.isReceiveMessage;
       }
    }else if(tag.intValue == kSXTagUpdateUserDisPermission){
        if ([rstcode intValue] == 1) {
            self.isReceiveMessage = _messageSwitch.on;
            [AuxiliaryFunc showToastMessage:@"修改成功" withView:self.view];
        }else{
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            _messageSwitch.on = self.isReceiveMessage;
        }
    }
}
#pragma mark-  请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagUserDisPermissionIsOpen || tag.intValue == kSXTagUpdateUserDisPermission) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    _messageSwitch.on = self.isReceiveMessage;
}
#pragma mark
#pragma mark 接收消息
-(void)messageSwitchChange:(UISwitch *)clickSwitch{
    DDLogDebug(@"clickSwitch.on ===>>> %d",clickSwitch.on);
    
    if (clickSwitch.on) {//短信通知由关>>>开
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"温馨提示：启用短信通知，可以使您通过手机短信收到与您投资相关的重要信息。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"开启短信通知", nil];
        actionSheet.tag = 2000;
        [actionSheet showInView:self.view];
    }else{//短信通知由开>>>关
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"温馨提示：若要关闭短信通知，请确保您的设备已开启消息通知，否则将无法收到与您投资相关的重要信息。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"关闭短信通知", nil];
        actionSheet.tag = 2000;
        [actionSheet showInView:self.view];
    }
}
-(void)setIsReceiveMessage:(BOOL)isReceiveMessage{
    _isReceiveMessage = isReceiveMessage;
    if (_isReceiveMessage) {
        _messageSwitch.on = YES;
    }else{
        _messageSwitch.on = NO;
    }
//    [self.settingTableView reloadData];
}
#pragma mark -UIAlertView的代理协议
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1 && alertView.tag == 1000) {
        if (kIS_IOS8) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }

        }
        else{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}
#pragma mark -UIActionSheet的代理协议
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && actionSheet.tag == 2000) {
         [self userUpdatePermissionIsOpenRequest:!_messageSwitch.on];
    }else{
       _messageSwitch.on = self.isReceiveMessage;
    }
}
@end
