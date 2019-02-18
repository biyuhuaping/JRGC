//
//  UCFBankDepositoryAccountViewController.m
//  JRGC
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFBankDepositoryAccountViewController.h"
#import "NZLabel.h"
#import "FullWebViewController.h"
#import "UCFOldUserGuideViewController.h"
#import "AppDelegate.h"
@interface UCFBankDepositoryAccountViewController ()
{
    BOOL isFirstLaunch;
}
@property (weak, nonatomic) IBOutlet UIView *whiteBaseView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
@property (weak, nonatomic) IBOutlet NZLabel *registLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *whiteBaseHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnButtom;//按钮与底部的距离
@end

@implementation UCFBankDepositoryAccountViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.btnButtom.constant = 30;
    
    if (ScreenWidth == 320)
    {
        _whiteBaseHeight.constant = CGRectGetMaxY(_bottomLab.frame) + 20;
    }else{
        _whiteBaseHeight.constant = CGRectGetMaxY(_bottomLab.frame) + 10;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!isFirstLaunch) {
        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_whiteBaseView isTop:YES];
        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_whiteBaseView isTop:NO];
        isFirstLaunch = YES;
    }
    self.scrollView.contentSize = CGSizeMake(0, ScreenHeight - 64);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"授权登录";
    if (self.accoutType == SelectAccoutTypeHoner) {
      [self initHonerUI];
    }else{
      [self initP2PUI];
    }
}
- (void)initHonerUI
{
    __weak typeof(self) weakSelf = self;
    self.bottomLab.text = @"获取您的金融工场用户信息注册并开通工场尊享用户";
    _registLabel.text = @"我已阅读并同意接受《工场尊享用户服务协议》";
    _registLabel.userInteractionEnabled = YES;
    [_registLabel addLinkString:@"《工场尊享用户服务协议》" block:^(ZBLinkLabelModel *linkModel) {
        [weakSelf showHeTong:linkModel];
    }];
    [_registLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"《工场尊享用户服务协议》"];
}
-(void)initP2PUI{
    __weak typeof(self) weakSelf = self;
    _registLabel.userInteractionEnabled = YES;
    self.bottomLab.text = @"获取您的金融工场用户信息注册并开通工场微金用户";
    _registLabel.text = @"我已阅读并同意《工场微金用户服务协议》";
    [_registLabel addLinkString:@"《工场微金用户服务协议》" block:^(ZBLinkLabelModel *linkModel) {
        [weakSelf showHeTong:linkModel];
    }];
    [_registLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"《工场微金用户服务协议》"];
 
    
}
- (void)showHeTong:(ZBLinkLabelModel *)model
{
    NSString *titleStr = self.accoutType ==SelectAccoutTypeHoner ? @"工场尊享用户服务协议" : @"工场微金用户服务协议";
    NSString *urlStr = self.accoutType ==SelectAccoutTypeHoner ? ZXREGISTURL : ZXREGISTURL;
    FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:urlStr title:titleStr];
    
    webController.baseTitleType = @"specialUser";
    [self.navigationController pushViewController:webController animated:YES];
}
- (IBAction)goToEnjoyOpenHSAccount:(id)sender {
    
    
    if (self.accoutType == SelectAccoutTypeHoner) {
        NSString *userID = SingleUserInfo.loginData.userInfo.userId;
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userID} tag:kSXTagGetUserAgree owner:self signature:YES Type:SelectAccoutTypeHoner];;
    }else{
        NSString *userID = SingleUserInfo.loginData.userInfo.userId;
        [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userID} tag:KSXTagP2pAuthorization owner:self signature:YES Type:SelectAccoutTypeP2P];;
    }
    
 
}
-(void)beginPost:(kSXTag)tag{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *Data = (NSString *)result;
    NSDictionary * dic = [Data objectFromJSONString];
    
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    switch (tag.intValue) {
        case kSXTagGetUserAgree:
        {
            NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
            if([[dataDict objectSafeForKey:@"status"] intValue] == 1){//授权成功
                
                [AuxiliaryFunc showToastMessage:@"授权成功" withView:self.view];
                 SingleUserInfo.loginData.userInfo.zxAuthorization = @"true";
                [SingleUserInfo setUserData: SingleUserInfo.loginData];
                [self performSelector:@selector(popViewController) withObject:nil afterDelay:2.0f];
                
//                UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:2];
//                vc.site = @"2";
//                vc.accoutType = SelectAccoutTypeHoner;
//                [self.navigationController pushViewController:vc animated:YES];
//                NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
//                [navVCArray removeObjectAtIndex:navVCArray.count-2];
//                [self.navigationController setViewControllers:navVCArray animated:NO];
            } else {
                [MBProgressHUD displayHudError:[dataDict objectSafeForKey:@"msg"]];
            }
        }
            break;
        case KSXTagP2pAuthorization:
        {
            if([dic[@"ret"] boolValue] == 1){//授权成功
                [AuxiliaryFunc showToastMessage:@"授权成功" withView:self.view];
                  SingleUserInfo.loginData.userInfo.p2pAuthorization = YES;
                [self performSelector:@selector(popViewController) withObject:nil afterDelay:2.0f];
               
       
//                UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:2];
//                vc.site = @"1";
//                vc.accoutType = SelectAccoutTypeP2P;
//                [self.navigationController pushViewController:vc animated:YES];
//                NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
//                [navVCArray removeObjectAtIndex:navVCArray.count-2];
//                [self.navigationController setViewControllers:navVCArray animated:NO];
            } else {
                [MBProgressHUD displayHudError:dic[@"msg"]];
            }
        }
            break;
            
        default:
            break;
    }
}
-(void)popViewController
{
   
    
    
    UCFBaseViewController *rootBaseVC = [self.navigationController.viewControllers firstObject];
    NSString *className = [NSString stringWithUTF8String:object_getClassName(rootBaseVC)];
    if ([className hasSuffix:@"UCFRechargeOrCashViewController"])
    {
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

        [appDelegate.tabBarController dismissViewControllerAnimated:NO completion:^{
                    NSUInteger selectedIndex = appDelegate.tabBarController.selectedIndex;
                    UINavigationController *nav = [appDelegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
                    [nav popToRootViewControllerAnimated:NO];
        }];
    }
    else
    {
         [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD displayHudError:[err.userInfo objectForKey:@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)dealloc
{
    
}
@end
