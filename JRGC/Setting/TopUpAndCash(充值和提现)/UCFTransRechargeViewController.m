//
//  UCFTransRechargeViewController.m
//  JRGC
//
//  Created by 金融工场 on 2018/11/20.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFTransRechargeViewController.h"
#import "UCFTransferTableView.h"
#import "FullWebViewController.h"
@interface UCFTransRechargeViewController ()<TransferTableViewDelegate>
@property(nonatomic, strong)UCFTransferTableView *showView;
@end

@implementation UCFTransRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _showView = [[UCFTransferTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -NavigationBarHeight1 - 40)];
    _showView.delegate = self;
    [self.view addSubview:_showView];
}
- (void)refreshTableView
{
    [_showView refreshView];
    
}
- (void)transferTableView:(UCFTransferTableView *)view withClickbutton:(UIButton *)button
{
    NSString *rechargeLimiteUrl = @"https://static.9888.cn/pages/transferNotice/other_notice.html";
    if (button.tag == 100) {
        rechargeLimiteUrl = @"https://static.9888.cn/pages/transferNotice/jh_notice.html";
    } else if (button.tag == 101) {
        rechargeLimiteUrl = @"https://static.9888.cn/pages/transferNotice/jt_notice.html";
    } else if (button.tag == 102) {
        rechargeLimiteUrl = @"https://static.9888.cn/pages/transferNotice/zs_notice.html";
    }
    FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:rechargeLimiteUrl title:@"转账充值流程"];
    webController.sourceVc = @"topUpVC";//充值页面
    webController.baseTitleType = @"specialUser";
    [((UIViewController *)self.rootVc).navigationController pushViewController:webController animated:YES];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}
- (void)updateFrame:(CGRect)frame
{
    _showView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight -NavigationBarHeight1 - 40);
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
