//
//  UCFGoldAuthorizationViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldAuthorizationViewController.h"
#import "UCFGoldRechargeViewController.h"
#import "NSString+CJString.h"
#import "AppDelegate.h"
@interface UCFGoldAuthorizationViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)clickGoldAuthorizationBtn:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *upViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *upViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *LabelTip;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBottom;
@property (weak, nonatomic) IBOutlet UIButton *goldAuthorizationBtn;

@end


@implementation UCFGoldAuthorizationViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    self.upViewWidth.constant = ScreenWidth;
    
    NSString *tipText = @"联合黄金在门户方为其提供的平台发布、运营各类黄金产品，为客户提供产品报价、加工、物流等服务。联合黄金应确保在平台展示的各信息及资料真实有效。";
    NSDictionary *dic = [Common getParagraphStyleDictWithStrFont:12 WithlineSpacing:2.0f];
    self.LabelTip.attributedText = [NSString getNSAttributedString:tipText labelDict:dic];

    
    self.upViewHeight.constant = CGRectGetMaxY(self.LabelTip.frame)+25;
    self.scrollView.contentSize = CGSizeMake(0, ScreenHeight - 64);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"用户授权";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)clickGoldAuthorizationBtn:(id)sender {
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userID} tag:kSXTagGoldAuthorizedOpenAccount owner:self signature:YES Type:SelectAccoutDefault];
    self.goldAuthorizationBtn.userInteractionEnabled = NO;
    
}
-(void)beginPost:(kSXTag)tag{
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *Data = (NSString *)result;
    NSDictionary * dic = [Data objectFromJSONString];
    
    if (tag.intValue == kSXTagGoldAuthorizedOpenAccount ) {
        BOOL ret  = [[dic objectSafeDictionaryForKey:@"ret"] boolValue];
        if(ret){//授权成功
            
            [UserInfoSingle sharedManager].goldAuthorization = YES;
            [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:GOldAUTHORIZATION];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([_sourceVc isEqualToString:@"GoldPurchaseVC"]) {
                [AuxiliaryFunc showToastMessage:@"授权成功" withView:self.view];
                [self performSelector:@selector(popViewController) withObject:nil afterDelay:2.0f];

            } else if([_sourceVc isEqualToString:@"UCFRechargeOrCashVC"])
            {
                [AuxiliaryFunc showToastMessage:@"授权成功" withView:self.view];
                [self performSelector:@selector(popMineViewController) withObject:nil afterDelay:2.0f];
            }
            else //
            {
                
                UCFGoldRechargeViewController *goldRecharge = [[UCFGoldRechargeViewController alloc] initWithNibName:@"UCFGoldRechargeViewController" bundle:nil];
                goldRecharge.baseTitleText = @"充值";
                goldRecharge.needToRechareStr = self.sourceVc;
                NSInteger index =  [[self.navigationController viewControllers] indexOfObject:self];
                goldRecharge.rootVc = [[self.navigationController viewControllers] objectAtIndex:index - 1];
                [self.navigationController pushViewController:goldRecharge animated:YES];
                
                NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
                [navVCArray removeObjectAtIndex:navVCArray.count-2];
                [self.navigationController setViewControllers:navVCArray animated:NO];
            }
            
        } else {
            self.goldAuthorizationBtn.userInteractionEnabled = YES;
            [MBProgressHUD displayHudError:[dic objectSafeForKey:@"message"]];
        }
    }
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD displayHudError:[err.userInfo objectForKey:@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)popMineViewController
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.tabBarController dismissViewControllerAnimated:NO completion:^{
        NSUInteger selectedIndex = appDelegate.tabBarController.selectedIndex;
        UINavigationController *nav = [appDelegate.tabBarController.viewControllers objectAtIndex:selectedIndex];
        [nav popToRootViewControllerAnimated:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
