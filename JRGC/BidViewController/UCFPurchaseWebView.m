 //
//  UCFPurchaseWebView.m
//  JRGC
//
//  Created by 秦 on 2016/9/13.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFPurchaseWebView.h"
#import "UCFInvestmentDetailViewController.h"
#import "UCFRedEnvelopeViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface UCFPurchaseWebView ()
@property (nonatomic, assign) BOOL flagInvestSuc;
@end

@implementation UCFPurchaseWebView

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    self.flagInvestSuc = NO;
    self.fd_interactivePopDisabled = YES;
    [self removeRefresh];
    [self gotoURLWithSignature:self.url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 初始化webView 并加入js
//***有验签跳转页面走该方法
- (void)jsToInvestDetail:(NSDictionary *)_dic
{
    if([_dic[@"action"] isEqualToString:@"app_invest_detail"])
    {
       UCFInvestmentDetailViewController *controller = [[UCFInvestmentDetailViewController alloc] init];
       controller.billId = [NSString stringWithFormat:@"%ld",[_dic[@"value"]integerValue]];
       controller.detailType = @"1";
       controller.flagGoRoot = NO;
        controller.accoutType = [[NSString stringWithFormat:@"%@",[_dic objectSafeForKey:@"fromSite"]] integerValue];
       [self.navigationController pushViewController:controller animated:YES];
    }

}

- (void)getToBack
{//***根据你投资或者提现的成功的返回标识来判断是poptoroot 还是popviewcontroller（现在由于后台还没有调好暂时不加上）
//    if(self.flagInvestSuc == YES)//***投资成功以后导航栏上的返回按钮返回的是投资列表页面
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
//         [self.navigationController popToRootViewControllerAnimated:YES];
//    } else {//***投资失败以后导航栏上的返回按钮返回的是投资填写页面
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    [self jsClose];
}
- (void)jsClose
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHonerPlanData" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadP2PData" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LatestProjectUpdate" object:nil];
    if (self.rootVc) {
        [self.navigationController popToViewController:self.rootVc animated:YES];
    }
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)jsInvestSuc:(BOOL)isSuc
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    self.flagInvestSuc = isSuc;
//    if (isSuc) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }

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
