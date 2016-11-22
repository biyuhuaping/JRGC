//
//  UCFBankDepositoryAccountViewController.m
//  JRGC
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFBankDepositoryAccountViewController.h"


#import "UCFOldUserGuideViewController.h"
@interface UCFBankDepositoryAccountViewController ()<UIWebViewDelegate>
@end

@implementation UCFBankDepositoryAccountViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"徽商存管账户";
    [self addLeftButton];

    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight-57-64)];
//    self.webView.frame =  CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight-57-64);
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate  =self ;
    [self.view addSubview:self.webView];
    UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.webView.frame), ScreenWidth, 57)];
    bkView.backgroundColor = [UIColor whiteColor];

    UIButton *investmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    investmentButton.frame = CGRectMake(15, 10,ScreenWidth - 15*2, 37);
    investmentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    investmentButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
    investmentButton.layer.cornerRadius = 2.0;
    investmentButton.layer.masksToBounds = YES;
    if (_openStatus == 1) {//非白名单用户
        [investmentButton setTitle:@"立即开通徽商存管账户" forState:UIControlStateNormal];
    }else if (_openStatus == 2) {//白名单用户
        [investmentButton setTitle:@"一键升级徽商存管账户" forState:UIControlStateNormal];
    }
    [investmentButton addTarget:self action:@selector(gotoNewOldOpenAccount:) forControlEvents:UIControlEventTouchUpInside];
    [bkView addSubview:investmentButton];
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0,-10, ScreenWidth, 10)];
    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    shadowView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
    [bkView addSubview:shadowView];
    [self.view addSubview:bkView];
    //请求数据
    [self gotoURL:BANKDEPOSITORYACCOUNTURL];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)addRefresh //去掉页面刷新
{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)gotoNewOldOpenAccount:(id)sender {
    UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:2];
    [self.navigationController pushViewController:vc animated:YES];
    
    NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [navVCArray removeObjectAtIndex:navVCArray.count-2];
    [self.navigationController setViewControllers:navVCArray animated:NO];
}
@end
